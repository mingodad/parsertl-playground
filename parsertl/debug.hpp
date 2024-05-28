// debug.hpp
// Copyright (c) 2014-2023 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#ifndef PARSERTL_DEBUG_HPP
#define PARSERTL_DEBUG_HPP

#include "dfa.hpp"
#include <ostream>
#include "rules.hpp"

namespace parsertl
{
    template<typename char_type>
    class basic_debug
    {
    public:
        using rules = basic_rules<char_type>;
        using ostream = std::basic_ostream<char_type>;

        static void dump(const rules& rules_, ostream& stream_,
                bool asEbnfRR = false, bool withIndex=false)
        {
            const std::size_t start_ = rules_.start();
            const production_vector& grammar_ = rules_.grammar();
            const token_info_vector& tokens_info_ = rules_.tokens_info();
            const std::size_t terminals_ = tokens_info_.size();
            string_vector symbols_;
            std::set<std::size_t> seen_;
            token_map map_;

            rules_.symbols(symbols_);

            if(asEbnfRR)
            {
                stream_ <<  "//\n"
                            "// EBNF to be viewd at\n"
                            "//    (IPV6) https://www.bottlecaps.de/rr/ui\n"
                            "//    (IPV4) https://rr.red-dove.com/ui\n"
                            "//\n"
                            "// Copy and paste this at one of the urls shown above in the 'Edit Grammar' tab\n"
                            "// then click the 'View Diagram' tab.\n"
                            "//\n\n";
            }
            else
            {
                // Skip EOI token
                for (std::size_t idx_ = 1, size_ = tokens_info_.size();
                    idx_ < size_; ++idx_)
                {
                    const token_info& token_info_ = tokens_info_[idx_];
                    token_prec_assoc info_(token_info_._precedence,
                        token_info_._associativity);
                    auto map_iter_ = map_.find(info_);

                    if (map_iter_ == map_.end())
                    {
                        map_.insert(token_pair(info_, symbols_[idx_]));
                    }
                    else
                    {
                        map_iter_->second += static_cast<char_type>(' ');
                        map_iter_->second += symbols_[idx_];
                    }
                }

                for (const auto& pair_ : map_)
                {
                    switch (pair_.first.second)
                    {
                    case rules::associativity::token_assoc:
                        token(stream_);
                        break;
                    case rules::associativity::precedence_assoc:
                        precedence(stream_);
                        break;
                    case rules::associativity::non_assoc:
                        nonassoc(stream_);
                        break;
                    case rules::associativity::left_assoc:
                        left(stream_);
                        break;
                    case rules::associativity::right_assoc:
                        right(stream_);
                        break;
                    default:
                        break;
                    }

                    stream_ << pair_.second << static_cast<char_type>('\n');
                }

                if (start_ != static_cast<std::size_t>(~0))
                {
                    stream_ << static_cast<char_type>('\n');
                    start(stream_);
                    stream_ << symbols_[terminals_ + start_] <<
                        static_cast<char_type>('\n') <<
                        static_cast<char_type>('\n');
                }

                stream_ << static_cast<char_type>('%') <<
                    static_cast<char_type>('%') <<
                    static_cast<char_type>('\n') <<
                    static_cast<char_type>('\n');
            }

            dump_grammar(grammar_, seen_, symbols_, terminals_, stream_,
                    asEbnfRR, withIndex);
            if(!asEbnfRR)
            {
                stream_ << static_cast<char_type>('%') <<
                    static_cast<char_type>('%') <<
                    static_cast<char_type>('\n');
            }
        }

