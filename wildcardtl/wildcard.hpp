// wildcard.hpp
// Copyright (c) 2017 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#ifndef WILDCARD_HPP
#define WILDCARD_HPP

#include <deque>
#include "partition/equivset.hpp"
#include <list>
#include <locale>
#include <memory>
#include "parser/tree/node.hpp"
#include "parser/parser.hpp"
#include <set>
#include "string_token.hpp"

namespace wildcardtl
{
const std::size_t npos = static_cast<std::size_t>(~0);

template<typename char_type>
class basic_wildcard
{
public:
    using string = std::basic_string<char_type>;

    basic_wildcard()
    {
    }

    ~basic_wildcard()
    {
    }

    basic_wildcard(const char_type* first_, const char_type* second_,
        const bool icase_, const char_type zom_ = '*',
        const char_type any_ = '?', const char_type not_ = '!') :
        _zom(zom_),
        _any(any_),
        _not(not_)
    {
        build(first_, second_, icase_);
    }

    basic_wildcard(const string& pattern_, const bool icase_,
        const char_type zom_ = '*', const char_type any_ = '?',
        const char_type not_ = '!') :
        basic_wildcard(pattern_.c_str(), pattern_.c_str() + pattern_.size(),
            icase_, zom_, any_, not_)
    {
    }

    void assign(const char_type* first_, const char_type* second_,
        const bool icase_, const char_type zom_ = '*',
        const char_type any_ = '?', const char_type not_ = '!')
    {
        clear();
        _zom = zom_;
        _any = any_;
        _not = not_;
        build(first_, second_, icase_);
    }

    void assign(const string &pattern_, const bool icase_,
        const char_type zom_ = '*', const char_type any_ = '?',
        const char_type not_ = '!')
    {
        clear();
        _zom = zom_;
        _any = any_;
        _not = not_;
        build(pattern_.c_str(), pattern_.c_str() + pattern_.size(), icase_);
    }

    void locale(const std::locale &locale_)
    {
        _locale = locale_;
    }

    void clear()
    {
        _dfa.clear();
        _zom = '*';
        _any = '?';
        _not = '!';
        _negated = false;
    }

    bool empty() const
    {
        return _dfa.empty();
    }

    bool match(const string &str_) const
    {
        const char_type *first_ = str_.c_str();
        const char_type *second_ = first_ + str_.size();

        return match(first_, second_);
    }

    bool match(const char_type* first_, const char_type* second_) const
    {
        bool match_ = true;
        std::size_t state_ = 0;

        for (; first_ < second_; ++first_)
        {
            if (!_dfa[state_].match(*first_, state_))
            {
                match_ = false;
                break;
            }
        }

        if (match_)
        {
            match_ = _dfa[state_]._end;
        }

        if (_negated)
            match_ ^= true;

        return match_;
    }

protected:
    using equivset = detail::basic_equivset<char_type>;
    using equivset_list = std::list<std::unique_ptr<equivset>>;
    using equivset_ptr = std::unique_ptr<equivset>;
    using node = detail::basic_node<char_type>;
    using node_set = std::set<const node *>;
    using node_set_vector = std::vector<std::unique_ptr<node_set>>;
    using node_vector = std::vector<const node *>;
    using node_vector_vector = std::vector<std::unique_ptr<node_vector>>;
    using parser = detail::basic_parser<char_type>;
    using size_t_vector = std::vector<size_t>;
    using string_token = basic_string_token<char_type>;
    using token_list = std::list<std::unique_ptr<string_token>>;
    using token_ptr = std::unique_ptr<string_token>;

    char_type _zom = '*';
    char_type _any = '?';
    char_type _not = '!';
    bool _negated = false;
    std::locale _locale;

    struct transition
    {
        string_token _chars;
        std::size_t _next;

        transition(const string_token &chars_, const std::size_t next_) :
            _chars(chars_),
            _next(next_)
        {
        }

        bool match(const char_type c_, std::size_t &next_) const
        {
            bool match_ = false;

            match_ = _chars._charset.find(c_) != string_token::string::npos;
            match_ ^= _chars._negated;

            if (match_)
            {
                next_ = _next;
            }

            return match_;
        }
    };

    struct state
    {
        using transition_deque = std::deque<transition>;

        bool _end;
        transition_deque _transitions;

        state() :
            _end(false)
        {
        }

        bool match(const char_type c_, std::size_t &next_) const
        {
            bool match_ = false;
            auto iter_ = _transitions.cbegin();
            auto end_ = _transitions.cend();

            for (; iter_ != end_; ++iter_)
            {
                if (iter_->match(c_, next_))
                {
                    match_ = true;
                    break;
                }
            }

            return match_;
        }
    };

    using state_vector = std::vector<state>;

    state_vector _dfa;

