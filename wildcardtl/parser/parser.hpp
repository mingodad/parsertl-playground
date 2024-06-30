// parser.hpp
// Copyright (c) 2017 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#ifndef WILDCARDTL_PARSER_HPP
#define WILDCARDTL_PARSER_HPP

#include "tree/end_node.hpp"
#include "tree/iteration_node.hpp"
#include "tree/leaf_node.hpp"
#include "tree/sequence_node.hpp"
#include "../string_token.hpp"
#include "tokeniser/tokeniser.hpp"

namespace wildcardtl
{
namespace detail
{
template<typename char_type>
class basic_parser
{
public:
    using node = basic_node<char_type>;
    using node_ptr_vector = std::vector<std::unique_ptr<node>>;

    static node *parse(const char_type * &curr_, const char_type *end_,
        node_ptr_vector &node_ptr_vector_, const bool icase_,
        const char_type zom_, const char_type any_, const char_type not_,
        const std::locale &locale_)
    {
        node *root_ = nullptr;
        typename tokeniser::string_token chars_;

        while (curr_ < end_)
        {
            typename tokeniser::e_Token eToken =
                tokeniser::next(curr_, end_, chars_, icase_, zom_, any_,
                    not_, locale_);
            node *node_ = nullptr;

            switch (eToken)
            {
            case tokeniser::e_Token::eZeroOrMore:
                node_ptr_vector_.emplace_back(std::make_unique
                    <leaf_node>(chars_));
                node_ = node_ptr_vector_.back().get();
                node_ptr_vector_.emplace_back(std::make_unique
                    <iteration_node>(node_));
                node_ = node_ptr_vector_.back().get();
                break;
            case tokeniser::e_Token::eAny:
            case tokeniser::e_Token::eCharSet:
                node_ptr_vector_.emplace_back(std::make_unique
                    <leaf_node>(chars_));
                node_ = node_ptr_vector_.back().get();
                break;
            default:
                break;
            }

            if (root_)
            {
                node *lhs_ = root_;

                node_ptr_vector_.emplace_back(std::make_unique<sequence_node>
                    (lhs_, node_));
                root_ = node_ptr_vector_.back().get();
            }
            else
            {
                root_ = node_;
            }
        }

        if (root_)
        {
            node *rhs_ = nullptr;

            node_ptr_vector_.emplace_back(std::make_unique<end_node>());
            rhs_ = node_ptr_vector_.back().get();
            node_ptr_vector_.emplace_back(std::make_unique<sequence_node>
                (root_, rhs_));
            root_ = node_ptr_vector_.back().get();
        }

        return root_;
    }

protected:
    using end_node = basic_end_node<char_type>;
    using iteration_node = basic_iteration_node<char_type>;
    using leaf_node = basic_leaf_node<char_type>;
    using sequence_node = basic_sequence_node<char_type>;
    using tokeniser = basic_tokeniser<char_type>;
};
}
}

#endif
