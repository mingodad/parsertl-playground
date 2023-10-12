// ebnf_tables.hpp
// Copyright (c) 2018-2023 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#ifndef PARSERTL_EBNF_TABLES_HPP
#define PARSERTL_EBNF_TABLES_HPP

#include <cstdint>
#include <vector>

namespace parsertl
{
    struct ebnf_tables
    {
        enum class yyconsts
        {
            YYFINAL = 16,
            YYLAST = 35,
            YYNTOKENS = 19,
            YYPACT_NINF = -11,
            YYTABLE_NINF = -1
        };

        enum class yytokentype
        {
            EMPTY = 258,                   /* EMPTY  */
            IDENTIFIER = 259,              /* IDENTIFIER  */
            PREC = 260,                    /* PREC  */
            TERMINAL = 261,                /* TERMINAL  */
            PRODALIAS = 262                /* PRODALIAS  */
          };

        const std::vector<uint8_t> yytranslate =
        {
               0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
              17,    18,    14,    16,     2,    15,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,    11,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     9,     2,    10,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,    12,     8,    13,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
               2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
               5,     6,     7
        };
        const std::vector<uint8_t> yyr1 =
        {
               0,    19,    20,    21,    21,    22,    23,    23,    23,    24,
              24,    25,    25,    25,    25,    25,    25,    25,    25,    25,
              26,    26,    26,    27,    27
        };
        const std::vector<uint8_t> yyr2
        {
               0,     2,     1,     1,     3,     3,     0,     1,     1,     1,
               2,     1,     1,     3,     2,     3,     2,     4,     2,     3,
               0,     2,     2,     0,     1
        };
        const std::vector<uint8_t> yydefact =
        {
               6,     7,    11,    12,     6,     6,     6,     0,     2,     3,
              20,     8,     9,     0,     0,     0,     1,     6,     0,    23,
              10,    14,    16,    18,    13,    15,    19,     4,    21,    22,
              24,     5,    17
        };
        const std::vector<int8_t> yydefgoto =
        {
               0,     7,     8,     9,    10,    11,    12,    19,    31
        };
        const std::vector<int8_t> yypact =
        {
              -3,   -11,   -11,   -11,    -3,    -3,    -3,    20,    22,   -11,
              23,    -2,     5,     3,     4,     0,   -11,    -3,    21,    19,
               5,   -11,   -11,   -11,   -11,   -10,   -11,   -11,   -11,   -11,
             -11,   -11,   -11
        };
        const std::vector<int8_t> yypgoto =
        {
             -11,   -11,    18,    12,   -11,   -11,    24,   -11,   -11
        };
        const std::vector<uint8_t> yytable =
        {
               1,     2,     2,     3,     3,    32,     4,     4,    17,     5,
               5,    17,    17,    24,     6,     6,    21,    25,    26,    22,
              16,    23,    13,    14,    15,    28,    30,    29,    18,    27,
              17,     0,     0,     0,     0,    20
        };
        const std::vector<int8_t> yycheck =
        {
               3,     4,     4,     6,     6,    15,     9,     9,     8,    12,
              12,     8,     8,    10,    17,    17,    11,    13,    18,    14,
               0,    16,     4,     5,     6,     4,     7,     6,     5,    17,
               8,    -1,    -1,    -1,    -1,    11
        };
    };
}

#endif
