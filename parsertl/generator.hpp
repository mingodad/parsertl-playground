// generator.hpp
// Copyright (c) 2014-2023 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#ifndef PARSERTL_GENERATOR_HPP
#define PARSERTL_GENERATOR_HPP

#include "dfa.hpp"
#include "narrow.hpp"
#include "nt_info.hpp"
#include "rules.hpp"
#include "state_machine.hpp"

namespace parsertl
{
    template<typename rules, typename sm, typename id_type = uint16_t>
    class basic_generator
    {
    public:
        using production = typename rules::production;
        using symbol_vector = typename rules::symbol_vector;

        struct prod
        {
            // Not owner
            const production* _production = nullptr;
            std::size_t _lhs = static_cast<std::size_t>(~0);
            cursor _lhs_indexes;
            symbol_vector _rhs;
            cursor_vector _rhs_indexes;

            void swap(prod& rhs_) noexcept
            {
                std::swap(_production, rhs_._production);
                std::swap(_lhs, rhs_._lhs);
                std::swap(_lhs_indexes, rhs_._lhs_indexes);
                _rhs.swap(rhs_._rhs);
                std::swap(_rhs_indexes, rhs_._rhs_indexes);
            }

            // This operator is tuned specifically for new_grammar_ lookup only
            bool operator<(const prod& rhs_) const
            {
                return _production->_lhs < rhs_._production->_lhs ||
                    (_production->_lhs == rhs_._production->_lhs &&
                    _production->_rhs < rhs_._production->_rhs) ||
                    (_production->_lhs == rhs_._production->_lhs &&
                    _production->_rhs == rhs_._production->_rhs &&
                    _rhs_indexes.back()._index <
                        rhs_._rhs_indexes.back()._index);
            }
        };

        using prod_vector = std::vector<prod>;
        using string = typename rules::string;

        static void build(rules& rules_, sm& sm_,
            std::string* warnings_ = nullptr)
        {
#ifdef DEBUGMEM_H_INCLUDED
            showDiffTime("build parser state machine start");
#endif
            dfa dfa_;
            prod_vector new_grammar_;
            auto new_start_ = static_cast<std::size_t>(~0);
            nt_info_vector new_nt_info_;
            std::string warns_;
#ifdef DEBUGMEM_H_INCLUDED
            showDiffTime("build parser state machine start2");
#endif
            rules_.validate();
#ifdef DEBUGMEM_H_INCLUDED
            showDiffTime("rules_.validate");
#endif
            build_dfa(rules_, dfa_);
#ifdef DEBUGMEM_H_INCLUDED
            showDiffTime("build_dfa");
#endif
            rewrite(rules_, dfa_, new_grammar_, new_start_, new_nt_info_);
#ifdef DEBUGMEM_H_INCLUDED
            showDiffTime("rewrite");
#endif
            build_first_sets(new_grammar_, new_nt_info_);
#ifdef DEBUGMEM_H_INCLUDED
            showDiffTime("build_first_sets");
#endif
            // First add EOF to follow_set of start.
#ifdef PARSERTL_WITH_BITSET
            new_nt_info_[new_start_]._follow_set.insert(0);
#else
            new_nt_info_[new_start_]._follow_set[0] = 1;
#endif
            build_follow_sets(new_grammar_, new_nt_info_);
#ifdef DEBUGMEM_H_INCLUDED
            showDiffTime("build_follow_sets");
#endif
            sm_.clear();
#ifndef PARSERTL_WITH_BUILD_TABLE_INDEX
            // new_grammar_ is only used for lookup now
            // so sort in order that std::lower_bound() can be used.
            std::sort(new_grammar_.begin(), new_grammar_.end());
#endif
            build_table(rules_, dfa_, new_grammar_, new_nt_info_,
                sm_, warns_);
#ifdef DEBUGMEM_H_INCLUDED
            showDiffTime("build_table");
#endif

            // Warnings are now an error
            // unless you are explicitly fetching them
            if (!warns_.empty())
            {
                // Braces to avoid clang warning
                if (warnings_)
                    *warnings_ = warns_;
                else
                    throw runtime_error(warns_);
            }

            // If you get an assert here then your id_type
            // is too small for the table.
            assert(static_cast<id_type>(sm_._columns - 1) == sm_._columns - 1);
            assert(static_cast<id_type>(sm_._rows - 1) == sm_._rows - 1);
            copy_rules(rules_, sm_);
#ifdef DEBUGMEM_H_INCLUDED
            showDiffTime("copy_rules");
#endif
            sm_._captures = rules_.captures();
#ifdef DEBUGMEM_H_INCLUDED
            showDiffTime("build parser state machine end");
#endif
        }

