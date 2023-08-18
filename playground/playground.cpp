#ifdef WASM_PLAYGROUND

#include <emscripten.h>

EM_JS(void, switch_output, (const char* which), {
    output = UTF8ToString(which);
})

EM_JS(void, set_result, (const char* which, int value), {
    result_name = UTF8ToString(which);
    result[result_name] = value;
})

EM_JS(void, showDiffTime, (const char *title), {
    const now = new Date().getTime();
    const diff_time = now - parse_start_time;

    outputs.parse_time  += UTF8ToString(title) + " -> Time taken : " + diff_time + "ms<br>\n";
    parse_start_time = now;
});

#else

#include "debugmem.h"
#include <lexertl/memory_file.hpp>

#endif

#include <parsertl/debug.hpp>
#include <lexertl/debug.hpp>
#include <parsertl/generator.hpp>
#include <parsertl/match_results.hpp>
#include <parsertl/parse.hpp>
#include <parsertl/state_machine.hpp>
#include <parsertl/lookup.hpp>


#if !defined(WASM_PLAYGROUND) && !defined(DEBUGMEM_H_INCLUDED)
static clock_t start_time;
static clock_t showDiffTime(const char *title)
{
    clock_t now = clock();
    clock_t diff = now - start_time;

    int msec = diff * 1000 / CLOCKS_PER_SEC;
    printf("%s: Time taken %d seconds %d milliseconds\n", title, msec/1000, msec%1000);
    start_time = now;
    return now;
}
#endif

struct BuildUserParser;
struct GlobalState;
struct ParserRT;

using config_actions_map = std::map<uint16_t, void(*)(BuildUserParser& state)>;

struct ParserRT
{
    parsertl::rules grules;
    lexertl::rules lrules;
    parsertl::state_machine gsm;
    lexertl::state_machine lsm;
    config_actions_map actions;
};

struct GlobalState
{
    ParserRT master_parser;
    ParserRT user_parser;
    int dumpAsEbnfRR;
    bool icase;
    bool dump_grammar_lexer;
    bool dump_grammar_lsm;
    bool dump_grammar_gsm;
    bool dump_input_lexer;
    bool dump_grammar_parse_tree;
    bool dump_grammar_parse_trace;
    bool dump_input_parse_tree;
    bool dump_input_parse_trace;

//#ifdef WASM_PLAYGROUND
    const char *grammar_data;
    size_t grammar_data_size;
    const char *input_data;
    size_t input_data_size;
//#endif
    
    uint16_t token_Number = 0;
    uint16_t token_Name = 0;
    uint16_t token_Literal = 0;
    uint16_t token_Reject = 0;
    uint16_t token_Skip = 0;
    std::vector<std::string> group_State;
    std::string group_State_str;
    
    GlobalState():
        dumpAsEbnfRR(0)
        ,icase(false)
        ,dump_grammar_lexer(false)
        ,dump_grammar_lsm(false)
        ,dump_grammar_gsm(false)
        ,dump_input_lexer(false)
        ,dump_grammar_parse_tree(false)
        ,dump_grammar_parse_trace(false)
        ,dump_input_parse_tree(false)
        ,dump_input_parse_trace(false)
//#ifdef WASM_PLAYGROUND
        ,grammar_data(nullptr)
        ,grammar_data_size(0)
        ,input_data(nullptr)
        ,input_data_size(0)
//#endif
    {}
};

using token = parsertl::token<lexertl::criterator>;

struct LineColumn
{
    std::size_t line, column;
};

#if 0
template<typename IT>
static LineColumn get_line_colum0(const IT& iter_lex, const char* data, size_t offset)
{
    LineColumn lc;
    const char endl[] = { '\n' };
    lc.line =
        std::count(data+offset, iter_lex->first, '\n');
    lc.column = iter_lex->first - std::find_end(data,
        iter_lex->first, endl, endl + 1);
    return lc;
}

template<typename IT>
static LineColumn get_line_colum(const IT& iter_lex, const char* data)
{
    LineColumn lc = get_line_colum0(iter_lex, data, 0);
    ++lc.line;
    return lc;
}
#endif

template<typename IT>
static LineColumn get_line_colum(const IT& iter_lex, const char* data)
{
    LineColumn lc;
    const char endl[] = { '\n' };
    lc.line =
        1 + std::count(data, iter_lex->first, '\n');
    lc.column = iter_lex->first - std::find_end(data,
        iter_lex->first, endl, endl + 1);
    return lc;
}

template<typename IT>
static void parser_throw_error(const char* msg, const IT& iter_lex, const char* data)
{
    LineColumn lc = get_line_colum(iter_lex, data);
    std::ostringstream ss;

    ss << "error:" <<  lc.line << ":" << lc.column
            << ": " << msg << " -> " << iter_lex->str();
    throw std::runtime_error(ss.str());
}

