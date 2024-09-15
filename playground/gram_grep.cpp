// A grep program that allows search by grammar or by lexer spec only
// as well as the conventional way.

//#include "stdafx.h"

#include <parsertl/debug.hpp>
#include <lexertl/debug.hpp>
#include <filesystem>
#include <fstream>
#include <parsertl/generator.hpp>
#include <parsertl/lookup.hpp>
#include <iostream>
#include <lexertl/iterator.hpp>
#include <parsertl/match_results.hpp>
#include <lexertl/memory_file.hpp>
#include <regex>
#include <parsertl/search.hpp>
#include <variant>
#include <lexertl/utf_iterators.hpp>
#include <wildcardtl/wildcard.hpp>

enum class file_type
{
    ansi, utf8, utf16, utf16_flip
};

enum config_flags
{
    none = 0,
    whole_word = 1,
    negate = 2,
    negate_all = 4,
    extend_search = 8
};

enum class match_type
{
    // Must match order of variant in g_pipeline
    parser, uparser, lexer, ulexer, regex, text, dfa_regex
};

using lexer_state_machine = lexertl::state_machine;

struct base
{
    unsigned int _flags = config_flags::none;

    virtual ~base() = default;
};

enum class cmd_type
{
    unknown, assign, append, erase, insert, print, replace, replace_all
};

struct erase_cmd
{
};

struct insert_cmd
{
    std::string _text;

    explicit insert_cmd(const std::string& text) :
        _text(text)
    {
    }
};

struct match_cmd
{
    uint16_t _front;
    uint16_t _back;

    match_cmd(const uint16_t front,
        const uint16_t back) noexcept :
        _front(front),
        _back(back)
    {
    }
};

struct print_cmd
{
    std::string _text;

    explicit print_cmd(const std::string& text) :
        _text(text)
    {
    }
};

struct replace_cmd
{
    std::string _text;

    explicit replace_cmd(const std::string& text) :
        _text(text)
    {
    }
};

struct replace_all_cmd
{
    std::regex _rx;
    std::string _text;

    replace_all_cmd(const std::string& rx, const std::string& text) :
        _rx(rx),
        _text(text)
    {
    }
};

struct cmd
{
    using action = std::variant<erase_cmd, insert_cmd, match_cmd, print_cmd,
        replace_cmd, replace_all_cmd>;
    cmd_type _type = cmd_type::unknown;
    uint16_t _param1 = 0;
    bool _second1 = false;
    uint16_t _param2 = 0;
    bool _second2 = true;
    action _action;

    cmd(const cmd_type type, const action& action) :
        _type(type),
        _action(action)
    {
    }

    cmd(const cmd_type type, const uint16_t param, const action& action) :
        _type(type),
        _param1(param),
        _param2(param),
        _action(action)
    {
    }

    cmd(const cmd_type type, const uint16_t param, const bool second,
        const action& action) :
        _type(type),
        _param1(param),
        _second1(second),
        _param2(param),
        _action(action)
    {
    }

    cmd(const cmd_type type, const uint16_t param1, const uint16_t param2,
        const action& action) :
        _type(type),
        _param1(param1),
        _param2(param2),
        _action(action)
    {
    }

    cmd(const cmd_type type, const uint16_t param1, const bool second1,
        const uint16_t param2, const bool second2, const action& action) :
        _type(type),
        _param1(param1),
        _second1(second1),
        _param2(param2),
        _second2(second2),
        _action(action)
    {
    }
};

struct parser_base : base
{
    parsertl::state_machine _gsm;
    std::set<uint16_t> _reduce_set;
    std::map<uint16_t, std::vector<cmd>> _actions;
};

struct parser : parser_base
{
    lexertl::state_machine _lsm;
};

struct uparser : parser_base
{
    lexer_state_machine _lsm;
};

struct lexer : base
{
    lexertl::state_machine _sm;
};

struct ulexer : base
{
    lexer_state_machine _sm;
};

struct regex : base
{
    std::regex _rx;
};

struct text : base
{
    std::string _text;
};

struct config_state;
struct config_parser;

using config_actions_map = std::map<uint16_t, void(*)(config_state& state,
    const config_parser& parser)>;
using utf8_iterator = lexertl::citerator;
using utf8results = parsertl::match_results;
using crutf8iterator = lexertl::criterator;
namespace fs = std::filesystem;

struct config
{
    match_type _type;
    std::string _param;
    unsigned int _flags = config_flags::none;

    config(const match_type type, const std::string& param, const unsigned int flags) :
        _type(type),
        _param(param),
        _flags(flags)
    {
    }
};

struct config_parser
{
    parsertl::state_machine _gsm;
    lexertl::state_machine _lsm;
    config_actions_map _actions;
};

struct match
{
    const char* _first = nullptr;
    const char* _second = nullptr;
    const char* _eoi = nullptr;

    match(const char* first, const char* second, const char* eoi) :
        _first(first),
        _second(second),
        _eoi(eoi)
    {
    }
};

config_parser g_config_parser;
std::vector<std::variant<parser, uparser, lexer, ulexer, regex, text>> g_pipeline;
std::pair<std::vector<wildcardtl::wildcard>,
    std::vector<wildcardtl::wildcard>> g_exclude;
bool g_show_hits = false;
bool g_force_unicode = false;
bool g_icase = false;
bool g_dump = false;
bool g_dump_master = false;
bool g_pathname_only = false;
//bool g_force_unicode = false;
bool g_modify = false; // Set when grammar has modifying operations
bool g_output = false;
bool g_recursive = false;
bool g_rule_print = false;
std::string g_print;
std::string g_replace;
std::string g_checkout;
parser* g_curr_parser = nullptr;
uparser* g_curr_uparser = nullptr;
std::map<std::string, std::pair<std::vector<wildcardtl::wildcard>,
    std::vector<wildcardtl::wildcard>>> g_pathnames;
std::size_t g_hits = 0;
std::size_t g_files = 0;
std::size_t g_searched = 0;
bool g_writable = false;
std::string g_startup;
std::string g_shutdown;
bool g_force_write = false;
std::regex g_capture_rx;

using token = parsertl::token<lexertl::criterator>;

struct config_state
{

    parsertl::rules _grules;
    lexertl::rules _lrules;
    lexertl::memory_file _mf;
    token::token_vector _productions;
    parsertl::match_results _results;
    std::string _lhs;
    bool _print = false;

    void parse(const std::string& config_pathname)
    {
        lexertl::citerator iter;
        lexertl::citerator end;

        if (g_icase)
        {
                _lrules.flags(*lexertl::regex_flags::icase |
                    *lexertl::regex_flags::dot_not_cr_lf);
        }

        _mf.open(config_pathname.c_str());

        if (!_mf.data())
        {
            std::ostringstream ss;

            ss << "Unable to open " << config_pathname;
            throw std::runtime_error(ss.str());
        }

        iter = lexertl::citerator(_mf.data(), _mf.data() + _mf.size(),
            g_config_parser._lsm);
        _results.reset(iter->id, g_config_parser._gsm);

        while (_results.entry.action != parsertl::action::error &&
            _results.entry.action != parsertl::action::accept)
        {
            if (_results.entry.action == parsertl::action::reduce)
            {
                auto i = g_config_parser._actions.find(_results.entry.param);

                if (i != g_config_parser._actions.end())
                {
                    try
                    {
                        i->second(*this, g_config_parser);
                    }
                    catch (const std::exception& e)
                    {
                        std::ostringstream ss;
                        const auto idx =
                            _results.production_size(g_config_parser._gsm,
                                _results.entry.param) - 1;
                        const auto& token =
                            _results.dollar(idx, g_config_parser._gsm,
                                _productions);
                        const std::size_t line =
                            1 + std::count(_mf.data(), token.first, '\n');

                        // Column makes no sense here as we are
                        // already at the end of the line
                        ss << config_pathname << '(' << line << "): " << e.what();
                        throw std::runtime_error(ss.str());
                    }
                }
            }

            parsertl::lookup(iter, g_config_parser._gsm, _results,
                _productions);
        }

        if (_results.entry.action == parsertl::action::error)
        {
            const std::size_t line =
                1 + std::count(_mf.data(), iter->first, '\n');
            const char endl[] = { '\n' };
            const std::size_t column = iter->first - std::find_end(_mf.data(),
                iter->first, endl, endl + 1);
            std::ostringstream ss;

            ss << config_pathname << '(' << line << ':' << column << "): Parse error";
            throw std::runtime_error(ss.str());
        }

        _mf.close();

        if (_grules.grammar().empty())
        {
                _lrules.push(".{+}[\r\n]", lexertl::rules::skip());
        }
        else
        {
            std::string warnings;
            parsertl::rules::string_vector terminals;
            const auto& grammar = _grules.grammar();
            const auto& ids = _lrules.ids();
            std::set<std::size_t> used_tokens;
            std::set<std::size_t> used_prec;

                parsertl::generator::build(_grules, g_curr_parser->_gsm,
                    &warnings);

            _grules.terminals(terminals);

            if (!warnings.empty())
                std::cerr << "Warnings from config " << config_pathname << " : " <<
                    warnings;

            for (const auto& p : grammar)
            {
                //Add %prec TOKEN to the list of used terminals
                if (p._ctx_precedence_id > 0)
                {
                        used_tokens.insert(p._ctx_precedence_id);
                }
                for (const auto& rhs : p._rhs._symbols)
                {
                    if (rhs._type == parsertl::rules::symbol::type::TERMINAL)
                        used_tokens.insert(rhs._id);
                }
            }

            for (std::size_t i = 1, size = terminals.size(); i < size; ++i)
            {
                bool found_id = false;

                for (const auto& curr_ids : ids)
                {
                    found_id = std::find(curr_ids.begin(), curr_ids.end(), i) !=
                        curr_ids.end() ||
                        used_prec.find(i) != used_prec.end();

                    if (found_id) break;
                }

                if (!found_id)
                    std::cerr << "Warning: Token \"" << terminals[i] <<
                        "\" does not have a lexer definiton.\n";

                if (used_tokens.find(i) == used_tokens.end() &&
                    used_prec.find(i) == used_prec.end())
                {
                    std::cerr << "Warning: Token \"" << terminals[i] <<
                        "\" is not used in the grammar.\n";
                }
            }
        }

            lexertl::generator::build(_lrules, g_curr_parser->_lsm);
    }
};