        static void build_dfa(const rules& rules_, dfa& dfa_)
        {
            const grammar& grammar_ = rules_.grammar();
            const std::size_t terminals_ = rules_.tokens_info().size();
            const std::size_t start_ = rules_.start();
            hash_map hash_map_;

            dfa_.emplace_back();

            // Only applies if build_dfa() has been called directly
            // from client code (i.e. build() will have already called
            // validate() in the normal case).
            if (start_ == npos())
            {
                dfa_.back()._basis.emplace_back(0, 0);
            }
            else
            {
                const auto &rules_nt_locations = rules_.nt_locations();
                if(rules_nt_locations.size() == 0)
                {
                    return;
                }
                const std::size_t index_ = rules_nt_locations[start_].
                    _first_production;

                dfa_.back()._basis.emplace_back(index_, 0);
            }

            hash_map_[hash_set(dfa_.back()._basis)].push_back(0);

            using item_sets = std::vector<cursor_vector>;

            for (std::size_t s_ = 0; s_ < dfa_.size(); ++s_)
            {
                dfa_state& state_ = dfa_[s_];
                item_sets item_sets_;
                size_t_vector symbols_;

                state_._closure.assign(state_._basis.begin(),
                    state_._basis.end());
                closure(rules_, state_);
                for (const auto& pair_ : state_._closure)
                {
                    const production &p_ = grammar_[pair_._id];

                    if (pair_._index < p_._rhs._symbols.size())
                    {
                        const symbol& symbol_ = p_._rhs._symbols[pair_._index];
                        const std::size_t id_ =
                            symbol_._type == symbol::type::TERMINAL ?
                            symbol_._id : terminals_ + symbol_._id;
                        auto sym_iter_ = std::find(symbols_.begin(),
                            symbols_.end(), id_);
                        cursor new_pair_(pair_._id, pair_._index + 1);

                        if (sym_iter_ == symbols_.end())
                        {
                            symbols_.push_back(id_);
                            item_sets_.emplace_back();
                            item_sets_.back().reserve(4);
                            item_sets_.back().push_back(new_pair_);
                        }
                        else
                        {
                            const std::size_t index_ =
                                sym_iter_ - symbols_.begin();
                            cursor_vector& vec_ = item_sets_[index_];
                            auto i_ = std::find(vec_.begin(), vec_.end(),
                                new_pair_);

                            if (i_ == vec_.end())
                            {
                                vec_.push_back(new_pair_);
                            }
                        }
                    }
                }

                for (auto iter_ = symbols_.cbegin(), end_ = symbols_.cend();
                    iter_ != end_; ++iter_)
                {
                    std::size_t index_ = iter_ - symbols_.begin();
                    cursor_vector& basis_ = item_sets_[index_];

                    std::sort(basis_.begin(), basis_.end());
                    index_ = add_dfa_state(dfa_, hash_map_, basis_);
                    state_._transitions.emplace_back(*iter_, index_);
                }
            }
        }

