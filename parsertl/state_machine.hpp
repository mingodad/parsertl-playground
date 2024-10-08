// state_machine.hpp
// Copyright (c) 2014-2023 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#ifndef PARSERTL_STATE_MACHINE_HPP
#define PARSERTL_STATE_MACHINE_HPP

#include <algorithm>
#include <cstdint>
#include "enums.hpp"
#include <vector>

namespace parsertl
{
    template<typename id_ty>
    struct base_state_machine
    {
        using id_type = id_ty;
        using id_type_pair = std::pair<id_type, id_type>;
        using capture_vector = std::vector<id_type_pair>;
        using capture = std::pair<std::size_t, capture_vector>;
        using captures_vector = std::vector<capture>;
        using id_type_vector = std::vector<id_type>;

        struct id_type_vector_pair
        {
            id_type _lhs = 0;
            id_type_vector _rhs;
        };

        using rules = std::vector<id_type_vector_pair>;

        std::size_t _columns = 0;
        std::size_t _rows = 0;
        rules _rules;
        captures_vector _captures;

        // If you get a compile error here you have
        // failed to define an unsigned id type.
        static_assert(std::is_unsigned<id_type>::value,
            "Your id type is signed");

        struct entry
        {
            // Qualify action to prevent compilation error
            parsertl::action action;
            id_type param;

            entry() :
                // Qualify action to prevent compilation error
                action(parsertl::action::error),
                param(static_cast<id_type>(error_type::syntax_error))
            {
            }

            // Qualify action to prevent compilation error
            entry(const parsertl::action action_, const id_type param_) :
                action(action_),
                param(param_)
            {
            }

            void clear() noexcept
            {
                // Qualify action to prevent compilation error
                action = parsertl::action::error;
                param = static_cast<id_type>(error_type::syntax_error);
            }

            bool operator ==(const entry& rhs_) const
            {
                return action == rhs_.action && param == rhs_.param;
            }
        };

        // No need to specify constructor.
        // Just in case someone wants to use a pointer to the base
        virtual ~base_state_machine() = default;

        virtual void clear() noexcept
        {
            _columns = _rows = 0;
            _rules.clear();
            _captures.clear();
        }
    };

    // Uses a vector of vectors for the state machine
    template<typename id_ty>
    struct basic_state_machine : base_state_machine<id_ty>
    {
        using base_sm = base_state_machine<id_ty>;
        using id_type = id_ty;
        using entry = typename base_sm::entry;

        struct id_type_entry_pair
        {
            id_type _id;
            entry _entry;

            id_type_entry_pair() :
                _id(0)
            {
            }

            id_type_entry_pair(const id_type id_, const entry& entry_) :
                _id(id_),
                _entry(entry_)
            {
            }
        };

        using id_type_entry_pair_vec = std::vector<id_type_entry_pair>;
        using table = std::vector<id_type_entry_pair_vec>;

        table _table;

        // No need to specify constructor.
        ~basic_state_machine() override = default;

        void clear() noexcept override
        {
            base_sm::clear();
            _table.clear();
        }

        bool empty() const
        {
            return _table.empty();
        }

        entry at(const std::size_t state_, const std::size_t token_id_) const
        {
            const auto& s_ = _table[state_];
            auto iter_ = std::find_if(s_.begin(), s_.end(),
                [token_id_](const auto& pair)
                {
                    return pair._id == token_id_;
                });

            if (iter_ == s_.end())
                return entry();
            else
                return iter_->_entry;
        }

        entry at(const std::size_t state_) const
        {
            return at(state_, 0);
        }

        const id_type_entry_pair_vec& state_at(const std::size_t state_) const
        {
            return _table[state_];
        }

        void set(const std::size_t state_, const std::size_t token_id_,
            const entry& entry_)
        {
            auto& s_ = _table[state_];
            auto iter_ = std::find_if(s_.begin(), s_.end(),
                [token_id_](const auto& pair)
                {
                    return pair._id == token_id_;
                });

            if (iter_ == s_.end())
                s_.emplace_back(static_cast<id_type>(token_id_), entry_);
            else
                iter_->_entry = entry_;
        }

        void push()
        {
            _table.resize(base_sm::_rows);
        }
    };

    // Uses uncompressed 2d array for state machine
    template<typename id_ty>
    struct basic_uncompressed_state_machine : base_state_machine<id_ty>
    {
        using base_sm = base_state_machine<id_ty>;
        using id_type = id_ty;
        using entry = typename base_sm::entry;
        using table = std::vector<entry>;

        table _table;

        // No need to specify constructor.
        ~basic_uncompressed_state_machine() override = default;

        void clear() noexcept override
        {
            base_sm::clear();
            _table.clear();
        }

        bool empty() const
        {
            return _table.empty();
        }

        entry at(const std::size_t state_) const
        {
            return _table[state_ * base_sm::_columns];
        }

        entry at(const std::size_t state_, const std::size_t token_id_) const
        {
            return _table[state_ * base_sm::_columns + token_id_];
        }

        void set(const std::size_t state_, const std::size_t token_id_,
            const entry& entry_)
        {
            _table[state_ * base_sm::_columns + token_id_] = entry_;
        }

        void push()
        {
            _table.resize(base_sm::_columns * base_sm::_rows);
        }
    };

    using state_machine = basic_state_machine<uint16_t>;
    using uncompressed_state_machine =
        basic_uncompressed_state_machine<uint16_t>;
}

#endif
