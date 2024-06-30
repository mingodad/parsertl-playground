// tokeniser.hpp
// Copyright (c) 2017 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#ifndef WILDCARDTL_TOKENISER_HPP
#define WILDCARDTL_TOKENISER_HPP

#include "../../char_traits.hpp"
#include <locale>
#include "../../runtime_error.hpp"
#include "../../string_token.hpp"

namespace wildcardtl
{
namespace detail
{
template<typename char_type, typename Traits = basic_char_traits<char_type> >
class basic_tokeniser
{
public:
    enum class e_Token {eEOF, eZeroOrMore, eAny, eCharSet};

    using string_token = basic_string_token<char_type>;

    static e_Token next(const char_type * &curr_, const char_type *end_,
        string_token &chars_, const bool icase_, const char_type zom_,
        const char_type any_, const char_type not_, const std::locale &locale_)
    {
        e_Token eToken = e_Token::eCharSet;

        if (curr_ >= end_) return e_Token::eEOF;

        if (*curr_ == zom_)
        {
            chars_._charset.clear();
            chars_._negated = true;
            eToken = e_Token::eZeroOrMore;
        }
        else if (*curr_ == any_)
        {
            chars_._charset.clear();
            chars_._negated = true;
            eToken = e_Token::eAny;
        }
        else if (*curr_ == '[')
        {
            charset(curr_, end_, chars_, icase_, not_, locale_);
            chars_.remove_duplicates();
            chars_.normalise();
        }
        else
        {
            if (icase_ && (std::isupper(*curr_, locale_) ||
                std::islower(*curr_, locale_)))
            {
                const char_type upper_ = std::toupper(*curr_, locale_);
                const char_type lower_ = std::tolower(*curr_, locale_);

                chars_._charset = upper_;
                chars_._charset += lower_;
            }
            else
            {
                chars_._charset = *curr_;
            }

            chars_._negated = false;
        }

        ++curr_;
        return eToken;
    }

protected:
    static void charset(const char_type * &curr_, const char_type *end_,
        string_token &chars_, const bool icase_, const char_type not_,
        const std::locale &locale_)
    {
        char_type prev_ = 0;

        ++curr_;

        if (curr_ >= end_)
        {
            // Pointless returning index if at end of string
            throw runtime_error("Unexpected end of wildcard "
                "following '['.");
        }

        chars_._negated = *curr_ == not_;

        if (chars_._negated)
        {
            ++curr_;

            if (curr_ >= end_)
            {
                // Pointless returning index if at end of string
                throw runtime_error("Unexpected end of wildcard "
                    "following '^'.");
            }
        }

        while (*curr_ != ']')
        {
            prev_ = *curr_;
            ++curr_;

            if (curr_ >= end_)
            {
                // Pointless returning index if at end of string
                throw runtime_error("Unexpected end of wildcard "
                    "(missing ']').");
            }

            if (*curr_ == '-')
            {
                charset_range(prev_, curr_, end_, chars_, icase_, locale_);
            }
            else
            {
                if (icase_ && (std::isupper(prev_, locale_) || std::islower
                    (prev_, locale_)))
                {
                    const char_type upper_ = std::toupper(prev_, locale_);
                    const char_type lower_ = std::tolower(prev_, locale_);

                    chars_._charset += upper_;
                    chars_._charset += lower_;
                }
                else
                {
                    chars_._charset += prev_;
                }
            }
        }

        if (!chars_._negated && chars_._charset.empty())
        {
            throw runtime_error("Empty charsets not allowed.");
        }
    }

    static void charset_range(const char_type prev_, const char_type * &curr_,
        const char_type *end_, string_token &chars_, const bool icase_,
        const std::locale &locale_)
    {
        ++curr_;

        if (curr_ >= end_)
        {
            // Pointless returning index if at end of string
            throw runtime_error("Unexpected end of wildcard "
                "following '-'.");
        }

        std::size_t range_end_ =
            static_cast<typename Traits::index_type>(*curr_);

        ++curr_;

        if (curr_ >= end_)
        {
            // Pointless returning index if at end of string
            throw runtime_error("Unexpected end of wildcard "
                "(missing ']').");
        }

        std::size_t range_start_ =
            static_cast<typename Traits::index_type>(prev_);

        // Semanic check
        if (range_end_ < range_start_)
        {
            throw runtime_error("Invalid range in charset.");
        }

        chars_._charset.reserve(chars_._charset.size() +
            (range_end_ + 1 - range_start_));

        for (; range_start_ <= range_end_; ++range_start_)
        {
            const char_type ch_ = static_cast<char_type>(range_start_);

            if (icase_ && (std::isupper(ch_, locale_) ||
                std::islower(ch_, locale_)))
            {
                const char_type upper_ = std::toupper(ch_, locale_);
                const char_type lower_ = std::tolower(ch_, locale_);

                chars_._charset += upper_;
                chars_._charset += lower_;
            }
            else
            {
                chars_._charset += ch_;
            }
        }
    }
};

using tokeniser = basic_tokeniser<char>;
using wtokeniser = basic_tokeniser<wchar_t>;
}
}

#endif