        static void rewrite(const rules& rules_, dfa& dfa_,
            prod_vector& new_grammar_, std::size_t& new_start_,
            nt_info_vector& new_nt_info_)
        {
            using trie = std::pair<std::size_t, cursor>;
            using trie_map = std::map<trie, std::size_t>;
            const grammar& grammar_ = rules_.grammar();
            size_t terminals_size;
            const std::size_t start_ = rules_.start();
            trie_map map_;

            terminals_size = rules_.terminals_count();
            //printf("new_grammar : %d : %d\n", (int)new_grammar_.size(), (int)dfa_.size());

            for (std::size_t sidx_ = 0, ssize_ = dfa_.size();
                sidx_ != ssize_; ++sidx_)
            {
                const dfa_state& state_ = dfa_[sidx_];

                for (std::size_t cidx_ = 0, csize_ = state_._closure.size();
                    cidx_ != csize_; ++cidx_)
                {
                    const cursor& pair_ = state_._closure[cidx_];

                    if (pair_._index != 0) continue;

                    const production& production_ = grammar_[pair_._id];
                    prod &prod_ = new_grammar_.emplace_back();

                    prod_._production = &production_;

                    if (production_._lhs != start_)
                    {
                        const std::size_t id_ = terminals_size +
                            production_._lhs;

                        prod_._lhs_indexes._id = sidx_;

                        for (std::size_t tidx_ = 0,
                            tsize_ = state_._transitions.size();
                            tidx_ != tsize_; ++tidx_)
                        {
                            const cursor& pr_ =
                                state_._transitions[tidx_];

                            if (pr_._id == id_)
                            {
                                prod_._lhs_indexes._index = pr_._index;
                                break;
                            }
                        }
                    }

                    trie trie_(production_._lhs, prod_._lhs_indexes);
                    auto map_iter_ = map_.find(trie_);

                    if (map_iter_ == map_.end())
                    {
                        prod_._lhs = map_.size();
                        map_[trie_] = prod_._lhs;

                        if (production_._lhs == start_)
                        {
                            new_start_ = prod_._lhs;
                        }
                    }
                    else
                    {
                        prod_._lhs = map_iter_->second;
                    }

                    std::size_t index_ = sidx_;

                    if (production_._rhs._symbols.empty())
                    {
                        prod_._rhs_indexes.emplace_back(sidx_, sidx_);
                    }

                    for (std::size_t ridx_ = 0, rsize_ = production_._rhs.
                        _symbols.size(); ridx_ != rsize_; ++ridx_)
                    {
                        const symbol& symbol_ = production_._rhs._symbols[ridx_];
                        const dfa_state& st_ = dfa_[index_];

                        prod_._rhs_indexes.emplace_back(index_, 0);

                        for (std::size_t tidx_ = 0,
                            tsize_ = st_._transitions.size();
                            tidx_ != tsize_; ++tidx_)
                        {
                            const std::size_t id_ =
                                symbol_._type == symbol::type::TERMINAL ?
                                symbol_._id :
                                terminals_size + symbol_._id;
                            const cursor& pr_ = st_._transitions[tidx_];

                            if (pr_._id == id_)
                            {
                                index_ = pr_._index;
                                break;
                            }
                        }

                        prod_._rhs_indexes.back()._index = index_;
                        prod_._rhs.push_back(symbol_);

                        if (symbol_._type == symbol::type::NON_TERMINAL)
                        {
                            symbol& rhs_symbol_ = prod_._rhs.back();

                            trie_ = trie(symbol_._id,
                                prod_._rhs_indexes.back());
                            map_iter_ = map_.find(trie_);

                            if (map_iter_ == map_.end())
                            {
                                rhs_symbol_._id = map_.size();
                                map_[trie_] = rhs_symbol_._id;
                            }
                            else
                            {
                                rhs_symbol_._id = map_iter_->second;
                            }
                        }
                    }
                }
            }
            //printf("new_grammar : %d : %d\n", (int)new_grammar_.size(), (int)dfa_.size());

            new_nt_info_.assign(map_.size(),
                nt_info(rules_.tokens_info().size()));
        }

        // http://www.sqlite.org/src/artifact?ci=trunk&filename=tool/lemon.c
        // FindFirstSets function
        static void build_first_sets(const prod_vector& grammar_,
            nt_info_vector& nt_info_)
        {
            bool progress_ = true;

            // First compute all lambdas
            do
            {
                progress_ = false;

                for (const auto& prod_ : grammar_)
                {
                    if (nt_info_[prod_._lhs]._nullable) continue;

                    std::size_t i_ = 0;
                    const std::size_t rhs_size_ = prod_._rhs.size();

                    for (; i_ < rhs_size_; i_++)
                    {
                        const symbol& symbol_ = prod_._rhs[i_];

                        if (symbol_._type != symbol::type::NON_TERMINAL ||
                            !nt_info_[symbol_._id]._nullable)
                        {
                            break;
                        }
                    }

                    if (i_ == rhs_size_)
                    {
                        nt_info_[prod_._lhs]._nullable = true;
                        progress_ = true;
                    }
                }
            } while (progress_);

            // Now compute all first sets
            do
            {
                progress_ = false;

                for (const auto& prod_ : grammar_)
                {
                    nt_info& lhs_info_ = nt_info_[prod_._lhs];
                    const std::size_t rhs_size_ = prod_._rhs.size();

                    for (std::size_t i_ = 0; i_ < rhs_size_; i_++)
                    {
                        const symbol& symbol_ = prod_._rhs[i_];

                        if (symbol_._type == symbol::type::TERMINAL)
                        {
                            progress_ |=
                                set_add(lhs_info_._first_set, symbol_._id);
                            break;
                        }
                        else if (prod_._lhs == symbol_._id)
                        {
                            if (!lhs_info_._nullable) break;
                        }
                        else
                        {
                            const nt_info& rhs_info_ = nt_info_[symbol_._id];

                            progress_ |= set_union(lhs_info_._first_set,
                                rhs_info_._first_set);

                            if (!rhs_info_._nullable) break;
                        }
                    }
                }
            } while (progress_);
        }

