// nt_info.hpp
// Copyright (c) 2016-2023 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#ifndef PARSERTL_NT_INFO_HPP
#define PARSERTL_NT_INFO_HPP

#include <vector>

namespace parsertl
{

#ifdef PARSERTL_WITH_BITSET
    struct bit_set_t
    {
        typedef size_t vector_set_t;
        std::vector<vector_set_t> set_;
#define VECTOTR_SET_T_ONE ((vector_set_t)1)
#define VECTOTR_SET_T_BITS_PER_ELEMENT (sizeof(vector_set_t) * 8)
#define VECTOR_SET_T_CALC_SIZE(sz) ((sz + VECTOTR_SET_T_BITS_PER_ELEMENT -1) / VECTOTR_SET_T_BITS_PER_ELEMENT)

        bit_set_t( size_t size ):set_( VECTOR_SET_T_CALC_SIZE(size)){}
        bit_set_t( bit_set_t&& set ): set_( std::move(set.set_) ){}
        bit_set_t( const bit_set_t& set ): set_( set.set_ ){}
        size_t size() {return set_.size()*VECTOTR_SET_T_BITS_PER_ELEMENT;}
        bit_set_t& operator=( bit_set_t&& set )
        {
            if ( this != &set )
            {
                std::swap( set_, set.set_ );
            }
            return *this;
        }
        bit_set_t& operator=( const bit_set_t& set )
        {
            if ( this != &set )
            {
                set_ = set.set_;
            }
            return *this;
        }

        bool contains( size_t bit_index ) const
        {
            size_t index = bit_index / VECTOTR_SET_T_BITS_PER_ELEMENT;
            vector_set_t mask = VECTOTR_SET_T_ONE << (bit_index % VECTOTR_SET_T_BITS_PER_ELEMENT);
            return (set_[index] & mask) != 0;
        }

        bool insert( size_t bit_index )
        {
            size_t index = bit_index / VECTOTR_SET_T_BITS_PER_ELEMENT;
            vector_set_t mask = VECTOTR_SET_T_ONE << (bit_index % VECTOTR_SET_T_BITS_PER_ELEMENT);
            if ( !(set_[index] & mask) )
            {
                set_[index] |= mask;
                return true;
            }
            return false;
        }
/*
        vector_set_t& operator[](std::size_t bit_index)
        {
            size_t index = bit_index / VECTOTR_SET_T_BITS_PER_ELEMENT;
            return set_[index];
        }
*/
        const bool operator[](std::size_t bit_index) const { return contains(bit_index); }

        int set_union( const bit_set_t& set )
        {
            int added = 0;
            for ( size_t i = 0, imax = set_.size(); i < imax; ++i )
            {
                vector_set_t mask = set_[i];
                vector_set_t new_mask = mask | set.set_[i];
                if ( mask != new_mask )
                {
                    set_[i] |= new_mask;
                    ++added;
                }
            }
            return added;
        }

        void set_clear()
        {
            for ( size_t i = 0, imax = set_.size(); i < imax; ++i )
            {
                set_[i] = 0;
            }
        }
    };

    using char_vector = bit_set_t;
#else
    using char_vector = std::vector<char>;
#endif //PARSERTL_WITH_BITSET

    struct nt_info
    {
        bool _nullable = false;
        char_vector _first_set;
        char_vector _follow_set;

        explicit nt_info(const std::size_t terminals_) :
#ifdef PARSERTL_WITH_BITSET
            _first_set(terminals_),
            _follow_set(terminals_)
#else
            _first_set(terminals_, 0),
            _follow_set(terminals_, 0)
#endif
        {
        }
    };

    using nt_info_vector = std::vector<nt_info>;
}

#endif