        static void dumpSql(const rules& rules_, ostream& stream_)
        {
            const std::size_t start_ = rules_.start();
            const production_vector& grammar_ = rules_.grammar();
            const token_info_vector& tokens_info_ = rules_.tokens_info();
            const std::size_t terminals_ = tokens_info_.size();
            string_vector symbols_;
            std::set<std::size_t> seen_;
            token_map map_;
            bool hasRecords;

            rules_.symbols(symbols_);

            stream_ <<
                "\nBEGIN TRANSACTION;"
                "\nCREATE TABLE symbol(\n"
                "  id INTEGER PRIMARY KEY,\n"
                "  name TEXT NOT NULL,\n"
                "  isTerminal BOOLEAN NOT NULL,\n"
                "  fallback INTEGER REFERENCES symbol DEFERRABLE INITIALLY DEFERRED\n"
                ");\n";

            int last_id = 0;
            hasRecords = false;
            for(const auto &terminal : rules_.terminals())
            {
                if(terminal.second > 0) //skip EOI
                {
                    if(!hasRecords) {
                        hasRecords = true;
                        stream_ << "\nINSERT INTO symbol(id, name, isTerminal, fallback) VALUES\n";
                    }
                    if(last_id)
                    {
                        stream_ << "\n,";
                    }
                    last_id = terminal.second;
                    const token_info& token_info_ = tokens_info_[last_id];
                    stream_ << "(" << last_id << ",'";
                    for(const auto ch : terminal.first){
                        if(ch == '\'') stream_ << "''";
                        else stream_ << ch;
                    }
                    stream_ << "',1,";
                    if(token_info_._fallback)
                    {
                        stream_ << token_info_._fallback;
                    }
                    else
                    {
                        stream_ << "NULL";
                    }
                    stream_ << ")";
                }
            }
            if(hasRecords) stream_ << ";\n\n";

            last_id = 0;
            hasRecords = false;
            for(const auto &non_terminal : rules_.non_terminals())
            {
                if(!hasRecords) {
                    hasRecords = true;
                    stream_ << "\nINSERT INTO symbol(id, name, isTerminal) VALUES\n";
                }
                if(last_id)
                {
                    stream_ << "\n,";
                }
                last_id = terminals_ + non_terminal.second;
                stream_ << "(" << last_id << ",'"<< non_terminal.first << "',0)";
            }
            if(hasRecords) stream_ << ";\n\n";

            stream_ << "\nCREATE TABLE precedence(\n"
                "  id INTEGER PRIMARY KEY REFERENCES symbol DEFERRABLE INITIALLY DEFERRED,\n"
                "  prec INTEGER NOT NULL,\n"
                "  assoc CHAR NOT NULL CHECK(assoc IN('L','R','N','P'))\n"
                ");\n";

            // Skip EOI token
            hasRecords = false;
            for (std::size_t idx_ = 1, size_ = tokens_info_.size();
                idx_ < size_; ++idx_)
            {
                const token_info& token_info_ = tokens_info_[idx_];
                if(token_info_._associativity != rules::associativity::token_assoc)
                {
                    if(!hasRecords) {
                        hasRecords = true;
                        stream_ << "\nINSERT INTO precedence(id,prec,assoc) VALUES\n";
                    }
                    else
                    {
                        stream_ << "\n,";
                    }
                    stream_ << "(" << idx_ << "," << token_info_._precedence << ",";
                    switch(token_info_._associativity)
                    {
                        case rules::associativity::precedence_assoc:
                            stream_ << "'P'";
                            break;
                        case rules::associativity::non_assoc:
                            stream_ << "'N'";
                            break;
                        case rules::associativity::left_assoc:
                            stream_ << "'L'";
                            break;
                        case rules::associativity::right_assoc:
                            stream_ << "'R'";
                            break;
                        default:
                            stream_ << "'Unknown'";
                            break;
                    }
                    stream_ << ")";
                }
            }
            if(hasRecords) stream_ << ";\n\n";

            stream_ << "\nCREATE TABLE rule(\n"
                "  ruleid INTEGER PRIMARY KEY,\n"
                "  lhs INTEGER REFERENCES symbol(id),\n"
                "  prec_id INTEGER REFERENCES symbol(id)\n"
                ");\n";


            int last_idx = 0;
            hasRecords = false;
            for (auto iter_ = grammar_.cbegin(), end_ = grammar_.cend();
                iter_ != end_; ++iter_)
            {
                auto lhs_iter_ = iter_;
                prod_size_t index_ = lhs_iter_ - grammar_.begin();
                auto lhs_id = terminals_ + lhs_iter_->_lhs;

                if(!hasRecords) {
                    hasRecords = true;
                    stream_ << "\nINSERT INTO rule(ruleid,lhs,prec_id) VALUES\n";
                }
                if(last_idx++)
                {
                    stream_ << "\n,";
                }
                stream_ << "(" << index_ << "," << lhs_id << ",";
                if (iter_->_ctx_precedence_id > 0)
                {
                    stream_ << iter_->_ctx_precedence_id;
                }
                else
                {
                    stream_ << "NULL";
                }
                stream_ << ")";
            }
            if(hasRecords) stream_ << ";\n\n";

            stream_ << "CREATE TABLE directives(\n"
                "  id INTEGER PRIMARY KEY CHECK(id = 1),\n"
                "  stack_size TEXT,\n"
                "  start_symbol INTEGER REFERENCES symbol,\n"
                "  wildcard INTEGER REFERENCES symbol\n"
                ");\n";

            stream_ << "INSERT INTO directives(id) values(1);\n";
            stream_ << "UPDATE directives SET start_symbol=" << (terminals_ + start_) << ";\n";
            //stream_ << "UPDATE directives SET wildcard=101;\n";

            stream_ << "\nCREATE TABLE rulerhs(\n"
                "  id INTEGER PRIMARY KEY,  ruleid INTEGER REFERENCES rule(ruleid),\n"
                "  pos INTEGER,\n"
                "  sym INTEGER REFERENCES symbol(id)\n"
                ");\n";

            last_idx = 0;
            hasRecords = false;
            for (auto iter_ = grammar_.cbegin(), end_ = grammar_.cend();
                iter_ != end_; ++iter_)
            {
                auto lhs_iter_ = iter_;
                prod_size_t index_ = lhs_iter_ - grammar_.begin();

                int lhs_pos = 0;
                if(!hasRecords) {
                    hasRecords = true;
                    stream_ << "\nINSERT INTO rulerhs(ruleid,pos,sym) VALUES\n";
                }
                if (lhs_iter_->_rhs._symbols.empty())
                {
                    if(last_idx++)
                    {
                        stream_ << "\n,";
                    }
                    stream_ << "(" << index_ << "," << lhs_pos++ << ",NULL)";
                }
                else
                {
                    auto rhs_iter_ = lhs_iter_->_rhs._symbols.cbegin();
                    auto rhs_end_ = lhs_iter_->_rhs._symbols.cend();

                    for (; rhs_iter_ != rhs_end_; ++rhs_iter_)
                    {
                        const std::size_t id_ =
                            rhs_iter_->_type == symbol::type::TERMINAL ?
                            rhs_iter_->_id :
                            terminals_ + rhs_iter_->_id;

                        // Don't dump '$'
                        if (id_ > 0)
                        {
                            if(last_idx++)
                            {
                                stream_ << "\n,";
                            }
                            stream_ << "(" << index_ << "," << lhs_pos++ << "," << id_ << ")";
                        }
                    }
                }
            }
            if(hasRecords) stream_ << ";\n\n";
            stream_ <<
                "CREATE VIEW rule_rhs_terminal_view AS\n"
                "SELECT rr.ruleid, pos, group_concat(rs.name, '|') as name\n"
                "FROM rulerhs AS rr LEFT JOIN symbol AS rs\n"
                "  ON rr.sym=rs.id\n"
                "GROUP BY ruleid, pos;\n"
                "CREATE VIEW rule_view AS\n"
                "SELECT srule || (case when lhs <> lhs2 then '\n"
                "' else '' end) FROM (\n"
                "  SELECT s.name || ' ::= ' || ifnull((\n"
                "    SELECT group_concat(rs.name, ' ')\n"
                "    FROM rule_rhs_terminal_view AS rs\n"
                "    WHERE rs.ruleid=r.ruleid\n"
                "    ORDER BY rs.pos), '/*empty*/') || ' .'\n"
                "      || ifnull((' [' || sp.name || ']'), '') as srule,\n"
                "    r.lhs, lead(r.lhs) OVER(ORDER BY r.ruleid) AS lhs2\n"
                "  FROM rule AS r\n"
                "    LEFT JOIN symbol AS s ON r.lhs=s.id\n"
                "    LEFT JOIN symbol AS sp ON r.prec_id=sp.id\n"
                "  ORDER BY r.ruleid\n"
                ") t;\n"
                "CREATE VIEW token_view AS\n"
                "SELECT ('%token ' || '\n"
                "  ' || group_concat(name || (CASE WHEN (cnt % 6) = 0 THEN '\n"
                "  ' ELSE ' ' END), '') || ' .\n"
                "  ') AS val FROM (\n"
                "  SELECT row_number() OVER (ORDER BY s.id) AS cnt, s.name\n"
                "  FROM symbol AS s WHERE isTerminal=TRUE\n"
                "  ORDER BY id\n"
                ") t;\n"
                "CREATE VIEW fallback_view AS\n"
                "SELECT ('%fallback ' || fb || '\n"
                "  ' || group_concat(name || (CASE WHEN (cnt % 6) = 0 THEN '\n"
                "  ' ELSE ' ' END), '') || ' .\n"
                "  ') AS val FROM (\n"
                "  SELECT sf.name AS fb, row_number() OVER (ORDER BY s.id) AS cnt, s.name\n"
                "  FROM symbol s JOIN symbol sf ON s.fallback = sf.id\n"
                ") t;\n"
                "CREATE VIEW prec_view AS\n"
                "WITH prec(id, name) AS (VALUES('L','%left'),('R','%right'),('N','%nonassoc'),('P','%precedence'))\n"
                "SELECT prec.name || ' ' || group_concat(s.name, ' ') || ' .'\n"
                "FROM precedence AS p\n"
                "	LEFT JOIN prec ON p.assoc=prec.id\n"
                "	LEFT JOIN symbol AS s on p.id=s.id\n"
                "GROUP BY p.prec\n"
                "ORDER BY p.prec;\n"
                "CREATE VIEW grammar_view AS\n"
                "SELECT * FROM token_view\n"
                "UNION ALL\n"
                "SELECT * FROM fallback_view\n"
                "UNION ALL\n"
                "SELECT * FROM prec_view\n"
                "UNION ALL\n"
                "SELECT '\n"
                "%stack_size ' || stack_size || ' .\n"
                "'\n"
                "FROM directives\n"
                "UNION ALL\n"
                "SELECT '\n"
                "%wildcard ' || s.name || ' .\n"
                "'\n"
                "FROM directives AS d join symbol AS s ON d.wildcard=s.id\n"
                "UNION ALL\n"
                "SELECT '\n"
                "%start_symbol ' || s.name || '\n"
                "'\n"
                "FROM directives AS d join symbol AS s ON d.start_symbol=s.id\n"
                "UNION ALL\n"
                "SELECT * FROM rule_view;\n"
                "COMMIT;\n"
                "select * from grammar_view;\n"
                ;
        }

