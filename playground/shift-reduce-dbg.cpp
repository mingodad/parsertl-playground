//g++ -std=c++17 -O2 -I.. -o shift-reduce-dbg shift-reduce-dbg.cpp
//From: https://www.codeproject.com/Articles/5269488/Debugging-a-Bison-Grammar
#include "parsertl/debug.hpp"
#include "parsertl/generator.hpp"
#include "parsertl/lookup.hpp"
#include <iostream>
#include "lexertl/memory_file.hpp"
#include "lexertl/debug.hpp"
#include "parsertl/parse.hpp"
#include <queue>

using char_ptr_pair = std::pair<const char*, const char*>;
using char_ptr_pair_vector = std::vector<char_ptr_pair>;
using int_char_ptr_map = std::map<int, char_ptr_pair>;
using int_vector = std::vector<int>;

struct non_terminal
{
    char_ptr_pair _name;
    int _id = -1;
    int_vector _lhs;
    int_vector _rhs;

    non_terminal(const char_ptr_pair &name) :
        _name(name)
    {
    }
};

using nt_vector = std::vector<non_terminal>;

template<typename Container, typename Iterator>
struct direction
{
};

template<typename Container>
struct direction<Container, typename Container::const_iterator>
{
    typename Container::const_iterator begin(const Container& c)
    {
        return c.cbegin();
    }

    typename Container::const_iterator end(const Container& c)
    {
        return c.cend();
    }
};

template<typename Container>
struct direction<Container, typename Container::const_reverse_iterator>
{
    typename Container::const_reverse_iterator begin(const Container& c)
    {
        return c.crbegin();
    }

    typename Container::const_reverse_iterator end(const Container& c)
    {
        return c.crend();
    }
};

std::size_t g_rule_name = ~0;
std::size_t g_sub_rule_idx = ~0;
std::size_t g_rule_item1 = ~0;
std::size_t g_rule_item2 = ~0;
std::size_t g_term_name_idx = ~0;
std::size_t g_term_rule_idx = ~0;
std::size_t g_nts_title = ~0;
std::size_t g_non_term_name_idx = ~0;
std::size_t g_non_term_id_idx = ~0;
std::size_t g_left_id_idx = ~0;
std::size_t g_right_id_idx = ~0;
std::size_t g_state_title_idx = ~0;
std::size_t g_state_prod_ix = ~0;
std::size_t g_state_shift_idx = ~0;
std::size_t g_state_reduce_idx = ~0;
std::size_t g_reduce_error_idx = ~0;

// Index from rule number to non terminal
int_vector g_rule_to_nt;
// Production for each rule
std::vector<char_ptr_pair_vector> g_rules;
// Terminals, with rules where they appear
std::vector<std::pair<char_ptr_pair, int_vector>> g_terminals;
// Nonterminals, with rules where they appear
nt_vector g_non_terminals;