void process_action(const parser& p, const char* start,
    const std::map<uint16_t, std::vector<cmd>>::const_iterator& action_iter,
    const std::pair<uint16_t, token::token_vector>& item,
    std::stack<std::string>& matches,
    std::map<std::pair<std::size_t, std::size_t>, std::string>& replacements)
{
    for (const auto& cmd : action_iter->second)
    {
        const token::token_vector& productions = item.second;

        switch (cmd._type)
        {
        case cmd_type::append:
        {
            const auto& c = std::get<match_cmd>(cmd._action);
            std::string temp = productions[productions.size() -
                p._gsm._rules[item.first]._rhs.size() + cmd._param1].str();
            const uint16_t size = c._front + c._back;

            if (c._front == 0 && c._back == 0)
                matches.top() += temp;
            else
            {
                if (c._front >= temp.size() || size > temp.size())
                {
                    std::ostringstream ss;

                    ss << "substr($" << cmd._param1 + 1 << ", " <<
                        c._front << ", " << c._back <<
                        ") out of range for string '" << temp << "'.";
                    throw std::runtime_error(ss.str());
                }

                matches.top() += temp.substr(c._front, temp.size() - size);
            }

            break;
        }
        case cmd_type::assign:
        {
            const auto& c = std::get<match_cmd>(cmd._action);
            std::string temp = productions[productions.size() -
                p._gsm._rules[item.first]._rhs.size() + cmd._param1].str();

            if (c._front == 0 && c._back == 0)
                matches.top() = std::move(temp);
            else
            {
                const uint16_t size = c._front + c._back;

                if (c._front >= temp.size() || size > temp.size())
                {
                    std::ostringstream ss;

                    ss << "substr($" << cmd._param1 + 1 << ", " <<
                        c._front << ", " << c._back <<
                        ") out of range for string '" << temp << "'.";
                    throw std::runtime_error(ss.str());
                }

                matches.top() = temp.substr(c._front, temp.size() - size);
            }

            break;
        }
        case cmd_type::erase:
        {
            if (g_output)
            {
                const auto& param1 = productions[productions.size() -
                    p._gsm._rules[item.first]._rhs.size() + cmd._param1];
                const auto& param2 = productions[productions.size() -
                    p._gsm._rules[item.first]._rhs.size() + cmd._param2];
                const auto index1 =
                    (cmd._second1 ? param1.second : param1.first) - start;
                const auto index2 =
                    (cmd._second2 ? param2.second : param2.first) - start;

                replacements[std::pair(index1, index2 - index1)] =
                    std::string();
            }

            break;
        }
        case cmd_type::insert:
        {
            if (g_output)
            {
                const auto& c = std::get<insert_cmd>(cmd._action);
                const auto& param = productions[productions.size() -
                    p._gsm._rules[item.first]._rhs.size() + cmd._param1];
                const auto index = (cmd._second1 ? param.second : param.first) -
                    start;

                replacements[std::pair(index, 0)] = c._text;
            }

            break;
        }
        case cmd_type::print:
        {
            const auto& c = std::get<print_cmd>(cmd._action);
            std::string output;
            const char* last = c._text.c_str();
            std::cregex_iterator iter(c._text.c_str(),
                c._text.c_str() + c._text.size(), g_capture_rx);
            std::cregex_iterator end;

            for (; iter != end; ++iter)
            {
                const std::size_t idx =
                    static_cast<std::size_t>(atoi((*iter)[0].first + 1)) - 1;

                output.append(last, (*iter)[0].first);
                output += idx >= item.second.size() ?
                    std::string() :
                    item.second[idx].str();
                last = (*iter)[0].second;
            }

            output.append(last, c._text.c_str() + c._text.size());
            std::cout << output;
             break;
        }
        case cmd_type::replace:
        {
            if (g_output)
            {
                const auto& c = std::get<replace_cmd>(cmd._action);
                const auto size = productions.size() -
                    p._gsm._rules[item.first]._rhs.size();
                const auto& param1 = productions[size + cmd._param1];
                const auto& param2 = productions[size + cmd._param2];
                const auto index1 =
                    (cmd._second1 ? param1.second : param1.first) - start;
                const auto index2 =
                    (cmd._second2 ? param2.second : param2.first) - start;

                replacements[std::pair(index1, index2 - index1)] = c._text;
            }

            break;
        }
        case cmd_type::replace_all:
            if (g_output)
            {
                const auto& c = std::get<replace_all_cmd>(cmd._action);
                const auto size = productions.size() -
                    p._gsm._rules[item.first]._rhs.size();
                const auto& param = productions[size + cmd._param1];
                const auto index1 = param.first - start;
                const auto index2 = param.second - start;
                auto pair = std::pair(index1, index2 - index1);
                auto iter = replacements.find(pair);
                const std::string text =
                    std::regex_replace(iter == replacements.end() ?
                    std::string(param.first, param.second) : iter->second,
                    c._rx, c._text);

                replacements[pair] = text;
            }

            break;
        default:
            break;
        }
    }
}

bool process_parser(const parser& p, const char* start,
    std::vector<match>& ranges, std::stack<std::string>& matches,
    std::map<std::pair<std::size_t, std::size_t>, std::string>& replacements,
    std::vector<std::string>& captures)
{
    using results = std::vector<std::vector<std::pair
        <const char*, const char*>>>;
    lexertl::criterator iter(ranges.back()._first,
        ranges.back()._eoi, p._lsm);
    lexertl::criterator end;
    std::vector<std::pair<uint16_t, token::token_vector>> prod_map;
    results cap;
    bool success = false;

    if (p._gsm._captures.empty())
        success = parsertl::search(iter, end, p._gsm, &prod_map);
    else
        success = parsertl::search(iter, end, p._gsm, cap);

    if (success)
    {
        if (p._flags & config_flags::negate)
        {
            if (p._flags & config_flags::negate_all)
                success = false;
            else
            {
                const char* last_start = ranges.back()._first;

                ranges.back()._second = end->first;

                if (last_start == iter->first)
                {
                    // The match is right at the beginning, so skip.
                    ranges.emplace_back(iter->second, iter->second,
                        iter->second);
                    success = false;
                }
                else
                    ranges.emplace_back(ranges.back()._first, iter->first,
                        iter->first);
            }
        }
        else
        {
            if (!p._actions.empty())
                matches.push(std::string());

            // Only care about grammar captures with a positive match
            if (p._gsm._captures.empty())
            {
                // Store start of match
                ranges.back()._first = iter->first;
                // Store end of match
                ranges.back()._second = end->first;
                ranges.emplace_back((p._flags & config_flags::extend_search) ? end->first : iter->first,
                    (p._flags & config_flags::extend_search) ? end->first : iter->first,
                    (p._flags & config_flags::extend_search) ? ranges.back()._eoi : end->first);
            }
            else
            {
                // Store start of match
                ranges.back()._first = cap[0][0].first;
                // Store end of match
                ranges.back()._second = cap[0][0].second;

                for (std::size_t idx = 1, size = cap.size();
                    idx < size; ++idx)
                {
                    for (const auto& pair : cap[idx])
                    {
                        ranges.emplace_back((p._flags & config_flags::extend_search) ? pair.second : pair.first,
                            (p._flags & config_flags::extend_search) ? pair.second : pair.first,
                            (p._flags & config_flags::extend_search) ? ranges.back()._eoi : pair.second);
                    }
                }
            }

            if (!p._reduce_set.empty())
            {
                // Success only if a _reduce_set item is found
                success = false;
            }

            for (const auto& item : prod_map)
            {
                const auto action_iter = p._actions.find(item.first);

                if (action_iter != p._actions.end())
                {
                    process_action(p, start, action_iter, item, matches,
                        replacements);
                    ranges.back()._first = ranges.back()._second =
                        matches.top().c_str();
                    ranges.back()._eoi = matches.top().c_str() +
                        matches.top().size();
                }
                else
                {
                    if (p._reduce_set.empty() ||
                        p._reduce_set.find(item.first) != p._reduce_set.end())
                    {
                        success = true;

                        if (!matches.empty())
                        {
                            ranges.back()._first = ranges.back()._second =
                                matches.top().c_str();
                            ranges.back()._eoi = matches.top().c_str() +
                                matches.top().size();
                        }
                    }
                }
            }
        }
    }
    else if (p._flags & config_flags::negate)
    {
        if (ranges.back()._first != ranges.back()._eoi)
        {
            ranges.back()._second = iter->first;
            ranges.emplace_back(ranges.back()._first, iter->first,
                iter->first);
            success = true;
        }
    }

    if (success)
    {
        captures.clear();

        if (p._flags & config_flags::negate)
            captures.emplace_back(ranges.back()._first, ranges.back()._second);
        else
        {
            for (const auto& v : cap)
            {
                if (v.empty())
                    captures.emplace_back();
                else
                    captures.emplace_back(v.front().first, v.front().second);
            }
        }
    }

    return success;
}

void process_action(const uparser& p, const char* start,
    const std::map<uint16_t, std::vector<cmd>>::const_iterator& action_iter,
    const std::pair<uint16_t,
    parsertl::token<crutf8iterator>::token_vector>& item,
    std::stack<std::string>& matches,
    std::map<std::pair<std::size_t, std::size_t>, std::string>& replacements)
{
    for (const auto& cmd : action_iter->second)
    {
        const parsertl::token<crutf8iterator>::token_vector& productions =
            item.second;

        switch (cmd._type)
        {
        case cmd_type::append:
        {
            const auto& c = std::get<match_cmd>(cmd._action);
            auto& token = productions[productions.size() -
                p._gsm._rules[item.first]._rhs.size() + cmd._param1];
            std::string temp(token.first, token.second);
            const uint16_t size = c._front + c._back;

            if (c._front == 0 && c._back == 0)
                matches.top() += temp;
            else
            {
                if (c._front >= temp.size() || size > temp.size())
                {
                    std::ostringstream ss;

                    ss << "substr($" << cmd._param1 + 1 << ", " <<
                        c._front << ", " << c._back <<
                        ") out of range for string '" << temp << "'.";
                    throw std::runtime_error(ss.str());
                }

                matches.top() += temp.substr(c._front, temp.size() - size);
            }

            break;
        }
        case cmd_type::assign:
        {
            const auto& c = std::get<match_cmd>(cmd._action);
            auto& token = productions[productions.size() -
                p._gsm._rules[item.first]._rhs.size() + cmd._param1];
            std::string temp(token.first, token.second);

            if (c._front == 0 && c._back == 0)
                matches.top() = std::move(temp);
            else
            {
                const uint16_t size = c._front + c._back;

                if (c._front >= temp.size() || size > temp.size())
                {
                    std::ostringstream ss;

                    ss << "substr($" << cmd._param1 + 1 << ", " <<
                        c._front << ", " << c._back <<
                        ") out of range for string '" << temp << "'.";
                    throw std::runtime_error(ss.str());
                }

                matches.top() = temp.substr(c._front, temp.size() - size);
            }

            break;
        }
        case cmd_type::erase:
        {
            if (g_output)
            {
                const auto& param1 = productions[productions.size() -
                    p._gsm._rules[item.first]._rhs.size() + cmd._param1];
                const auto& param2 = productions[productions.size() -
                    p._gsm._rules[item.first]._rhs.size() + cmd._param2];
                const auto index1 = (cmd._second1 ? param1.second :
                    param1.first) - start;
                const auto index2 = (cmd._second2 ? param2.second :
                    param2.first) - start;

                replacements[std::pair(index1, index2 - index1)] =
                    std::string();
            }

            break;
        }
        case cmd_type::insert:
        {
            if (g_output)
            {
                const auto& c = std::get<insert_cmd>(cmd._action);
                const auto& param = productions[productions.size() -
                    p._gsm._rules[item.first]._rhs.size() + cmd._param1];
                const auto index = (cmd._second1 ? param.second :
                    param.first) - start;

                replacements[std::pair(index, 0)] = c._text;
            }

            break;
        }
        case cmd_type::replace:
        {
            if (g_output)
            {
                const auto& c = std::get<replace_cmd>(cmd._action);
                const auto size = productions.size() -
                    p._gsm._rules[item.first]._rhs.size();
                const auto& param1 = productions[size + cmd._param1];
                const auto& param2 = productions[size + cmd._param2];
                const auto index1 = (cmd._second1 ? param1.second :
                    param1.first) - start;
                const auto index2 = (cmd._second2 ? param2.second :
                    param2.first) - start;

                replacements[std::pair(index1, index2 - index1)] = c._text;
            }

            break;
        }
        case cmd_type::replace_all:
            if (g_output)
            {
                const auto& c = std::get<replace_all_cmd>(cmd._action);
                const auto size = productions.size() -
                    p._gsm._rules[item.first]._rhs.size();
                const auto& param = productions[size + cmd._param1];
                const auto index1 = param.first - start;
                const auto index2 = param.second - start;
                auto pair = std::pair(index1, index2 - index1);
                auto iter = replacements.find(pair);
                const std::string text =
                    std::regex_replace(iter == replacements.end() ?
                    std::string(param.first, param.second) :
                        iter->second,
                    c._rx, c._text);

                replacements[pair] = text;
            }

            break;
        default:
            break;
        }
    }
}

bool process_lexer(const lexer& l, std::vector<match>& ranges,
    std::vector<std::string>& captures)
{
    lexertl::criterator iter(ranges.back()._first,
        ranges.back()._eoi, l._sm);
    bool success = iter->first != ranges.back()._eoi;

    if (success)
    {
        if (l._flags & config_flags::negate)
        {
            if (l._flags & config_flags::negate_all)
                success = false;
            else
            {
                const char* last_start = ranges.back()._first;

                ranges.back()._second = iter->second;

                if (last_start == iter->first)
                {
                    // The match is right at the beginning, so skip.
                    ranges.emplace_back(iter->second, iter->second,
                        iter->second);
                    success = false;
                }
                else
                    ranges.emplace_back(ranges.back()._first, iter->first,
                        iter->first);
            }
        }
        else
        {
            // Store start of match
            ranges.back()._first = iter->first;
            // Store end of match
            ranges.back()._second = iter->second;
            ranges.emplace_back((l._flags & config_flags::extend_search) ? iter->second : iter->first,
                (l._flags & config_flags::extend_search) ? iter->second : iter->first,
                (l._flags & config_flags::extend_search) ? ranges.back()._eoi : iter->second);
        }
    }
    else if (l._flags & config_flags::negate)
    {
        if (ranges.back()._first != ranges.back()._eoi)
        {
            ranges.back()._second = iter->first;
            ranges.emplace_back(ranges.back()._first, iter->first, iter->first);
            success = true;
        }
    }

    if (success)
    {
        captures.clear();
        captures.emplace_back(ranges.back()._first, ranges.back()._eoi);
    }

    return success;
}

