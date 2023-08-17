// debug.hpp
// Copyright (c) 2005-2023 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#ifndef LEXERTL_DEBUG_HPP
#define LEXERTL_DEBUG_HPP

#include <map>
#include <ostream>
#include "rules.hpp"
#include "sm_to_csm.hpp"
#include "state_machine.hpp"
#include "stream_num.hpp"
#include "string_token.hpp"
#include <vector>

namespace lexertl
{
    template<typename sm, typename char_type, typename id_type = uint16_t,
        bool is_dfa = true>
    class basic_debug
    {
    public:
        using char_state_machine =
            basic_char_state_machine<char_type, id_type, is_dfa>;
        using ostream = std::basic_ostream<char_type>;
        using rules = basic_rules<char_type, char_type, id_type>;
        using string = std::basic_string<char_type>;

        static void dumpRegex(ostream& stream_, const typename rules::token_vector& tokens)
        {
            //size_t i = 0;
            for (const auto& token : tokens) {
                //stream_ << ++i << ":" << " ";
                using tok_type = lexertl::detail::token_type;
                switch(token._type)
                {
                    case tok_type::BEGIN: ; break;
                    case tok_type::REGEX: stream_ << "REGEX "; break;
                    case tok_type::OREXP: stream_ << "OREXP "; break;
                    case tok_type::SEQUENCE: stream_ << "SEQUENCE "; break;
                    case tok_type::SUB: stream_ << "SUB "; break;
                    case tok_type::EXPRESSION: stream_ << "EXPRESSION "; break;
                    case tok_type::REPEAT: stream_ << "REPEAT "; break;
                    case tok_type::DUP: stream_ << "DUP "; break;
                    case tok_type::OR: stream_ << static_cast<char_type>('|'); break;
                    case tok_type::CHARSET: dump_charset(token._str, stream_); break;
                    case tok_type::BOL: stream_ << static_cast<char_type>('^'); break;
                    case tok_type::EOL: stream_ << static_cast<char_type>('$'); break;
                    case tok_type::MACRO: stream_ << "{MACRO}"; break;
                    case tok_type::OPENPAREN: stream_ << static_cast<char_type>('('); break;
                    case tok_type::CLOSEPAREN: stream_ << static_cast<char_type>(')'); break;
                    case tok_type::OPT: stream_ << static_cast<char_type>('?'); break;
                    case tok_type::AOPT: stream_ << static_cast<char_type>('?') <<
                                        static_cast<char_type>('?'); break;
                    case tok_type::ZEROORMORE: stream_ << static_cast<char_type>('*'); break;
                    case tok_type::AZEROORMORE: stream_ << static_cast<char_type>('*') <<
                                        static_cast<char_type>('?'); break;
                    case tok_type::ONEORMORE: stream_ << static_cast<char_type>('+'); break;
                    case tok_type::AONEORMORE: stream_ << static_cast<char_type>('+') <<
                                        static_cast<char_type>('?'); break;
                    case tok_type::REPEATN: stream_ << token._extra; break;
                    case tok_type::AREPEATN: stream_ << token._extra <<
                                        static_cast<char_type>('?'); break;
                    case tok_type::END: ; break;
                    case tok_type::DIFF: stream_ << "DIFF "; break;

                    default:
                         stream_ << " @^-_-^@ ";
                }
            }
        }

        static void dump(const rules& rules_, ostream& stream_, bool asEbnfRR = false)
        {
            if(rules_.statemap().size() > 0)
            {
                stream_ << "%x";
                for (auto it = rules_.statemap().begin(); it != rules_.statemap().end(); ++it) {
                    stream_ << " " << it->first;
                }
                stream_ << "\n";
            }

            if(rules_.macrosmap().size() > 0)
            {
                stream_ << "%%\n";
                for(const auto& [name, tokens]: rules_.macrosmap()) {
                    stream_ << name << "\t";
                    dumpRegex(stream_, tokens);
                    stream_ << "\n";
                }
                stream_ << "\n%%\n";
            }

            stream_ << "Rules.regexes = " << rules_.regexes().size() << "\n%%\n";
            if(rules_.regexes().size() > 0)
            {
                size_t i = 0;
                for(const auto& regex :  rules_.regexes())
                {
                    stream_ << "* " << ++i << "\n";
                    size_t i2 = 0;
                    for(const auto& tok_vec :  regex)
                    {
                        dumpRegex(stream_, tok_vec);
                        stream_ << "   " << ++i2 << "\n";
                    }
                }
                stream_ << "\n";
            }
        }

        static void dump(const sm& sm_, rules& rules_, ostream& stream_)
        {
            char_state_machine csm_;

            sm_to_csm(sm_, csm_);
            dump(csm_, rules_, stream_);
        }

        static void dump(const sm& sm_, ostream& stream_)
        {
            char_state_machine csm_;

            sm_to_csm(sm_, csm_);
            dump(csm_, stream_);
        }

        static void dump(const char_state_machine& csm_, rules& rules_,
            ostream& stream_)
        {
            for (std::size_t dfa_ = 0, dfas_ = csm_.size();
                dfa_ < dfas_; ++dfa_)
            {
                lexer_state(stream_);
                stream_ << rules_.state(dfa_) <<
                        "\t" << dfa_ <<
                        std::endl << std::endl;

                dump_ex(csm_._sm_vector[dfa_], stream_);
            }
        }

        static void dump(const char_state_machine& csm_, ostream& stream_)
        {
            for (std::size_t dfa_ = 0, dfas_ = csm_.size();
                dfa_ < dfas_; ++dfa_)
            {
                lexer_state(stream_);
                 stream_num<std::size_t>(dfa_, stream_);
                stream_ << std::endl << std::endl;

                dump_ex(csm_._sm_vector[dfa_], stream_);
            }
        }