        static void build_follow_sets(const prod_vector& grammar_,
            nt_info_vector& nt_info_)
        {
            for (;;)
            {
                bool changes_ = false;

                for (const auto& prod_ : grammar_)
                {
                    auto rhs_iter_ = prod_._rhs.cbegin();
                    auto rhs_end_ = prod_._rhs.cend();

                    for (; rhs_iter_ != rhs_end_; ++rhs_iter_)
                    {
                        if (rhs_iter_->_type == symbol::type::NON_TERMINAL)
                        {
                            auto next_iter_ = rhs_iter_ + 1;
                            nt_info& lhs_info_ = nt_info_[rhs_iter_->_id];
                            bool nullable_ = next_iter_ == rhs_end_;

                            if (next_iter_ != rhs_end_)
                            {
                                if (next_iter_->_type == symbol::type::TERMINAL)
                                {
                                    const std::size_t id_ = next_iter_->_id;

                                    // Just add terminal.
                                    changes_ |= set_add
                                    (lhs_info_._follow_set, id_);
                                }
                                else
                                {
                                    // If there is a production A -> aBb
                                    // then everything in FIRST(b) is
                                    // placed in FOLLOW(B).
                                    const nt_info* rhs_info_ =
                                        &nt_info_[next_iter_->_id];

                                    changes_ |= set_union(lhs_info_._follow_set,
                                        rhs_info_->_first_set);
                                    ++next_iter_;

                                    // If nullable, keep going
                                    if (rhs_info_->_nullable)
                                    {
                                        for (; next_iter_ != rhs_end_;
                                            ++next_iter_)
                                        {
                                            auto next_id_ =
                                                static_cast<std::size_t>(~0);

                                            if (next_iter_->_type ==
                                                symbol::type::TERMINAL)
                                            {
                                                next_id_ = next_iter_->_id;
                                                // Just add terminal.
                                                changes_ |= set_add
                                                (lhs_info_._follow_set,
                                                    next_id_);
                                                break;
                                            }
                                            else
                                            {
                                                next_id_ = next_iter_->_id;
                                                rhs_info_ = &nt_info_[next_id_];
                                                changes_ |= set_union
                                                (lhs_info_._follow_set,
                                                    rhs_info_->_first_set);

                                                if (!rhs_info_->_nullable)
                                                {
                                                    break;
                                                }
                                            }
                                        }

                                        nullable_ = next_iter_ == rhs_end_;
                                    }
                                }
                            }

                            if (nullable_)
                            {
                                // If there is a production A -> aB
                                // then everything in FOLLOW(A) is in FOLLOW(B).
                                const nt_info& rhs_info_ = nt_info_[prod_._lhs];

                                changes_ |= set_union(lhs_info_._follow_set,
                                    rhs_info_._follow_set);
                            }
                        }
                    }
                }

                if (!changes_) break;
            }
        }

    private:
        using entry = typename sm::entry;
        using grammar = typename rules::production_vector;
        using size_t_vector = std::vector<std::size_t>;
        using hash_map = std::map<std::size_t, size_t_vector>;
        using string_vector = typename rules::string_vector;
        using symbol = typename rules::symbol;
        using token_info = typename rules::token_info;
        using token_info_vector = typename rules::token_info_vector;

