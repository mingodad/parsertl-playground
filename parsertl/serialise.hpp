// serialise.hpp
// Copyright (c) 2007-2023 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#ifndef PARSERTL_SERIALISE_HPP
#define PARSERTL_SERIALISE_HPP

#include "runtime_error.hpp"
#include "lexertl/serialise.hpp"
#include "state_machine.hpp"
#include "rules.hpp"
#include <climits>

namespace parsertl
{
    template <typename id_type, class stream>
    void save(const basic_state_machine<id_type>& sm_, stream& stream_)
    {
        // Version number
        stream_ << 1 << '\n';
        stream_ << sizeof(id_type) << '\n';
        stream_ << sm_._columns << '\n';
        stream_ << sm_._rows << '\n';
        stream_ << sm_._rules.size() << '\n';

        for (const auto& rule_ : sm_._rules)
        {
            stream_ << rule_._lhs << '\n';
            lexertl::detail::output_vec<char>(rule_._rhs, stream_);
        }

        stream_ << sm_._captures.size() << '\n';

        for (const auto& capture_ : sm_._captures)
        {
            stream_ << capture_.first << '\n';
            stream_ << capture_.second.size() << '\n';

            for (const auto& pair_ : capture_.second)
            {
                stream_ << pair_.first << ' ' << pair_.second << '\n';
            }
        }

        stream_ << sm_._table.size() << '\n';

        for (const auto& vec_ : sm_._table)
        {
            stream_ << vec_.size() << '\n';

            for (const auto& pair_ : vec_)
            {
                stream_ << pair_._id << ' ';
                stream_ << static_cast<std::size_t>(pair_._entry.action) << ' ';
                stream_ << pair_._entry.param << '\n';
            }
        }
    }

    template <typename id_type, class stream>
    void save2cpp(const basic_state_machine<id_type>& sm_, stream& stream_)
    {
        size_t rhs_count = 0;
        for (const auto& rule_ : sm_._rules)
        {
            rhs_count += rule_._rhs.size();
        }
        size_t action_count = 0;
        for (const auto& vec_ : sm_._table)
        {
            action_count += vec_.size();
        }
        if(rhs_count < USHRT_MAX && action_count < USHRT_MAX)
        {
            stream_ << "typedef unsigned short size_type;\n";
            stream_ << "static const int sizeof_size_type = " << sizeof(unsigned short) << ";\n";
        }
        else if(rhs_count < UINT_MAX && action_count < UINT_MAX)
        {
            stream_ << "typedef unsigned int size_type;\n";
            stream_ << "static const int sizeof_size_type = " << sizeof(unsigned int) << ";\n";
        }
        else
        {
            stream_ << "typedef size_t size_type;\n";
            stream_ << "static const int sizeof_size_type = " << sizeof(size_t) << ";\n";
        }
        stream_ << "typedef unsigned short id_type;\n";
        // Version number
        stream_ << "static const int version_num = " << 1 << ";\n";
        stream_ << "static const int sizeof_id_type = " << sizeof(id_type) << ";\n";
        stream_ << "static const int sm_columns = " << sm_._columns << ";\n";
        stream_ << "static const int sm_rows = " << sm_._rows << ";\n";
        stream_ << "static const int sm_rules_size = " << sm_._rules.size() << ";\n\n";
        stream_ << "static const int sm_rules_rhs_count = " << rhs_count << ";\n\n";
        stream_ << "static const int sm_action_count = " << action_count << ";\n\n";

        stream_ << "static const id_type rules_rhs_all[" << rhs_count << "] = {\n";
        int idx = 0;
        size_t idx_sum = 0;
        for (const auto& rule_ : sm_._rules)
        {
            stream_ << "  /*" << idx++ << ":" << rule_._lhs << ":"
                    << rule_._rhs.size() << ":" << idx_sum << "*/ ";
            if(rule_._rhs.size())
            {
                idx_sum += rule_._rhs.size();
                bool need_sep = false;
                for (const id_type rhs_id : rule_._rhs)
                {
                    if(need_sep) stream_ << ", ";
                    else need_sep = true;
                    stream_ << rhs_id;
                }
                stream_ << ",\n";
            }
            else
            {
                stream_ << "\n";
            }
        }
        stream_ << "};\n\n";

        stream_ << "struct SmRule {id_type lhs; size_type rhs_count; size_type rhs_all_offset;};\n\n";

        stream_ << "static const SmRule sm_rules[" << sm_._rules.size() << "] = {\n";
        idx = 0;
        idx_sum = 0;
        for (const auto& rule_ : sm_._rules)
        {
            stream_ << "  /*" << idx++ << "*/ {" << rule_._lhs << ", "
                    << rule_._rhs.size() << ", "
                    << idx_sum << "},\n";
            idx_sum += rule_._rhs.size();
        }
        stream_ << "};\n\n";

/*
        stream_ << sm_._captures.size() << '\n';

        for (const auto& capture_ : sm_._captures)
        {
            stream_ << capture_.first << '\n';
            stream_ << capture_.second.size() << '\n';

            for (const auto& pair_ : capture_.second)
            {
                stream_ << pair_.first << ' ' << pair_.second << '\n';
            }
        }
*/
        stream_ << "struct SmAction {id_type symbol_id; id_type action; id_type param;};\n\n";

        stream_ << "static const SmAction sm_action_all[" << action_count << "] = {\n";
        idx = 0;
        idx_sum = 0;
        for (const auto& vec_ : sm_._table)
        {
            stream_ << "  /*" << idx++ << ":" << vec_.size() << ":" << idx_sum << "*/ {";
            idx_sum += vec_.size();
            bool need_sep = false;
            for (const auto& pair_ : vec_)
            {
                if(need_sep) stream_ << "}, {";
                else need_sep = true;
                stream_ << pair_._id << ", ";
                stream_ << static_cast<std::size_t>(pair_._entry.action) << ", ";
                stream_ << pair_._entry.param;
            }
            stream_ << "},\n";
        }
        stream_ << "};\n\n";


        stream_ << "struct SmTable {size_type size; size_type action_all_offset;};\n\n";
        stream_ << "static const SmTable sm_table[" << sm_._table.size() << "] = {\n";
        idx = 0;
        idx_sum = 0;
        for (const auto& vec_ : sm_._table)
        {
            stream_ << "  /*" << idx++ << "*/ {" << vec_.size() << ", " << idx_sum << "},\n";
            idx_sum += vec_.size();
        }
        stream_ << "};\n\n";
    }