    protected:
        using dfa_state = typename char_state_machine::state;
        using id_type_string_token_pair =
            typename dfa_state::id_type_string_token_pair;
        using string_token = typename dfa_state::string_token;
        using stringstream = std::basic_stringstream<char_type>;

        static void dump_ex(const typename char_state_machine::dfa& dfa_,
            ostream& stream_)
        {
            const std::size_t states_ = dfa_._states.size();
            const id_type bol_index_ = dfa_._bol_index;

            for (std::size_t i_ = 0; i_ < states_; ++i_)
            {
                const dfa_state& state_ = dfa_._states[i_];

                state(stream_);
                stream_num(i_, stream_);
                stream_ << std::endl;

                if (state_._end_state)
                {
                    end_state(stream_);

                    if (state_._push_pop_dfa ==
                        dfa_state::push_pop_dfa::push_dfa)
                    {
                        push(stream_);
                        stream_num(state_._push_dfa, stream_);
                    }
                    else if (state_._push_pop_dfa ==
                        dfa_state::push_pop_dfa::pop_dfa)
                    {
                        pop(stream_);
                    }

                    id(stream_);
                    stream_num(static_cast<std::size_t>(state_._id), stream_);
                    user_id(stream_);
                    stream_num(static_cast<std::size_t>(state_._user_id),
                        stream_);
                    dfa(stream_);
                    stream_num(static_cast<std::size_t>(state_._next_dfa),
                        stream_);
                    stream_ << std::endl;
                }

                if (i_ == 0 && bol_index_ != char_state_machine::npos())
                {
                    bol(stream_);
                    stream_num(static_cast<std::size_t>(bol_index_), stream_);
                    stream_ << std::endl;
                }

                if (state_._eol_index != char_state_machine::npos())
                {
                    eol(stream_);
                    stream_num(static_cast<std::size_t>(state_._eol_index),
                        stream_);
                    stream_ << std::endl;
                }

                for (const auto& tran_ : state_._transitions)
                    dump_transition(tran_, stream_);

                stream_ << std::endl;
            }
        }

        static void dump_transition(const id_type_string_token_pair& tran_,
            ostream& stream_)
        {
            string_token token_ = tran_.second;

            open_bracket(stream_);

            if (!tran_.second.any() && tran_.second.negatable())
            {
                token_.negate();
                negated(stream_);
            }

            string chars_;

            for (const auto& range_ : token_._ranges)
            {
                if (range_.first == static_cast<char_type>('-') ||
                    range_.first == static_cast<char_type>('^') ||
                    range_.first == static_cast<char_type>(']'))
                {
                    stream_ << static_cast<char_type>('\\');
                }

                chars_ = string_token::escape_char
                (range_.first);

                if (range_.first != range_.second)
                {
                    if (range_.first + 1 < range_.second)
                    {
                        chars_ += static_cast<char_type>('-');
                    }

                    if (range_.second == static_cast<char_type>('-') ||
                        range_.second == static_cast<char_type>('^') ||
                        range_.second == static_cast<char_type>(']'))
                    {
                        stream_ << static_cast<char_type>('\\');
                    }

                    chars_ += string_token::escape_char(range_.second);
                }

                stream_ << chars_;
            }

            close_bracket(stream_);
            stream_num(static_cast<std::size_t>(tran_.first), stream_);
            stream_ << std::endl;
        }

#define TO_OSTREAM_SOMESTR_FUNC0(func_name, stream_type, str)\
        static void func_name(std::stream_type& stream_)\
        {\
            stream_ << str;\
        }

#define TO_OSTREAM_SOMESTR_FUNC(the_func_name, the_str)\
TO_OSTREAM_SOMESTR_FUNC0(the_func_name, ostream, the_str)\
TO_OSTREAM_SOMESTR_FUNC0(the_func_name, wostream, L##the_str)\
TO_OSTREAM_SOMESTR_FUNC0(the_func_name, basic_ostream<char32_t>, U##the_str)

TO_OSTREAM_SOMESTR_FUNC(lexer_state, "Lexer state: ")
TO_OSTREAM_SOMESTR_FUNC(state, "State: ")
TO_OSTREAM_SOMESTR_FUNC(bol, "  BOL -> ")
TO_OSTREAM_SOMESTR_FUNC(eol, "  EOL -> ")
TO_OSTREAM_SOMESTR_FUNC(end_state, "  END STATE")
TO_OSTREAM_SOMESTR_FUNC(id, ", Id = ")
TO_OSTREAM_SOMESTR_FUNC(push, ", PUSH ")
TO_OSTREAM_SOMESTR_FUNC(pop, ", POP")
TO_OSTREAM_SOMESTR_FUNC(user_id, ", User Id = ")
TO_OSTREAM_SOMESTR_FUNC(open_bracket, "  [")
TO_OSTREAM_SOMESTR_FUNC(negated, "^")
TO_OSTREAM_SOMESTR_FUNC(close_bracket, "] -> ")
TO_OSTREAM_SOMESTR_FUNC(dfa, ", dfa = ")

#undef TO_OSTREAM_SOMESTR_FUNC
#undef TO_OSTREAM_SOMESTR_FUNC0
    };

    using debug = basic_debug<state_machine, char>;
    using wdebug = basic_debug<wstate_machine, wchar_t>;
    using u32debug = basic_debug<u32state_machine, char32_t>;
}

#endif
