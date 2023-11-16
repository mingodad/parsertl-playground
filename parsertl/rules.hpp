// rules.hpp
// Copyright (c) 2014-2023 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#ifndef PARSERTL_RULES_HPP
#define PARSERTL_RULES_HPP

#include "bison_lookup.hpp"
#include "ebnf_tables.hpp"
#include "enum_operator.hpp"
#include "enums.hpp"
#include "lexertl/generator.hpp"
#include "lexertl/iterator.hpp"
#include "match_results.hpp"
#include "narrow.hpp"
#include "runtime_error.hpp"
#include "lexertl/stream_num.hpp"
#include "token.hpp"

namespace parsertl
{
    using prod_size_t = uint32_t;

    template<typename T, typename id_type = uint16_t>
    class basic_rules
    {
    public:
        using char_type = T;

        struct nt_location
        {
            std::size_t _first_production = static_cast<std::size_t>(~0);
            std::size_t _last_production = static_cast<std::size_t>(~0);
        };

        using capture_vector = std::vector<std::pair<id_type, id_type>>;
        // first is the starting index for each block of captures
        using captures_vector =
            std::vector<std::pair<std::size_t, capture_vector>>;
        using nt_location_vector = std::vector<nt_location>;
        using string = std::basic_string<char_type>;
        using string_id_type_map = std::map<string, id_type>;
        using string_id_type_pair = std::pair<string, id_type>;
        using string_vector = std::vector<string>;

        struct symbol
        {
            enum class type:id_type { TERMINAL, NON_TERMINAL };

            type _type;
            id_type _id;

            symbol(const type type_, const id_type id_) :
                _type(type_),
                _id(id_)
            {
            }

            bool operator<(const symbol& rhs_) const
            {
                return _type < rhs_._type ||
                    // Added parenthesis to allow -Wall on clang++
                    (_type == rhs_._type && _id < rhs_._id);
            }

            bool operator==(const symbol& rhs_) const
            {
                return _type == rhs_._type && _id == rhs_._id;
            }
        };

        using symbol_vector = std::vector<symbol>;
        enum class associativity
        {
            token_assoc, precedence_assoc, non_assoc, left_assoc, right_assoc
        };

        struct production
        {
            prod_size_t _lhs = static_cast<prod_size_t>(~0);
            prod_size_t _next_lhs = static_cast<prod_size_t>(~0);
            prod_size_t _index;
            prod_size_t _precedence_id = 0;
            prod_size_t _ctx_precedence_id = 0;
            symbol_vector _rhs;
            string  _alias;

            explicit production(const prod_size_t index_) :
                _index(index_)
            {
            }

            void clear()
            {
                _lhs = static_cast<prod_size_t>(~0);
                _rhs.clear();
                _alias.clear();
                _precedence_id = 0;
                _ctx_precedence_id = 0;
                _index = static_cast<prod_size_t>(~0);
                _next_lhs = static_cast<prod_size_t>(~0);
            }
        };

        using production_vector = std::vector<production>;

        struct token_info
        {
            prod_size_t _precedence;
            associativity _associativity;
            id_type _fallback;

            token_info() :
                _precedence(0),
                _associativity(associativity::token_assoc),
                _fallback(0)
            {
            }

            token_info(const prod_size_t precedence_,
                const associativity associativity_,
                const id_type fallback_) :
                _precedence(precedence_),
                _associativity(associativity_),
                _fallback(fallback_)
            {
            }
        };

        using token_info_vector = std::vector<token_info>;

        explicit basic_rules(const std::size_t flags_ = 0) :
            _flags(flags_)
        {
            lexer_rules rules_;
            shift_reduce_count = reduce_reduce_count = 0;

            rules_.insert_macro("TERMINAL",
                R"('(\\([^0-9cx]|[0-9]{1,3}|c[@a-zA-Z]|x\d+)|[^\\\r\n'])+'|)"
                R"(\"(\\([^0-9cx]|[0-9]{1,3}|c[@a-zA-Z]|x\d+)|[^\\\r\n"])+\")");
            rules_.insert_macro("IDENTIFIER", "[A-Za-z_.][-A-Za-z_.0-9]*");
            rules_.push("{TERMINAL}",
                static_cast<uint16_t>(ebnf_tables::yytokentype::TERMINAL));
            rules_.push("{IDENTIFIER}",
                static_cast<uint16_t>(ebnf_tables::yytokentype::IDENTIFIER));
            rules_.push("[#]{IDENTIFIER}",
                static_cast<uint16_t>(ebnf_tables::yytokentype::PRODALIAS));
            rules_.push("\\s+", rules_.skip());
            lexer_generator::build(rules_, _token_lexer);