static void dump_lexer(lexertl::citerator& iter_lex, const parsertl::rules& grules, const char* input)
{
    std::cout << "line:column:state:token:value\n";
    while(iter_lex->id != 0) {
        LineColumn lc = get_line_colum(iter_lex, input);
        std::cout << lc.line << ":" << lc.column << ":"
            << iter_lex->state << ":" << iter_lex->id << ":"
            << grules.name_from_token_id(iter_lex->id)
            << ": " << (iter_lex->str() == "\n" ? "@\\n" : iter_lex->str())
            << "\n"; ++iter_lex;
    }
}
#if 0
static void dump_lexer2(lexertl::citerator& iter_lex, const parsertl::rules& grules, const char* input)
{
    std::cout << "line:column:state:token:value\n";
    size_t line_offset = 0, input_offset = 0, last_line = 0, curr_line;
    while(iter_lex->id != 0) {
        LineColumn lc = get_line_colum0(iter_lex, input, input_offset);
        curr_line = line_offset + lc.line +1;
        std::cout << curr_line << ":" << lc.column << ":"
            << iter_lex->state << ":" << iter_lex->id << ":"
            << grules.name_from_token_id(iter_lex->id)
            << ": " << (iter_lex->str() == "\n" ? "@\\n" : iter_lex->str())
            << "\n"; ++iter_lex;
        if(lc.line != last_line)
        {
            line_offset = curr_line;
            input_offset = iter_lex->first - input;
            last_line = 0;
        }
    }
}
#endif
struct ParseTreeUserData {
    std::vector<ParseTreeUserData> children;
    int symbol_id;
    parsertl::rules::string value; ///< The value at this node (empty if this node's symbol is non-terminal).
    ParseTreeUserData():children(0),symbol_id(-1) {}
    ParseTreeUserData(int id):children(0),symbol_id(id) {}
    ParseTreeUserData(int id, const parsertl::rules::string& v):children(0),symbol_id(id), value(v) {}
};

static void parsetree_indent( int level )
{
    for ( int i = 0; i < level; ++i )
    {
        printf( " |" );
    }
}

static void print_parsetree( const ParseTreeUserData& ast, const parsertl::rules::string_vector& symbols, int level )
{
    if(ast.symbol_id >= 0)
    {
        parsetree_indent( level );
        if(!ast.value.empty()) //it's a terminal
        {
            printf("%s -> %s\n", symbols[ast.symbol_id].c_str(),
                    (ast.value == "\n" ? "\\n" : ast.value.c_str()));
        }
        else
        {
            printf("%s\n", symbols[ast.symbol_id].c_str());
        }
    }

    for (const auto& child : ast.children)
    {
        print_parsetree( child, symbols, ast.symbol_id >= 0 ? (level + 1) : level );
    }
}

static void dump_parse_tree(const char* data_start, const char* data_end,
        const parsertl::rules grules, const parsertl::state_machine& gsm,
        const lexertl::state_machine& lsm
#ifdef WASM_PLAYGROUND
        ,const char* error_output
#endif
        )
{
    parsertl::rules::string_vector symbols;
    grules.terminals(symbols);
    grules.non_terminals(symbols);
    lexertl::citerator iter_lex(data_start, data_end, lsm);
    parsertl::match_results results(iter_lex->id, gsm);
    std::vector<ParseTreeUserData> syn_tree;
    bool parse_done=false;
    for(;;)
    {
        const auto& sm_entry = results.entry;
        const auto& tok_start = iter_lex->first;
        const auto& tok_end = iter_lex->second;
        // Debug info
        switch (sm_entry.action)
        {
            case parsertl::action::error:
#ifdef WASM_PLAYGROUND
        switch_output(error_output);
#endif
                parser_throw_error("dumping parse tree", iter_lex, data_start);
                break;
            case parsertl::action::shift:
            {
                const std::string str(tok_start, tok_end);
                syn_tree.emplace_back(iter_lex->id, str);
                break;
            }
            case parsertl::action::reduce:
            {
                const auto& [lhs_id, rhs_id_vec] = gsm._rules[sm_entry.param];
                ParseTreeUserData ud(lhs_id);

                if(!rhs_id_vec.empty())
                {
                    auto rhs_id_vec_iter = rhs_id_vec.begin();
                    auto syn_tree_iter = syn_tree.end()-rhs_id_vec.size();
                    bool isLeftRecursion = lhs_id == *rhs_id_vec_iter;
                    if(isLeftRecursion)
                    {
                        ud.children.swap(syn_tree_iter->children);
                        ++syn_tree_iter;
                        ++rhs_id_vec_iter;
                    }
                    while(rhs_id_vec_iter++ != rhs_id_vec.end())
                    {
                        ud.children.emplace_back(std::move(*syn_tree_iter));
                        ++syn_tree_iter;
                    }
                    syn_tree.erase(syn_tree.end()-rhs_id_vec.size(), syn_tree.end());
                }
                syn_tree.emplace_back(std::move(ud));
                break;
            }
            case parsertl::action::go_to:
                break;
            case parsertl::action::accept:
                for(;;) //do a hack cleanup
                {
                    ParseTreeUserData& ud = syn_tree.back();
                    if(ud.children.size() == 0 && syn_tree.size() > 1)
                    {
                        syn_tree.pop_back();
                        continue;
                    }
                    break;
                }
                parse_done = true;
                break;
        }
        if(parse_done) break;
        parsertl::lookup(iter_lex, gsm, results);
    }

    if (!syn_tree.empty())
    {
        print_parsetree(syn_tree.back(), symbols, 0);
    }
}

static void dump_parse_trace(const char* data_start, const char* data_end,
        const parsertl::rules grules, const parsertl::state_machine& gsm,
        const lexertl::state_machine& lsm
#ifdef WASM_PLAYGROUND
        ,const char* error_output
#endif
        )
{
    parsertl::rules::string_vector symbols;
    grules.terminals(symbols);
    grules.non_terminals(symbols);
    lexertl::citerator iter_lex(data_start, data_end, lsm);
    parsertl::match_results results(iter_lex->id, gsm);
    bool parse_done=false;
    std::cout << "== action | param:stack.size | data\n";
    for(;;)
    {
        const auto& sm_entry = results.entry;
        // Debug info
        switch (sm_entry.action)
        {
            case parsertl::action::error:
#ifdef WASM_PLAYGROUND
        switch_output(error_output);
#endif
                parser_throw_error("dumping parse trace", iter_lex, data_start);
                break;
            case parsertl::action::shift:
            {
                const std::string str(iter_lex->first, iter_lex->second);
                std::cout << "shift " << sm_entry.param << ":" <<
                        results.stack.size() << " <- " << 
                        (str == "\n" ? "\\n" : str) << '\n';
                break;
            }
            case parsertl::action::reduce:
            {
                const parsertl::state_machine::id_type_vector_pair &idv_pair =
                    gsm._rules[sm_entry.param];

                std::cout << "reduce " << sm_entry.param << ":" <<
                        results.stack.size() << " by " << 
                        symbols[idv_pair.first] << " ->";

                if (idv_pair.second.empty())
                {
                    std::cout << " %empty";
                }
                else
                {
                    for (auto iter_ = idv_pair.second.cbegin(),
                        end_ = idv_pair.second.cend(); iter_ != end_; ++iter_)
                    {
                        std::cout << ' ' << symbols[*iter_];
                    }
                }

                std::cout << '\n';
                break;
            }
            case parsertl::action::go_to:
                std::cout << "goto " << sm_entry.param << ":" <<
                        results.stack.size() << '\n';
                break;
            case parsertl::action::accept:
                std::cout << "accept " << sm_entry.param << ":" <<
                        results.stack.size() << "\n";
                parse_done = true;
                break;
        }
        if(parse_done) break;
        parsertl::lookup(iter_lex, gsm, results);
    }
}

