// char_traits.hpp
// Copyright (c) 2017 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#ifndef WILDCARDTL_CHAR_TRAITS_H
#define WILDCARDTL_CHAR_TRAITS_H

// Make sure wchar_t is defined
#include <string>

namespace wildcardtl
{
template<typename ch_type>
struct basic_char_traits
{
    using char_type = ch_type;
    using index_type = ch_type;

    static index_type max_val()
    {
        const uint32_t max_ = 0x10ffff;

        return sizeof(char_type) > 2 ?
            max_ : (max_ & 0xffff);
    }
};

template<>
struct basic_char_traits<char>
{
    using char_type = char;
    using index_type = unsigned char;

    static index_type max_val()
    {
        // Prevent annoying warning (VC++)
        index_type zero_ = 0;

        return ~zero_;
    }
};
}

#endif