            rules_.push("[|]", '|');
            rules_.push("\\[", '[');
            rules_.push("\\]", ']');
            rules_.push("[?]", '?');
            rules_.push("[{]", '{');
            rules_.push("[}]", '}');
            rules_.push("[*]", '*');
            rules_.push("-", '-');
            rules_.push("[+]", '+');
            rules_.push("[(]", '(');
            rules_.push("[)]", ')');
            rules_.push("%empty",
                static_cast<uint16_t>(ebnf_tables::yytokentype::EMPTY));
            rules_.push("%prec",
                static_cast<uint16_t>(ebnf_tables::yytokentype::PREC));
            rules_.push("[/][*].{+}[\r\n]*?[*][/]|[/][/].*", rules_.skip());
            lexer_generator::build(rules_, _rule_lexer);

            const std::size_t id_ = insert_terminal(string(1, '$'));

            info(id_);
        }

        void clear()
        {
            _flags = 0;
            _next_precedence = 1;

            _non_terminals.clear();
            _nt_locations.clear();
            _new_rule_ids.clear();
            _generated_rules.clear();
            _start.clear();
            _grammar.clear();
            _captures.clear();

            _terminals.clear();
            _tokens_info.clear();
            reduce_reduce_count = 0;
            shift_reduce_count = 0;

            const std::size_t id_ = insert_terminal(string(1, '$'));

            info(id_);
        }

        void flags(const std::size_t flags_)
        {
            _flags = flags_;
        }

        id_type one_token(const string& name_)
        {
            token(name_);
            return token_id(name_);
        }

        void token(const char_type* names_start_, const char_type* names_end_)
        {
            lexer_iterator iter_(names_start_, names_end_, _token_lexer);

            token(iter_, 0, associativity::token_assoc, "token");
        }

        void token(const char_type* names_)
        {
            token(names_, str_end(names_));
        }

        void token(const string& names_)
        {
            token(names_.c_str(), names_.c_str() + names_.size());
        }

        void fallback(const char_type* names_start_, const char_type* names_end_)
        {
            lexer_iterator iter_(names_start_, names_end_, _token_lexer);

            //token(iter_, 0, associativity::token_assoc, "fallback");
            lexer_iterator end_;
            string token_;
            id_type fallback_id = 0;
            auto id_ = static_cast<std::size_t>(~0);

            for (; iter_ != end_; ++iter_)
            {
                if (iter_->id == _token_lexer.npos())
                {
                    std::ostringstream ss_;

                    ss_ << "Unrecognised char in fallback().";
                    throw runtime_error(ss_.str());
                }

                token_ = iter_->str();
                auto iter_t = _terminals.find(token_);

                if (iter_t == _terminals.end())
                {
                    std::ostringstream ss_;

                    ss_ << "Unknown token \"";
                    narrow(token_.c_str(), ss_);
                    ss_ << "\".";
                    throw runtime_error(ss_.str());
                }

                id_ = iter_t->second;

                if(fallback_id == 0)
                {
                    fallback_id = id_;
                    continue;
                }

                token_info& token_info_ = info(id_);

                if(token_info_._fallback)
                {
                    std::ostringstream ss_;

                    ss_ << "Token \"";
                    narrow(token_.c_str(), ss_);
                    ss_ << "\" already has a fallback.";
                    throw runtime_error(ss_.str());
                }

                token_info_._fallback = fallback_id;
            }

        }

        void fallback(const char_type* names_)
        {
            falback(names_, str_end(names_));
        }

        void fallback(const string& names_)
        {
            fallback(names_.c_str(), names_.c_str() + names_.size());
        }

        void left(const char_type* names_start_, const char_type* names_end_)
        {
            lexer_iterator iter_(names_start_, names_end_, _token_lexer);

            token(iter_, _next_precedence, associativity::left_assoc, "left");
            ++_next_precedence;
        }

        void left(const char_type* names_)
        {
            left(names_, str_end(names_));
        }

        void left(const string& names_)
        {
            left(names_.c_str(), names_.c_str() + names_.size());
        }

        void right(const char_type* names_start_, const char_type* names_end_)
        {
            lexer_iterator iter_(names_start_, names_end_, _token_lexer);

            token(iter_, _next_precedence, associativity::right_assoc, "right");
            ++_next_precedence;
        }

        void right(const char_type* names_)
        {
            right(names_, str_end(names_));
        }

        void right(const string& names_)
        {
            right(names_.c_str(), names_.c_str() + names_.size());
        }

        void nonassoc(const char_type* names_start_, const char_type* names_end_)
        {
            lexer_iterator iter_(names_start_, names_end_, _token_lexer);

            token(iter_, _next_precedence, associativity::non_assoc,
                "nonassoc");
            ++_next_precedence;
        }

        void nonassoc(const char_type* names_)
        {
            nonassoc(names_, str_end(names_));
        }

        void nonassoc(const string& names_)
        {
            nonassoc(names_.c_str(), names_.c_str() + names_.size());
        }

        void precedence(const char_type* names_start_, const char_type* names_end_)
        {
            lexer_iterator iter_(names_start_, names_end_, _token_lexer);

            token(iter_, _next_precedence, associativity::precedence_assoc,
                "precedence");
            ++_next_precedence;
        }

        void precedence(const char_type* names_)
        {
            precedence(names_, str_end(names_));
        }

        void precedence(const string& names_)
        {
            precedence(names_.c_str(), names_.c_str() + names_.size());
        }

        id_type push(const string& lhs_, const string& rhs_)
        {
            // Return the first index of any EBNF/rule with ors.
            auto index_ = static_cast<id_type>(_grammar.size());
            const std::size_t old_size_ = _grammar.size();

            validate(lhs_.c_str());

            if (_terminals.find(lhs_) != _terminals.end())
            {
                std::ostringstream ss_;

                ss_ << "Rule ";
                narrow(lhs_.c_str(), ss_);
                ss_ << " is already defined as a TERMINAL.";
                throw runtime_error(ss_.str());
            }

            if (_generated_rules.find(lhs_) != _generated_rules.end())
            {
                std::ostringstream ss_;

                ss_ << "Rule ";
                narrow(lhs_.c_str(), ss_);
                ss_ << " is already defined as a generated rule.";
                throw runtime_error(ss_.str());
            }

            lexer_iterator iter_(rhs_.c_str(), rhs_.c_str() + rhs_.size(),
                _rule_lexer);
            basic_match_results<basic_state_machine<id_type>> results_;
            // Qualify token to prevent arg dependant lookup
            using token_t = parsertl::token<lexer_iterator>;
            typename token_t::token_vector productions_;
            std::stack<string> rhs_stack_;
            std::stack<std::pair<string, string>> new_rules_;
            static const char_type empty_or_[] =
            { '%', 'e', 'm', 'p', 't', 'y', ' ', '|', ' ', '\0' };
            static const char_type or_[] = { ' ', '|', ' ', '\0' };

            bison_next(_ebnf_tables, iter_, results_);

            while (results_.entry.action != action::error &&
                results_.entry.action != action::accept)
            {
                if (results_.entry.action == action::reduce)
                {
                    switch (static_cast<ebnf_indexes>(results_.entry.param))
                    {
                    case ebnf_indexes::rhs_or_2_idx:
                    {
                        // rhs_or: rhs_or '|' opt_list
                        const std::size_t size_ =
                            _ebnf_tables.yyr2[results_.entry.param];
                        const std::size_t idx_ = productions_.size() - size_;
                        const token_t& token_ = productions_[idx_ + 1];
                        const string r_ = token_.str() + char_type(' ') +
                            rhs_stack_.top();

                        rhs_stack_.pop();

                        if (rhs_stack_.empty())
                        {
                            rhs_stack_.push(r_);
                        }
                        else
                        {
                            rhs_stack_.top() += char_type(' ') + r_;
                        }

                        break;
                    }
                    case ebnf_indexes::opt_prec_list_idx:
                    {
                        // opt_prec_list: opt_list opt_prec opt_prod_alias
                        const std::size_t size_ =
                            _ebnf_tables.yyr2[results_.entry.param];
                        const std::size_t idx_ = productions_.size() - size_;
                        const token_t& token_prec = productions_[idx_ + 1];
                        const token_t& token_alias = productions_[idx_ + 2];

                        // Check if prod_alias is present
                        if (token_alias.first != token_alias.second)
                        {
                            string r_ = rhs_stack_.top();

                            rhs_stack_.pop();
                            rhs_stack_.top() += char_type(' ') + r_;
                        }

                        // Check if %prec is present
                        if (token_prec.first != token_prec.second)
                        {
                            string r_ = rhs_stack_.top();

                            rhs_stack_.pop();
                            rhs_stack_.top() += char_type(' ') + r_;
                        }

                        break;
                    }
                    case ebnf_indexes::opt_list_1_idx:
                        // opt_list: %empty
                        rhs_stack_.push(string());
                        break;
                    case ebnf_indexes::rhs_list_2_idx:
                    {
                        // rhs_list: rhs_list rhs
                        string r_ = rhs_stack_.top();

                        rhs_stack_.pop();
                        rhs_stack_.top() += char_type(' ') + r_;
                        break;
                    }
                    case ebnf_indexes::opt_list_2_idx:
                    case ebnf_indexes::identifier_idx:
                    case ebnf_indexes::terminal_idx:
                    {
                        // opt_list: %empty
                        // rhs: IDENTIFIER
                        // rhs: TERMINAL
                        const std::size_t size_ =
                            _ebnf_tables.yyr2[results_.entry.param];
                        const std::size_t idx_ = productions_.size() - size_;
                        const token_t& token_ = productions_[idx_];

                        rhs_stack_.push(token_.str());
                        break;
                    }
                    case ebnf_indexes::optional_1_idx:
                    case ebnf_indexes::optional_2_idx:
                    {
                        // rhs: '[' rhs_or ']'
                        // rhs: rhs '?'
                        std::size_t& counter_ = _new_rule_ids[lhs_];
                        std::basic_ostringstream<char_type> ss_;
                        std::pair<string, string> pair_;

                        ++counter_;
                        lexertl::stream_num(counter_, ss_);
                        pair_.first = lhs_ + char_type('_') + ss_.str();
                        _generated_rules.insert(pair_.first);
                        pair_.second = empty_or_ + rhs_stack_.top();
                        rhs_stack_.top() = pair_.first;
                        new_rules_.push(pair_);
                        break;
                    }
                    case ebnf_indexes::zom_1_idx:
                    case ebnf_indexes::zom_2_idx:
                    {
                        // rhs: '{' rhs_or '}'
                        // rhs: rhs '*'
                        std::size_t& counter_ = _new_rule_ids[lhs_];
                        std::basic_ostringstream<char_type> ss_;
                        std::pair<string, string> pair_;

                        ++counter_;
                        lexertl::stream_num(counter_, ss_);
                        pair_.first = lhs_ + char_type('_') + ss_.str();
                        _generated_rules.insert(pair_.first);
                        pair_.second = empty_or_ + pair_.first +
                            char_type(' ') + rhs_stack_.top();
                        rhs_stack_.top() = pair_.first;
                        new_rules_.push(pair_);
                        break;
                    }
                    case ebnf_indexes::oom_1_idx:
                    case ebnf_indexes::oom_2_idx:
                    {
                        // rhs: '{' rhs_or '}' '-'
                        // rhs: rhs '+'
                        std::size_t& counter_ = _new_rule_ids[lhs_];
                        std::basic_ostringstream<char_type> ss_;
                        std::pair<string, string> pair_;

                        ++counter_;
                        lexertl::stream_num(counter_, ss_);
                        pair_.first = lhs_ + char_type('_') + ss_.str();
                        _generated_rules.insert(pair_.first);
                        pair_.second = rhs_stack_.top() + or_ +
                            pair_.first + char_type(' ') + rhs_stack_.top();
                        rhs_stack_.top() = pair_.first;
                        new_rules_.push(pair_);
                        break;
                    }
                    case ebnf_indexes::bracketed_idx:
                    {
                        // rhs: '(' rhs_or ')'
                        std::size_t& counter_ = _new_rule_ids[lhs_];
                        std::basic_ostringstream<char_type> ss_;
                        std::pair<string, string> pair_;

                        ++counter_;
                        lexertl::stream_num(counter_, ss_);
                        pair_.first = lhs_ + char_type('_') + ss_.str();
                        _generated_rules.insert(pair_.first);
                        pair_.second = rhs_stack_.top();

                        if (_flags & *rule_flags::enable_captures)
                        {
                            rhs_stack_.top() = char_type('(') + pair_.first +
                                char_type(')');
                        }
                        else
                        {
                            rhs_stack_.top() = pair_.first;
                        }

                        new_rules_.push(pair_);
                        break;
                    }
                    case ebnf_indexes::prec_ident_idx:
                    case ebnf_indexes::prec_term_idx:
                    {
                        // opt_prec: PREC IDENTIFIER
                        // opt_prec: PREC TERMINAL
                        const std::size_t size_ =
                            _ebnf_tables.yyr2[results_.entry.param];
                        const std::size_t idx_ = productions_.size() - size_;
                        const token_t& token_ = productions_[idx_];

                        rhs_stack_.push(token_.str() + char_type(' ') +
                            productions_[idx_ + 1].str());
                        break;
                    }
                    //case ebnf_indexes::prodalias_empy_idx:
                        // opt_prod_alias: %empty
                    case ebnf_indexes::prodalias_idx:
                    {
                        // opt_prod_alias: PRODALIAS
                        const std::size_t size_ =
                            _ebnf_tables.yyr2[results_.entry.param];
                        const std::size_t idx_ = productions_.size() - size_;
                        const token_t& token_ = productions_[idx_];

                        rhs_stack_.push(token_.str());
                        break;
                    }
                    default:
                        break;
                    }
                }

                bison_lookup(_ebnf_tables, iter_, results_, productions_);
                bison_next(_ebnf_tables, iter_, results_);
            }

            if (results_.entry.action == action::error)
            {
                std::ostringstream ss_;

                ss_ << "Syntax error in rule ";
                narrow(lhs_.c_str(), ss_);
                ss_ << '(' << iter_->first - rhs_.c_str() + 1 << "): '";
                narrow(rhs_.c_str(), ss_);
                ss_ << "'.";
                throw runtime_error(ss_.str());
            }

            assert(rhs_stack_.size() == 1);
            push_production(lhs_, rhs_stack_.top());

            while (!new_rules_.empty())
            {
                push_production(new_rules_.top().first,
                    new_rules_.top().second);
                new_rules_.pop();
            }

            if (!_captures.empty() && old_size_ != _grammar.size())
            {
                resize_captures();
            }

            return index_;
        }

        id_type token_id(const string& name_) const
        {
            auto iter_t = _terminals.find(name_);

            if (iter_t == _terminals.end())
            {
                std::ostringstream ss_;

                ss_ << "Unknown token \"";
                narrow(name_.c_str(), ss_);
                ss_ << "\".";
                throw runtime_error(ss_.str());
            }

            return id(*iter_t);
        }

        string name_from_map_id(const std::size_t id_, const string_id_type_map& nmap) const
        {
            string name_;

            for (const auto& pair_nt : nmap)
            {
                if (id(pair_nt) == id_)
                {
                    name_ = name(pair_nt);
                    break;
                }
            }

            return name_;
        }

        string name_from_token_id(const std::size_t id_) const
        {
            return name_from_map_id(id_, _terminals);
        }

        string name_from_nt_id(const std::size_t id_) const
        {
            return name_from_map_id(id_, _non_terminals);
        }

        void start(const char_type* start_)
        {
            validate(start_);
            _start = start_;
        }

        void start(const string& start_)
        {
            validate(start_.c_str());
            _start = start_;
        }

        size_t start() const
        {
            return _start.empty() ?
                npos() :
                _non_terminals.find(_start)->second;
        }

        id_type indent_token(const string& name)
        {
            validate(name.c_str());
            _indent_token = one_token(name);
            return _indent_token;
        }

        id_type dedent_token(const string& name)
        {
            validate(name.c_str());
            _dedent_token = one_token(name);
            return _dedent_token;
        }

        id_type symbol_table_token(const string& name)
        {
            validate(name.c_str());
            _symbol_table_token = one_token(name);
            return _symbol_table_token;
        }

        void validate()
        {
            if (_grammar.empty())
            {
                throw runtime_error("No productions are defined.");
            }

            std::size_t start_ = npos();

            // Determine id of start rule
            if (_start.empty())
            {
                const std::size_t id_ = _grammar[0]._lhs;

                _start = name_from_nt_id(id_);

                if (!_start.empty())
                    start_ = id_;
            }
            else
            {
                auto iter_nt = _non_terminals.find(_start);

                if (iter_nt != _non_terminals.end())
                    start_ = iter_nt->second;
            }

            if (start_ == npos())
            {
                throw runtime_error("Specified start rule does not exist.");
            }

            // Look for unused rules
            std::ostringstream ss_;
            for (const auto& [nt_name, nt_id] : _non_terminals)
            {
                bool found_ = false;

                // Skip start_
                if (nt_id == start_) continue;

                for (const auto& prod_ : _grammar)
                {
                    for (const auto& symbol_ : prod_._rhs)
                    {
                        if (symbol_._type == symbol::type::NON_TERMINAL &&
                            symbol_._id == nt_id && symbol_._id != prod_._lhs)
                        {
                            found_ = true;
                            break;
                        }
                    }

                    if (found_) break;
                }

                if (!found_)
                {

                    const string name_ = nt_name;
                    ss_ << '\'';
                    narrow(name_.c_str(), ss_);
                    ss_ << "' is an unused rule.\n";
                }
            }
            if(ss_.str().size())
            {
                throw runtime_error(ss_.str());
            }

            static const char_type accept_[] =
            {
                '$', 'a', 'c', 'c', 'e', 'p', 't', '\0'
            };

            // Validate start rule
            if (_non_terminals.find(accept_) == _non_terminals.end())
            {
                string rhs_ = _start;

                push_production(accept_, rhs_);
                _grammar.back()._rhs.emplace_back(symbol::type::TERMINAL,
                    insert_terminal(string(1, '$')));
            }

            _start = accept_;

            // Validate all non-terminals.
            for (std::size_t i_ = 0, size_ = _nt_locations.size();
                i_ < size_; ++i_)
            {
                if (_nt_locations[i_]._first_production == npos())
                {
                    const string name_ = name_from_nt_id(i_);

                    ss_ << "Non-terminal '";
                    narrow(name_.c_str(), ss_);
                    ss_ << "' does not have any productions.\n";
                }
            }
            if(ss_.str().size())
            {
                throw runtime_error(ss_.str());
            }
        }

        const production_vector& grammar() const
        {
            return _grammar;
        }

        const token_info_vector& tokens_info() const
        {
            return _tokens_info;
        }

        const nt_location_vector& nt_locations() const
        {
            return _nt_locations;
        }

        void fill_vector_from_map(string_vector& vec_, const string_id_type_map& nmap) const
        {
            const std::size_t size_ = vec_.size();

            vec_.resize(size_ + nmap.size());

            for (const auto& [nt_name, nt_id] : nmap)
            {
                vec_[size_ + nt_id] = nt_name;
            }
        }

        void terminals(string_vector& vec_) const
        {
            fill_vector_from_map(vec_, _terminals);
        }

        const string_id_type_map&   terminals() const
        {
            return _terminals;
        }

        std::size_t terminals_count() const
        {
            return _terminals.size();
        }

        void non_terminals(string_vector& vec_) const
        {
            fill_vector_from_map(vec_, _non_terminals);
        }

        const string_id_type_map&   non_terminals() const
        {
            return _non_terminals;
        }

        std::size_t non_terminals_count() const
        {
            return _non_terminals.size();
        }

        void symbols(string_vector& vec_) const
        {
            vec_.clear();
            terminals(vec_);
            non_terminals(vec_);
        }

        const captures_vector& captures() const
        {
            return _captures;
        }

        std::size_t npos() const
        {
            return static_cast<std::size_t>(~0);
        }

        const std::string& name(const string_id_type_pair& pair) const {return pair.first;}
        const id_type id(const string_id_type_pair& pair) const {return pair.second;}
        //const id_type id(const typename string_id_type_map::iterator& iter) const {return iter.second;}

        mutable int shift_reduce_count, reduce_reduce_count;
    private:
        enum class ebnf_indexes
        {
            rule_idx = 2,
            rhs_or_1_idx,
            rhs_or_2_idx,
            opt_prec_list_idx,
            opt_list_1_idx,
            opt_list_2_idx,
            opt_list_3_idx,
            rhs_list_1_idx,
            rhs_list_2_idx,
            identifier_idx,
            terminal_idx,
            optional_1_idx,
            optional_2_idx,
            zom_1_idx,
            zom_2_idx,
            oom_1_idx,
            oom_2_idx,
            bracketed_idx,
            prec_empty_idx,
            prec_ident_idx,
            prec_term_idx,
            prodalias_empy_idx,
            prodalias_idx
        };

        using lexer_rules = typename lexertl::basic_rules<char, char_type>;
        using lexer_state_machine =
            typename lexertl::basic_state_machine<char_type>;
        using lexer_generator =
            typename lexertl::basic_generator<lexer_rules, lexer_state_machine>;
        using lexer_iterator =
            typename lexertl::iterator<const char_type*, lexer_state_machine,
            typename lexertl::match_results<const char_type*>>;

        std::size_t _flags;
        ebnf_tables _ebnf_tables;
        std::size_t _next_precedence = 1;
        lexer_state_machine _rule_lexer;
        lexer_state_machine _token_lexer;
        string_id_type_map _terminals;
        token_info_vector _tokens_info;
        string_id_type_map _non_terminals;
        nt_location_vector _nt_locations;
        std::map<string, std::size_t> _new_rule_ids;
        std::set<string> _generated_rules;
        string _start;
        id_type _symbol_table_token = _token_lexer.npos();
        id_type _indent_token = _token_lexer.npos();
        id_type _dedent_token = _token_lexer.npos();
        production_vector _grammar;
        captures_vector _captures;

        token_info& info(const std::size_t id_)
        {
            if (_tokens_info.size() <= id_)
            {
                _tokens_info.resize(id_ + 1);
            }

            return _tokens_info[id_];
        }

        void token(lexer_iterator& iter_, const std::size_t precedence_,
            const associativity associativity_, const char* func_)
        {
            lexer_iterator end_;
            string token_;
            auto id_ = static_cast<std::size_t>(~0);

            for (; iter_ != end_; ++iter_)
            {
                if (iter_->id == _token_lexer.npos())
                {
                    std::ostringstream ss_;

                    ss_ << "Unrecognised char in " << func_ << "().";
                    throw runtime_error(ss_.str());
                }

                token_ = iter_->str();
                id_ = insert_terminal(token_);

                token_info& token_info_ = info(id_);

                if(token_info_._precedence)
                {
                    std::ostringstream ss_;

                    ss_ << "Token already has precedence declared: " << token_;
                    throw runtime_error(ss_.str());
                }

                token_info_._precedence = precedence_;
                token_info_._associativity = associativity_;
            }
        }

        void validate(const char_type* name_) const
        {
            const char_type* start_ = name_;

            while (*name_)
            {
                if (!(*name_ >= 'A' && *name_ <= 'Z') &&
                    !(*name_ >= 'a' && *name_ <= 'z') &&
                    *name_ != '_' && *name_ != '.' &&
                    !(*name_ >= '0' && *name_ <= '9') &&
                    *name_ != '-')
                {
                    std::ostringstream ss_;

                    ss_ << "Invalid name '";
                    name_ = start_;
                    narrow(name_, ss_);
                    ss_ << "'.";
                    throw runtime_error(ss_.str());
                }

                ++name_;
            }
        }

        id_type insert_terminal(const string& str_)
        {
            return _terminals.insert
            (string_id_type_pair(str_,
                static_cast<id_type>(_terminals.size()))).first->second;
        }

        id_type insert_non_terminal(const string& str_)
        {
            return _non_terminals.insert
            (string_id_type_pair(str_,
                static_cast<id_type>(_non_terminals.size()))).first->second;
        }

        const char_type* str_end(const char_type* str_)
        {
            while (*str_) ++str_;

            return str_;
        }

        void push_production(const string& lhs_, const string& rhs_)
        {
            const id_type lhs_id_ = insert_non_terminal(lhs_);
            nt_location& location_ = location(lhs_id_);
            lexer_iterator iter_(rhs_.c_str(), rhs_.c_str() +
                rhs_.size(), _rule_lexer);
            basic_match_results<basic_state_machine<id_type>> results_;
            // Qualify token to prevent arg dependant lookup
            using token_t = parsertl::token<lexer_iterator>;
            typename token_t::token_vector productions_;
            production production_(_grammar.size());
            int curr_bracket_ = 0;
            std::stack<int> bracket_stack_;

            if (location_._first_production == npos())
            {
                location_._first_production = production_._index;
            }

            if (location_._last_production != npos())
            {
                _grammar[location_._last_production]._next_lhs =
                    production_._index;
            }

            location_._last_production = production_._index;
            production_._lhs = lhs_id_;
            bison_next(_ebnf_tables, iter_, results_);

            while (results_.entry.action != action::error &&
                results_.entry.action != action::accept)
            {
                if (results_.entry.action == action::shift)
                {
                    switch (iter_->id)
                    {
                    case '(':
                        if (_captures.size() <= _grammar.size())
                        {
                            resize_captures();
                            curr_bracket_ = 0;
                        }

                        ++curr_bracket_;
                        bracket_stack_.push(curr_bracket_);
                        _captures.back().second.emplace_back(static_cast
                            <id_type>(production_._rhs.size()),
                                static_cast<id_type>(0));
                        break;
                    case ')':
                        _captures.back().second[static_cast<std::size_t>
                            (bracket_stack_.top()) - 1].second =
                            static_cast<id_type>(production_.
                                _rhs.size() - 1);
                        bracket_stack_.pop();
                        break;
                    case '|':
                    {
                        std::size_t old_lhs_ = production_._lhs;
                        std::size_t index_ = _grammar.size() + 1;
                        nt_location& loc_ = location(old_lhs_);

                        production_._next_lhs = loc_._last_production = index_;
                        _grammar.push_back(production_);
                        production_.clear();
                        production_._lhs = old_lhs_;
                        production_._index = index_;
                        break;
                    }
                    default:
                        break;
                    }
                }
                else if (results_.entry.action == action::reduce)
                {
                    switch (static_cast<ebnf_indexes>(results_.entry.param))
                    {
                    case ebnf_indexes::identifier_idx:
                    {
                        // rhs: IDENTIFIER
                        const std::size_t size_ =
                            _ebnf_tables.yyr2[results_.entry.param];
                        const std::size_t idx_ = productions_.size() - size_;
                        const string token_ = productions_[idx_].str();
                        typename string_id_type_map::const_iterator
                            terminal_iter_ = _terminals.find(token_);

                        if (terminal_iter_ == _terminals.end())
                        {
                            const id_type id_ = insert_non_terminal(token_);

                            // NON_TERMINAL
                            location(id_);
                            production_._rhs.
                                emplace_back(symbol::type::NON_TERMINAL, id_);
                        }
                        else
                        {
                            const std::size_t id_ = id(*terminal_iter_);
                            token_info& token_info_ = info(id_);

                            if (token_info_._precedence)
                            {
                                production_._precedence_id = id_;
                            }

                            production_._rhs.
                                emplace_back(symbol::type::TERMINAL, id_);
                        }

                        break;
                    }
                    case ebnf_indexes::terminal_idx:
                    {
                        // rhs: TERMINAL
                        const std::size_t size_ =
                            _ebnf_tables.yyr2[results_.entry.param];
                        const std::size_t idx_ = productions_.size() - size_;
                        const string token_ = productions_[idx_].str();
                        const std::size_t id_ = insert_terminal(token_);
                        token_info& token_info_ = info(id_);

                        if (token_info_._precedence)
                        {
                            production_._precedence_id = id_;
                        }

                        production_._rhs.
                            emplace_back(symbol::type::TERMINAL, id_);
                        break;
                    }
                    case ebnf_indexes::prec_ident_idx:
                    case ebnf_indexes::prec_term_idx:
                    {
                        // opt_prec: PREC IDENTIFIER
                        // opt_prec: PREC TERMINAL
                        const std::size_t size_ =
                            _ebnf_tables.yyr2[results_.entry.param];
                        const std::size_t idx_ = productions_.size() - size_;
                        const string token_ = productions_[idx_ + 1].str();
                        const id_type id_ = token_id(token_);

                        // Explicit %prec, so no conditional
                        production_._ctx_precedence_id = id_;
                        break;
                    }
                    case ebnf_indexes::prodalias_idx:
                    {
                        // opt_prod_alias: PRODALIAS
                        const std::size_t size_ =
                            _ebnf_tables.yyr2[results_.entry.param];
                        const std::size_t idx_ = productions_.size() - size_;
                        const string token_ = productions_[idx_].str();
                        production_._alias = token_;
                        break;
                    }
                    default:
                        break;
                    }
                }

                bison_lookup(_ebnf_tables, iter_, results_, productions_);
                bison_next(_ebnf_tables, iter_, results_);
            }

            // As rules passed in are generated,
            // they have already been validated.
            assert(results_.entry.action == action::accept);
            _grammar.push_back(production_);
        }

        void resize_captures()
        {
            const std::size_t old_size_ = _captures.size();

            _captures.resize(_grammar.size() + 1);

            if (old_size_ > 0)
            {
                for (std::size_t i_ = old_size_ - 1,
                    size_ = _captures.size() - 1; i_ < size_; ++i_)
                {
                    _captures[i_ + 1].first = _captures[i_].first +
                        _captures[i_].second.size();
                }
            }
        }

        nt_location& location(const std::size_t id_)
        {
            if (_nt_locations.size() <= id_)
            {
                _nt_locations.resize(id_ + 1);
            }

            return _nt_locations[id_];
        }
    };

    using rules = basic_rules<char>;
    using wrules = basic_rules<wchar_t>;
    using u32rules = basic_rules<char32_t>;
}

#endif