struct BuildUserParser
{
    GlobalState& gs;
    token::token_vector productions;
    parsertl::match_results results;

    BuildUserParser(GlobalState& pgs): gs(pgs)
    {}
    

    const std::string dollar(const std::size_t index)
    {
        const auto& token = results.dollar(index, gs.master_parser.gsm,
            productions);
        return token.str();
    }
    const std::string dollar(const std::size_t index, int start_offset, int end_offset)
    {
        const auto& token = results.dollar(index, gs.master_parser.gsm,
            productions);
        return std::string(token.first + start_offset,
                token.second + end_offset);
    }
    const token& dollar_token(const std::size_t index)
    {
        return results.dollar(index, gs.master_parser.gsm,
            productions);
    }
    size_t dollar_argc()
    {
        return results.production_size(gs.master_parser.gsm, results.entry.param);
    }

    bool build()
    {
        lexertl::citerator iter_lex;

        if(gs.dump_grammar_parse_tree)
        {
#ifdef WASM_PLAYGROUND
        switch_output("parse_debug");
#endif
            dump_parse_tree(gs.grammar_data, gs.grammar_data + gs.grammar_data_size,
                    gs.master_parser.grules, gs.master_parser.gsm, gs.master_parser.lsm
#ifdef WASM_PLAYGROUND
                    ,"compile_status"
#endif
                    );
            showDiffTime("dump grammar parse tree");
            return false;
        }
        if(gs.dump_grammar_parse_trace)
        {
#ifdef WASM_PLAYGROUND
        switch_output("parse_debug");
#endif
            dump_parse_trace(gs.grammar_data, gs.grammar_data + gs.grammar_data_size,
                    gs.master_parser.grules, gs.master_parser.gsm, gs.master_parser.lsm
#ifdef WASM_PLAYGROUND
                    ,"compile_status"
#endif
                    );
            showDiffTime("dump grammar parse trace");
            return false;
        }

        if (gs.icase)
        {
            gs.user_parser.lrules.flags(*lexertl::regex_flags::icase |
                    *lexertl::regex_flags::dot_not_cr_lf);
        }

        iter_lex = lexertl::citerator(gs.grammar_data,
            gs.grammar_data + gs.grammar_data_size, gs.master_parser.lsm);
        results.reset(iter_lex->id, gs.master_parser.gsm);

        if(gs.dump_grammar_lexer)
        {
#ifdef WASM_PLAYGROUND
        switch_output("parse_debug");
#endif
            dump_lexer(iter_lex, gs.master_parser.grules, gs.grammar_data);
            showDiffTime("dump grammr lexer");
            return false;
        }

        while (results.entry.action != parsertl::action::error &&
            results.entry.action != parsertl::action::accept)
        {
            if (results.entry.action == parsertl::action::reduce)
            {
                auto i = gs.master_parser.actions.find(results.entry.param);

                if (i != gs.master_parser.actions.end())
                {
                    try
                    {
                        i->second(*this);
                    }
                    catch (const std::exception& e)
                    {
                        std::ostringstream ss;
                        LineColumn lc = get_line_colum(iter_lex, gs.grammar_data);
                        ss << e.what() << "\nLine error:" << lc.line << ":" 
                                << lc.column << ":\n";
                        throw std::runtime_error(ss.str());
                    }
                }
            }

            parsertl::lookup(iter_lex, gs.master_parser.gsm, results,
                productions);
        }

        if (results.entry.action == parsertl::action::error)
        {
            parser_throw_error("parsing the grammar", iter_lex,
                    gs.grammar_data);
        }

        if(gs.dumpAsEbnfRR)
        {
#ifdef WASM_PLAYGROUND
            switch_output("parse_ebnf_yacc");
#endif
            parsertl::debug::dump(gs.user_parser.grules, std::cout, gs.dumpAsEbnfRR == 1);
            showDiffTime("dump grammar ebnf");
            return false;
        }            
        
        if (gs.user_parser.grules.grammar().empty())
        {
            gs.user_parser.lrules.push(".{+}[\r\n]", lexertl::rules::skip());
        }
        else
        {
            std::string warnings;
            parsertl::rules::string_vector terminals;
            const auto& grammar = gs.user_parser.grules.grammar();
            const auto& ids = gs.user_parser.lrules.ids();
            std::set<std::size_t> used_tokens;

            parsertl::generator::build(gs.user_parser.grules, gs.user_parser.gsm, &warnings);

            if (!warnings.empty())
                std::cerr << "Warnings from user_parser : " << warnings;

            gs.user_parser.grules.terminals(terminals);

            for (const auto& p : grammar)
            {
                //Add %prec TOKEN to the list of used terminals
                if (!p._rhs.second.empty())
                {
                    const auto pos = std::find( terminals.begin()
                                                     , terminals.end()
                                                     , p._rhs.second );
                    if( pos != terminals.end() ) {
                        size_t idx = pos-terminals.begin();
                        used_tokens.insert(idx);
                    }

                }
                for (const auto& rhs : p._rhs.first)
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
                        curr_ids.end();

                    if (found_id) break;
                }

                if (!found_id)
                    std::cerr << "Warning: Token \"" << terminals[i] <<
                        "\" does not have a lexer definiton.\n";

                if (std::find(used_tokens.begin(), used_tokens.end(), i) ==
                    used_tokens.end())
                {
                    std::cerr << "Warning: Token \"" << terminals[i] <<
                        "\" is not used in the grammar.\n";
                }
            }
        }