        static void build_table(const rules& rules_, const dfa& dfa_,
            const prod_vector& new_grammar_, const nt_info_vector& new_nt_info_,
            sm& sm_, std::string& warnings_)
        {
            const grammar& grammar_ = rules_.grammar();
            const std::size_t start_ = rules_.start();
            const std::size_t terminals_ = rules_.tokens_info().size();
            const std::size_t non_terminals_ = rules_.nt_locations().size();
            string_vector symbols_;
            const std::size_t columns_ = terminals_ + non_terminals_;
            std::size_t index_ = 0;
#ifdef PARSERTL_WITH_BUILD_TABLE_INDEX

            struct grammar_idx {
                dfa_size_t lhs, prod_lhs, rhs_back;
                const symbol_vector* rhs;
                grammar_idx(dfa_size_t the_lhs, dfa_size_t the_prod_lhs,
                    dfa_size_t the_rhs_back, const symbol_vector* the_rhs):
                    lhs(the_lhs), prod_lhs(the_prod_lhs),
                    rhs_back(the_rhs_back), rhs(the_rhs)
                {}
            };
            std::vector<grammar_idx> new_grammar_idx_vec;
            new_grammar_idx_vec.reserve(new_grammar_.size());
            for (const auto& p_ : new_grammar_)
            {
                new_grammar_idx_vec.emplace_back(p_._production->_lhs, p_._lhs,
                        p_._rhs_indexes.back()._index, &(p_._production->_rhs._symbols));
            }

            auto cmp_grammar_idx = [] (grammar_idx const& a, grammar_idx const& b) {
                    if(a.lhs < b.lhs) return true;
                    if(a.lhs == b.lhs && a.rhs_back < b.rhs_back) return true;
                    return false;
                };
            std::sort(new_grammar_idx_vec.begin(), new_grammar_idx_vec.end(),
                cmp_grammar_idx);
#endif
            rules_.symbols(symbols_);
            sm_._columns = columns_;
            sm_._rows = dfa_.size();
            sm_.push();

#ifdef PARSERTL_WITH_BITSET
            char_vector follow_set_(terminals_);
#endif
            for (const auto& d_ : dfa_)
            {
                // shift and gotos
                for (const auto& tran_ : d_._transitions)
                {
                    const dfa_size_t id_ = tran_._id;
                    entry lhs_ = sm_.at(index_, id_);
                    const entry rhs_((id_ < terminals_) ?
                        // TERMINAL
                        action::shift :
                        // NON_TERMINAL
                        action::go_to,
                        static_cast<id_type>(tran_._index));

                    if (fill_entry(0, rules_, d_._closure, symbols_,
                        lhs_, id_, rhs_, warnings_))
                        sm_.set(index_, id_, lhs_);
                }

                // reductions
                for (const auto& c_ : d_._closure)
                {
                    const production& production_ = grammar_[c_._id];

                    if (production_._rhs._symbols.size() == c_._index)
                    {
#ifdef PARSERTL_WITH_BITSET
                        follow_set_.set_clear();
#else
                        char_vector follow_set_(terminals_, 0);
#endif

                        // config is reduction
#ifdef PARSERTL_WITH_BUILD_TABLE_INDEX
                        grammar_idx gidx_start(production_._lhs, 0, index_, nullptr);
                        auto it = std::lower_bound(new_grammar_idx_vec.begin(), new_grammar_idx_vec.end(), gidx_start,
                                cmp_grammar_idx);
                        while(it != new_grammar_idx_vec.end() && it->lhs == production_._lhs && index_ == it->rhs_back)
                        {
                            if (production_._rhs._symbols == *(it->rhs))
                            {
                                const std::size_t lhs_id_ = it->prod_lhs;

                                set_union(follow_set_,
                                    new_nt_info_[lhs_id_]._follow_set);
                            }
                            ++it;
                        }
#else
                        prod key_;

                        key_._production = &production_;
                        // Only the second value is relevant for the lookup
                        key_._rhs_indexes.emplace_back(index_, index_);

                        // config is reduction
                        for (auto iter_ = std::lower_bound(new_grammar_.begin(),
                            new_grammar_.end(), key_), end_ = new_grammar_.end();
                            iter_ != end_; ++iter_)
                        {
                            if (production_._lhs == iter_->_production->_lhs &&
                                production_._rhs == iter_->_production->_rhs &&
                                index_ == iter_->_rhs_indexes.back()._index)
                            {
                                const std::size_t lhs_id_ = iter_->_lhs;

                                set_union(follow_set_,
                                    new_nt_info_[lhs_id_]._follow_set);
                            }
                            else
                                break;
                        }
#endif
                        for (std::size_t id_ = 0, size_ = follow_set_.size();
                            id_ < size_; ++id_)
                        {
                            if (!follow_set_[id_]) continue;

                            entry lhs_ = sm_.at(index_, id_);
                            const entry rhs_(production_._lhs == start_ ?
                                action::accept :
                                action::reduce,
                                static_cast<id_type>(production_._index));

                            if (fill_entry(index_, rules_, d_._closure, symbols_,
                                lhs_, id_, rhs_, warnings_))
                                sm_.set(index_, id_, lhs_);
                        }
                    }
                }

                ++index_;
            }
        }

