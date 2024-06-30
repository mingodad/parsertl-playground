// leaf_node.hpp
// Copyright (c) 2017 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#ifndef WILDCARDTL_LEAF_NODE_HPP
#define WILDCARDTL_LEAF_NODE_HPP

#include "../../consts.hpp" // null_token
#include "node.hpp"
#include "../../size_t.hpp"

namespace wildcardtl
{
namespace detail
{
template<typename char_type>
class basic_leaf_node : public basic_node<char_type>
{
public:
    using node = basic_node<char_type>;
    using bool_stack = typename node::bool_stack;
    using const_node_stack = typename node::const_node_stack;
    using node_ptr_vector = typename node::node_ptr_vector;
    using node_stack = typename node::node_stack;
    using node_vector = typename node::node_vector;
    using string_token = typename node::string_token;
    using node_type = typename node::node_type;

    basic_leaf_node(const string_token &token_) :
        node(false),
        _token(token_)
    {
        if (!node::_nullable)
        {
            node::_firstpos.push_back(this);
            node::_lastpos.push_back(this);
        }
    }

    virtual ~basic_leaf_node() override
    {
    }

    virtual void append_followpos(const node_vector &followpos_) override
    {
        _followpos.insert(_followpos.end(),
            followpos_.begin(), followpos_.end());
    }

    virtual node_type what_type() const override
    {
        return node::node_type::LEAF;
    }

    virtual bool traverse(const_node_stack &/*node_stack_*/,
        bool_stack &/*perform_op_stack_*/) const override
    {
        return false;
    }

    virtual const string_token &token() const override
    {
        return _token;
    }

    virtual const node_vector &followpos() const override
    {
        return _followpos;
    }

    virtual node_vector &followpos() override
    {
        return _followpos;
    }

private:
    string_token _token;
    node_vector _followpos;

    virtual void copy_node(node_ptr_vector &node_ptr_vector_,
        node_stack &new_node_stack_, bool_stack &/*perform_op_stack_*/,
        bool &/*down_*/) const override
    {
        node_ptr_vector_.emplace_back(std::make_unique<basic_leaf_node>
            (_token));
        new_node_stack_.push(node_ptr_vector_.back().get());
    }

    // No copy construction.
    basic_leaf_node(const basic_leaf_node &) = delete;
    // No assignment.
    const basic_leaf_node &operator =(const basic_leaf_node &) = delete;
};
}
}

#endif
