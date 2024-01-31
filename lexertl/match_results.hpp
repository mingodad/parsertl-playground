// match_results.hpp
// Copyright (c) 2015-2023 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#ifndef LEXERTL_MATCH_RESULTS_HPP
#define LEXERTL_MATCH_RESULTS_HPP

#include "char_traits.hpp"
#include "enum_operator.hpp"
#include "enums.hpp"
#include <iterator>
#include <stack>
#include <string>

namespace lexertl
{
    template<typename iter, typename id_t = uint16_t,
        std::size_t flags = +feature_bit::bol | +feature_bit::eol |
        +feature_bit::skip | +feature_bit::again | +feature_bit::multi_state |
        +feature_bit::advance | +feature_bit::reject>
    struct match_results
    {
        using id_type = id_t;
        using iter_type = iter;
        using char_type = typename std::iterator_traits<iter_type>::value_type;
        using index_type = typename basic_char_traits<char_type>::index_type;
        using string = std::basic_string<char_type>;

        id_type id = 0;
        id_type user_id = npos();
        id_type fallback_id = npos();
        id_type state = 0;
        bool bol = true;
        iter_type first = iter_type();
        iter_type second = iter_type();
        iter_type eoi = iter_type();

        match_results() = default;

        match_results(const iter_type& start_, const iter_type& end_,
            const bool bol_ = true, const id_type state_ = 0) :
            state(state_),
            bol(bol_),
            first(start_),
            second(start_),
            eoi(end_)
        {
        }

        virtual ~match_results() = default;

        string str() const
        {
            return string(first, second);
        }

        string substr(const std::size_t soffset_,
            const std::size_t eoffset_) const
        {
            return string(first + soffset_, second - eoffset_);
        }

        virtual void clear()
        {
            id = 0;
            user_id = npos();
            fallback_id = npos();
            first = eoi;
            second = eoi;
            bol = true;
            state = 0;
        }

        virtual void reset(const iter_type& start_, const iter_type& end_)
        {
            id = 0;
            user_id = npos();
            fallback_id = npos();
            first = start_;
            second = start_;
            eoi = end_;
            bol = true;
            state = 0;
        }

        std::size_t length() const
        {
            return second - first;
        }

        static id_type npos()
        {
            return LEXERTL_NPOS;
        }

        static id_type skip()
        {
            return LEXERTL_SKIP;
        }

        static id_type reject()
        {
            return LEXERTL_REJECT;
        }

        bool operator ==(const match_results& rhs_) const
        {
            return id == rhs_.id &&
                user_id == rhs_.user_id &&
                fallback_id == rhs_.fallback_id &&
                first == rhs_.first &&
                second == rhs_.second &&
                eoi == rhs_.eoi &&
                bol == rhs_.bol &&
                state == rhs_.state;
        }
    };

    template<typename iter, typename id_type = uint16_t,
        std::size_t flags = +feature_bit::bol | +feature_bit::eol |
        +feature_bit::skip | +feature_bit::again | +feature_bit::multi_state |
        +feature_bit::recursive | +feature_bit::advance | +feature_bit::reject>
    struct recursive_match_results :
        public match_results<iter, id_type, flags>
    {
        using id_type_pair = std::pair<id_type, id_type>;
        std::stack<id_type_pair> stack;

        recursive_match_results() :
            match_results<iter, id_type, flags>()
        {
        }

        recursive_match_results(const iter& start_, const iter& end_,
            const bool bol_ = true, const id_type state_ = 0) :
            match_results<iter, id_type, flags>(start_, end_, bol_, state_)
        {
        }

        ~recursive_match_results() override = default;

        void clear() override
        {
            match_results<iter, id_type, flags>::clear();

            while (!stack.empty()) stack.pop();
        }

        void reset(const iter& start_, const iter& end_) override
        {
            match_results<iter, id_type, flags>::reset(start_, end_);

            while (!stack.empty()) stack.pop();
        }
    };

    using smatch = match_results<std::string::const_iterator>;
    using cmatch = match_results<const char*>;
    using wsmatch = match_results<std::wstring::const_iterator>;
    using wcmatch = match_results<const wchar_t*>;
    using u32smatch = match_results<std::u32string::const_iterator>;
    using u32cmatch = match_results<const char32_t*>;

    using srmatch =
        recursive_match_results<std::string::const_iterator>;
    using crmatch = recursive_match_results<const char*>;
    using wsrmatch =
        recursive_match_results<std::wstring::const_iterator>;
    using wcrmatch = recursive_match_results<const wchar_t*>;
    using u32srmatch =
        recursive_match_results<std::u32string::const_iterator>;
    using u32crmatch = recursive_match_results<const char32_t*>;
}

#endif