void build_grammar(parsertl::state_machine &gsm, lexertl::state_machine &lsm, bool dumpGrammar=false)
{
    parsertl::rules grules;
    lexertl::rules lrules;
    std::string warnings;

    grules.token("ACCEPT Literal GOTO Grammar Integer Name NL NON_TERMINALS_TITLE "
        "OnLeft OnRight REDUCE ReduceReduce RUG_TITLE RUPC_TITLE SHIFT Empty T_NT_Tag "
        "ShiftReduce State STATE_TITLE TERMINALS_TITLE TUG_TITLE UNT_TITLE");

    grules.push("start", "useless_nonterms terms_unused rules_useless "
        "rules_useless_conflicts conflict_states grammar terminals non_terminals "
        "states");
    grules.push("useless_nonterms", "%empty | UNT_TITLE NL NL name_list NL NL");
    grules.push("terms_unused", "%empty | TUG_TITLE NL NL name_list NL NL");
    grules.push("rules_useless", "%empty | RUG_TITLE NL NL production_list NL");
    grules.push("rules_useless_conflicts", "%empty | RUPC_TITLE NL NL production_list NL");
    grules.push("name_list", "Name NL "
        "| name_list Name NL");

    grules.push("production_list", "production "
        "| production_list production");
    grules.push("production",
        "opt_nl Integer Name ':' item_list NL or_item_list NL");
    grules.push("item_list", "%empty "
	"| Empty"
        "| item_list name_literal");
    grules.push("or_item_list", "%empty "
        "| or_item_list Integer '|' item_list NL");

    grules.push("conflict_states", "conflict_state_list NL NL");
    grules.push("conflict_state_list", "State conflicts NL "
        "| conflict_state_list State conflicts NL");
    grules.push("conflicts", "Integer ShiftReduce "
        "| Integer ReduceReduce "
        "| conflicts ',' Integer ShiftReduce "
        "| conflicts ',' Integer ReduceReduce");
    grules.push("grammar", "Grammar NL NL gram_production_list NL");
    grules.push("gram_production_list", "gram_production "
        "| gram_production_list gram_production");
    grules.push("gram_production", "Integer rule_name ':' gram_item_list NL sub_prod NL");

    g_rule_name = grules.push("rule_name", "Name");

    grules.push("gram_item_list", "%empty "
        "| gram_item_list rule_item");

    grules.push("sub_prod", "%empty "
        "| sub_prod sub_rule_id '|' gram_item_list NL");

    g_sub_rule_idx = grules.push("sub_rule_id", "Integer");
    g_rule_item1 = grules.push("rule_item", "Name");
    g_rule_item2 = grules.push("rule_item", "Literal");
    grules.push("rule_item", "Empty");

    grules.push("terminals", "TERMINALS_TITLE NL NL terminal_list");
    grules.push("terminal_list", "term_name t_nt_tag_opt '(' Integer ')' term_integer_list "
        "| terminal_list term_name t_nt_tag_opt '(' Integer ')' term_integer_list");

    g_term_name_idx = grules.push("term_name", "name_literal");

    grules.push("term_integer_list", "NL "
        "| term_rule "
        "| term_integer_list term_rule "
        "| term_integer_list NL");

    g_term_rule_idx = grules.push("term_rule", "Integer");

    grules.push("non_terminals", "nts_title NL NL non_terminal_list NL NL");

    g_nts_title = grules.push("nts_title", "NON_TERMINALS_TITLE");

    // e.g: decimal (2971)
    grules.push("non_terminal_list", "non_term_name t_nt_tag_opt '(' non_term_id ')' NL left_right NL "
        "| non_terminal_list non_term_name t_nt_tag_opt '(' non_term_id ')' NL left_right NL");

    g_non_term_name_idx = grules.push("non_term_name", "Name");
    g_non_term_id_idx = grules.push("non_term_id", "Integer");

    // e.g: on left: 4257, on right: 600 797
    grules.push("left_right", "OnLeft left_int_list "
        "| OnRight right_int_list "
        "| left_right left_right_sep OnLeft left_int_list "
        "| left_right left_right_sep OnRight right_int_list");

    grules.push("left_right_sep", "NL "
        "| ',' "
        "| ',' NL ");

    grules.push("left_int_list", "left_id "
        "| left_int_list left_id ");

    g_left_id_idx = grules.push("left_id", "Integer");

    grules.push("right_int_list", "right_id "
        "| right_int_list right_id ");

    g_right_id_idx = grules.push("right_id", "Integer");

    grules.push("opt_nl", "%empty | NL");
    grules.push("states", "state "
        "| states state");
    grules.push("state", "state_title NL NL state_prod_list transitions");
    g_state_title_idx = grules.push("state_title", "STATE_TITLE");
    grules.push("state_prod_list", "state_prod "
        "| state_prod_list state_prod");
    g_state_prod_ix = grules.push("state_prod", "opt_nl state_prod_rule lhs item_dot_list NL");
    grules.push("state_prod_rule", "Integer");
    grules.push("lhs", "Name ':'");
    grules.push("lhs", "'|'");
    grules.push("item_dot_list", "%empty "
        "| item_dot_list item");
    grules.push("item", "name_literal");
    grules.push("item", "'.'");

    grules.push("transitions", "NL "
        "| action "
        "| transitions action "
        "| transitions NL");
    grules.push("action", "name_literal ACCEPT NL "
        "| name_literal GOTO Integer NL");
    g_state_shift_idx = grules.push("action", "name_literal SHIFT Integer NL");
    g_state_reduce_idx = grules.push("action", "name_literal REDUCE Integer '(' Name ')' NL");

    g_reduce_error_idx = grules.push("action", "name_literal '[' REDUCE Integer '(' Name ')' ']' NL");
/*
    grules.push("integer_list", "NL "
        "| Integer "
        "| integer_list Integer "
        "| integer_list NL");
*/
    grules.push("name_literal", "Name | Literal");
    grules.push("t_nt_tag_opt", "%empty "
        "| T_NT_Tag");

    //parsertl::debug::dump(grules, std::cout, false);
    parsertl::generator::build(grules, gsm, &warnings);

    lrules.push_state("INT_LIST");
    lrules.push("[ \t]+|[/][*].{+}[\r\n]*?[*][/]", lrules.skip());
    lrules.push("\r?\n", grules.token_id("NL"));
    lrules.push("[0-9]+", grules.token_id("Integer"));
    lrules.push(":", grules.token_id("':'"));
    lrules.push("[|]", grules.token_id("'|'"));
    lrules.push(",", grules.token_id("','"));
    lrules.push("•", grules.token_id("'.'"));
    lrules.push("[.]", grules.token_id("'.'"));
    lrules.push("[(]", grules.token_id("'('"));
    lrules.push("[)]", grules.token_id("')'"));
    lrules.push("\\[", grules.token_id("'['"));
    lrules.push("\\]", grules.token_id("']'"));
    lrules.push("'([^'\n\r\\\\]|\\\\.)'", grules.token_id("Literal"));
    lrules.push("[\"]([^\"\n\r\\\\]|\\\\.)+[\"]", grules.token_id("Literal"));
    lrules.push("accept", grules.token_id("ACCEPT"));
    lrules.push("Grammar", grules.token_id("Grammar"));
    lrules.push("State \\d+ conflicts: ", grules.token_id("State"));
    lrules.push("State \\d+", grules.token_id("STATE_TITLE"));
    lrules.push("reduce[/]reduce", grules.token_id("ReduceReduce"));
    lrules.push("shift[/]reduce", grules.token_id("ShiftReduce"));
    lrules.push("INITIAL", "on left:", grules.token_id("OnLeft"), "INT_LIST");
    lrules.push("INITIAL", "on right:", grules.token_id("OnRight"), "INT_LIST");
    lrules.push("INT_LIST", "[\n\r\t ]+[0-9]+", grules.token_id("Integer"), ".");
    lrules.push("INT_LIST", "[^0-9]", lrules.reject(), "INITIAL");
    lrules.push("Nonterminals useless in grammar", grules.token_id("UNT_TITLE"));
    lrules.push("Terminals unused in grammar", grules.token_id("TUG_TITLE"));
    lrules.push("Rules useless in grammar", grules.token_id("RUG_TITLE"));
    lrules.push("Rules useless in parser due to conflicts", grules.token_id("RUPC_TITLE"));
    lrules.push("Terminals, with rules where they appear", grules.token_id("TERMINALS_TITLE"));
    lrules.push("Nonterminals, with rules where they appear", grules.token_id("NON_TERMINALS_TITLE"));
    lrules.push("go to state", grules.token_id("GOTO"));
    lrules.push("reduce using rule", grules.token_id("REDUCE"));
    lrules.push("shift, and go to state", grules.token_id("SHIFT"));
    lrules.push("[$@]?[A-Z_a-z][0-9A-Z_a-z]*", grules.token_id("Name"));
    lrules.push("%empty", grules.token_id("Empty"));
    lrules.push("ε", grules.token_id("Empty"));
    lrules.push("[<][^>]+>", grules.token_id("T_NT_Tag"));
    lexertl::generator::build(lrules, lsm);

    if(dumpGrammar)
    {
	parsertl::debug::dump(grules, std::cout, false);
        parsertl::rules::string_vector terminals;
        grules.terminals(terminals);
        lexertl::debug::dump(lrules, std::cout, terminals);
    }
}