        if(gs.dump_grammar_gsm)
        {
#ifdef WASM_PLAYGROUND
        switch_output("parse_debug");
#endif
            parsertl::dfa dfa_;
            parsertl::generator::build_dfa(gs.user_parser.grules, dfa_);
            parsertl::debug::dump(gs.user_parser.grules, dfa_, std::cout);
            return false;
        }
        
        lexertl::generator::build(gs.user_parser.lrules, gs.user_parser.lsm);

        if(gs.dump_grammar_lsm)
        {
#ifdef WASM_PLAYGROUND
        switch_output("parse_debug");
#endif
            lexertl::debug::dump(gs.user_parser.lsm, gs.user_parser.lrules, std::cout);
            return false;
        }
        return true;
    }
};

void build_master_parser(GlobalState& gs, bool dumpGrammar=false, bool asEbnfRR=false)
{
    parsertl::rules& grules = gs.master_parser.grules;
    lexertl::rules& lrules = gs.master_parser.lrules;
    
    static const char* initial_state_str = "INITIAL";
    static const char* current_state_str = ".";

    grules.token("Charset ExitState Macro MacroName "
        "NL Repeat StartState String");

    gs.token_Number = grules.one_token("Number");
    gs.token_Name = grules.one_token("Name");
    gs.token_Literal = grules.one_token("Literal");
    gs.token_Skip = grules.one_token("Skip");
    gs.token_Reject = grules.one_token("Reject");

    grules.push("start", "file");
    grules.push("file",
        "directives '%%' grules '%%' rx_macros '%%' rx_rules '%%'");
    grules.push("directives", "%empty "
        "| directives directive");
    grules.push("directive", "NL");

    // Read and store %left entries
    gs.master_parser.actions[grules.push("directive", "'%left' tokens NL")] =
        [](BuildUserParser& state)
    {
        const std::string tokens = state.dollar(1);

        state.gs.user_parser.grules.left(tokens);
    };
    // Read and store %nonassoc entries
    gs.master_parser.actions[grules.push("directive",
        "'%nonassoc' tokens NL")] =
        [](BuildUserParser& state)
    {
        const std::string tokens = state.dollar(1);

        state.gs.user_parser.grules.nonassoc(tokens);
    };
    // Read and store %precedence entries
    gs.master_parser.actions[grules.push("directive",
        "'%precedence' tokens NL")] =
        [](BuildUserParser& state)
    {
        const std::string tokens = state.dollar(1);

        state.gs.user_parser.grules.precedence(tokens);
    };
    // Read and store %right entries
    gs.master_parser.actions[grules.push("directive", "'%right' tokens NL")] =
        [](BuildUserParser& state)
    {
        const std::string tokens = state.dollar(1);

        state.gs.user_parser.grules.right(tokens);
    };
    // Read and store %start
    gs.master_parser.actions[grules.push("directive", "'%start' Name NL")] =
        [](BuildUserParser& state)
    {
        const std::string name = state.dollar(1);

        state.gs.user_parser.grules.start(name);
    };
    // Read and store %token entries
    gs.master_parser.actions[grules.push("directive", "'%token' tokens NL")] =
        [](BuildUserParser& state)
    {
        const std::string tokens = state.dollar(1);

        state.gs.user_parser.grules.token(tokens);
    };
    grules.push("tokens", "token "
        "| tokens token");
    grules.push("token", "Literal | Name");
    // Read and store %option caseless
    gs.master_parser.actions[grules.push("directive",
        "'%option' 'caseless' NL")] =
        [](BuildUserParser& state)
    {
        state.gs.user_parser.lrules.flags(state.gs.user_parser.lrules.flags() |
                *lexertl::regex_flags::icase);
    };
    // Read and store %x entries
    gs.master_parser.actions[grules.push("directive", "'%x' names NL")] =
        [](BuildUserParser& state)
    {
        const auto& names = state.results.dollar(1, state.gs.master_parser.gsm,
            state.productions);
        const char* start = names.first;
        const char* curr = start;

        for (; curr != names.second; ++curr)
        {
            if (*curr == ' ' || *curr == '\t')
            {
                state.gs.user_parser.lrules.push_state(std::string(start, curr).c_str());

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
            state.gs.user_parser.lrules.push_state(std::string(start, curr).c_str());
        }
    };
    grules.push("names", "Name "
        "| names Name");

    // Grammar rules
    grules.push("grules", "%empty "
        "| grules grule");
    gs.master_parser.actions[grules.push("grule",
        "Name ':' production ';'")] =
        [](BuildUserParser& state)
    {
        const std::string lhs = state.dollar(0);
        const std::string prod = state.dollar(2);

        state.gs.user_parser.grules.push(lhs, prod);
    };
    grules.push("production", "opt_prec_list"
        "| production '|' opt_prec_list");
    grules.push("opt_prec_list", "opt_list opt_prec");
    grules.push("opt_list", "%empty "
        "| '%empty' "
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
        "| '%prec' Literal "
        "| '%prec' Name");

    // Token regex macros
    grules.push("rx_macros", "%empty");
    gs.master_parser.actions[grules.push("rx_macros",
        "rx_macros MacroName regex")] =
        [](BuildUserParser& state)
    {
        const std::string name = state.dollar(1);
        const std::string regex = state.dollar(2);

        state.gs.user_parser.lrules.insert_macro(name.c_str(), regex);
    };

    // Tokens

    auto regex_token_action_token =
        [](BuildUserParser& state)
    {
        const std::string regex = state.dollar(1);
        const token& token = state.dollar_token(2);
        
        const char* start_state = state.gs.group_State_str.empty()
                        ? initial_state_str : state.gs.group_State_str.c_str();

        if(token.id == state.gs.token_Number)
        {
            state.gs.user_parser.lrules.push(start_state,
                regex, static_cast<uint16_t>(atoi(token.str().c_str())),
                current_state_str);
        }
        else if(token.id == state.gs.token_Skip)
        {
            state.gs.user_parser.lrules.push(start_state,
                regex, lexertl::rules::skip(),
                current_state_str);
        }
        else if(token.id == state.gs.token_Literal 
                || token.id == state.gs.token_Name)
        {
            state.gs.user_parser.lrules.push(start_state,
                regex, state.gs.user_parser.grules.token_id(token.str()),
                current_state_str);
        }
        else
        {
            throw std::runtime_error("Unexpected token id in rxrule");
        }
    };

    auto start_end_state_action_token =
        [](BuildUserParser& state)
    {
        const std::string start_state = state.dollar(1, 1, -1);
        const std::string regex = state.dollar(2);
        const std::string exit_state = state.dollar(3, 1, -1);

        switch(state.dollar_argc())
        {
            case 5: /* with return value */
            {
                const token& token = state.dollar_token(4);

                if(token.id == state.gs.token_Number)
                {
                    state.gs.user_parser.lrules.push(start_state.c_str(),
                        regex, static_cast<uint16_t>(atoi(token.str().c_str())),
                        exit_state.c_str());
                }
                else if(token.id == state.gs.token_Skip)
                {
                    state.gs.user_parser.lrules.push(start_state.c_str(),
                        regex, lexertl::rules::skip(),
                        exit_state.c_str());
                }
                else if(token.id == state.gs.token_Reject)
                {
                    state.gs.user_parser.lrules.push(start_state.c_str(),
                        regex, lexertl::rules::reject(),
                        exit_state.c_str());
                }
                else if(token.id == state.gs.token_Literal 
                        || token.id == state.gs.token_Name)
                {
                    state.gs.user_parser.lrules.push(start_state.c_str(),
                        regex, state.gs.user_parser.grules.token_id(token.str()),
                        exit_state.c_str());
                }
                else
                {
                    throw std::runtime_error("Unexpected token id in rxrule");
                }
            }
            break;
            case 4: /* no return value */
                state.gs.user_parser.lrules.push(start_state.c_str(), regex,
                        exit_state.c_str());
                break;
            default:
                    throw std::runtime_error("Unexpected number of productions in rxrule");
        }
    };

    auto start_state_regex_token_action_token =
        [](BuildUserParser& state)
    {
        const std::string start_state = state.dollar(1, 1, -1);
        const std::string regex = state.dollar(2);
        const token& token = state.dollar_token(3);

        if(token.id == state.gs.token_Number)
        {
            state.gs.user_parser.lrules.push(start_state.c_str(),
                regex, static_cast<uint16_t>(atoi(token.str().c_str())),
                current_state_str);
        }
        else if(token.id == state.gs.token_Skip)
        {
            state.gs.user_parser.lrules.push(start_state.c_str(),
                regex, lexertl::rules::skip(),
                current_state_str);
        }
        else if(token.id == state.gs.token_Literal 
                || token.id == state.gs.token_Name)
        {
            state.gs.user_parser.lrules.push(start_state.c_str(),
                regex, state.gs.user_parser.grules.token_id(token.str()),
                current_state_str);
        }
        else
        {
            throw std::runtime_error("Unexpected token id in rxrule");
        }
    };
    
    auto regex_exit_state_token_action_token =
        [](BuildUserParser& state)
    {
        const std::string regex = state.dollar(1);
        const std::string exit_state = state.dollar(2, 1, -1);
        const token& token = state.dollar_token(3);
        
        const char* start_state = state.gs.group_State_str.empty()
                        ? initial_state_str : state.gs.group_State_str.c_str();

        if(token.id == state.gs.token_Number)
        {
            state.gs.user_parser.lrules.push(start_state,
                regex, static_cast<uint16_t>(atoi(token.str().c_str())),
                exit_state.c_str());
        }
        else if(token.id == state.gs.token_Skip)
        {
            state.gs.user_parser.lrules.push(start_state,
                regex, lexertl::rules::skip(),
                exit_state.c_str());
        }
        else if(token.id == state.gs.token_Reject)
        {
            state.gs.user_parser.lrules.push(start_state,
                regex, lexertl::rules::reject(),
                exit_state.c_str());
        }
        else if(token.id == state.gs.token_Literal 
                || token.id == state.gs.token_Name)
        {
            state.gs.user_parser.lrules.push(start_state,
                regex, state.gs.user_parser.grules.token_id(token.str()),
                exit_state.c_str());
        }
        else
        {
            throw std::runtime_error("Unexpected token id in rxrule");
        }
    };
    
    grules.push("rx_rules", "%empty");
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules regex Number")] =
        regex_token_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules StartState regex Number")] =
        start_state_regex_token_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules regex ExitState Number")] =
        regex_exit_state_token_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules StartState regex ExitState Number")] =
        start_end_state_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules regex Literal")] = regex_token_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules StartState regex Literal")] =
        start_state_regex_token_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules regex ExitState Literal")] =
        regex_exit_state_token_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules StartState regex ExitState Literal")] = 
        start_end_state_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules regex Name")] =
        regex_token_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules StartState regex Name")] =
        start_state_regex_token_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules regex ExitState Name")] =
        regex_exit_state_token_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules StartState regex ExitState Name")] = 
        start_end_state_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules regex Skip")] =regex_token_action_token ;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules StartState regex Skip")] =
        start_state_regex_token_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules regex ExitState Skip")] =
        regex_exit_state_token_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules regex ExitState Reject")] =
        regex_exit_state_token_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules StartState regex ExitState Skip")] =
        start_end_state_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules StartState regex ExitState Reject")] =
        start_end_state_action_token;
    gs.master_parser.actions[grules.push("rx_rules",
        "rx_rules StartState regex ExitState")] =
        start_end_state_action_token;
    grules.push("rx_rules", "rx_rules rx_group_start rx_group_end");
    gs.master_parser.actions[grules.push(
            "rx_group_start", "StartState '{'")] =
        [](BuildUserParser& state)
    {
        const std::string start_state = state.dollar(0, 1, -1);
        state.gs.group_State.push_back(start_state);
        if(state.gs.group_State_str.empty())
        {
            state.gs.group_State_str = start_state;
        }
        else
        {
            state.gs.group_State_str += "," + start_state;
        }
    };
    gs.master_parser.actions[grules.push(
            "rx_group_end", "rx_rules '}'")] =
        [](BuildUserParser& state)
    {
        if(state.gs.group_State.empty())
        {
            throw std::runtime_error("No start state to close in rxrule");
        }
        state.gs.group_State.pop_back();
        if(state.gs.group_State.empty())
        {
            state.gs.group_State_str.clear();
        }
        else
        {
            state.gs.group_State_str = state.gs.group_State[0];
            for(size_t idx = 1; idx < state.gs.group_State.size(); ++idx)
            {
                state.gs.group_State_str += "," + state.gs.group_State[idx];
            }
        }
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
        "| '\?\?' "
        "| '*' "
        "| '*?' "
        "| '+' "
        "| '+?' "
        "| Repeat");

    std::string warnings;

    if(dumpGrammar)
    {
        parsertl::debug::dump(grules, std::cout, asEbnfRR);
    }
    parsertl::generator::build(grules, gs.master_parser.gsm, &warnings);

    if (!warnings.empty())
        std::cerr << "Config parser warnings: " << warnings;

    lrules.push_state("OPTION");
    lrules.push_state("GRULE");
    lrules.push_state("MACRO");
    lrules.push_state("REGEX");
    lrules.push_state("RULE");
    lrules.push_state("ID");
    lrules.insert_macro("c_comment", "[/]{2}.*|[/][*](?s:.)*?[*][/]");
    lrules.insert_macro("escape", "\\\\(.|x[0-9A-Fa-f]+|c[@a-zA-Z])");
    lrules.insert_macro("posix_name", "alnum|alpha|blank|cntrl|digit|graph|"
        "lower|print|punct|space|upper|xdigit");
    lrules.insert_macro("posix", "\\[:{posix_name}:\\]");
    lrules.insert_macro("state_name", "[A-Z_a-z][0-9A-Z_a-z]*");

    lrules.push("INITIAL,OPTION", "[ \t]+", lexertl::rules::skip(), ".");
    lrules.push("\n|\r\n", grules.token_id("NL"));
    lrules.push("%left", grules.token_id("'%left'"));
    lrules.push("%nonassoc", grules.token_id("'%nonassoc'"));
    lrules.push("%precedence", grules.token_id("'%precedence'"));
    lrules.push("%right", grules.token_id("'%right'"));
    lrules.push("%start", grules.token_id("'%start'"));
    lrules.push("%token", grules.token_id("'%token'"));
    lrules.push("%x", grules.token_id("'%x'"));
    lrules.push("INITIAL", "%option", grules.token_id("'%option'"), "OPTION");
    lrules.push("OPTION", "caseless", grules.token_id("'caseless'"), "INITIAL");
    lrules.push("INITIAL", "%%", grules.token_id("'%%'"), "GRULE");

    lrules.push("GRULE", ":", grules.token_id("':'"), ".");
    lrules.push("GRULE", "%prec", grules.token_id("'%prec'"), ".");
    lrules.push("GRULE", "\\[", grules.token_id("'['"), ".");
    lrules.push("GRULE", "\\]", grules.token_id("']'"), ".");
    lrules.push("GRULE", "[(]", grules.token_id("'('"), ".");
    lrules.push("GRULE", "[)]", grules.token_id("')'"), ".");
    lrules.push("GRULE", "[?]", grules.token_id("'?'"), ".");
    lrules.push("GRULE", "[*]", grules.token_id("'*'"), ".");
    lrules.push("GRULE", "[+]", grules.token_id("'+'"), ".");
    lrules.push("GRULE", "[|]", grules.token_id("'|'"), ".");
    lrules.push("GRULE", ";", grules.token_id("';'"), ".");
    lrules.push("GRULE", "[ \t]+|\n|\r\n", lexertl::rules::skip(), ".");
    lrules.push("GRULE", "%empty", grules.token_id("'%empty'"), ".");
    lrules.push("GRULE", "%%", grules.token_id("'%%'"), "MACRO");
    lrules.push("INITIAL,GRULE", "{c_comment}", lexertl::rules::skip(), ".");
    // Bison supports single line comments
    lrules.push("INITIAL,GRULE", "[/][/].*", lexertl::rules::skip(), ".");
    lrules.push("INITIAL,GRULE,ID",
        "'(\\\\([^0-9cx]|[0-9]{1,3}|c[@a-zA-Z]|x\\d+)|[^'\\\\])+'|"
        "[\"](\\\\([^0-9cx]|[0-9]{1,3}|c[@a-zA-Z]|x\\d+)|[^\"\\\\])+[\"]",
        grules.token_id("Literal"), ".");
    lrules.push("INITIAL,GRULE,ID", "[.A-Z_a-z][-.0-9A-Z_a-z]*",
        grules.token_id("Name"), ".");
    lrules.push("ID", "[1-9][0-9]*", grules.token_id("Number"), ".");

    lrules.push("MACRO,RULE", "%%", grules.token_id("'%%'"), "RULE");
    lrules.push("MACRO", "[A-Z_a-z][0-9A-Z_a-z]*",
        grules.token_id("MacroName"), "REGEX");
    lrules.push("MACRO,REGEX", "\n|\r\n", lexertl::rules::skip(), "MACRO");

    lrules.push("MACRO,RULE", "{c_comment}",
        lexertl::rules::skip(), ".");
    lrules.push("RULE", "^<([*]|{state_name}(,{state_name})*)>",
        grules.token_id("StartState"), ".");
    lrules.push("RULE", "[ \t]*\\{", grules.token_id("'{'"), ".");
    lrules.push("RULE", "\\}", grules.token_id("'}'"), ".");
    lrules.push("REGEX", "[ \t]+", lexertl::rules::skip(), ".");
    lrules.push("REGEX,RULE", "\\^", grules.token_id("'^'"), ".");
    lrules.push("REGEX,RULE", "\\$", grules.token_id("'$'"), ".");
    lrules.push("REGEX,RULE", "[|]", grules.token_id("'|'"), ".");
    lrules.push("REGEX,RULE", "[(]([?](-?(i|s|x))*:)?",
        grules.token_id("'('"), ".");
    lrules.push("REGEX,RULE", "[)]", grules.token_id("')'"), ".");
    lrules.push("REGEX,RULE", "[?]", grules.token_id("'?'"), ".");
    lrules.push("REGEX,RULE", "[?][?]", grules.token_id("'\?\?'"), ".");
    lrules.push("REGEX,RULE", "[*]", grules.token_id("'*'"), ".");
    lrules.push("REGEX,RULE", "[*][?]", grules.token_id("'*?'"), ".");
    lrules.push("REGEX,RULE", "[+]", grules.token_id("'+'"), ".");
    lrules.push("REGEX,RULE", "[+][?]", grules.token_id("'+?'"), ".");
    lrules.push("REGEX,RULE", "{escape}|(\\[^?({escape}|{posix}|"
        "[^\\\\\\]])*\\])|[^\\s]", grules.token_id("Charset"), ".");
    lrules.push("REGEX,RULE", "[{][A-Z_a-z][-0-9A-Z_a-z]*[}]",
        grules.token_id("Macro"), ".");
    lrules.push("REGEX,RULE", "[{][0-9]+(,([0-9]+)?)?[}][?]?",
        grules.token_id("Repeat"), ".");
    lrules.push("REGEX,RULE", "[\"](\\\\.|[^\r\n\"\\\\])*[\"]",
        grules.token_id("String"), ".");

    lrules.push("RULE,ID", "[ \t]+({c_comment}([ \t]+|{c_comment})*)?",
        lexertl::rules::skip(), "ID");
    lrules.push("RULE", "<([.]|<|>?{state_name})>",
        grules.token_id("ExitState"), "ID");
    lrules.push("RULE,ID", "\n|\r\n", lexertl::rules::skip(), "RULE");
    lrules.push("ID", "skip\\s*[(]\\s*[)]", gs.token_Skip, "RULE");
    lrules.push("ID", "reject\\s*[(]\\s*[)]", gs.token_Reject, "RULE");
    lexertl::generator::build(lrules, gs.master_parser.lsm);
    //gs.master_parser.lsm.minimise ();
    if(dumpGrammar)
    {
        //lexertl::debug::dump(lrules, std::cout, asEbnfRR);
    }
}