        static void copy_rules(const rules& rules_, sm& sm_)
        {
            const grammar& grammar_ = rules_.grammar();
            const std::size_t terminals_ = rules_.tokens_info().size();

            for (const production& production_ : grammar_)
            {
                auto& pair_ = sm_._rules.emplace_back();

                pair_._lhs = static_cast<id_type>(terminals_ +
                    production_._lhs);

                for (const auto& symbol_ : production_._rhs._symbols)
                {
                    if (symbol_._type == symbol::type::TERMINAL)
                    {
                        pair_._rhs.
                            push_back(static_cast<id_type>(symbol_._id));
                    }
                    else
                    {
                        pair_._rhs.push_back(static_cast<id_type>
                            (terminals_ + symbol_._id));
                    }
                }
            }
        }

        // Helper functions:

        // Add a new element to the set. Return true if the element was added
        // and false if it was already there.
        static bool set_add(char_vector& s_, const std::size_t e_)
        {
            const char rv_ = s_[e_];

            assert(e_ < s_.size());
#ifdef PARSERTL_WITH_BITSET
            s_.insert(e_);
#else
            s_[e_] = 1;
#endif
            return !rv_;
        }

        // Add every element of rhs_ to lhs_. Return true if lhs_ changes.
        static bool set_union(char_vector& lhs_, const char_vector& rhs_)
        {
#ifdef PARSERTL_WITH_BITSET
            return lhs_.set_union(rhs_) > 0;
#else
            const std::size_t size_ = lhs_.size();
            bool progress_ = false;
#ifdef PARSERTL_WITH_BOOLSET
            char_vector& lhs_ptr_ = lhs_;
            const char_vector& rhs_ptr_ = rhs_;
#else
            char* lhs_ptr_ = &lhs_.front();
            const char* rhs_ptr_ = &rhs_.front();
#endif

            for (std::size_t i_ = 0; i_ < size_; i_++)
            {
                if (rhs_ptr_[i_] == 0) continue;

                if (lhs_ptr_[i_] == 0)
                {
                    progress_ = true;
                    lhs_ptr_[i_] = 1;
                }
            }

            return progress_;
#endif
        }

        static void closure(const rules& rules_, dfa_state& state_)
        {
            const auto& nt_locations_ = rules_.nt_locations();
            const grammar& grammar_ = rules_.grammar();

            for (std::size_t c_ = 0; c_ < state_._closure.size(); ++c_)
            {
                const cursor pair_ = state_._closure[c_];
                const production& p_ = grammar_[pair_._id];
                const std::size_t rhs_size_ = p_._rhs._symbols.size();

                if (pair_._index < rhs_size_)
                {
                    // SHIFT
                    const symbol& symbol_ = p_._rhs._symbols[pair_._index];

                    if (symbol_._type == symbol::type::NON_TERMINAL)
                    {
                        for (prod_size_t rule_ =
                            nt_locations_[symbol_._id]._first_production;
                            rule_ != npos(); rule_ = grammar_[rule_]._next_lhs)
                        {
                            const cursor new_pair_(rule_, 0);
                            auto i_ = std::find(state_._closure.begin(),
                                state_._closure.end(), new_pair_);

                            if (i_ == state_._closure.end())
                            {
                                state_._closure.push_back(new_pair_);
                            }
                        }
                    }
                }
            }
        }

        static std::size_t add_dfa_state(dfa& dfa_, hash_map& hash_map_,
            cursor_vector& basis_)
        {
            size_t_vector& states_ = hash_map_[hash_set(basis_)];
            std::size_t index_ = npos();

            if (!states_.empty())
            {
                for (const auto s_ : states_)
                {
                    const dfa_state& state_ = dfa_[s_];

                    if (state_._basis == basis_)
                    {
                        index_ = s_;
                        break;
                    }
                }
            }

            if (states_.empty() || index_ == npos())
            {
                index_ = dfa_.size();
                states_.push_back(index_);
                dfa_.emplace_back();
                dfa_.back()._basis.swap(basis_);
            }

            return index_;
        }