bool process_regex(const regex& r, std::vector<match>& ranges,
    std::vector<std::string>& captures)
{
    std::cregex_iterator iter(ranges.back()._first,
        ranges.back()._eoi, r._rx);
    std::cregex_iterator end;
    bool success = iter != end;

    if (success)
    {
        if (r._flags & config_flags::negate)
        {
            if (r._flags & config_flags::negate_all)
                success = false;
            else
            {
                const char* last_start = ranges.back()._first;

                ranges.back()._second = (*iter)[0].second;

                if (last_start == (*iter)[0].first)
                {
                    // The match is right at the beginning, so skip.
                    ranges.emplace_back((*iter)[0].second, (*iter)[0].second,
                        (*iter)[0].second);
                    success = false;
                }
                else
                    ranges.emplace_back(ranges.back()._first, (*iter)[0].first,
                        (*iter)[0].first);
            }
        }
        else
        {
            // Store start of match
            ranges.back()._first = (*iter)[0].first;
            // Store end of match
            ranges.back()._second = (*iter)[0].second;
            ranges.emplace_back((r._flags & config_flags::extend_search) ? (*iter)[0].second : (*iter)[0].first,
                (r._flags & config_flags::extend_search) ? (*iter)[0].second : (*iter)[0].first,
                (r._flags & config_flags::extend_search) ? ranges.back()._eoi : (*iter)[0].second);
        }
    }
    else if (r._flags & config_flags::negate)
    {
        if (ranges.back()._first != ranges.back()._eoi)
        {
            ranges.back()._second = ranges.back()._eoi;
            ranges.emplace_back(ranges.back()._first, ranges.back()._eoi,
                ranges.back()._eoi);
            success = true;
        }
    }

    if (success)
    {
        captures.clear();

        if (r._flags & config_flags::negate)
            captures.emplace_back(ranges.back()._first, ranges.back()._second);
        else
        {
            for (const auto& m : *iter)
            {
                captures.push_back(m.str());
            }
        }
    }

    return success;
}

std::string build_text(const std::string& input,
    const std::vector<std::string>& captures)
{
    std::string output;
    const char* last = input.c_str();
    std::cregex_iterator iter(input.c_str(), input.c_str() + input.size(), g_capture_rx);
    std::cregex_iterator end;

    for (; iter != end; ++iter)
    {
        const std::size_t idx = static_cast<std::size_t>(atoi((*iter)[0].first + 1));

        output.append(last, (*iter)[0].first);
        output += idx >= captures.size() ? std::string() : captures[idx];
        last = (*iter)[0].second;
    }

    output.append(last, input.c_str() + input.size());
    return output;
}

bool process_text(const text& t, const char* data_first,
    std::vector<match>& ranges, std::vector<std::string>& captures)
{
    const std::string text = build_text(t._text, captures);
    const bool bow = (text.front() >= 'A' && text.front() <= 'Z') ||
        (text.front() == '_') ||
        (text.front() >= 'a' && text.front() <= 'z');
    const bool back_dig = text.back() >= '0' && text.back() <= '9';
    const bool eow = (bow && back_dig) ||
        (text.back() >= 'A' && text.back() <= 'Z') ||
        (text.back() == '_') ||
        (text.back() >= 'a' && text.back() <= 'z');
    const char* first = ranges.back()._first;
    const char* second = ranges.back()._eoi;
    bool success = false;
    bool whole_word = false;

    do
    {
        first = text.empty() ? ranges.back()._eoi :
            g_icase ?
            std::search(first, second, &text.front(),
                &text.front() + text.size(),
                [](const char lhs, const char rhs)
                {
                    return ::tolower(lhs) == ::tolower(rhs);
                })
            : std::search(first, second, &text.front(),
                &text.front() + text.size());
        second = first + text.size();
        success = first != ranges.back()._eoi;
        whole_word = success && (!bow ||
            !((first == data_first) ||
            (*(first - 1) >= 'A' && *(first - 1) <= 'Z') ||
            (*(first - 1) == '_') ||
            (*(first - 1) >= 'a' && *(first - 1) <= 'z'))) &&
            (!eow ||
            !((second == ranges.front()._eoi) ||
            (*second >= 'A' && *second <= 'Z') ||
            (*second == '_') ||
            (*second >= 'a' && *second <= 'z') ||
            (back_dig && *second >= '0' && *second <= '9')));

        if (success && !whole_word)
        {
            first = second;
            second = ranges.back()._eoi;
        }
    } while (success && !whole_word);

    success &= whole_word;

    if (success)
    {
        if (t._flags & config_flags::negate)
        {
            if (t._flags & config_flags::negate_all)
                success = false;
            else
            {
                const char* last_start = ranges.back()._first;

                ranges.back()._second = first + text.size();

                if (last_start == first)
                {
                    // The match is right at the beginning, so skip.
                    ranges.emplace_back(second, second, second);
                    success = false;
                }
                else
                    ranges.emplace_back(ranges.back()._first, first, first);
            }
        }
        else
        {
            // Store start of match
            ranges.back()._first = first;
            // Store end of match
            ranges.back()._second = second;
            ranges.emplace_back((t._flags & config_flags::extend_search) ? second : first,
                (t._flags & config_flags::extend_search) ? second : first,
                (t._flags & config_flags::extend_search) ? ranges.back()._eoi : second);
        }
    }
    else if (t._flags & config_flags::negate)
    {
        if (ranges.back()._first != ranges.back()._eoi)
        {
            ranges.back()._second = first;
            ranges.emplace_back(ranges.back()._first, first, first);
            success = true;
        }
    }

    if (success)
    {
        captures.clear();
        captures.emplace_back(ranges.back()._first, ranges.back()._eoi);
    }

    return success;
}

file_type fetch_file_type(const char* data, std::size_t size)
{
    file_type type = file_type::ansi;

    if (size > 1)
    {
        const uint16_t* utf16 = reinterpret_cast<const uint16_t*>(data);

        switch (*utf16)
        {
        case 0xfeff:
            type = file_type::utf16;
            break;
        case 0xfffe:
            type = file_type::utf16_flip;
            break;
        default:
            if (size > 2)
            {
                const unsigned char* utf8 =
                    reinterpret_cast<const unsigned char*>(data);

                if (utf8[0] == 0xef && utf8[1] == 0xbb && utf8[2] == 0xbf)
                    type = file_type::utf8;
            }

            break;
        }
    }

    return type;
}

file_type load_file(std::vector<unsigned char>& utf8,
    const char*& data_first, const char*& data_second,
    std::vector<match>& ranges)
{
    const std::size_t size = data_second - data_first;
    file_type type = fetch_file_type(data_first, size);

    switch (type)
    {
    case file_type::utf16:
    {
        using in_iter =
            lexertl::basic_utf16_in_iterator<const uint16_t*, int32_t>;
        using out_iter = lexertl::basic_utf8_out_iterator<in_iter>;
        const uint16_t* first =
            reinterpret_cast<const uint16_t*>(data_first + 2);
        const uint16_t* second =
            reinterpret_cast<const uint16_t*>(data_second);
        in_iter in(first, second);
        in_iter in_end(second, second);
        out_iter out(in, in_end);
        out_iter out_end(in_end, in_end);

        utf8.reserve(size / 2 - 1);

        for (; out != out_end; ++out)
        {
            utf8.push_back(*out);
        }

        data_first = reinterpret_cast<const char*>(&utf8.front());
        data_second = data_first + utf8.size();
        ranges.emplace_back(data_first, data_first, data_second);
        break;
    }
    case file_type::utf16_flip:
    {
        using in_flip_iter = lexertl::basic_utf16_in_iterator
            <lexertl::basic_flip_iterator<const uint16_t*>, int32_t>;
        using out_flip_iter = lexertl::basic_utf8_out_iterator<in_flip_iter>;
        lexertl::basic_flip_iterator<const uint16_t*>
            first(reinterpret_cast<const uint16_t*>(data_first + 2));
        lexertl::basic_flip_iterator<const uint16_t*>
            second(reinterpret_cast<const uint16_t*>(data_second));
        in_flip_iter in(first, second);
        in_flip_iter in_end(second, second);
        out_flip_iter out(in, in_end);
        out_flip_iter out_end(in_end, in_end);

        utf8.reserve(size / 2 - 1);

        for (; out != out_end; ++out)
        {
            utf8.push_back(*out);
        }

        data_first = reinterpret_cast<const char*>(&utf8.front());
        data_second = data_first + utf8.size();
        ranges.emplace_back(data_first, data_first, data_second);
        break;
    }
    case file_type::utf8:
        data_first += 3;
        ranges.emplace_back(data_first, data_first, data_second);
        break;
    default:
        ranges.emplace_back(data_first, data_first, data_second);
        break;
    }

    return type;
}

std::pair<bool, bool> search(std::vector<match>& ranges, const char* data_first,
    std::stack<std::string>& matches,
    std::map<std::pair<std::size_t, std::size_t>, std::string>& replacements,
    std::vector<std::string>& captures)
{
    bool success = false;
    bool negate = false;

    for (std::size_t index = ranges.size() - 1, size = g_pipeline.size();
        index < size; ++index)
    {
        const auto& v = g_pipeline[index];

        switch (static_cast<match_type>(v.index()))
        {
        case match_type::parser:
        {
            const auto& p = std::get<parser>(v);

            success = process_parser(p, data_first, ranges, matches,
                replacements, captures);
            negate = (p._flags & config_flags::negate) != 0;
            break;
        }
        case match_type::lexer:
        {
            const auto& l = std::get<lexer>(v);

            success = process_lexer(l, ranges, captures);
            negate = (l._flags & config_flags::negate) != 0;
            break;
        }
        case match_type::regex:
        {
            const auto& r = std::get<regex>(v);

            success = process_regex(r, ranges, captures);
            negate = (r._flags & config_flags::negate) != 0;
            break;
        }
        case match_type::text:
        {
            const auto& t = std::get<text>(v);

            success = process_text(t, data_first, ranges, captures);
            negate = (t._flags & config_flags::negate) != 0;
            break;
        }
        default:
            break;
        }

        if (!success) break;
    }

    return std::make_pair(success, negate);
}

bool process_matches(const std::vector<match>& ranges,
    std::map<std::pair<std::size_t, std::size_t>, std::string>& replacements,
    std::map<std::pair<std::size_t, std::size_t>,
    std::string>& temp_replacements,
    const bool negate, const std::vector<std::string>& captures,
    const char* data_first, const char* data_second,
    lexertl::state_machine& cap_sm, const std::string& pathname,
    std::size_t& hits)
{
    bool finished = false;
    const auto& tuple = ranges.front();
    auto iter = ranges.rbegin();
    auto end = ranges.rend();

    replacements.insert(temp_replacements.begin(), temp_replacements.end());
    temp_replacements.clear();

    // Only allow g_replace if g_modify (grammar actions) not set
    if (g_output && !g_modify)
    {
        const char* first = negate ? iter->_first : iter->_second;

        if (first < tuple._first || first > tuple._second)
        {
            std::cerr << "Cannot replace text when source "
                "is not contained in original string.\n";
            return true;
        }
        else
        {
            // Replace with g_replace.
            const char* second = iter->_eoi;

            if (captures.empty())
                replacements[std::make_pair(first - data_first,
                    second - first)] = g_replace;
            else
            {
                std::string replace;
                bool skip = false;

                if (cap_sm.empty())
                {
                    lexertl::rules rules;

                    rules.push(R"(\$\d)", 1);
                    lexertl::generator::build(rules, cap_sm);
                }

                lexertl::citerator i(g_replace.c_str(),
                    g_replace.c_str() + g_replace.size(), cap_sm);
                lexertl::citerator e;

                for (; i != e; ++i)
                {
                    if (i->id == 1)
                    {
                        const std::size_t idx = atoi(i->first + 1);

                        if (idx < captures.size())
                            replace += captures[idx];
                        else
                        {
                            std::cerr << "Capture $" << idx <<
                                " is out of range.\n";
                            skip = true;
                        }
                    }
                    else
                        replace.push_back(*i->first);
                }

                if (!skip)
                    replacements[std::make_pair(first - data_first,
                        second - first)] = replace;
            }
        }
    }

    for (; iter != end; ++iter)
    {
        const char* first = iter->_second;

        if (first >= tuple._first && first <= tuple._eoi)
        {
            const char* curr = iter->_first;
            const char* eoi = data_second;

            if (!g_show_hits && g_print.empty() && !g_rule_print)
                std::cout << pathname;

            if (g_pathname_only)
            {
                std::cout << std::endl;
                finished = true;
                break;
            }
            else if (!g_print.empty())
            {
                std::cout << build_text(g_print, captures);
            }
            else if (!g_show_hits && !g_rule_print)            {
                const auto count = std::count(data_first, curr, '\n');

                if (!pathname.empty())
                    std::cout << '(' << 1 + count << "):";

                if (count == 0)
                    curr = data_first;
                else
                    for (; *(curr - 1) != '\n'; --curr);

                for (; curr != eoi && *curr != '\r' && *curr != '\n'; ++curr)
                {
                    std::cout << *curr;
                }
            }

            if (!g_show_hits && g_print.empty() && !g_rule_print)
            {
                // Flush buffer, to give fast feedback to user
                std::cout << std::endl;
            }

            ++hits;
            break;
        }
    }

    return finished;
}

