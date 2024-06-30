// equivset.hpp
// Copyright (c) 2017 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#ifndef WILDCARDTL_EQUIVSET_HPP
#define WILDCARDTL_EQUIVSET_HPP

#include <algorithm>
#include "../parser/tree/node.hpp"
#include <set>
#include "../size_t.hpp"
#include "../string_token.hpp"

namespace wildcardtl
{
namespace detail
{
template<typename char_type>
struct basic_equivset
{
    using node = basic_node<char_type>;
    using node_set = std::set<node>;
    // Not owner of nodes:
    using node_vector = std::vector<node *>;
    using string_token = basic_string_token<char_type>;

    string_token _token;
    node_vector _followpos;

    basic_equivset()
    {
    }

    basic_equivset(const string_token &token_, const node_vector &followpos_) :
        _token(token_),
        _followpos(followpos_)
    {
    }

    bool empty() const
    {
        return _token.empty() && _followpos.empty();
    }

    void intersect(basic_equivset &rhs_, basic_equivset &overlap_)
    {
        _token.intersect(rhs_._token, overlap_._token);

        if (!overlap_._token.empty())
        {
            overlap_._followpos = _followpos;

            auto overlap_begin_ = overlap_._followpos.cbegin();
            auto overlap_end_ = overlap_._followpos.cend();

            for (node *node_ : rhs_._followpos)
            {
                if (std::find(overlap_begin_, overlap_end_, node_) ==
                    overlap_end_)
                {
                    overlap_._followpos.push_back(node_);
                    overlap_begin_ = overlap_._followpos.begin();
                    overlap_end_ = overlap_._followpos.end();
                }
            }

            if (_token.empty())
            {
                _followpos.clear();
            }

            if (rhs_._token.empty())
            {
                rhs_._followpos.clear();
            }
        }
    }
};
}
}

#endif