        static std::size_t hash_set(const cursor_vector& vec_)
        {
            std::size_t hash_ = 0;

            for (const auto& pair_ : vec_)
            {
                hash_ *= 571;
                hash_ += pair_._id * 37 + pair_._index;
            }

            return hash_;
        }

        static bool fill_entry(const std::size_t rule_index, const rules& rules_,
            const cursor_vector& config_, const string_vector& symbols_,
            entry& lhs_, const std::size_t id_, const entry& rhs_,
            std::string& warnings_)
        {
            bool modified_ = false;
            const grammar& grammar_ = rules_.grammar();
            const token_info_vector& tokens_info_ = rules_.tokens_info();
            const std::size_t terminals_ = tokens_info_.size();
            static const char* actions_[] =
            { "ERROR", "SHIFT", "REDUCE", "GOTO", "ACCEPT" };
            bool error_ = false;

            if (lhs_.action == action::error)
            {
                if (static_cast<error_type>(lhs_.param) ==
                    error_type::syntax_error)
                {
                    // No conflict
                    lhs_ = rhs_;
                    modified_ = true;
                }
                else
                {
                    error_ = true;
                }
            }
            else
            {
                std::size_t lhs_prec_ = 0;
                typename rules::associativity lhs_assoc_ =
                    rules::associativity::token_assoc;
                std::size_t rhs_prec_ = 0;
                const token_info* iter_ = &tokens_info_[id_];

                if (lhs_.action == action::shift)
                {
                    lhs_prec_ = iter_->_precedence;
                    lhs_assoc_ = iter_->_associativity;
                }
                else if (lhs_.action == action::reduce)
                {
                    const production& prod_ = grammar_[lhs_.param];

                    if(prod_._ctx_precedence_id > 0)
                    {
                        const token_info& tki = tokens_info_[prod_._ctx_precedence_id];
                        lhs_prec_ = tki._precedence;
                        lhs_assoc_ = tki._associativity;
                    }
                    else if(prod_._precedence_id > 0)
                    {
                        const token_info& tki = tokens_info_[prod_._precedence_id];
                        lhs_prec_ = tki._precedence;
                        lhs_assoc_ = tki._associativity;
                    }
                }

                if (rhs_.action == action::shift)
                {
                    rhs_prec_ = iter_->_precedence;
                }
                else if (rhs_.action == action::reduce)
                {
                    const production& prod_ = grammar_[rhs_.param];

                    if(prod_._ctx_precedence_id > 0)
                    {
                        const token_info& tki = tokens_info_[prod_._ctx_precedence_id];
                        rhs_prec_ = tki._precedence;
                    }
                    else if(prod_._precedence_id > 0)
                    {
                        const token_info& tki = tokens_info_[prod_._precedence_id];
                        rhs_prec_ = tki._precedence;
                    }
                }

                if (lhs_.action == action::shift &&
                    rhs_.action == action::reduce)
                {
                    ++rules_.shift_reduce_count;
                    if (lhs_prec_ == 0 || rhs_prec_ == 0)
                    {
                        // Favour shift (leave lhs as it is).
                        std::ostringstream ss_;

                        ss_ << "state " << rule_index << " ";
                        ss_ << actions_[static_cast<int>(lhs_.action)];
                        dump_action(grammar_, terminals_, config_, symbols_,
                            id_, lhs_, ss_);
                        ss_ << '/' <<
                            actions_[static_cast<int>(rhs_.action)];
                        dump_action(grammar_, terminals_, config_, symbols_,
                            id_, rhs_, ss_);
                        ss_ << " conflict.\n";
                        warnings_ += ss_.str();
                    }
                    else if (lhs_prec_ == rhs_prec_)
                    {
                        switch (lhs_assoc_)
                        {
                        case rules::associativity::precedence_assoc:
                            // Favour shift (leave lhs as it is).
                            {
                                std::ostringstream ss_;

                                ss_ << "state " << rule_index << " ";
                                ss_ << actions_[static_cast<int>(lhs_.action)];
                                dump_action(grammar_, terminals_, config_,
                                    symbols_, id_, lhs_, ss_);
                                ss_ << '/' <<
                                    actions_[static_cast<int>(rhs_.action)];
                                dump_action(grammar_, terminals_, config_,
                                    symbols_, id_, rhs_, ss_);
                                ss_ << " conflict.\n";
                                warnings_ += ss_.str();
                            }

                            break;
                        case rules::associativity::non_assoc:
                            lhs_ = entry(action::error, static_cast<id_type>
                                (error_type::non_associative));
                            modified_ = true;
                            break;
                        case rules::associativity::left_assoc:
                            lhs_ = rhs_;
                            modified_ = true;
                        break;
                        default:
                            break;
                        }
                    }
                    else if (rhs_prec_ > lhs_prec_)
                    {
                        lhs_ = rhs_;
                        modified_ = true;
                    }
                }
                else
                {
                    error_ = true;
                }
            }

            if (error_)
            {
                std::ostringstream ss_;

                ss_ << "state " << rule_index << ":" << symbols_[id_] << " ";
                ss_ << actions_[static_cast<int>(lhs_.action)];
                dump_action(grammar_, terminals_, config_, symbols_, id_,
                    lhs_, ss_);
                ss_ << '/' << actions_[static_cast<int>(rhs_.action)];
                dump_action(grammar_, terminals_, config_, symbols_, id_, rhs_,
                    ss_);
                ss_ << " conflict.\n";
                warnings_ += ss_.str();

                if (lhs_.action == action::reduce &&
                    rhs_.action == action::reduce)
                {
                    ++rules_.reduce_reduce_count;
                    if(rhs_.param < lhs_.param)
                    {
                        // Take the earlier rule on reduce/reduce error
                        lhs_.param = rhs_.param;
                        modified_ = true;
                    }
                }
            }

            return modified_;
        }