void perform_output(const std::size_t hits, const std::string& pathname,
    std::map<std::pair<std::size_t, std::size_t>, std::string>& replacements,
    const char* data_first, const char* data_second, lexertl::memory_file& mf,
    const file_type type, const std::size_t size)
{
    const auto perms = fs::status(pathname.c_str()).permissions();

    ++g_files;
    g_hits += hits;

    if ((perms & fs::perms::owner_write) != fs::perms::owner_write)
    {
        // Read-only
        if (!g_checkout.empty())
        {
            std::string checkout = g_checkout;
            const std::size_t index = checkout.find("$1");

            if (index != std::string::npos)
            {
                checkout.erase(index, 2);
                checkout.insert(index, pathname);
            }

            if (::system(checkout.c_str()) != 0)
                std::cerr << "Failed to execute " << g_checkout << ".\n";
        }
        else if (g_force_write)
            fs::permissions(pathname.c_str(), perms | fs::perms::owner_write);
    }

    if (!replacements.empty())
    {
        std::string content(data_first, data_second);

        for (auto iter = replacements.rbegin(), end = replacements.rend();
            iter != end; ++iter)
        {
            content.erase(iter->first.first, iter->first.second);
            content.insert(iter->first.first, iter->second);
        }

        replacements.clear();
        // In case the memory_file is still open
        mf.close();

        if ((fs::status(pathname.c_str()).permissions() &
            fs::perms::owner_write) != fs::perms::owner_write)
        {
            std::cerr << pathname << " is read only.\n";
        }
        else
        {
            switch (type)
            {
            case file_type::utf16:
            {
                std::vector<uint16_t> utf16;
                const unsigned char* first = reinterpret_cast
                    <const unsigned char*>(&content.front());
                const unsigned char* second = first + content.size();
                lexertl::basic_utf8_in_iterator<const unsigned char*, int32_t>
                    iter(first, second);
                lexertl::basic_utf8_in_iterator<const unsigned char*, int32_t>
                    end(second, second);

                utf16.reserve(size);
                utf16.push_back(0xfeff);

                for (; iter != end; ++iter)
                {
                    const int32_t val = *iter;
                    lexertl::basic_utf16_out_iterator<const int32_t*, uint16_t>
                        out_iter(&val, &val + 1);
                    lexertl::basic_utf16_out_iterator<const int32_t*, uint16_t>
                        out_end(&val + 1, &val + 1);

                    for (; out_iter != out_end; ++out_iter)
                    {
                        utf16.push_back(*out_iter);
                    }
                }

                std::ofstream os(pathname.c_str(), std::ofstream::binary);

                os.exceptions(std::ofstream::badbit);
                os.write(reinterpret_cast<const char*>(&utf16.front()),
                    utf16.size() * sizeof(uint16_t));
                os.close();
                break;
            }
            case file_type::utf16_flip:
            {
                std::vector<uint16_t> utf16;
                const unsigned char* first = reinterpret_cast
                    <const unsigned char*>(&content.front());
                const unsigned char* second = first + content.size();
                lexertl::basic_utf8_in_iterator<const unsigned char*, int32_t>
                    iter(first, second);
                lexertl::basic_utf8_in_iterator<const unsigned char*, int32_t>
                    end(second, second);

                utf16.reserve(size);
                utf16.push_back(0xfffe);

                for (; iter != end; ++iter)
                {
                    const int32_t val = *iter;
                    lexertl::basic_utf16_out_iterator<const int32_t*, uint16_t>
                        out_iter(&val, &val + 1);
                    lexertl::basic_utf16_out_iterator<const int32_t*, uint16_t>
                        out_end(&val + 1, &val + 1);

                    for (; out_iter != out_end; ++out_iter)
                    {
                        uint16_t flip = *out_iter;
                        lexertl::basic_flip_iterator<uint16_t*>
                            flip_iter(&flip);

                        utf16.push_back(*flip_iter);
                    }
                }

                std::ofstream os(pathname.c_str(), std::ofstream::binary);

                os.exceptions(std::ofstream::badbit);
                os.write(reinterpret_cast<const char*>(&utf16.front()),
                    utf16.size() * sizeof(uint16_t));
                os.close();
                break;
            }
            case file_type::utf8:
            {
                std::ofstream os(pathname.c_str(), std::ofstream::binary);
                const unsigned char header[] = { 0xef, 0xbb, 0xbf };

                os.exceptions(std::ofstream::badbit);
                os.write(reinterpret_cast<const char*>(header), sizeof(header));
                os.write(content.c_str(), content.size());
                os.close();
                break;
            }
            default:
            {
                std::ofstream os(pathname.c_str(), std::ofstream::binary);

                os.exceptions(std::ofstream::badbit);
                os.write(content.c_str(), content.size());
                os.close();
                break;
            }
            }
        }
    }
}

void process_file(const std::string& pathname, std::string* cin = nullptr)
{
    if (g_writable && (fs::status(pathname).permissions() &
        fs::perms::owner_write) == fs::perms::none)
    {
        return;
    }

    lexertl::memory_file mf(pathname.c_str());
    std::vector<unsigned char> utf8;
    const char* data_first = nullptr;
    const char* data_second = nullptr;
    file_type type = file_type::ansi;
    std::size_t hits = 0;
    std::vector<match> ranges;
    static lexertl::state_machine cap_sm;
    std::vector<std::string> captures;
    std::stack<std::string> matches;
    std::map<std::pair<std::size_t, std::size_t>, std::string> replacements;
    bool finished = false;

    if (!mf.data() && !cin)
    {
        std::cerr << "Error: failed to open " << pathname << ".\n";
        return;
    }

    if (cin)
    {
        std::ostringstream ss;

        ss << std::cin.rdbuf();
        *cin = ss.str();
        data_first = cin->c_str();
        data_second = data_first + cin->size();
    }
    else
    {
        data_first = mf.data();
        data_second = data_first + mf.size();
    }

    type = load_file(utf8, data_first, data_second, ranges);

    if (type == file_type::utf16 || type == file_type::utf16_flip)
        // No need for original data
        mf.close();

    do
    {
        std::map<std::pair<std::size_t, std::size_t>, std::string>
            temp_replacements;
        auto [success, negate] =
            search(ranges, data_first, matches, temp_replacements, captures);

        if (success)
            finished = process_matches(ranges, replacements, temp_replacements,
                negate, captures, data_first, data_second, cap_sm, pathname,
                hits);

        const auto& old = ranges.back();

        ranges.pop_back();

        if (!ranges.empty())
        {
            const auto& curr = ranges.back();

            // Cleardown any stale strings in matches.
            // First makes sure current range is not from the same
            // string (in matches) as the last.
            if (!matches.empty() && (old._first < curr._first ||
                old._first > curr._eoi))
            {
                while (!matches.empty() &&
                    old._first >= matches.top().c_str() &&
                    old._eoi <= matches.top().c_str() + matches.top().size())
                {
                    matches.pop();
                }
            }

            // Start searching from end of last match
            ranges.back()._first = ranges.back()._second;
        }
    } while (!finished && !ranges.empty());

    if (hits)
    {
        perform_output(hits, pathname, replacements, data_first, data_second,
            mf, type, utf8.size());

        if (g_show_hits)
            std::cout << pathname << ": " << hits << " hits." << std::endl;
    }

    ++g_searched;
}

void process_file(const fs::path& path,
    const std::pair<std::vector<wildcardtl::wildcard>,
    std::vector<wildcardtl::wildcard>>& include)
{
    // Skip directories
    if (fs::is_directory(path) ||
        (g_writable && (fs::status(path).permissions() &
            fs::perms::owner_write) == fs::perms::none))
    {
        return;
    }

    const auto pathname = path.string();

    // Skip zero length files
    if (fs::file_size(pathname) == 0)
        return;

    bool skip = !g_exclude.second.empty();

    for (const auto& wc : g_exclude.second)
    {
        if (!wc.match(pathname))
        {
            skip = false;
            break;
        }
    }

    if (!skip)
    {
        for (const auto& wc : g_exclude.first)
        {
            if (wc.match(pathname))
            {
                skip = true;
                break;
            }
        }
    }

    if (!skip)
    {
        bool process = !include.second.empty();

        for (const auto& wc : include.second)
        {
            if (wc.match(pathname))
            {
                process = false;
                break;
            }
        }

        if (!process)
        {
            for (const auto& wc : include.first)
            {
                if (wc.match(pathname))
                {
                    process = true;
                    break;
                }
            }
        }

        if (process)
            process_file(pathname);
    }
}

void process()
{
    for (const auto& pair : g_pathnames)
    {
        if (g_recursive)
        {
            for (auto iter = fs::recursive_directory_iterator(pair.first,
                fs::directory_options::skip_permission_denied),
                end = fs::recursive_directory_iterator(); iter != end; ++iter)
            {
                process_file(iter->path(), pair.second);
            }
        }
        else
        {
            for (auto iter = fs::directory_iterator(pair.first,
                fs::directory_options::skip_permission_denied),
                end = fs::directory_iterator(); iter != end; ++iter)
            {
                process_file(iter->path(), pair.second);
            }
        }
    }
}

std::string unescape(const std::string_view& vw)
 {
     std::string ret;
    bool escape = false;
 
    for (const char& c : vw)
     {
        if (c == '\\')
            escape = true;
        else
        {
            if (escape)
            {
                lexertl::detail::basic_re_tokeniser_state
                    <char, uint16_t> state(&c, &vw.back() + 1, 1, 0,
                        std::locale(), nullptr);

                ret += lexertl::detail::basic_re_tokeniser_helper
                    <char, char, uint16_t>::chr(state);
                escape = false;
            }
            else
                ret += c;
        }
    }

    return ret;
}

static std::string unescape_str(const char* first, const char* second)
{
    std::string ret = unescape(std::string_view(first, second-first));
 
    for (std::size_t idx = ret.find('\''); idx != std::string::npos;
        idx = ret.find('\'', idx + 1))
    {
        if (ret[idx + 1] == '\'')
            ret.replace(idx, 2, 1, '\'');
     }
 
     return ret;
}

