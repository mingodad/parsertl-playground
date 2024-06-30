// end_node.hpp
// Copyright (c) 2017 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#ifndef WILDCARDTL_END_NODE_HPP
#define WILDCARDTL_END_NODE_HPP

#include "node.hpp"
#include "../../size_t.hpp"

namespace wildcardtl
{
namespace detail
{
template<typename char_type>
class basic_end_node : public basic_node<char_type>
{
public:
    using node = basic_node<char_type>;
    using bool_stack = typename node::bool_stack;
    using const_node_stack = typename node::const_node_stack;
    using node_ptr_vector = typename node::node_ptr_vector;
    using node_stack = typename node::node_stack;
    using node_vector = typename node::node_vector;
    using node_type = typename node::node_type;

    basic_end_node() :
        node(false)
    {
        node::_firstpos.push_back(this);
        node::_lastpos.push_back(this);
    }

    virtual ~basic_end_node() override
    {
    }

    virtual node_type what_type() const override
    {
        return node::node_type::END;
    }

    virtual bool traverse(const_node_stack &/*node_stack_*/,
        bool_stack &/*perform_op_stack_*/) const override
    {
        return false;
    }

    virtual const node_vector &followpos() const override
    {
        // _followpos is always empty..!
        return _followpos;
    }

    virtual bool end_state() const override
    {
        return true;
    }

private:
    node_vector _followpos;

    virtual void copy_node(node_ptr_vector &/*node_ptr_vector_*/,
        node_stack &/*new_node_stack_*/, bool_stack &/*perform_op_stack_*/,
        bool &/*down_*/) const override
    {
        // Nothing to do, as end_nodes are not copied.
    }

    // No copy construction.
    basic_end_node(const basic_end_node &) = delete;
    // No assignment.
    const basic_end_node &operator =(const basic_end_node &) = delete;
};
}
}

#endif