        static void dump(const rules& rules_, const dfa& dfa_, ostream& stream_,
                bool withIndex=false)
        {
            const production_vector& grammar_ = rules_.grammar();
            const std::size_t terminals_ = rules_.tokens_info().size();
            string_vector symbols_;

            rules_.symbols(symbols_);

            dump(rules_, stream_, false, true);

            for (std::size_t idx_ = 0, dfa_size_ = dfa_.size();
                idx_ < dfa_size_; ++idx_)
            {
                const dfa_state& state_ = dfa_[idx_];
                const cursor_vector& config_ = state_._closure;

                state(idx_, stream_);

                for (const auto& pair_ : config_)
                {
                    const production& p_ = grammar_[pair_._id];
                    std::size_t j_ = 0;

                    stream_ << static_cast<char_type>('(') <<
                        pair_._id <<
                        static_cast<char_type>(')') <<
                        static_cast<char_type>(' ') <<
                        static_cast<char_type>(' ') <<
                        symbols_[terminals_ + p_._lhs] <<
                        static_cast<char_type>(' ') <<
                        static_cast<char_type>(':');
                    dump_rhs(j_, p_, terminals_, pair_, symbols_, stream_);

                    if (j_ == pair_._index)
                    {
                        stream_ << static_cast<char_type>(' ') <<
                            static_cast<char_type>('.');
                    }

                    stream_ << static_cast<char_type>('\n');
                }

                if (!state_._transitions.empty())
                    stream_ << static_cast<char_type>('\n');

                for (const auto& pair_ : state_._transitions)
                {
                    stream_ << static_cast<char_type>(' ') <<
                        static_cast<char_type>(' ') <<
                        symbols_[pair_._id] <<
                        static_cast<char_type>(' ') <<
                        static_cast<char_type>('-') <<
                        static_cast<char_type>('>') <<
                        static_cast<char_type>(' ') << pair_._index <<
                        static_cast<char_type>('\n');
                }

                stream_ << static_cast<char_type>('\n');
            }
        }