void build_config_parser(bool dumpGrammar=false, bool asEbnfRR=false)
{
    parsertl::rules grules;
    lexertl::rules lrules;

    grules.token("Charset ExitState Index Integer Literal Macro MacroName "
        "Name NL Number Repeat ScriptString StartState String");

    grules.push("start", "file");
    grules.push("file",
        "directives \"%%\" grules \"%%\" rx_macros \"%%\" rx_rules \"%%\"");
    grules.push("directives", "%empty "
        "| directives directive");
    grules.push("directive", "NL");

    // Read and set %captures
    g_config_parser._actions[grules.push("directive", "\"%captures\" NL")] =
        [](config_state& state, const config_parser&)
    {
        state._grules.flags(*parsertl::rule_flags::enable_captures);
    };
    // Read and store %left entries
    g_config_parser._actions[grules.push("directive", "\"%left\" tokens NL")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& token = state._results.dollar(1, parser._gsm,
            state._productions);
        const std::string tokens = token.str();

        state._grules.left(tokens.c_str());
    };
    // Read and store %nonassoc entries
    g_config_parser._actions[grules.push("directive",
        "\"%nonassoc\" tokens NL")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& token = state._results.dollar(1, parser._gsm,
            state._productions);
        const std::string tokens = token.str();

        state._grules.nonassoc(tokens.c_str());
    };
    // Read and store %precedence entries
    g_config_parser._actions[grules.push("directive",
        "\"%precedence\" tokens NL")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& token = state._results.dollar(1, parser._gsm,
            state._productions);
        const std::string tokens = token.str();

        state._grules.precedence(tokens.c_str());
    };
    // Read and store %right entries
    g_config_parser._actions[grules.push("directive", "\"%right\" tokens NL")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& token = state._results.dollar(1, parser._gsm,
            state._productions);
        const std::string tokens = token.str();

        state._grules.right(tokens.c_str());
    };
    // Read and store %start
    g_config_parser._actions[grules.push("directive", "\"%start\" Name NL")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& token = state._results.dollar(1, parser._gsm,
            state._productions);
        const std::string name = token.str();

        state._grules.start(name.c_str());
    };
    // Read and store %token entries
    g_config_parser._actions[grules.push("directive", "\"%token\" tokens NL")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& token = state._results.dollar(1, parser._gsm,
            state._productions);
        const std::string tokens = token.str();

        state._grules.token(tokens.c_str());
    };
    grules.push("tokens", "token "
        "| tokens token");
    grules.push("token", "Literal | Name");
    // Read and store %option caseless
    g_config_parser._actions[grules.push("directive",
        "\"%option\" \"caseless\" NL")] =
        [](config_state& state, const config_parser&)
    {
            state._lrules.flags(state._lrules.flags() |
                *lexertl::regex_flags::icase);
    };
    // Read and store %x entries
    g_config_parser._actions[grules.push("directive", "\"%x\" names NL")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& names = state._results.dollar(1, parser._gsm,
            state._productions);
        const char* start = names.first;
        const char* curr = start;

        for (; curr != names.second; ++curr)
        {
            if (*curr == ' ' || *curr == '\t')
            {
                    state._lrules.push_state(std::string(start, curr).c_str());

                do
                {
                    ++curr;
                } while (curr != names.second &&
                    (*curr == ' ' || *curr == '\t'));

                start = curr;
            }
        }

        if (start != curr)
        {
                state._lrules.push_state(std::string(start, curr).c_str());
        }
    };
    grules.push("names", "Name "
        "| names Name");

    // Grammar rules
    grules.push("grules", "%empty "
        "| grules grule");
    grules.push("grule", "lhs ':' production ';'");
    g_config_parser._actions[grules.push("lhs", "Name")] =
        [](config_state& state, const config_parser& parser)
    {
        state._lhs = state._results.dollar(0, parser._gsm,
            state._productions).str();
    };
    grules.push("production", "opt_prec_list "
        "| production '|' opt_prec_list");
    g_config_parser._actions[grules.push("opt_prec_list",
        "opt_list opt_prec opt_script")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& item1 = state._results.dollar(0, parser._gsm,
            state._productions);
        const auto& item2 = state._results.dollar(1, parser._gsm,
            state._productions);
        const auto rhs = std::string(item1.first, item2.second);
        const uint16_t prod_index = state._grules.push(state._lhs, rhs);
        auto iter = g_force_unicode ?
            g_curr_uparser->_actions.find(prod_index) :
            g_curr_parser->_actions.find(prod_index);

        if (iter != (g_force_unicode ? g_curr_uparser->_actions.end() :
            g_curr_parser->_actions.end()))
        {
            for (const auto& cmd : iter->second)
            {
                if (cmd._param1 >=
                    state._grules.grammar().back()._rhs._symbols.size())
                {
                    std::ostringstream ss;

                    ss << "Index $" << cmd._param1 + 1 << " is out of range.";
                    throw std::runtime_error(ss.str());
                }

                if (cmd._param2 >=
                    state._grules.grammar().back()._rhs._symbols.size())
                {
                    std::ostringstream ss;

                    ss << "Index $" << cmd._param2 + 1 << " is out of range.";
                    throw std::runtime_error(ss.str());
                }

                if (cmd._param1 == cmd._param2 && cmd._second1 > cmd._second2)
                {
                    std::ostringstream ss;

                    ss << "Index $" << cmd._param2 + 1 <<
                        " cannot have first following second.";
                    throw std::runtime_error(ss.str());
                }
            }
        }
    };
    grules.push("opt_list", "%empty "
        "| \"%empty\" "
        "| rhs_list");
    grules.push("rhs_list", "rhs "
        "| rhs_list rhs");
    grules.push("rhs", "Literal "
        "| Name "
        "| '[' production ']' "
        "| rhs '?' "
        "| rhs '*' "
        "| rhs '+' "
        "| '(' production ')'");
    grules.push("opt_prec", "%empty "
        "| \"%prec\" Literal "
        "| \"%prec\" Name");
    grules.push("opt_script", "%empty");
    g_config_parser._actions[grules.push("opt_script", "'{' cmd_list '}'")] =
        [](config_state& state, const config_parser& parser)
    {
        if (!parser._gsm._captures.empty())
            throw std::runtime_error("Cannot mix %captures and actions.");

        const auto& token = state._results.dollar(1, parser._gsm,
            state._productions);

        if (token.first == token.second)
        {
            const uint16_t size = static_cast<uint16_t>(state._grules.
                grammar().size());

            // No commands
                g_curr_parser->_reduce_set.insert(size);
        }
    };
    grules.push("cmd_list", "%empty "
        "| cmd_list single_cmd ';'");
    grules.push("single_cmd", "cmd");
    g_config_parser._actions[grules.push("single_cmd",
        "mod_cmd")] =
        [](config_state&, const config_parser&)
    {
        g_modify = true;
    };
    g_config_parser._actions[grules.push("mod_cmd",
        "\"erase\" '(' Index ')'")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& token = state._results.dollar(2, parser._gsm,
            state._productions);
        const uint16_t rule_idx = static_cast<uint16_t>(state._grules.
            grammar().size());
        const uint16_t index = static_cast<uint16_t>(atoi(token.first + 1) - 1);

            g_curr_parser->_actions[rule_idx].emplace_back(cmd_type::erase,
                index, erase_cmd());
    };
    g_config_parser._actions[grules.push("mod_cmd",
        "\"erase\" '(' Index ',' Index ')'")] =
        [](config_state& state, const config_parser& parser)
    {
        const uint16_t rule_idx = static_cast<uint16_t>(state._grules.
            grammar().size());
        const auto& token2 = state._results.dollar(2, parser._gsm,
            state._productions);
        const auto& token4 = state._results.dollar(4, parser._gsm,
            state._productions);
        const uint16_t index1 =
            static_cast<uint16_t>(atoi(token2.first + 1) - 1);
        const uint16_t index2 =
            static_cast<uint16_t>(atoi(token4.first + 1) - 1);

            g_curr_parser->_actions[rule_idx].emplace_back(cmd_type::erase,
                index1, index2, erase_cmd());
    };
    g_config_parser._actions[grules.push("mod_cmd",
        "\"erase\" '(' Index '.' first_second ',' Index '.' first_second ')'")] =
        [](config_state& state, const config_parser& parser)
    {
        const uint16_t rule_idx = static_cast<uint16_t>(state._grules.
            grammar().size());
        const auto& token2 = state._results.dollar(2, parser._gsm,
            state._productions);
        const bool second1 = *state._results.dollar(4, parser._gsm,
            state._productions).first == 's';
        const auto& token6 = state._results.dollar(6, parser._gsm,
            state._productions);
        const bool second2 = *state._results.dollar(8, parser._gsm,
            state._productions).first == 's';
        const uint16_t index1 =
            static_cast<uint16_t>(atoi(token2.first + 1) - 1);
        const uint16_t index2 =
            static_cast<uint16_t>(atoi(token6.first + 1) - 1);

            g_curr_parser->_actions[rule_idx].emplace_back(cmd_type::erase,
                index1, second1, index2, second2, erase_cmd());
    };
    g_config_parser._actions[grules.push("mod_cmd",
        "\"insert\" '(' Index ',' ScriptString ')'")] =
        [](config_state& state, const config_parser& parser)
    {
        const uint16_t rule_idx = static_cast<uint16_t>(state._grules.
            grammar().size());
        const auto& token2 = state._results.dollar(2, parser._gsm,
            state._productions);
        const uint16_t index =
            static_cast<uint16_t>(atoi(token2.first + 1) - 1);
        const auto& token4 = state._results.dollar(4, parser._gsm,
            state._productions);
        const std::string text =
            unescape_str(token4.first + 1, token4.second - 1);

            g_curr_parser->_actions[rule_idx].emplace_back(cmd_type::insert,
                index, insert_cmd(text));
    };
    g_config_parser._actions[grules.push("mod_cmd",
        "\"insert\" '(' Index '.' \"second\" ',' ScriptString ')'")] =
        [](config_state& state, const config_parser& parser)
    {
        const uint16_t rule_idx = static_cast<uint16_t>(state._grules.
            grammar().size());
        const auto& token2 = state._results.dollar(2, parser._gsm,
            state._productions);
        const uint16_t index =
            static_cast<uint16_t>(atoi(token2.first + 1) - 1);
        const auto& token6 = state._results.dollar(6, parser._gsm,
            state._productions);
        const std::string text =
            unescape_str(token6.first + 1, token6.second - 1);

            g_curr_parser->_actions[rule_idx].emplace_back(cmd_type::insert,
                index, true, insert_cmd(text));
    };
    g_config_parser._actions[grules.push("cmd", "\"match\" '=' Index")] =
        [](config_state& state, const config_parser& parser)
    {
        const uint16_t rule_idx = static_cast<uint16_t>(state._grules.
            grammar().size());
        const auto& token = state._results.dollar(2, parser._gsm,
            state._productions);
        const uint16_t index = static_cast<uint16_t>(atoi(token.first + 1) - 1);

            g_curr_parser->_actions[rule_idx].emplace_back(cmd_type::assign,
                index, match_cmd(0, 0));
    };
    g_config_parser._actions[grules.push("cmd",
        "\"match\" '=' \"substr\" '(' Index ',' Integer ',' Integer ')'")] =
        [](config_state& state, const config_parser& parser)
    {
        const uint16_t rule_idx = static_cast<uint16_t>(state._grules.
            grammar().size());
        const auto& token4 = state._results.dollar(4, parser._gsm,
            state._productions);
        const uint16_t index =
            static_cast<uint16_t>(atoi(token4.first + 1) - 1);
        const auto& token6 = state._results.dollar(6, parser._gsm,
            state._productions);
        const auto& token8 = state._results.dollar(8, parser._gsm,
            state._productions);

            g_curr_parser->_actions[rule_idx].emplace_back(cmd_type::assign,
                index, match_cmd(static_cast<uint16_t>(atoi(token6.first)),
                    static_cast<uint16_t>(atoi(token8.first))));
    };
    g_config_parser._actions[grules.push("mod_cmd",
        "\"print\" '(' ScriptString ')'")] =
        [](config_state& state, const config_parser& parser)
        {
            const auto rule_idx = static_cast<uint16_t>
                (state._grules.grammar().size());
            const auto& token2 = state._results.dollar(2, parser._gsm,
                state._productions);
            const std::string text =
                unescape_str(token2.first + 1, token2.second - 1);

            if (g_force_unicode)
            {
                g_curr_uparser->_actions[rule_idx].
                    emplace_back(cmd_type::print, print_cmd(text));
            }
            else
            {
                g_curr_parser->_actions[rule_idx].
                    emplace_back(cmd_type::print, print_cmd(text));
            }

            state._print = true;
        };
    g_config_parser._actions[grules.push("cmd", "\"match\" \"+=\" Index")] =
        [](config_state& state, const config_parser& parser)
    {
        const uint16_t rule_idx = static_cast<uint16_t>(state._grules.
            grammar().size());
        const auto& token = state._results.dollar(2, parser._gsm,
            state._productions);
        const uint16_t index = static_cast<uint16_t>(atoi(token.first + 1) - 1);

            g_curr_parser->_actions[rule_idx].emplace_back(cmd_type::append,
                index, match_cmd(0, 0));
    };
    g_config_parser._actions[grules.push("cmd",
        "\"match\" \"+=\" \"substr\" '(' Index ',' Integer ',' Integer ')'")] =
        [](config_state& state, const config_parser& parser)
    {
        const uint16_t rule_idx = static_cast<uint16_t>(state._grules.
            grammar().size());
        const auto& token4 = state._results.dollar(4, parser._gsm,
            state._productions);
        const uint16_t index =
            static_cast<uint16_t>(atoi(token4.first + 1) - 1);
        const auto& token6 = state._results.dollar(6, parser._gsm,
            state._productions);
        const auto& token8 = state._results.dollar(8, parser._gsm,
            state._productions);

            g_curr_parser->_actions[rule_idx].emplace_back(cmd_type::append,
                index, match_cmd(static_cast<uint16_t>(atoi(token6.first)),
                    static_cast<uint16_t>(atoi(token8.first))));
    };
    g_config_parser._actions[grules.push("mod_cmd",
        "\"replace\" '(' Index ',' ScriptString ')'")] =
        [](config_state& state, const config_parser& parser)
    {
        const uint16_t rule_idx = static_cast<uint16_t>(state._grules.
            grammar().size());
        const auto& token2 = state._results.dollar(2, parser._gsm,
            state._productions);
        const uint16_t index =
            static_cast<uint16_t>(atoi(token2.first + 1) - 1);
        const auto& token4 = state._results.dollar(4, parser._gsm,
            state._productions);
        const std::string text =
            unescape_str(token4.first + 1, token4.second - 1);

            g_curr_parser->_actions[rule_idx].
            emplace_back(cmd_type::replace, index, replace_cmd(text));
    };
    g_config_parser._actions[grules.push("mod_cmd",
        "\"replace\" '(' Index ',' Index ',' ScriptString ')'")] =
        [](config_state& state, const config_parser& parser)
    {
        const uint16_t rule_idx = static_cast<uint16_t>(state._grules.
            grammar().size());
        const auto& token2 = state._results.dollar(2, parser._gsm,
            state._productions);
        const uint16_t index1 =
            static_cast<uint16_t>(atoi(token2.first + 1) - 1);
        const auto& token4 = state._results.dollar(4, parser._gsm,
            state._productions);
        const uint16_t index2 =
            static_cast<uint16_t>(atoi(token4.first + 1) - 1);
        const auto& token6 = state._results.dollar(6, parser._gsm,
            state._productions);
        const std::string text =
            unescape_str(token6.first + 1, token6.second - 1);

            g_curr_parser->_actions[rule_idx].
            emplace_back(cmd_type::replace, index1, index2,
                replace_cmd(text));
    };
    g_config_parser._actions[grules.push("mod_cmd",
        "\"replace\" '(' Index '.' first_second ',' "
        "Index '.' first_second ',' ScriptString ')'")] =
        [](config_state& state, const config_parser& parser)
    {
        const uint16_t rule_idx = static_cast<uint16_t>(state._grules.
            grammar().size());
        const auto& token2 = state._results.dollar(2, parser._gsm,
            state._productions);
        const uint16_t index1 =
            static_cast<uint16_t>(atoi(token2.first + 1) - 1);
        const bool second1 = *state._results.dollar(4, parser._gsm,
            state._productions).first == 's';
        const auto& token6 = state._results.dollar(6, parser._gsm,
            state._productions);
        const uint16_t index2 =
            static_cast<uint16_t>(atoi(token6.first + 1) - 1);
        const bool second2 = *state._results.dollar(8, parser._gsm,
            state._productions).first == 's';
        const auto& token10 = state._results.dollar(10, parser._gsm,
            state._productions);
        const std::string text =
            unescape_str(token10.first + 1, token10.second - 1);

            g_curr_parser->_actions[rule_idx].
            emplace_back(cmd_type::replace, index1, second1, index2,
                second2, replace_cmd(text));
    };
    g_config_parser._actions[grules.push("mod_cmd",
        "\"replace_all\" '(' Index ',' ScriptString ',' ScriptString ')'")] =
        [](config_state& state, const config_parser& parser)
    {
        const uint16_t rule_idx = static_cast<uint16_t>(state._grules.
            grammar().size());
        const auto& token2 = state._results.dollar(2, parser._gsm,
            state._productions);
        const uint16_t index =
            static_cast<uint16_t>(atoi(token2.first + 1) - 1);
        const auto& token4 = state._results.dollar(4, parser._gsm,
            state._productions);
        const std::string text1 =
            unescape_str(token4.first + 1, token4.second - 1);
        const auto& token6 = state._results.dollar(6, parser._gsm,
            state._productions);
        const std::string text2 =
            unescape_str(token6.first + 1, token6.second - 1);

            g_curr_parser->_actions[rule_idx].
            emplace_back(cmd_type::replace_all, index,
                replace_all_cmd(text1, text2));
    };
    grules.push("first_second", "\"first\" | \"second\"");

    // Token regex macros
    grules.push("rx_macros", "%empty");
    g_config_parser._actions[grules.push("rx_macros",
        "rx_macros MacroName regex")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& token = state._results.dollar(1, parser._gsm,
            state._productions);
        const std::string name = token.str();
        const std::string regex = state._results.dollar(2, parser._gsm,
            state._productions).str();

            state._lrules.insert_macro(name.c_str(), regex.c_str());
    };

    // Tokens
    grules.push("rx_rules", "%empty");
    g_config_parser._actions[grules.push("rx_rules", "rx_rules regex Number")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& token = state._results.dollar(1, parser._gsm,
            state._productions);
        const std::string regex = token.str();
        const std::string number = state._results.dollar(2, parser._gsm,
            state._productions).str();

            state._lrules.push(regex,
                static_cast<uint16_t>(atoi(number.c_str())));
    };
    g_config_parser._actions[grules.push("rx_rules",
        "rx_rules StartState regex ExitState")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& start_state = state._results.dollar(1, parser._gsm,
            state._productions);
        const std::string regex = state._results.dollar(2, parser._gsm,
            state._productions).str();
        const auto& exit_state = state._results.dollar(3, parser._gsm,
            state._productions);

            state._lrules.push(std::string(start_state.first + 1,
                start_state.second - 1).c_str(), regex,
                std::string(exit_state.first + 1,
                    exit_state.second - 1).c_str());
    };
    g_config_parser._actions[grules.push("rx_rules",
        "rx_rules StartState regex ExitState Number")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& start_state = state._results.dollar(1, parser._gsm,
            state._productions);
        const std::string regex = state._results.dollar(2, parser._gsm,
            state._productions).str();
        const auto& exit_state = state._results.dollar(3, parser._gsm,
            state._productions);
        const std::string number = state._results.dollar(4, parser._gsm,
            state._productions).str();

            state._lrules.push(std::string(start_state.first + 1,
                start_state.second - 1).c_str(),
                regex, static_cast<uint16_t>(atoi(number.c_str())),
                std::string(exit_state.first + 1,
                    exit_state.second - 1).c_str());
    };
    g_config_parser._actions[grules.push("rx_rules",
        "rx_rules regex Literal")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& token = state._results.dollar(1, parser._gsm,
            state._productions);
        const std::string regex = token.str();
        const std::string literal = state._results.dollar(2, parser._gsm,
            state._productions).str();

            state._lrules.push(regex, state._grules.token_id(literal.c_str()));
    };
    g_config_parser._actions[grules.push("rx_rules",
        "rx_rules StartState regex ExitState Literal")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& start_state = state._results.dollar(1, parser._gsm,
            state._productions);
        const std::string regex = state._results.dollar(2, parser._gsm,
            state._productions).str();
        const auto& exit_state = state._results.dollar(3, parser._gsm,
            state._productions);
        const std::string literal = state._results.dollar(4, parser._gsm,
            state._productions).str();

            state._lrules.push(std::string(start_state.first + 1,
                start_state.second - 1).c_str(),
                regex, state._grules.token_id(literal.c_str()),
                std::string(exit_state.first + 1,
                    exit_state.second - 1).c_str());
    };
    g_config_parser._actions[grules.push("rx_rules", "rx_rules regex Name")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& token = state._results.dollar(1, parser._gsm,
            state._productions);
        const std::string regex = token.str();
        const std::string name = state._results.dollar(2, parser._gsm,
            state._productions).str();

            state._lrules.push(regex, state._grules.token_id(name.c_str()));
    };
    g_config_parser._actions[grules.push("rx_rules",
        "rx_rules StartState regex ExitState Name")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& start_state = state._results.dollar(1, parser._gsm,
            state._productions);
        const std::string regex = state._results.dollar(2, parser._gsm,
            state._productions).str();
        const auto& exit_state = state._results.dollar(3, parser._gsm,
            state._productions);
        const std::string name = state._results.dollar(4, parser._gsm,
            state._productions).str();

            state._lrules.push(std::string(start_state.first + 1,
                start_state.second - 1).c_str(),
                regex, state._grules.token_id(name.c_str()),
                std::string(exit_state.first + 1,
                    exit_state.second - 1).c_str());
    };
    g_config_parser._actions[grules.push("rx_rules",
        "rx_rules regex \"skip()\"")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& token = state._results.dollar(1, parser._gsm,
            state._productions);
        const std::string regex = token.str();

            state._lrules.push(regex, lexertl::rules::skip());
    };
    g_config_parser._actions[grules.push("rx_rules",
        "rx_rules StartState regex ExitState \"skip()\"")] =
        [](config_state& state, const config_parser& parser)
    {
        const auto& start_state = state._results.dollar(1, parser._gsm,
            state._productions);
        const std::string regex = state._results.dollar(2, parser._gsm,
            state._productions).str();
        const auto& exit_state = state._results.dollar(3, parser._gsm,
            state._productions);

            state._lrules.push(std::string(start_state.first + 1,
                start_state.second - 1).c_str(),
                regex, lexertl::rules::skip(),
                std::string(exit_state.first + 1,
                    exit_state.second - 1).c_str());
    };

    // Regex
    grules.push("regex", "rx "
        "| '^' rx "
        "| rx '$' "
        "| '^' rx '$'");
    grules.push("rx", "sequence "
        "| rx '|' sequence");
    grules.push("sequence", "item "
        "| sequence item");
    grules.push("item", "atom "
        "| atom repeat");
    grules.push("atom", "Charset "
        "| Macro "
        "| String "
        "| '(' rx ')'");
    grules.push("repeat", "'?' "
        "| \"\?\?\" "
        "| '*' "
        "| \"*?\" "
        "| '+' "
        "| \"+?\" "
        "| Repeat");

    std::string warnings;

    if(dumpGrammar)
    {
        parsertl::debug::dump(grules, std::cout, asEbnfRR);
    }
    parsertl::generator::build(grules, g_config_parser._gsm, &warnings);

    if (!warnings.empty())
        std::cerr << "Config parser warnings: " << warnings;

    lrules.push_state("OPTION");
    lrules.push_state("GRULE");
    lrules.push_state("SCRIPT");
    lrules.push_state("MACRO");
    lrules.push_state("REGEX");
    lrules.push_state("RULE");
    lrules.push_state("ID");
    lrules.insert_macro("c_comment", R"("/*"(?s:.)*?"*/")");
    lrules.insert_macro("escape", R"(\\(.|x[0-9A-Fa-f]+|c[@a-zA-Z]))");
    lrules.insert_macro("posix_name", "alnum|alpha|blank|cntrl|digit|graph|"
        "lower|print|punct|space|upper|xdigit");
    lrules.insert_macro("posix", R"(\[:{posix_name}:\])");
    lrules.insert_macro("state_name", R"([A-Z_a-z]\w*)");

    lrules.push("INITIAL,OPTION", "[ \t]+", lexertl::rules::skip(), ".");
    lrules.push("\n|\r\n", grules.token_id("NL"));
    lrules.push("%captures", grules.token_id("\"%captures\""));
    lrules.push("%left", grules.token_id("\"%left\""));
    lrules.push("%nonassoc", grules.token_id("\"%nonassoc\""));
    lrules.push("%precedence", grules.token_id("\"%precedence\""));
    lrules.push("%right", grules.token_id("\"%right\""));
    lrules.push("%start", grules.token_id("\"%start\""));
    lrules.push("%token", grules.token_id("\"%token\""));
    lrules.push("%x", grules.token_id("\"%x\""));
    lrules.push("INITIAL", "%option", grules.token_id("\"%option\""), "OPTION");
    lrules.push("OPTION", "caseless", grules.token_id("\"caseless\""), "INITIAL");
    lrules.push("INITIAL", "%%", grules.token_id("\"%%\""), "GRULE");

    lrules.push("GRULE", ":", grules.token_id("':'"), ".");
    lrules.push("GRULE", R"(\[)", grules.token_id("'['"), ".");
    lrules.push("GRULE", R"(\])", grules.token_id("']'"), ".");
    lrules.push("GRULE", R"(\()", grules.token_id("'('"), ".");
    lrules.push("GRULE", R"(\))", grules.token_id("')'"), ".");
    lrules.push("GRULE", R"(\?)", grules.token_id("'?'"), ".");
    lrules.push("GRULE", R"(\*)", grules.token_id("'*'"), ".");
    lrules.push("GRULE", R"(\+)", grules.token_id("'+'"), ".");
    lrules.push("GRULE", R"(\|)", grules.token_id("'|'"), ".");
    lrules.push("GRULE", "%prec", grules.token_id("\"%prec\""), ".");
    lrules.push("GRULE", ";", grules.token_id("';'"), ".");
    lrules.push("GRULE", R"(\{)", grules.token_id("'{'"), "SCRIPT");
    lrules.push("SCRIPT", R"(\})", grules.token_id("'}'"), "GRULE");
    lrules.push("SCRIPT", "=", grules.token_id("'='"), ".");
    lrules.push("SCRIPT", ",", grules.token_id("','"), ".");
    lrules.push("SCRIPT", R"(\()", grules.token_id("'('"), ".");
    lrules.push("SCRIPT", R"(\))", grules.token_id("')'"), ".");
    lrules.push("SCRIPT", R"(\.)", grules.token_id("'.'"), ".");
    lrules.push("SCRIPT", ";", grules.token_id("';'"), ".");
    lrules.push("SCRIPT", R"(\+=)", grules.token_id("\"+=\""), ".");
    lrules.push("SCRIPT", "erase", grules.token_id("\"erase\""), ".");
    lrules.push("SCRIPT", "first", grules.token_id("\"first\""), ".");
    lrules.push("SCRIPT", "insert", grules.token_id("\"insert\""), ".");
    lrules.push("SCRIPT", "match", grules.token_id("\"match\""), ".");
    lrules.push("SCRIPT", "print", grules.token_id("\"print\""), ".");
    lrules.push("SCRIPT", "replace", grules.token_id("\"replace\""), ".");
    lrules.push("SCRIPT", "replace_all", grules.token_id("\"replace_all\""), ".");
    lrules.push("SCRIPT", "second", grules.token_id("\"second\""), ".");
    lrules.push("SCRIPT", "substr", grules.token_id("\"substr\""), ".");
    lrules.push("SCRIPT", R"(\d+)", grules.token_id("Integer"), ".");
    lrules.push("SCRIPT", R"(\s+)", lexertl::rules::skip(), ".");
    lrules.push("SCRIPT", R"(\$[1-9]\d*)", grules.token_id("Index"), ".");
    lrules.push("SCRIPT", "'(''|[^'])*'", grules.token_id("ScriptString"), ".");
    lrules.push("GRULE", "[ \t]+|\n|\r\n", lexertl::rules::skip(), ".");
    lrules.push("GRULE", "%empty", grules.token_id("\"%empty\""), ".");
    lrules.push("GRULE", "%%", grules.token_id("\"%%\""), "MACRO");
    lrules.push("INITIAL,GRULE,SCRIPT", "{c_comment}", lexertl::rules::skip(), ".");
    // Bison supports single line comments
    lrules.push("INITIAL,GRULE,SCRIPT", R"("//".*)", lexertl::rules::skip(), ".");
    lrules.push("INITIAL,GRULE,ID",
        R"('(\\([^0-9cx]|\d{1,3}|c[@a-zA-Z]|x\d+)|[^\\\r\n'])+'|)"
        R"(\"(\\([^0-9cx]|\d{1,3}|c[@a-zA-Z]|x\d+)|[^\\\r\n"])+\")",
        grules.token_id("Literal"), ".");
    lrules.push("INITIAL,GRULE,ID", "[.A-Z_a-z][-.0-9A-Z_a-z]*",
        grules.token_id("Name"), ".");
    lrules.push("ID", R"([1-9]\d*)", grules.token_id("Number"), ".");

    lrules.push("MACRO,RULE", "%%", grules.token_id("\"%%\""), "RULE");
    lrules.push("MACRO", R"([A-Z_a-z]\w*)",
        grules.token_id("MacroName"), "REGEX");
    lrules.push("MACRO", "{c_comment}", lexertl::rules::skip(), ".");
    lrules.push("MACRO,REGEX", "\n|\r\n", lexertl::rules::skip(), "MACRO");

    lrules.push("REGEX", "[ \t]+", lexertl::rules::skip(), ".");
    lrules.push("RULE", "^[ \t]+({c_comment}([ \t]+|{c_comment})*)?",
        lexertl::rules::skip(), ".");
    lrules.push("RULE", R"(^<(\*|{state_name}(,{state_name})*)>)",
        grules.token_id("StartState"), ".");
    lrules.push("REGEX,RULE", R"(\^)", grules.token_id("'^'"), ".");
    lrules.push("REGEX,RULE", R"(\$)", grules.token_id("'$'"), ".");
    lrules.push("REGEX,RULE", R"(\|)", grules.token_id("'|'"), ".");
    lrules.push("REGEX,RULE", R"(\((\?(-?[is])*:)?)",
        grules.token_id("'('"), ".");
    lrules.push("REGEX,RULE", R"(\))", grules.token_id("')'"), ".");
    lrules.push("REGEX,RULE", R"(\?)", grules.token_id("'?'"), ".");
    lrules.push("REGEX,RULE", R"(\?\?)", grules.token_id("\"\?\?\""), ".");
    lrules.push("REGEX,RULE", R"(\*)", grules.token_id("'*'"), ".");
    lrules.push("REGEX,RULE", R"(\*\?)", grules.token_id("\"*?\""), ".");
    lrules.push("REGEX,RULE", R"(\+)", grules.token_id("'+'"), ".");
    lrules.push("REGEX,RULE", R"(\+\?)", grules.token_id("\"+?\""), ".");
    lrules.push("REGEX,RULE", R"({escape}|(\[^?({escape}|{posix}|)"
        R"([^\\\]])*\])|\S)",
        grules.token_id("Charset"), ".");
    lrules.push("REGEX,RULE", R"(\{[A-Z_a-z][-0-9A-Z_a-z]*\})",
        grules.token_id("Macro"), ".");
    lrules.push("REGEX,RULE", R"(\{\d+(,(\d+)?)?\}[?]?)",
        grules.token_id("Repeat"), ".");
    lrules.push("REGEX,RULE", R"(\"(\\.|[^\\\r\n"])*\")",
        grules.token_id("String"), ".");

    lrules.push("RULE,ID", "[ \t]+({c_comment}([ \t]+|{c_comment})*)?",
        lexertl::rules::skip(), "ID");
    lrules.push("RULE", R"(<(\.|<|{state_name}|>{state_name}(:{state_name})?)>)",
        grules.token_id("ExitState"), "ID");
    lrules.push("RULE,ID", "\n|\r\n", lexertl::rules::skip(), "RULE");
    lrules.push("ID", R"(skip\s*\(\s*\))",
        grules.token_id("\"skip()\""), "RULE");
    lexertl::generator::build(lrules, g_config_parser._lsm);
    if(dumpGrammar)
    {
        parsertl::rules::string_vector terminals;
        grules.terminals(terminals);
        lexertl::debug::dump(lrules, std::cout, terminals);
    }
}