        static void dump_action(const grammar& grammar_,
            const std::size_t terminals_, const cursor_vector& config_,
            const string_vector& symbols_, const std::size_t id_,
            const entry& entry_, std::ostringstream& ss_)
        {
            if (entry_.action == action::shift)
            {
                for (const auto& c_ : config_)
                {
                    const production& production_ = grammar_[c_._id];

                    if (production_._rhs._symbols.size() > c_._index &&
                        production_._rhs._symbols[c_._index]._id == id_)
                    {
                        dump_production(production_, c_._index, terminals_,
                            symbols_, ss_);
                    }
                }
            }
            else if (entry_.action == action::reduce)
            {
                const production& production_ = grammar_[entry_.param];

                dump_production(production_, static_cast<std::size_t>(~0),
                    terminals_, symbols_, ss_);
            }
        }

        static void dump_production(const production& production_,
            const std::size_t dot_, const std::size_t terminals_,
            const string_vector& symbols_, std::ostringstream& ss_)
        {
            auto sym_iter_ = production_._rhs._symbols.cbegin();
            auto sym_end_ = production_._rhs._symbols.cend();
            std::size_t index_ = 0;

            ss_ << " (";
            narrow(symbols_[terminals_ + production_._lhs].c_str(), ss_);
            ss_ << " -> ";

            if (sym_iter_ != sym_end_)
            {
                const std::size_t id_ =
                    sym_iter_->_type == symbol::type::TERMINAL ?
                    sym_iter_->_id :
                    terminals_ + sym_iter_->_id;

                if (index_ == dot_) ss_ << ". ";

                narrow(symbols_[id_].c_str(), ss_);
                ++sym_iter_;
                ++index_;
            }

            for (; sym_iter_ != sym_end_; ++sym_iter_, ++index_)
            {
                const std::size_t id_ =
                    sym_iter_->_type == symbol::type::TERMINAL ?
                    sym_iter_->_id :
                    terminals_ + sym_iter_->_id;

                ss_ << ' ';

                if (index_ == dot_) ss_ << ". ";

                narrow(symbols_[id_].c_str(), ss_);
            }

            ss_ << ')';
        }

        static std::size_t npos()
        {
            return static_cast<prod_size_t>(~0);
        }
    };

    using generator = basic_generator<rules, state_machine>;
    using uncompressed_generator =
        basic_generator<rules, uncompressed_state_machine>;
    using wgenerator = basic_generator<wrules, state_machine>;
    using wuncompressed_generator =
        basic_generator<wrules, uncompressed_state_machine>;
}

#endif