        static void dumpSql(const rules& rules_, const dfa& dfa_, ostream& stream_)
        {
            string_vector symbols_;
            rules_.symbols(symbols_);
            dumpSql(rules_, stream_);
        }

    private:
        using production = typename rules::production;
        using production_vector = typename rules::production_vector;
        using string = std::basic_string<char_type>;
        using string_vector = typename rules::string_vector;
        using symbol = typename rules::symbol;
        using token_prec_assoc =
            std::pair<std::size_t, typename rules::associativity>;
        using token_info = typename rules::token_info;
        using token_info_vector = typename rules::token_info_vector;
        using token_map = std::map<token_prec_assoc, string>;
        using token_pair = std::pair<token_prec_assoc, string>;

        static void dump_grammar(const production_vector& grammar_,
            std::set<std::size_t>& seen_, const string_vector& symbols_,
            const std::size_t terminals_, ostream& stream_,
            bool asEbnfRR = false, bool withIndex=false)
        {
            for (auto iter_ = grammar_.cbegin(), end_ = grammar_.cend();
                iter_ != end_; ++iter_)
            {
                if (seen_.find(iter_->_lhs) == seen_.end())
                {
                    auto lhs_iter_ = iter_;
                    prod_size_t index_ = lhs_iter_ - grammar_.begin();

                    const auto& lhs_name = symbols_[terminals_ + lhs_iter_->_lhs];
                    //if(lhs_name[0] == '$') continue; //skip $accept
                    stream_ << lhs_name;
                    if(asEbnfRR)
                    {
                        stream_ << static_cast<char_type>(':') <<
                            static_cast<char_type>(':') <<
                            static_cast<char_type>('=');
                    }
                    else
                    {
                        stream_ << static_cast<char_type>(':');
                    }

                    stream_ << static_cast<char_type>('\n');
                    if(withIndex) {
                        stream_ << static_cast<char_type>('(') <<
                            index_ <<
                            static_cast<char_type>(')');
                    }
                    stream_ << static_cast<char_type>('\t') <<
                        static_cast<char_type>(' ');

                    while (index_ != static_cast<prod_size_t>(~0))
                        dump_production(grammar_, lhs_iter_, symbols_,
                            terminals_, index_, stream_, asEbnfRR, withIndex);

                    seen_.insert(iter_->_lhs);
                    if(!asEbnfRR)
                    {
                        stream_ << static_cast<char_type>('\n') <<
                            static_cast<char_type>('\t') <<
                            static_cast<char_type>(';');
                    }
                    stream_ << static_cast<char_type>('\n') <<
                        static_cast<char_type>('\n');
                }
            }
        }