void show_help()
{
    std::cout << "--help\t\t\tShows help.\n"
        "-checkout\t\t<checkout command (include $1 for pathname)>.\n"
        "-E <regex>\t\tSearch using DFA regex.\n"
        "-Ee <regex>\t\tAs -E but continue search following match.\n"
        "-exclude <wildcard>\tExclude pathnames matching wildcard.\n"
        "-f <config file>\tSearch using config file.\n"
        "-fe <config file>\tAs -f but continue search following match.\n"
        "-force_write\t\tIf a file is read only, force it to be writable.\n"
        "-hits\t\t\tShow hit count per file.\n"
        "-i\t\t\tCase insensitive searching.\n"
        "-l\t\t\tOutput pathname only.\n"
        "-o\t\t\tOutput changes to matching file.\n"
        "-P <regex>\t\tSearch using std::regex.\n"
        "-Pe <regex>\t\tAs -P but continue search following match.\n"
        "-print <text>\t\tPrint text instead of line of match.\n"
        "-r, -R, --recursive\tRecurse subdirectories.\n"
        "-replace\t\tReplacement literal text.\n"
        "-shutdown\t\t<command to run when exiting>.\n"
        "-startup\t\t<command to run at startup>.\n"
        "-T <text>\t\tSearch for plain text with support for capture ($n) syntax.\n"
        "-Tw <text>\t\tAs -T but with whole word matching.\n"
        "-utf8\t\t\tIn the absence of a BOM assume UTF-8\n"
        "-vE <regex>\t\tSearch using DFA regex (negated).\n"
        "-VE <regex>\t\tSearch using DFA regex (all negated).\n"
        "-vf <config file>\tSearch using config file (negated).\n"
        "-Vf <config file>\tSearch using config file (all negated).\n"
        "-vP <regex>\t\tSearch using std::regex (negated).\n"
        "-VP <regex>\t\tSearch using std::regex (all negated).\n"
        "-vT <text>\t\tSearch for plain text with support for capture ($n) syntax (negated).\n"
        "-vTw <text>\t\tAs -vT but with whole word matching.\n"
        "-VT <text>\t\tSearch for plain text with support for capture ($n) syntax (all negated).\n"
        "-VTw <text>\t\tAs -VT but with whole word matching.\n"
        "-writable\t\tOnly process files that are writable.\n"
        "<pathname>...\t\tFiles to search (wildcards supported).\n\n"
        "Config file format:\n\n"
        "<grammar directives>\n"
        "%%\n"
        "<grammar>\n"
        "%%\n"
        "<regex macros>\n"
        "%%\n"
        "<regexes>\n"
        "%%\n\n"
        "Grammar Directives:\n\n"
        "%captures\n"
        "%option caseless\n"
        "%token\n"
        "%left\n"
        "%right\n"
        "%nonassoc\n"
        "%precedence\n"
        "%start\n"
        "%x\n\n"
        "Grammar scripting:\n\n"
        "erase($n);\n"
        "erase($from, $to);\n"
        "erase($from.second, $to.first);\n"
        "insert($n, 'text');\n"
        "insert($n.second, 'text');\n"
        "match = $n;\n"
        "match += $n;\n"
        "match = substr($n, <omit from left>, <omit from right>);\n"
        "match += substr($n, <omit from left>, <omit from right>);\n"
        "print('text');\n"
        "replace($n, 'text');\n"
        "replace($from, $to, 'text');\n"
        "replace($from.second, $to.first, 'text');\n"
        "replace_all($n, 'regex', 'text');\n\n"
        "Example:\n\n"
        "%token RawString String\n"
        "%%\n"
        "list: String { match = substr($1, 1, 1); };\n"
        "list: RawString { match = substr($1, 3, 2); };\n"
        "list: list String { match += substr($2, 1, 1); };\n"
        "list: list RawString { match += substr($2, 3, 2); };\n"
        "%%\n"
        "ws [ \\t\\r\\n]+\n"
        "%%\n"
        R"(\"([^"\\\r\n]|\\.)*\"        String)"
        "\n"
        R"(R\"\((?s:.)*?\)\"            RawString)"
        "\n"
        R"('([^'\\\r\n]|\\.)*'          skip())"
        "\n"
        R"({ws}|"//".*|"/*"(?s:.)*?"*/" skip())"
        "\n"
        "%%\n\n"
        "Note that you can pipeline searches by using multiple switches.\n"
        "The searches are run in the order they occur on the command line.\n";
}