    template <typename id_type, class stream>
    void save2sql(const basic_state_machine<id_type>& sm_, stream& stream_)
    {
        stream_ << "create table parser_sm(\n"
                "  id integer primary key,\n"
                "  version integer,\n"
                "  sizeof_id_type integer,\n"
                "  sm_columns integer,\n"
                "  sm_rows integer,\n"
                "  sm_rules integer\n"
                ");\n"
                "insert into parser_sm(version, sizeof_id_type, sm_columns, sm_rows, sm_rules)\n"
                "values(";
        // Version number
        stream_ << 1 << ",";
        stream_ << sizeof(id_type) << ",";
        stream_ << sm_._columns << ",";
        stream_ << sm_._rows << ",";
        stream_ << sm_._rules.size() << ");\n";

        stream_ << "create table parser_sm_rules_lhs(\n"
                "  id integer primary key,\n"
                "  lhs integer\n"
                ");\n";
        stream_ << "create table parser_sm_rules_rhs(\n"
                "  id integer primary key,\n"
                "  lhs integer,\n"
                "  rhs integer,\n"
                "  pos integer\n"
                ");\n";
        stream_ << "insert into parser_sm_rules_lhs(lhs) values\n";
        bool need_sep = false;
        int loop_count = 1;
        for (const auto& rule_ : sm_._rules)
        {
            if(need_sep) stream_ << ",";
            else need_sep = true;
            stream_ << "(" << rule_._lhs << ")";
            if((loop_count++ % 6) == 0) stream_ << "\n";
        }
        stream_ << "insert into parser_sm_rules_rhs(lhs,rhs, pos) values\n";
        need_sep = false;
        loop_count = 1;
        for (const auto& rule_ : sm_._rules)
        {
            if(rule_._rhs.size())
            {
                int pos = 0;
                for (const id_type id_ : rule_._rhs)
                {
                    if(need_sep) stream_ << ",";
                    else need_sep = true;
                    stream_ << "(" << rule_._lhs << "," << id_ << "," << pos++ << ")";
                    if((loop_count++ % 4) == 0) stream_ << "\n";
                }
            }
            else
            {
                if(need_sep) stream_ << ",";
                else need_sep = true;
                stream_ << "(" << rule_._lhs << ",NULL, 0)";
                if((loop_count++ % 4) == 0) stream_ << "\n";
            }
        }
        stream_ << ";\n";
/*
        stream_ << sm_._captures.size() << " //sm_._captures.size()\n";

        for (const auto& capture_ : sm_._captures)
        {
            stream_ << capture_.first << '\n';
            stream_ << capture_.second.size() << '\n';

            for (const auto& pair_ : capture_.second)
            {
                stream_ << pair_.first << ' ' << pair_.second << '\n';
            }
        }
*/
        stream_ << "create table parser_sm_states(\n"
                "  id integer primary key,\n"
                "  size integer\n"
                ");\n";
        stream_ << "create table parser_sm_states_entries(\n"
                "  id integer primary key,\n"
                "  state integer,\n"
                "  token_la integer,\n"
                "  action integer, -- CHECK(action IN(0 /*error*/,1 /*shift*/,2 /*reduce*/,3 /*go_to*/, 4 /*accept*/)\n"
                "  param integer, -- error=syntax_error, shift=token_id, reduce=rule_id, goto=state_no, accept=rule_id\n"
                ");\n";
        //stream_ << sm_._table.size() << " //sm_._table.size()\n";

        stream_ << "insert into parser_sm_states(size) values\n";
        need_sep = false;
        loop_count = 1;
        for (const auto& vec_ : sm_._table)
        {
            if(need_sep) stream_ << ",";
            else need_sep = true;
            stream_ << "(" << vec_.size() << ")";
            if((loop_count++ % 6) == 0) stream_ << "\n";
        }
        stream_ << ";\n";
        stream_ << "insert into parser_sm_states_entries(state, token_la, action, param) values\n";
        need_sep = false;
        loop_count = 1;
        int state_no = 0;
        for (const auto& vec_ : sm_._table)
        {
            for (const auto& pair_ : vec_)
            {
                if(need_sep) stream_ << ",";
                else need_sep = true;
                stream_ << "(" << state_no << "," << pair_._id << ",";
                stream_ << static_cast<std::size_t>(pair_._entry.action) << ",";
                stream_ << pair_._entry.param << ")";
                if((loop_count++ % 4) == 0) stream_ << "\n";
            }
            ++state_no;
        }
        stream_ << ";\n";
    }

