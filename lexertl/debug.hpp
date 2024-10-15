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

        static void dump(rules& rules_, ostream& stream_, const typename rules::string_vector& terminals, bool noMacros=false)
        {
            const auto& statemap = rules_.statemap();
            typename rules::string_vector states(statemap.size());

            if(statemap.size() > 0)
            {
                stream_ << static_cast<char_type>('%') <<
                        static_cast<char_type>('x');
                for(size_t i=0, imax=statemap.size(); i < imax; ++i)
                {
                    for (auto it = statemap.begin(); it != statemap.end(); ++it) {
                        if(i == it->second)
                        {
                            states[i] = it->first;
                            stream_ << static_cast<char_type>(' ') << it->first;
                            break;
                        }
                    }
                }
                stream_ << std::endl;
            }
            auto macros_ = rules_.macrosmap();
            std::multimap<std::size_t, string, std::greater<>> macro_sizes_;
            auto all_regexes_ = rules_.regexes();
            const auto& all_next_dfas = rules_.next_dfas();
            const auto& all_pushes = rules_.pushes();
            const auto& all_popos = rules_.pops();
            const auto& all_ids_ = rules_.ids();

            // Prune BEGIN and END tokens
            for (auto& pair_ : macros_)
            {
                auto iter_ = pair_.second.end();

                pair_.second.erase(--iter_);
                iter_ = pair_.second.begin();
                pair_.second.erase(iter_);

                macro_sizes_.emplace(pair_.second.size(), pair_.first);
            }

            // Search for MACRO usage by token vector
            for (auto& regexes_ : all_regexes_)
            {
                for (auto& regex_ : regexes_)
                {
                    for (const auto& macro_ : macro_sizes_)
                    {
                        auto macro_iter_ = macros_.find(macro_.second);

                        if (macro_iter_ != macros_.cend())
                        {
                            auto iter_ = std::search(regex_.begin(), regex_.end(),
                                macro_iter_->second.begin(), macro_iter_->second.end());

                            while (iter_ != regex_.end())
                            {
                                token token_(detail::token_type::MACRO);

                                token_._extra = static_cast<char_type>('{') +
                                    macro_.second +
                                    static_cast<char_type>('}');
                                *iter_ = token_;

                                if (macro_.first > 1)
                                {
                                    ++iter_;
                                    regex_.erase(iter_, iter_ + (macro_.first - 1));
                                }

                                iter_ = std::search(regex_.begin(), regex_.end(),
                                    macro_iter_->second.begin(), macro_iter_->second.end());
                            }
                        }
                    }
                }
            }

            //perc_perc(stream_);
            //stream_ << std::endl;

            for (const auto& pair_ : macros_)
            {
                stream_ << pair_.first << static_cast<char_type>(' ');

                for (const auto& token_ : pair_.second)
                {
                    dump_token(token_, stream_);
                }

                stream_ << std::endl;
            }

            perc_perc(stream_);
            stream_ << std::endl;

            for (auto it = statemap.begin(); it != statemap.end(); ++it) {
                auto ids_iter_ = all_ids_[it->second].cbegin();
                stream_ << static_cast<char_type>('<') <<
                        it->first <<
                        static_cast<char_type>('>') <<
                        static_cast<char_type>(' ') <<
                        static_cast<char_type>('{');
                stream_ << std::endl;

                const auto& next_dfas = all_next_dfas[it->second];
                const auto& next_pops = all_popos[it->second];
                const auto& next_pushes = all_pushes[it->second];

                size_t regex_idx = 0;
                for (const auto& regex_ : all_regexes_[it->second])
                {
                    auto regexes_iter_ = regex_.cbegin();
                    auto regexes_end_ = regex_.cend();

                    stream_ << static_cast<char_type>(' ') <<
                        static_cast<char_type>(' ');
                    for (; regexes_iter_ != regexes_end_; ++regexes_iter_)
                    {
                        const token& tk = *regexes_iter_;
                        if (noMacros && tk._type == lexertl::detail::token_type::MACRO) {
                            const auto& mp = macros_.at(tk._extra.substr(1, tk._extra.size()-2));
                            for (const auto& token_ : mp)
                            {
                                dump_token(token_, stream_);
                            }
                        }
                        else dump_token(*regexes_iter_, stream_);
                    }
                    if(next_dfas[regex_idx] != it->second || next_pushes[regex_idx] != rules_.npos())
                    {
                        stream_ << static_cast<char_type>('<');
                        if(next_pops[regex_idx])
                        {
                            stream_ << static_cast<char_type>('<');
                        }
                        else if(next_pushes[regex_idx] != rules_.npos())
                        {
                            stream_ << static_cast<char_type>('>') <<
                                states[next_dfas[regex_idx]];
                        }
                        else
                        {
                            stream_ << states[next_dfas[regex_idx]];
                        }
                        stream_ << static_cast<char_type>('>');
                    }
                    else if(*ids_iter_ == 0)
                    {
                        stream_ << static_cast<char_type>('<')
                                << static_cast<char_type>('.')
                                << static_cast<char_type>('>');
                    }
                    if(*ids_iter_ != 0)
                    {
                        if(*ids_iter_ < terminals.size())
                        {
                            stream_ << static_cast<char_type>(' ') <<
                                    terminals[*ids_iter_];
                        }
                        else
                        {
                            if(*ids_iter_ == rules_.skip())
                            {
                                id_skip(stream_);
                            }
                            else if(*ids_iter_ == rules_.reject())
                            {
                                id_reject(stream_);
                            }
                        }
                    }
                    stream_ << std::endl;
                    ++ids_iter_;
                    ++regex_idx;
                }
                stream_ << static_cast<char_type>('}');
                stream_ << std::endl;
            }

            perc_perc(stream_);
            stream_ << std::endl;
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
                stream_ << rules_.state(dfa_) << std::endl << std::endl;

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
        using token = detail::basic_re_token<char_type, char_type>;

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
            indent(stream_);
            dump_charset(tran_.second, stream_);
            goes_to(stream_);
            stream_num(static_cast<std::size_t>(tran_.first), stream_);
            stream_ << std::endl;
        }

        static void dump_token(const token& token_, ostream& stream_)
        {
            switch (token_._type)
            {
            case lexertl::detail::token_type::OR:
                stream_ << static_cast<char_type>('|');
                break;
            case lexertl::detail::token_type::CHARSET:
                dump_charset(token_._str, stream_);
                break;
            case lexertl::detail::token_type::BOL:
                stream_ << static_cast<char_type>('^');
                break;
            case lexertl::detail::token_type::EOL:
                stream_ << static_cast<char_type>('$');
                break;
            case lexertl::detail::token_type::MACRO:
                stream_ << token_._extra;
                break;
            case lexertl::detail::token_type::OPENPAREN:
                stream_ << static_cast<char_type>('(');
                break;
            case lexertl::detail::token_type::CLOSEPAREN:
                stream_ << static_cast<char_type>(')');
                break;
            case lexertl::detail::token_type::OPT:
                stream_ << static_cast<char_type>('?');
                break;
            case lexertl::detail::token_type::AOPT:
                stream_ << static_cast<char_type>('?') <<
                    static_cast<char_type>('?');
                break;
            case lexertl::detail::token_type::ZEROORMORE:
                stream_ << static_cast<char_type>('*');
                break;
            case lexertl::detail::token_type::AZEROORMORE:
                stream_ << static_cast<char_type>('*') <<
                    static_cast<char_type>('?');
                break;
            case lexertl::detail::token_type::ONEORMORE:
                stream_ << static_cast<char_type>('+');
                break;
            case lexertl::detail::token_type::AONEORMORE:
                stream_ << static_cast<char_type>('+') <<
                    static_cast<char_type>('?');
                break;
            case lexertl::detail::token_type::REPEATN:
                stream_ << static_cast<char_type>('{') <<
                    token_._extra <<
                    static_cast<char_type>('}');
                break;
            case lexertl::detail::token_type::AREPEATN:
                stream_ << static_cast<char_type>('{') <<
                    token_._extra <<
                    static_cast<char_type>('}') <<
                    static_cast<char_type>('?');
                break;
            default:
                break;
            }
        }

        static void dump_charset(const string_token& in_token_, ostream& stream_)
        {
            string_token token_ = in_token_;

            bool needBracket = token_._ranges.size() > 1 ||
                token_._ranges.front().first != token_._ranges.front().second;
            if (needBracket)
            {
                open_bracket(stream_);
            }
            else
            {
                const auto& range_ = token_._ranges.front();
                const char_type c_ = range_.first;

                switch (c_)
                {
                case static_cast<char_type>('|'):
                case static_cast<char_type>('('):
                case static_cast<char_type>(')'):
                case static_cast<char_type>('?'):
                case static_cast<char_type>('*'):
                case static_cast<char_type>('+'):
                case static_cast<char_type>('{'):
                case static_cast<char_type>('}'):
                case static_cast<char_type>('['):
                case static_cast<char_type>(']'):
                case static_cast<char_type>('.'):
                case static_cast<char_type>('/'):
                //case static_cast<char_type>('"'):
                    stream_ << static_cast<char_type>('\\');
                    break;
                /*
                case static_cast<char_type>('\\'):
                    if(range_.first != range_.second)
                    {
                        stream_ << static_cast<char_type>('\\');
                    }
                    break;
                */
                default:
                    break;
                }
            }

            if (!token_.any() && token_.negatable())
            {
                token_.negate();
                negated(stream_);
            }

            string chars_;
#define CH_NEED_ESCAPE(x) \
                   (x == static_cast<char_type>('-') || \
                    x == static_cast<char_type>('^') || \
                    x == static_cast<char_type>('%') || \
                    x == static_cast<char_type>('$') || \
                    (needBracket && x == static_cast<char_type>('[')) || \
                    (needBracket && x == static_cast<char_type>(']')) || \
                    (!needBracket && x == static_cast<char_type>(' ')))

            for (const auto& range_ : token_._ranges)
            {
                if (CH_NEED_ESCAPE(range_.first))
                {
                    stream_ << static_cast<char_type>('\\');
                }

                chars_ = string_token::escape_char(range_.first);

                if (range_.first != range_.second)
                {
                    if (range_.first + 1 < range_.second)
                    {
                        chars_ += static_cast<char_type>('-');
                    }

                    if (CH_NEED_ESCAPE(range_.second))
                    {
                        stream_ << static_cast<char_type>('\\');
                    }

                    chars_ += string_token::escape_char(range_.second);
                }

                stream_ << chars_;
            }
#undef CH_NEED_ESCAPE

            if (needBracket)
            {
                close_bracket(stream_);
            }
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

TO_OSTREAM_SOMESTR_FUNC(perc_perc, "%%")
TO_OSTREAM_SOMESTR_FUNC(indent, " ")
TO_OSTREAM_SOMESTR_FUNC(ret, " return ")
TO_OSTREAM_SOMESTR_FUNC(goes_to, " -> ")
TO_OSTREAM_SOMESTR_FUNC(lexer_state, "Lexer state: ")
TO_OSTREAM_SOMESTR_FUNC(state, "State: ")
TO_OSTREAM_SOMESTR_FUNC(bol, "  BOL -> ")
TO_OSTREAM_SOMESTR_FUNC(eol, "  EOL -> ")
TO_OSTREAM_SOMESTR_FUNC(end_state, "  END STATE")
TO_OSTREAM_SOMESTR_FUNC(id, ", Id = ")
TO_OSTREAM_SOMESTR_FUNC(push, ", PUSH ")
TO_OSTREAM_SOMESTR_FUNC(pop, ", POP")
TO_OSTREAM_SOMESTR_FUNC(user_id, ", User Id = ")
TO_OSTREAM_SOMESTR_FUNC(open_bracket, "[")
TO_OSTREAM_SOMESTR_FUNC(negated, "^")
TO_OSTREAM_SOMESTR_FUNC(close_bracket, "]")
TO_OSTREAM_SOMESTR_FUNC(dfa, ", dfa = ")
TO_OSTREAM_SOMESTR_FUNC(id_skip, " skip()")
TO_OSTREAM_SOMESTR_FUNC(id_reject, " reject()")

#undef TO_OSTREAM_SOMESTR_FUNC
#undef TO_OSTREAM_SOMESTR_FUNC0
    };

    using debug = basic_debug<state_machine, char>;
    using wdebug = basic_debug<wstate_machine, wchar_t>;
    using u32debug = basic_debug<u32state_machine, char32_t>;
}

#endif