int main_base(int argc, char* argv[], GlobalState& gs)
{
#ifdef WASM_PLAYGROUND
    int err = 0; // currently, zero is always returned; result codes for each part
                 // are sent to JS via set_result()

    switch_output("compile_status");
#else
#ifndef DEBUGMEM_H_INCLUDED   
    start_time = clock();
#endif
#endif

    try
    {
        build_master_parser(gs);
        showDiffTime("build master parser");

        lexertl::citerator iter_lexg(gs.grammar_data,
                gs.grammar_data + gs.grammar_data_size, gs.master_parser.lsm);
        parsertl::match_results resultsg(iter_lexg->id, gs.master_parser.gsm);

        bool success = parsertl::parse(iter_lexg, gs.master_parser.gsm, resultsg);
        showDiffTime("parse user grammar");
        if (resultsg.entry.action == parsertl::action::error)
        {
            parser_throw_error("parsing the user grammar", iter_lexg, gs.grammar_data);
        }
        else std::cout << "Parser user grammar success: " << success << "\n";

        BuildUserParser bup(gs);
        bup.build();
        if(gs.dump_grammar_parse_tree
                || gs.dump_grammar_parse_trace
                || gs.dump_grammar_lexer 
                || gs.dump_grammar_lsm 
                || gs.dump_grammar_gsm 
                || gs.dumpAsEbnfRR)
        {
            return -1;
        }
        showDiffTime("build user parser");
        std::cerr << "Productions " << gs.user_parser.grules.grammar().size() << ".\n";
        std::cerr << "Terminals " << gs.user_parser.grules.terminals_count() << ".\n";
        std::cerr << "NonTerminals " << gs.user_parser.grules.non_terminals_count() << ".\n";
        std::cerr << "States " << gs.user_parser.gsm._rows << ".\n";
        std::cerr << "Lexer States " << gs.user_parser.lsm.data()._dfa.size() << ".\n";
        std::cerr << "Lexer State0 " << gs.user_parser.lsm.data()._dfa[0].size() << ".\n";
        std::cerr << "Shift/Reduce conflicts resolved " << gs.user_parser.grules.shift_reduce_count << ".\n";
        std::cerr << "Reduce/Reduce conflicts resolved " << gs.user_parser.grules.reduce_reduce_count << ".\n";
        //std::cerr << "dumpAsEbnfRR = " << gs.dumpAsEbnfRR << "\n";
        
        if(gs.dump_input_parse_tree)
        {
#ifdef WASM_PLAYGROUND
        switch_output("parse_debug");
#endif
            dump_parse_tree(gs.input_data, gs.input_data + gs.input_data_size,
                    gs.user_parser.grules, gs.user_parser.gsm, gs.user_parser.lsm
#ifdef WASM_PLAYGROUND
                    ,"parse_stats"
#endif
                    );
            showDiffTime("dump input parser tree");
            return -1;
        }
        if(gs.dump_input_parse_trace)
        {
#ifdef WASM_PLAYGROUND
        switch_output("parse_debug");
#endif
            dump_parse_trace(gs.input_data, gs.input_data + gs.input_data_size,
                    gs.user_parser.grules, gs.user_parser.gsm, gs.user_parser.lsm
#ifdef WASM_PLAYGROUND
                    ,"parse_stats"
#endif
                    );
            showDiffTime("dump input parser trace");
            return -1;
        }
        lexertl::citerator iter_lexi(gs.input_data,
                gs.input_data + gs.input_data_size, gs.user_parser.lsm);
        if(gs.dump_input_lexer)
        {
#ifdef WASM_PLAYGROUND
        switch_output("parse_debug");
#endif
            dump_lexer(iter_lexi, gs.user_parser.grules, gs.input_data);
            showDiffTime("dump input lexer");
            return -1;
        }
#ifdef WASM_PLAYGROUND
        switch_output("parse_stats");
#endif
        parsertl::match_results resultsi(iter_lexi->id, gs.user_parser.gsm);

        success = parsertl::parse(iter_lexi, gs.user_parser.gsm, resultsi);
        showDiffTime("parse input");
        if (resultsi.entry.action == parsertl::action::error)
        {
            parser_throw_error("parsing the input", iter_lexi, gs.input_data);
        }
#ifndef WASM_PLAYGROUND
        else std::cout << "Parser input success: " << success << "\n";
#endif

    }
    catch (const std::exception &e)
    {
        std::cout << e.what() << '\n';
    }

#ifdef WASM_PLAYGROUND
    //set_result("compile", errors);
    //set_result("parse", parse_result ? 0 : err);
    return err;
#else
    return 0;
#endif    
}