    template <class stream, typename id_type>
    void load(stream& stream_, basic_state_machine<id_type>& sm_)
    {
        std::size_t num_ = 0;

        sm_.clear();
        // Version
        stream_ >> num_;
        // sizeof(id_type)
        stream_ >> num_;

        if (num_ != sizeof(id_type))
            throw runtime_error("id_type mismatch in parsertl::load()");

        stream_ >> sm_._columns;
        stream_ >> sm_._rows;
        stream_ >> num_;
        sm_._rules.reserve(num_);

        for (std::size_t idx_ = 0; idx_ < num_; ++idx_)
        {
            sm_._rules.emplace_back();

            auto& rule_ = sm_._rules.back();

            stream_ >> rule_._lhs;
            lexertl::detail::input_vec<char>(stream_, rule_._rhs);
        }

        stream_ >> num_;
        sm_._captures.reserve(num_);

        for (std::size_t idx_ = 0, rows_ = num_; idx_ < rows_; ++idx_)
        {
            sm_._captures.emplace_back();

            auto& capture_ = sm_._captures.back();

            stream_ >> capture_.first;
            stream_ >> num_;
            capture_.second.reserve(num_);

            for (std::size_t idx2_ = 0, entries_ = num_;
                idx2_ < entries_; ++idx2_)
            {
                capture_.second.emplace_back();

                auto& pair_ = capture_.second.back();

                stream_ >> num_;
                pair_.first = static_cast<id_type>(num_);
                stream_ >> num_;
                pair_.second = static_cast<id_type>(num_);
            }
        }

        stream_ >> num_;
        sm_._table.reserve(num_);

        for (std::size_t idx_ = 0, rows_ = num_; idx_ < rows_; ++idx_)
        {
            sm_._table.emplace_back();

            auto& vec_ = sm_._table.back();

            stream_ >> num_;
            vec_.reserve(num_);

            for (std::size_t idx2_ = 0, entries_ = num_;
                idx2_ < entries_; ++idx2_)
            {
                vec_.emplace_back();

                auto& pair_ = vec_.back();

                stream_ >> num_;
                pair_._id = static_cast<id_type>(num_);
                stream_ >> num_;
                pair_._entry.action = static_cast<action>(num_);
                stream_ >> num_;
                pair_._entry.param = static_cast<id_type>(num_);
            }
        }
    }
}

#endif