bool is_windows()
{
#ifdef WIN32
    return true;
#else
    return false;
#endif
}

void add_pathname(std::string pn,
    std::map<std::string, std::pair<std::vector<wildcardtl::wildcard>,
    std::vector<wildcardtl::wildcard>>>& map)
{
    const std::size_t wc_idx = pn.find_first_of("*?[");
    const std::size_t sep_idx = pn.rfind(fs::path::preferred_separator,
        wc_idx);
    const bool negate = pn[0] == '!';
    const std::string path = sep_idx == std::string::npos ? "." :
        pn.substr(negate ? 1 : 0, sep_idx + (negate ? 0 : 1));
    auto& [positive, negative] = map[path];

    if (sep_idx == std::string::npos)
    {
        if (!((!negate && wc_idx == 0) || (negate && wc_idx == 1)))
        {
            if (g_recursive)
                pn.insert(negate ? 1 : 0, std::string(1, '*') +
                    static_cast<char>(fs::path::preferred_separator));
            else
                pn.insert(negate ? 1 : 0, path +
                    static_cast<char>(fs::path::preferred_separator));
        }
    }
    else if (g_recursive &&
        !((!negate && wc_idx == 0) || (negate && wc_idx == 1)))
    {
        pn = std::string(1, '*') + pn.substr(sep_idx);

        if (negate)
            pn = '!' + pn;
    }

    if (negate)
        negative.emplace_back(pn, is_windows());
    else
        positive.emplace_back(pn, is_windows());
}

std::vector<std::string_view> split(const char* str, const char c)
{
    std::vector<std::string_view> ret;
    const char* first = str;
    std::size_t count = 0;

    for (; *str; ++str)
    {
        if (*str == c)
        {
            count = str - first;

            if (count > 0)
                ret.emplace_back(first, count);

            first = str + 1;
        }
    }

    count = str - first;

    if (count > 0)
        ret.emplace_back(first, count);

    return ret;
}