extern "C" int main_playground(
        const char *grammar_data
        ,const char *input_data
        ,int dump_grammar_lexer
        ,int dump_grammar_lsm
        ,int dump_grammar_gsm
        ,int dump_grammar_parse_tree
        ,int dump_grammar_parse_trace
        ,int dump_input_lexer
        ,int dump_input_parse_tree
        ,int dump_input_parse_trace
        ,int dumpAsEbnfRR)
{
    const char *argv[] = {"parsertl", "-f", "grammar.g", "input.txt"}; 
    int argc = 4;
    GlobalState gs;
    gs.grammar_data = grammar_data;
    //use of Javascript string.length can't be used for utf8
    gs.grammar_data_size = strlen(grammar_data);
    gs.input_data = input_data;
    gs.input_data_size = strlen(input_data);
    gs.dump_grammar_lexer = dump_grammar_lexer;
    gs.dump_grammar_lsm = dump_grammar_lsm;
    gs.dump_grammar_gsm = dump_grammar_gsm;
    gs.dump_grammar_parse_tree = dump_grammar_parse_tree;
    gs.dump_grammar_parse_trace = dump_grammar_parse_trace;
    gs.dump_input_lexer = dump_input_lexer;
    gs.dump_input_parse_tree = dump_input_parse_tree;
    gs.dump_input_parse_trace = dump_input_parse_trace;
    gs.dumpAsEbnfRR = dumpAsEbnfRR;
    
    return main_base(argc, (char**)argv, gs);
}