        static void dump_production(const production_vector& grammar_,
            typename production_vector::const_iterator& lhs_iter_,
            const string_vector& symbols_, const std::size_t terminals_,
            prod_size_t& index_, ostream& stream_, bool asEbnfRR = false,
            bool withIndex=false)
        {
            if (lhs_iter_->_rhs._symbols.empty())
            {
                stream_ << static_cast<char_type>(' ');
                empty(stream_, asEbnfRR);
            }
            else
            {
                auto rhs_iter_ = lhs_iter_->_rhs._symbols.cbegin();
                auto rhs_end_ = lhs_iter_->_rhs._symbols.cend();

                for (; rhs_iter_ != rhs_end_; ++rhs_iter_)
                {
                    const std::size_t id_ =
                        rhs_iter_->_type == symbol::type::TERMINAL ?
                        rhs_iter_->_id :
                        terminals_ + rhs_iter_->_id;

                    // Don't dump '$'
                    if (id_ > 0)
                    {
                        const std::string &sym = symbols_[id_];
                        stream_ << static_cast<char_type>(' ') <<
                            (sym == "'\n'" ? "'\\n'" : sym);
                    }
                }
            }

            if (!asEbnfRR && lhs_iter_->_ctx_precedence_id > 0)
            {
                stream_ << static_cast<char_type>(' ');
                prec(stream_);
                stream_ << symbols_[lhs_iter_->_ctx_precedence_id];
            }

            index_ = lhs_iter_->_next_lhs;

            if (index_ != static_cast<prod_size_t>(~0))
            {
                //const string& lhs_ =
                //    symbols_[terminals_ + lhs_iter_->_lhs];

                lhs_iter_ = grammar_.cbegin() + index_;
                stream_ << static_cast<char_type>('\n');
                if(withIndex) {
                    stream_ << static_cast<char_type>('(') <<
                        index_ <<
                        static_cast<char_type>(')');
                }

                stream_ << static_cast<char_type>('\t') <<
                    static_cast<char_type>('|');
            }
        }