void read_switches(const int argc, const char* const argv[],
    std::vector<config>& configs, std::vector<std::string>& files)
{
    for (int i = 1; i < argc; ++i)
    {
        const char* param = argv[i];

        if (strcmp("-checkout", param) == 0)
        {
            ++i;
            param = argv[i];

            if (i < argc)
            {
                // "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\tf.exe"
                // checkout $1
                // *NOTE* $1 is replaced by the pathname
                g_checkout = param;
            }
            else
                throw std::runtime_error("Missing pathname "
                    "following -checkout.");
        }
        else if (strcmp("-dump", param) == 0)
        {
            g_dump = true;
        }
        else if (strcmp("-dumpMaster", param) == 0)
        {
            g_dump_master = true;
        }
        else if (strcmp("-E", param) == 0)
        {
            // DFA regex
            ++i;
            param = argv[i];

            if (i < argc)
                configs.emplace_back(match_type::dfa_regex, param, config_flags::none);
            else
                throw std::runtime_error("Missing regex following -E.");
        }
        else if (strcmp("-Ee", param) == 0)
        {
            // DFA regex
            ++i;
            param = argv[i];

            if (i < argc)
                configs.emplace_back(match_type::dfa_regex, param,
                    config_flags::extend_search);
            else
                throw std::runtime_error("Missing regex following -Ee.");
        }
        else if (strcmp("-exclude", param) == 0)
        {
            ++i;

            if (i < argc)
            {
                auto pathnames = split(argv[i], ';');

                for (const auto& p : pathnames)
                {
                    param = p.data();

                    if (*param == '!')
                        g_exclude.second.
                        emplace_back(&param[1],
                            param + p.size(), is_windows());
                    else
                        g_exclude.first.emplace_back(param, param + p.size(),
                            is_windows());
                }
            }
            else
                throw std::runtime_error("Missing wildcard "
                    "following -exclude.");
        }
        else if (strcmp("-f", param) == 0)
        {
            ++i;

            if (i < argc)
            {
                auto pathnames = split(argv[i], ';');

                for (const auto& p : pathnames)
                {
                    param = p.data();
                    configs.emplace_back(match_type::parser,
                        std::string(param, param + p.size()), config_flags::none);
                }
            }
            else
                throw std::runtime_error("Missing pathname following -f.");
        }
        else if (strcmp("-fe", param) == 0)
        {
            ++i;

            if (i < argc)
            {
                auto pathnames = split(argv[i], ';');

                for (const auto& p : pathnames)
                {
                    param = p.data();
                    configs.emplace_back(match_type::parser,
                        std::string(param, param + p.size()),
                        config_flags::extend_search);
                }
            }
            else
                throw std::runtime_error("Missing pathname following -fe.");
        }
        else if (strcmp("-force_write", param) == 0)
            g_force_write = true;
        else if (strcmp("--help", param) == 0)
        {
            show_help();
            exit(0);
        }
        else if (strcmp("-hits", param) == 0)
            g_show_hits = true;
        else if (strcmp("-i", param) == 0)
            g_icase = true;
        else if (strcmp("-l", param) == 0)
            g_pathname_only = true;
        else if (strcmp("-o", param) == 0)
            g_output = true;
        else if (strcmp("-P", param) == 0)
        {
            // Perl style regex
            ++i;
            param = argv[i];

            if (i < argc)
                configs.emplace_back(match_type::regex, param, config_flags::none);
            else
                throw std::runtime_error("Missing regex following -P.");
        }
        else if (strcmp("-Pe", param) == 0)
        {
            // Perl style regex
            ++i;
            param = argv[i];

            if (i < argc)
                configs.emplace_back(match_type::regex, param,
                        config_flags::extend_search);
            else
                throw std::runtime_error("Missing regex following -Pe.");
        }
        else if (strcmp("-print", param) == 0)
        {
            // Perl style regex
            ++i;
            param = argv[i];

            if (i < argc)
                g_print = unescape(param);
            else
                throw std::runtime_error("Missing string following -print.");
        }
        else if (strcmp("-r", param) == 0 || strcmp("-R", param) == 0 ||
            strcmp("--recursive", param) == 0)
        {
            g_recursive = true;
        }
        else if (strcmp("-replace", param) == 0)
        {
            ++i;
            param = argv[i];

            if (i < argc)
                g_replace = unescape(param);
            else
                throw std::runtime_error("Missing text "
                    "following -replacement.");
        }
        else if (strcmp("-shutdown", param) == 0)
        {
            ++i;
            param = argv[i];

            if (i < argc)
            {
                // "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\tf.exe"
                // /delete /collection:http://tfssrv01:8080/tfs/PartnerDev gram_grep /noprompt
                g_shutdown = param;
            }
            else
                throw std::runtime_error("Missing pathname "
                    "following -shutdown.");
        }
        else if (strcmp("-startup", param) == 0)
        {
            ++i;
            param = argv[i];

            if (i < argc)
            {
                // "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\tf.exe"
                // workspace /new /collection:http://tfssrv01:8080/tfs/PartnerDev gram_grep
                // /noprompt
                g_startup = param;
            }
            else
                throw std::runtime_error("Missing pathname "
                    "following -startup.");
        }
        else if (strcmp("-T", param) == 0)
        {
            // Text
            ++i;
            param = argv[i];

            if (i < argc)
                configs.emplace_back(match_type::text, param, config_flags::none);
            else
                throw std::runtime_error("Missing regex following -T.");
        }
        else if (strcmp("-Tw", param) == 0)
        {
            // Text
            ++i;
            param = argv[i];

            if (i < argc)
                configs.emplace_back(match_type::text, param,
                        config_flags::whole_word);
            else
                throw std::runtime_error("Missing regex following -T.");
        }
        else if (strcmp("-vE", param) == 0)
        {
            // DFA regex
            ++i;
            param = argv[i];

            if (i < argc)
                configs.emplace_back(match_type::dfa_regex, param,
                        config_flags::negate);
            else
                throw std::runtime_error("Missing regex following -vE.");
        }
        else if (strcmp("-VE", param) == 0)
        {
            // DFA regex
            ++i;
            param = argv[i];

            if (i < argc)
                configs.emplace_back(match_type::dfa_regex, param,
                        config_flags::negate | config_flags::negate_all);
            else
                throw std::runtime_error("Missing regex following -VE.");
        }
        else if (strcmp("-vf", param) == 0)
        {
            ++i;

            if (i < argc)
            {
                auto pathnames = split(argv[i], ';');

                for (const auto& p : pathnames)
                {
                    param = p.data();
                    configs.emplace_back(match_type::parser,
                        std::string(param, param + p.size()),
                            config_flags::negate);
                }
            }
            else
                throw std::runtime_error("Missing pathname following -vf.");
        }
        else if (strcmp("-Vf", param) == 0)
        {
            ++i;

            if (i < argc)
            {
                auto pathnames = split(argv[i], ';');

                for (const auto& p : pathnames)
                {
                    param = p.data();
                    configs.emplace_back(match_type::parser,
                        std::string(param, param + p.size()),
                            config_flags::negate | config_flags::negate_all);
                }
            }
            else
                throw std::runtime_error("Missing pathname following -Vf.");
        }
        else if (strcmp("-vP", param) == 0)
        {
            // Perl style regex
            ++i;
            param = argv[i];

            if (i < argc)
                configs.emplace_back(match_type::regex, param,
                        config_flags::negate);
            else
                throw std::runtime_error("Missing regex following -vP.");
        }
        else if (strcmp("-VP", param) == 0)
        {
            // Perl style regex
            ++i;
            param = argv[i];

            if (i < argc)
                configs.emplace_back(match_type::regex, param,
                        config_flags::negate | config_flags::negate_all);
            else
                throw std::runtime_error("Missing regex following -VP.");
        }
        else if (strcmp("-vT", param) == 0)
        {
            // Perl style regex
            ++i;
            param = argv[i];

            if (i < argc)
                configs.emplace_back(match_type::text, param,
                        config_flags::negate);
            else
                throw std::runtime_error("Missing regex following -vT.");
        }
        else if (strcmp("-vTw", param) == 0)
        {
            ++i;
            param = argv[i];

            if (i < argc)
                configs.emplace_back(match_type::text, param,
                    config_flags::whole_word | config_flags::negate);
            else
                throw std::runtime_error("Missing regex following -vT.");
        }
        else if (strcmp("-VT", param) == 0)
        {
            // Perl style regex
            ++i;
            param = argv[i];

            if (i < argc)
                configs.emplace_back(match_type::text, param,
                        config_flags::negate | config_flags::negate_all);
            else
                throw std::runtime_error("Missing regex following -VT.");
        }
        else if (strcmp("-VTw", param) == 0)
        {
            ++i;
            param = argv[i];

            if (i < argc)
                configs.emplace_back(match_type::text, param,
                    config_flags::whole_word |
                    config_flags::negate | config_flags::negate_all);
            else
                throw std::runtime_error("Missing regex following -VT.");
        }
        else if (strcmp("-writable", param) == 0)
            g_writable = true;
        //else if (strcmp("-utf8", param) == 0)
        //    g_force_unicode = true;
        else
            files.push_back(argv[i]);
    }
}

void fill_pipeline(const std::vector<config>& configs)
{
    // Postponed to allow -i to be processed first.
    for (const auto& config : configs)
    {
        switch (config._type)
        {
        case match_type::dfa_regex:
        {
            {
                lexertl::rules rules;
                lexer lexer;

                lexer._flags = config._flags;

                if (g_icase)
                    rules.flags(*lexertl::regex_flags::icase |
                        *lexertl::regex_flags::dot_not_cr_lf);

                rules.push(config._param, 1);
                rules.push(".{+}[\r\n]", lexertl::rules::skip());
                lexertl::generator::build(rules, lexer._sm);
                g_pipeline.emplace_back(std::move(lexer));
            }

            break;
        }
        case match_type::regex:
        {
            regex regex;

            regex._flags = config._flags;
            regex._rx.assign(config._param, g_icase ?
                (std::regex_constants::ECMAScript |
                    std::regex_constants::icase) :
                std::regex_constants::ECMAScript);
            g_pipeline.emplace_back(std::move(regex));
            break;
        }
        case match_type::parser:
        {
            {
                parser parser;
                config_state state;

                parser._flags = config._flags;
                g_curr_parser = &parser;

                if (g_config_parser._gsm.empty())
                    build_config_parser(g_dump_master);

                state.parse(config._param);
                g_rule_print |= state._print;

                if (parser._gsm.empty())
                {
                    lexer lexer;

                    lexer._flags |= parser._flags & config_flags::negate;
                    lexer._sm.swap(parser._lsm);
                    g_pipeline.emplace_back(std::move(lexer));
                }
                else
                    g_pipeline.emplace_back(std::move(parser));
            }

            break;
        }
        case match_type::text:
        {
            text text;

            text._flags = config._flags;
            text._text = config._param;
            g_pipeline.emplace_back(std::move(text));
        }
        default:
            break;
        }
    }
}

int main(int argc, char* argv[])
{
    try
    {
        if (argc == 1)
        {
            show_help();
            return 1;
        }

        std::vector<config> configs;
        std::vector<std::string> files;
        bool run = true;

        read_switches(argc, argv, configs, files);
        fill_pipeline(configs);

        // Postponed to allow -r to be processed first as
        // add_pathname() checks g_recursive.
        for (const auto& f : files)
        {
            auto pathnames = split(f.c_str(), ';');

            for (const auto& p : pathnames)
            {
                const char* param = p.data();

                add_pathname(std::string(param, param + p.size()), g_pathnames);
            }
        }

        if (g_dump)
        {
            for (const auto& v : g_pipeline)
            {
                switch (static_cast<match_type>(v.index()))
                {
                case match_type::lexer:
                    //if (!g_force_unicode)
                    {
                        const auto& l = std::get<lexer>(v);

                        lexertl::debug::dump(l._sm, std::cout);
                    }

                    break;
                default:
                    break;
                }
            }
        }

        if (g_pipeline.empty())
            throw std::runtime_error("No actions have been specified.");

        if (g_pathname_only && g_show_hits)
            throw std::runtime_error("Cannot combine -l and -hits.");

        if (g_output && g_pathnames.empty())
            throw std::runtime_error("Cannot combine stdin with -o.");

        if (!g_replace.empty() && g_modify)
            throw std::runtime_error("Cannot combine -replace with grammar "
                "actions that modify the input.");

        if (!g_startup.empty())
        {
            if (::system(g_startup.c_str()))
            {
                std::cerr << "Failed to execute " << g_startup << ".\n";
                run = false;
            }
        }

        if (run)
        {
            g_capture_rx = R"(\$\d+)";

            if (g_pathnames.empty())
            {
                std::string cin;

                process_file(std::string(), &cin);
            }
            else
                process();
        }

        if (!g_shutdown.empty())
            if (::system(g_shutdown.c_str()))
                std::cerr << "Failed to execute " << g_shutdown << ".\n";

        if (!g_pathname_only && g_print.empty() && !g_rule_print)
            std::cout << "Matches: " << g_hits << "    Matching files: " <<
            g_files << "    Total files searched: " << g_searched << std::endl;

        return 0;
    }
    catch (const std::exception& e)
    {
        std::cerr << e.what() << '\n';
        return 1;
    }
}
