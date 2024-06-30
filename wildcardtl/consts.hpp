// consts.hpp
// Copyright (c) 2017 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#ifndef WILDCARDTL_CONSTS_H
#define WILDCARDTL_CONSTS_H

#include "size_t.hpp"
#include <wchar.h>

namespace wildcardtl
{
    const std::size_t num_chars = 256;
    const std::size_t num_wchar_ts = WCHAR_MAX < 0x110000 ?
        WCHAR_MAX : 0x110000;
}

#endif