    void build(const char_type *curr_, const char_type *end_, const bool icase_)
    {
        if (curr_ != end_)
        {
            if (*curr_ == '!')
            {
                _negated = true;
                ++curr_;
            }
        }

        typename parser::node_ptr_vector node_ptr_vector_;
        node *root_ = parser::parse(curr_, end_, node_ptr_vector_, icase_,
            _zom, _any, _not, _locale);
        const typename node::node_vector *followpos_ = root_ ?
            &root_->firstpos() : nullptr;
        node_set_vector seen_sets_;
        size_t_vector hash_vector_;

        if (root_ == nullptr)
        {
            state state_;

            state_._end = true;
            _dfa.push_back(state_);
        }
        else
        {
            closure(*followpos_, seen_sets_, hash_vector_);
        }

        for (std::size_t index_ = 0; index_ < seen_sets_.size(); ++index_)
        {
            equivset_list equiv_list_;

            build_equiv_list(*seen_sets_[index_].get(), equiv_list_);

            for (const auto &equivset_ : equiv_list_)
            {
                const std::size_t transition_ = closure(equivset_->_followpos,
                    seen_sets_, hash_vector_);

                if (transition_ != npos)
                {
                    _dfa[index_]._transitions.push_back
                        (transition(equivset_->_token, transition_));
                }
            }
        }
    }

    std::size_t closure(const typename node::node_vector &followpos_,
        node_set_vector &seen_sets_, size_t_vector &hash_vector_)
    {
        bool end_state_ = false;
        std::size_t hash_ = 0;

        if (followpos_.empty()) return npos;

        std::size_t index_ = 0;
        std::unique_ptr<node_set> set_ptr_(new node_set);

        for (auto iter_ = followpos_.cbegin(), end_ = followpos_.cend();
            iter_ != end_; ++iter_)
        {
            closure_ex(*iter_, end_state_, *set_ptr_.get(), hash_);
        }

        bool found_ = false;
        auto hash_iter_ = hash_vector_.cbegin();
        auto hash_end_ = hash_vector_.cend();
        auto set_iter_ = seen_sets_.cbegin();

        for (; hash_iter_ != hash_end_; ++hash_iter_, ++set_iter_, ++index_)
        {
            found_ = *hash_iter_ == hash_ && *(*set_iter_) == *set_ptr_;

            if (found_) break;
        }

        if (!found_)
        {
            seen_sets_.emplace_back(std::move(set_ptr_));
            hash_vector_.push_back(hash_);

            const std::size_t old_size_ = _dfa.size();

            _dfa.push_back(state());
            _dfa[old_size_]._end = end_state_;
        }

        return index_;
    }

    void closure_ex(node *node_, bool &end_state_, node_set &set_ptr_,
        std::size_t &hash_)
    {
        const bool temp_end_state_ = node_->end_state();

        if (temp_end_state_)
        {
            end_state_ = true;
        }

        if (set_ptr_.insert(node_).second)
        {
            hash_ += reinterpret_cast<std::size_t>(node_);
        }
    }

    void build_equiv_list(const node_set &set_, equivset_list &lhs_)
    {
        equivset_list rhs_;

        fill_rhs_list(set_, rhs_);

        if (!rhs_.empty())
        {
            equivset_ptr overlap_ = std::make_unique<equivset>();

            lhs_.emplace_back(std::move(rhs_.front()));
            rhs_.pop_front();

            while (!rhs_.empty())
            {
                equivset_ptr r_(rhs_.front().release());
                auto iter_ = lhs_.begin();
                auto end_ = lhs_.end();

                rhs_.pop_front();

                while (!r_->empty() && iter_ != end_)
                {
                    auto l_iter_ = iter_;

                    (*l_iter_)->intersect(*r_.get(), *overlap_.get());

                    if (overlap_->empty())
                    {
                        ++iter_;
                    }
                    else if ((*l_iter_)->empty())
                    {
                        l_iter_->reset(overlap_.release());
                        overlap_ = std::make_unique<equivset>();
                        ++iter_;
                    }
                    else if (r_->empty())
                    {
                        r_.reset(overlap_.release());
                        overlap_ = std::make_unique<equivset>();
                        break;
                    }
                    else
                    {
                        iter_ = lhs_.insert(++iter_, equivset_ptr());
                        iter_->reset(overlap_.release());
                        overlap_ = std::make_unique<equivset>();
                        ++iter_;
                        end_ = lhs_.end();
                    }
                }

                if (!r_->empty())
                {
                    lhs_.emplace_back(std::move(r_));
                }
            }
        }
    }

    void fill_rhs_list(const node_set &set_, equivset_list &list_)
    {
        auto iter_ = set_.cbegin();
        auto end_ = set_.cend();

        for (; iter_ != end_; ++iter_)
        {
            const node *node_ = *iter_;

            if (!node_->end_state())
            {
                const string_token token_ = node_->token();

                list_.emplace_back(std::make_unique<equivset>
                    (token_, node_->followpos()));
            }
        }
    }
};

using wildcard = basic_wildcard<char>;
using wwildcard = basic_wildcard<wchar_t>;
}

#endif