bool nullable(const nt_vector::const_iterator &iter)
{
    for (const int rule : iter->_lhs)
    {
        if (g_rules[rule].empty())
            return true;
    }

    return false;
}

bool nullable(const int start_rule)
{
    int nt = g_rule_to_nt[start_rule];
    auto iter = std::find_if(g_non_terminals.begin(),
        g_non_terminals.end(), [&nt](const auto& rec)
        {
            return nt == rec._id;
        });

    return nullable(iter);
}

void output(const char* first, const char* second, std::ostream& ss)
{
    for (; first < second; ++first)
    {
        ss << *first;
    }
}

void display_match(const bool prev_matched, const int rule,
    const nt_vector::const_iterator &nt_iter,
    const char_ptr_pair_vector &curr_rhs,
    char_ptr_pair_vector::const_iterator& next,
    char_ptr_pair_vector::const_iterator& end)
{
    if (!prev_matched)
        std::cout << '\n';

    std::cout << rule << ' ';
    output(nt_iter->_name.first, nt_iter->_name.second, std::cout);
    std::cout << ':';

    for (auto iter = curr_rhs.begin(); iter != next; ++iter)
    {
        std::cout << ' ';
        output(iter->first, iter->second, std::cout);
    }

    std::cout << " .";

    for (auto iter = next; iter != end; ++iter)
    {
        std::cout << ' ';
        output(iter->first, iter->second, std::cout);
    }

    std::cout << '\n';
}