#ifndef WASM_PLAYGROUND
int main(int argc, char *argv[])
{
    GlobalState gs;
    //gs.dump_grammar_lexer = true;
    //gs.dump_grammar_lsm = true;
    //gs.dump_grammar_gsm = true;
    //gs.dump_input_lexer = true;
    //gs.dump_input_parse_tree = true;
    //gs.dump_input_parse_trace = true;
    if(argc < 3)
    {
        std::cout << "usage: " << argv[0] << " grammar_fname input_fname\n";
        return 1;
    }
    const char* grammar_pathname = argv[1];
    const char* input_pathname = argv[2];

    showDiffTime("Starting");
    try
    {
        lexertl::memory_file mfg(grammar_pathname);
        if (!mfg.data())
        {
            std::cerr << "Error: failed to open " << grammar_pathname << ".\n";
            return 1;
        }
        gs.grammar_data = mfg.data();
        gs.grammar_data_size = mfg.size();
        showDiffTime("read user grammar");

        lexertl::memory_file mfi(input_pathname);
        if (!mfi.data())
        {
            std::cerr << "Error: failed to open " << input_pathname << ".\n";
            return 1;
        }
        gs.input_data = mfi.data();
        gs.input_data_size = mfi.size();
        showDiffTime("read input");
        return main_base(argc, argv, gs);
    }
    catch (const std::exception &e)
    {
        std::cout << e.what() << '\n';
    }
    
    //return main_playground(nullptr, 0, nullptr, 0, false, false, false, false, true);
    return 1;    
}
#endif