        static void dump_rhs(std::size_t& j_, const production& p_,
            const std::size_t terminals_, const cursor& pair_,
            const string_vector& symbols_, ostream& stream_)
        {
            for (; j_ < p_._rhs._symbols.size(); ++j_)
            {
                const symbol& symbol_ = p_._rhs._symbols[j_];
                const std::size_t id_ = symbol_._type ==
                    symbol::type::TERMINAL ? symbol_._id :
                    terminals_ + symbol_._id;

                if (j_ == pair_._index)
                {
                    stream_ << static_cast<char_type>(' ') <<
                        static_cast<char_type>('.');
                }

                stream_ << static_cast<char_type>(' ') <<
                    symbols_[id_];
            }
        }


#define TO_OSTREAM_EMPTY(stream_type, strpfx) \
        static void empty(std::stream_type& stream_, bool asEbnfRR = false) \
        {\
            if(asEbnfRR) stream_ << strpfx##"/*%empty*/";\
            else stream_ << strpfx##"%empty";\
        }

        TO_OSTREAM_EMPTY(ostream, )
        TO_OSTREAM_EMPTY(wostream, L)
        TO_OSTREAM_EMPTY(basic_ostream<char32_t>, U)
#undef TO_OSTREAM_EMPTY

#define TO_OSTREAM_SOMESTR_FUNC0(func_name, stream_type, str)\
        static void func_name(std::stream_type& stream_)\
        {\
            stream_ << str;\
        }

#define TO_OSTREAM_SOMESTR_FUNC(the_func_name, the_str)\
TO_OSTREAM_SOMESTR_FUNC0(the_func_name, ostream, the_str)\
TO_OSTREAM_SOMESTR_FUNC0(the_func_name, wostream, L##the_str)\
TO_OSTREAM_SOMESTR_FUNC0(the_func_name, basic_ostream<char32_t>, U##the_str)

TO_OSTREAM_SOMESTR_FUNC(left, "%left ")
TO_OSTREAM_SOMESTR_FUNC(nonassoc, "%nonassoc ")
TO_OSTREAM_SOMESTR_FUNC(prec, "%prec ")
TO_OSTREAM_SOMESTR_FUNC(precedence, "%precedence ")
TO_OSTREAM_SOMESTR_FUNC(right, "%right ")
TO_OSTREAM_SOMESTR_FUNC(start, "%start ")
TO_OSTREAM_SOMESTR_FUNC(token, "%token ")

#undef TO_OSTREAM_SOMESTR_FUNC
#undef TO_OSTREAM_SOMESTR_FUNC0

        static void state(const std::size_t row_, std::ostream& stream_)
        {
            stream_ << "state " << row_ << "\n\n";
        }

        static void state(const std::size_t row_, std::wostream& stream_)
        {
            stream_ << L"state " << row_ << L"\n\n";
        }

        static void state(const std::size_t row_,
            std::basic_ostream<char32_t>& stream_)
        {
            stream_ << U"state " << row_ << U"\n\n";
        }

    };

    using debug = basic_debug<char>;
    using wdebug = basic_debug<wchar_t>;
    using u32debug = basic_debug<char32_t>;
}

#endif