bool find_match(const std::string& terminal, int_char_ptr_map& lhs_nts,
    int_char_ptr_map& rhs_nts)
{
    bool matched = false;
    const char* first = terminal.c_str();
    const char* second = first + terminal.size();

    for (const auto& lhs : lhs_nts)
    {
        const int id = lhs.first;
        auto nt_iter = std::find_if(g_non_terminals.begin(),
            g_non_terminals.end(),
            [id](const auto& nt)
            {
                return id == nt._id;
            });

        for (const int rule : nt_iter->_rhs)
        {
            const auto& curr_rhs = g_rules[rule];
            auto iter = curr_rhs.begin();
            auto end = curr_rhs.end();

            for (; iter != end; ++iter)
            {
                if (std::equal(nt_iter->_name.first, nt_iter->_name.second,
                    iter->first, iter->second))
                {
                    auto next = iter;

                    ++next;

                    if (next != end)
                    {
                        if (std::equal(first, second, next->first, next->second))
                        {
                            const int id = g_rule_to_nt[rule];

                            nt_iter = std::find_if(g_non_terminals.begin(),
                                g_non_terminals.end(),
                                [id](const auto& nt)
                                {
                                    return id == nt._id;
                                });
                            display_match(matched, rule, nt_iter, curr_rhs, next, end);
                            // If terminal matched directly, no need to set matched flag
                            // as there is no additional rule to output.
                        }
                        else
                        {
                            for (const auto& rhs : rhs_nts)
                            {
                                if (std::equal(rhs.second.first,
                                    rhs.second.second, next->first,
                                    next->second))
                                {
                                    const int id = g_rule_to_nt[rule];
                                    auto nt_iter =
                                        std::find_if(g_non_terminals.begin(),
                                        g_non_terminals.end(),
                                        [id](const auto& nt)
                                        {
                                            return id == nt._id;
                                        });

                                    display_match(matched, rule, nt_iter, curr_rhs,
                                        next, end);
                                    matched = true;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    return matched;
}

// Recursively find all nts beginning/ending with start_nt
template<typename Container, typename Iterator>
void recurse(int start_nt, int_char_ptr_map& nts)
{
    direction<Container, Iterator> d;
    std::queue<int> queue;

    for (queue.push(start_nt); !queue.empty(); queue.pop())
    {
        int curr_nt = queue.front();

        auto nt_iter = std::find_if(g_non_terminals.begin(),
            g_non_terminals.end(), [curr_nt](const auto& nt)
            {
                return curr_nt == nt._id;
            });

        nts[curr_nt] = nt_iter->_name;

        for (const int rule : nt_iter->_rhs)
        {
            auto& rhs = g_rules[rule];
            Iterator iter = d.begin(rhs);
            Iterator end = d.end(rhs);

            for (; iter != end; ++iter)
            {
                if (std::equal(nt_iter->_name.first, nt_iter->_name.second,
                    iter->first, iter->second))
                {
                    curr_nt = g_rule_to_nt[rule];

                    if (nts.find(curr_nt) == nts.end())
                        queue.push(curr_nt);

                    break;
                }
                else
                {
                    auto curr_iter = std::find_if(g_non_terminals.begin(),
                        g_non_terminals.end(), [&iter](const auto& nt)
                        {
                            return std::equal(iter->first, iter->second,
                                nt._name.first, nt._name.second);
                        });

                    if (curr_iter == g_non_terminals.end() ||
                        !nullable(curr_iter))
                    {
                        break;
                    }
                }
            }
        }
    }
}

void process_clash(const int reduce_rule, const std::string& terminal)
{
    int reduce_nt = g_rule_to_nt[reduce_rule];
    const char* first = terminal.c_str();
    const char* second = first + terminal.size();
    auto term_iter = std::find_if(g_terminals.begin(),
        g_terminals.end(), [first, second](const auto& term)
        {
            return std::equal(first, second, term.first.first, term.first.second);
        });
    int_char_ptr_map reduction_nts;

    // Recursively look for reduce_nt at the end of rules
    recurse<char_ptr_pair_vector, char_ptr_pair_vector::const_reverse_iterator>
        (reduce_nt, reduction_nts);

    // Look for rules starting with terminal
    for (const int rule : term_iter->second)
    {
        auto& rhs = g_rules[rule];
        auto iter = rhs.begin();
        auto end = rhs.end();

        for (; iter != end; ++iter)
        {
            if (std::equal(first, second, iter->first, iter->second))
            {
                const int shift_nt = g_rule_to_nt[rule];
                int_char_ptr_map shift_nts;

                // Recursively look for reduce_nt at the end of rules
                recurse<char_ptr_pair_vector, char_ptr_pair_vector::const_iterator>
                    (shift_nt, shift_nts);

                if (find_match(terminal, reduction_nts, shift_nts))
                {
                    const int id = g_rule_to_nt[rule];
                    auto nt_iter = std::find_if(g_non_terminals.begin(),
                        g_non_terminals.end(),
                        [id](const auto& nt)
                        {
                            return id == nt._id;
                        });
                    const auto& rhs = g_rules[rule];

                    std::cout << rule << ' ';
                    output(nt_iter->_name.first, nt_iter->_name.second, std::cout);
                    std::cout << ": .";

                    for (const auto& item : rhs)
                    {
                        std::cout << ' ';
                        output(item.first, item.second, std::cout);
                    }

                    std::cout << '\n';
                }

                break;
            }
            else
            {
                auto curr_iter = std::find_if(g_non_terminals.begin(),
                    g_non_terminals.end(), [&iter](const auto& nt)
                    {
                        return std::equal(iter->first, iter->second,
                            nt._name.first, nt._name.second);
                    });

                if (curr_iter == g_non_terminals.end() || !nullable(curr_iter))
                {
                    break;
                }
            }
        }
    }
}

static int myatoi(const char *int_str)
{
	while(int_str && isspace(*int_str)) ++int_str;
	return atoi(int_str);
}

void process(const char* pathname, bool g_dump_grammar_lexer=false)
{
    parsertl::state_machine gsm;
    lexertl::state_machine lsm;
    lexertl::memory_file mf(pathname);
    const char endl[] = { '\n' };

    build_grammar(gsm, lsm);

    lexertl::citerator iter(mf.data(), mf.data() + mf.size(), lsm);

    if(g_dump_grammar_lexer)
    {
        while(iter->id != 0) {
            const std::size_t line =
                1 + std::count(mf.data(), iter->first, '\n');
            const std::size_t column = iter->first - std::find_end(mf.data(),
                    iter->first, endl, endl + 1);
            std::cout << line << ":" << column << ":" << iter->id << ": " <<
                    iter->str() << "\n"; ++iter;
        }
        return;
    }

    parsertl::match_results results(iter->id, gsm);
    using token = parsertl::token<lexertl::citerator>;
    token::token_vector productions;
    int curr_prod = -1;
    // Used in population of g_rule_to_nt
    std::vector<std::string> nt_names;
    std::vector<char_ptr_pair> state_productions;
    std::map<std::string, int> state_shifts;
    std::map<std::string, std::pair<int, std::string>> state_reduces;
    int state = -1;

    for (; results.entry.action != parsertl::action::accept &&
        results.entry.action != parsertl::action::error; )
    {
        switch (results.entry.action)
        {
            case parsertl::action::reduce:
            if (results.entry.param == g_rule_name)
            {
                // rule_name: Name;
                std::string name = results.dollar(0, gsm, productions).str();
                auto iter = std::find(nt_names.begin(), nt_names.end(), name);

                if (iter == nt_names.end())
                {
                    curr_prod = static_cast<int>(nt_names.size());
                    nt_names.emplace_back(std::move(name));
                }
                else
                {
                    curr_prod = static_cast<int>(iter - nt_names.begin());
                }

                g_rule_to_nt.push_back(curr_prod);
                g_rules.emplace_back(char_ptr_pair_vector());
            }
            else if (results.entry.param == g_sub_rule_idx)
            {
                // sub_rule_id: Integer;
                g_rule_to_nt.push_back(curr_prod);
                g_rules.emplace_back(char_ptr_pair_vector());
            }
            else if (results.entry.param == g_rule_item1 ||
                results.entry.param == g_rule_item2)
            {
                // rule_item: Name | Literal;
                const token& token = results.dollar(0, gsm, productions);

                if (*token.first != '$')
                    g_rules.back().emplace_back(std::pair(token.first, token.second));
            }
            else if (results.entry.param == g_term_name_idx)
            {
                // term_name: name_literal;
                const token& token = results.dollar(0, gsm, productions);

                g_terminals.emplace_back(std::pair(token.first, token.second),
                    int_vector());
            }
            else if (results.entry.param == g_term_rule_idx)
            {
                // term_rule: Integer;
                const token& token = results.dollar(0, gsm, productions);

                g_terminals.back().second.push_back(myatoi(token.first));
            }
            else if (results.entry.param == g_nts_title)
            {
                // nts_title: NON_TERMINALS_TITLE;
                const int offset = static_cast<int>(g_terminals.size() + 1);
                std::vector<std::string> temp;

                for (int& val : g_rule_to_nt)
                {
                    val += offset;
                }

                // Finished with temporary vector
                nt_names.swap(temp);
            }
            else if (results.entry.param == g_non_term_name_idx)
            {
                // non_term_name: Name;
                const token& name = results.dollar(0, gsm, productions);

                g_non_terminals.emplace_back(non_terminal(std::pair(name.first, name.second)));
            }
            else if (results.entry.param == g_non_term_id_idx)
            {
                // non_term_id: Integer;
                const token& id = results.dollar(0, gsm, productions);

                g_non_terminals.back()._id = myatoi(id.first);
            }
            else if (results.entry.param == g_left_id_idx)
            {
                // left_id: Integer;
                const token& id = results.dollar(0, gsm, productions);
                g_non_terminals.back()._lhs.push_back(myatoi(id.first));
            }
            else if (results.entry.param == g_right_id_idx)
            {
                // right_id: Integer;
                const token& id = results.dollar(0, gsm, productions);

                g_non_terminals.back()._rhs.push_back(myatoi(id.first));
            }
            else if (results.entry.param == g_state_title_idx)
            {
                // state_title: STATE_TITLE;
                const token& title = results.dollar(0, gsm, productions);
                const char* curr = title.second;

                for (; *(curr - 1) != ' '; --curr);

                state = myatoi(curr);
                state_productions.clear();
                state_shifts.clear();
                state_reduces.clear();
            }
            else if (results.entry.param == g_state_prod_ix)
            {
                // state_prod: opt_nl state_prod_rule lhs item_dot_list NL;
                state_productions.
                    emplace_back(char_ptr_pair(results.dollar(1, gsm, productions).first,
                        results.dollar(3, gsm, productions).second));
            }
            else if (results.entry.param == g_state_shift_idx)
            {
                // action: name_literal SHIFT Integer NL;
                state_shifts[results.dollar(0, gsm, productions).str()] =
                    myatoi(results.dollar(2, gsm, productions).first);
            }
            else if (results.entry.param == g_state_reduce_idx)
            {
                // action: name_literal REDUCE Integer '(' Name ')' NL;
                state_reduces[results.dollar(0, gsm, productions).str()] =
                    std::pair(myatoi(results.dollar(2, gsm, productions).first),
                        results.dollar(4, gsm, productions).str());
            }
            else if (results.entry.param == g_reduce_error_idx)
            {
                // action: name_literal '[' REDUCE Integer '(' Name ')' ']' NL;
                const std::string terminal = results.dollar(0, gsm, productions).str();
                auto shift_iter = state_shifts.find(terminal);
                const int rule =
                    myatoi(results.dollar(3, gsm, productions).first);

                std::cout << "State " << state << "\n\n";

                if (shift_iter == state_shifts.end())
                {
                    // Reduce/Reduce error
                    auto reduce_iter = state_reduces.find(terminal);
                    auto& reduce_rule = g_rules[reduce_iter->second.first];
                    auto& clash_rule = g_rules[rule];

                    std::cout << "reduce/reduce error(s):\n\n";
                    std::cout << terminal << ' ';
                    std::cout << reduce_iter->second.second << ':';

                    for (auto& item : reduce_rule)
                    {
                        std::cout << ' ';
                        output(item.first, item.second, std::cout);
                    }

                    std::cout << " .\n";
                    std::cout << terminal << ' ';
                    std::cout << results.dollar(5, gsm, productions).str() << ':';

                    for (auto& item : clash_rule)
                    {
                        std::cout << ' ';
                        output(item.first, item.second, std::cout);
                    }

                    std::cout << " .\n\n";
                }
                else
                {
                    // Shift/Reduce error
                    for (const auto& pair : state_productions)
                    {
                        output(pair.first, pair.second, std::cout);
                        std::cout << '\n';
                    }

                    std::cout << '\n';
                    std::cout << terminal;
                    output(results.dollar(0, gsm, productions).second,
                        results.dollar(1, gsm, productions).first, std::cout);
                    std::cout << "shift, and go to state " <<
                        shift_iter->second << '\n';
                    output(results.dollar(0, gsm, productions).first,
                        results.dollar(8, gsm, productions).second, std::cout);
                    process_clash(rule, terminal);
                    std::cout << '\n';
                }
            }

            break;
        }

        parsertl::lookup(iter, gsm, results, productions);
    }

    if (results.entry.action == parsertl::action::error)
    {
        const std::size_t line =
            1 + std::count(mf.data(), iter->first, '\n');
        const std::size_t column = iter->first - std::find_end(mf.data(),
            iter->first, endl, endl + 1);
        std::ostringstream ss;

        ss << "Parse error in " << pathname << " at line " <<
            line << ", column " << column;
        throw std::runtime_error(ss.str());
    }
}

int main(int argc, char *argv[])
{
    if(argc < 2)
    {
	    printf("usage: %s bison-verbose.output\n", argv[0]);
	    exit(1);
    }
    try
    {
        process(argv[1]);
    }
    catch (const std::exception &e)
    {
        std::cout << e.what() << '\n';
    }
}
