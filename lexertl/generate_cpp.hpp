// generate_cpp.hpp
// Copyright (c) 2005-2023 Ben Hanson (http://www.benhanson.net/)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file licence_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#ifndef LEXERTL_GENERATE_CPP_HPP
#define LEXERTL_GENERATE_CPP_HPP

#include "enum_operator.hpp"
#include "enums.hpp"
#include <sstream>
#include "state_machine.hpp"

namespace lexertl
{
    class table_based_cpp
    {
    public:
        template<typename char_type, typename id_type>
        static void generate_cpp
        (const std::string& name_,
            const basic_state_machine<char_type, id_type>& sm_,
            const bool pointers_, std::ostream& os_)
        {
            using sm = basic_state_machine<char_type, id_type>;
            using internals = typename sm::internals;
            const internals& internals_ = sm_.data();
            std::size_t additional_tabs_ = 0;

            os_ << "#define FALSE 0\n"
                "#define TRUE 1\n"
                "#define NULLPTR NULL\n"
                "typedef char char_type;\n"
                "typedef const char_type*  iter_type;\n"
                "typedef unsigned char index_type;\n"
                "\n"
                "static const id_type results_npos = 0x" << std::hex << sm_.npos() << ";\n"
                "static const id_type results_skip = 0x" << std::hex << sm_.skip() << ";\n"
                "static const id_type results_reject = 0x" << std::hex << sm_.reject() << ";\n"
                "\n";
            if (internals_._features & *feature_bit::recursive)
            {
                os_ << "using id_type_pair = std::pair<id_type, id_type>;\n";
            }
            os_ <<
                "struct lexertl_match_results {\n"
                "    iter_type eoi, first, second;\n"
                "    id_type id, user_id, state, bol;\n";
            if (internals_._features & *feature_bit::recursive)
            {
                os_ << "    std::stack<id_type_pair> stack;\n";
            }
            os_ << "    lexertl_match_results():eoi(0),first(0),second(0),\n"
			"    id(0),user_id(0),state(0),bol(0){}\n"
                        "};\n"
                        "\n";


            dump_tables(sm_, 0, pointers_, os_);

            os_ << "\n";
            os_ << "void " << name_ << " (lexertl_match_results *results)\n";
            os_ << "{\n";
            os_ << "    iter_type end_token = results->second;\n";

            if (internals_._features & *feature_bit::skip)
            {
                os_ << "    auto saved_bol = results->bol;\n"
                       "skip:\n"
                       "    /* adjust saved_curr after skip to prevent infinty loop\n"
                       "     * when using reject() */\n"
                       "    auto saved_curr = results->second;\n";
            }

            os_ << "    iter_type curr = results->second;\n\n";
            os_ << "    results->first = curr;\n\n";

            if (internals_._features & *feature_bit::again)
            {
                os_ << "again:\n";
            }

            os_ << "    if (curr == results->eoi)\n";
            os_ << "    {\n";
            // We want a number regardless of id_type.
            os_ << "        results->id = " << static_cast<std::size_t>
                (internals_._eoi) << ";\n";
            os_ << "        results->user_id = results_npos;\n";
            os_ << "        return;\n";
            os_ << "    }\n";

            if (internals_._features & *feature_bit::reject)
            {
                os_ << "reject:\n\n";
            }

            if (internals_._features & *feature_bit::bol)
            {
                os_ << "    bool bol = results->bol;\n";
            }

            os_ << "    const id_type *lookup = "
                "lexer_lookups[results->state];\n";
            os_ << "    const id_type dfa_alphabet = lexer_dfa_alphabets"
                "[results->state];\n";
            os_ << "    const ";

            if (pointers_)
            {
                os_ << "void * const";
            }
            else
            {
                os_ << "id_type";
            }

            os_ << " *dfa = lexer_dfas[results->state];\n";

            os_ << "    const ";

            if (pointers_)
            {
                os_ << "void * const";
            }
            else
            {
                os_ << "id_type";
            }

            os_ << " *ptr = dfa + dfa_alphabet;\n";
            os_ << "    bool end_state = *ptr != 0;\n";

            if (internals_._features & *feature_bit::recursive)
            {
                os_ << "    bool pop = (";

                if (pointers_)
                {
                    // Done this way for GCC:
                    os_ << "static_cast<id_type>(reinterpret_cast<ptrdiff_t>(";
                }

                os_ << "*ptr";

                if (pointers_)
                {
                    os_ << ')';
                }

                os_ << " & " << *state_bit::pop_dfa;

                if (pointers_)
                {
                    os_ << ')';
                }

                os_ << ") != 0;\n";
            }

            os_ << "    id_type id = ";

            if (pointers_)
            {
                // Done this way for GCC:
                os_ << "static_cast<id_type>(reinterpret_cast<ptrdiff_t>(";
            }

            os_ << "*(ptr + " << *state_index::id << ")";

            if (pointers_)
            {
                os_ << "))";
            }

            os_ << ";\n";
            os_ << "    id_type uid = ";

            if (pointers_)
            {
                // Done this way for GCC:
                os_ << "static_cast<id_type>(reinterpret_cast<ptrdiff_t>(";
            }

            os_ << "*(ptr + " << *state_index::user_id << ")";

            if (pointers_)
            {
                os_ << "))";
            }

            os_ << ";\n";

            if (internals_._features & *feature_bit::recursive)
            {
                os_ << "    id_type push_dfa = ";

                if (pointers_)
                {
                    // Done this way for GCC:
                    os_ << "static_cast<id_type>(reinterpret_cast<ptrdiff_t>(";
                }

                os_ << "*(ptr + " << *state_index::push_dfa << ")";

                if (pointers_)
                {
                    os_ << "))";
                }

                os_ << ";\n";
            }

            if (internals_._dfa.size() > 1)
            {
                os_ << "    id_type start_state = results->state;\n";
            }

            if (internals_._features & *feature_bit::bol)
            {
                os_ << "    bool end_bol = bol;\n";
            }

            if (internals_._features & *feature_bit::eol)
            {
                os_ << "    ";

                if (pointers_)
                {
                    os_ << "const void * const *";
                }
                else
                {
                    os_ << "id_type ";
                }

                os_ << "EOL_state = 0;\n";
            }

            os_ << '\n';

            if (internals_._features & *feature_bit::bol)
            {
                os_ << "    if (bol)\n";
                os_ << "    {\n";
                os_ << "        const ";

                if (pointers_)
                {
                    os_ << "void *";
                }
                else
                {
                    os_ << "id_type ";
                }

                os_ << "state = *dfa;\n\n";
                os_ << "        if (state)\n";
                os_ << "        {\n";
                os_ << "            ptr = ";

                if (pointers_)
                {
                    os_ << "reinterpret_cast<void * const *>(state);\n";
                }
                else
                {
                    os_ << "&dfa[state * dfa_alphabet];\n";
                }

                os_ << "        }\n";
                os_ << "    }\n\n";
            }

            os_ << "    while (curr != results->eoi)\n";
            os_ << "    {\n";

            if (internals_._features & *feature_bit::eol)
            {
                os_ << "        EOL_state = ";

                if (pointers_)
                {
                    os_ << "reinterpret_cast<const void * const *>(";
                }

                os_ << "ptr[" << *state_index::eol << ']';

                if (pointers_)
                {
                    os_ << ')';
                }

                os_ << ";\n\n";
                os_ << "        if (EOL_state && *curr == '\\n')\n";
                os_ << "        {\n";
                os_ << "            ptr = ";

                if (pointers_)
                {
                    os_ << "EOL_state";
                }
                else
                {
                    os_ << "&dfa[EOL_state * dfa_alphabet]";
                }

                os_ << ";\n";
                os_ << "        }\n";
                os_ << "        else\n";
                os_ << "        {\n";
                ++additional_tabs_;
            }

            output_char_loop(internals_._features, additional_tabs_, pointers_,
                os_, std::integral_constant<bool,
                (sizeof(typename sm::traits::input_char_type) > 1)>());

            if (internals_._features & *feature_bit::eol)
            {
                output_tabs(additional_tabs_, os_);
                os_ << "    }\n";
                --additional_tabs_;
            }

            os_ << '\n';
            os_ << "        if (*ptr)\n";
            os_ << "        {\n";
            os_ << "            end_state = true;\n";


            if (internals_._features & *feature_bit::recursive)
            {
                os_ << "            pop = (";

                if (pointers_)
                {
                    // Done this way for GCC:
                    os_ << "static_cast<id_type>(reinterpret_cast<ptrdiff_t>(";
                }

                os_ << "*ptr";

                if (pointers_)
                {
                    os_ << ')';
                }

                os_ << " & " << *state_bit::pop_dfa;

                if (pointers_)
                {
                    os_ << ')';
                }

                os_ << ") != 0;\n";
            }

            os_ << "            id = ";

            if (pointers_)
            {
                // Done this way for GCC:
                os_ << "static_cast<id_type>(reinterpret_cast<ptrdiff_t>(";
            }

            os_ << "*(ptr + " << *state_index::id << ")";

            if (pointers_)
            {
                os_ << "))";
            }

            os_ << ";\n";
            os_ << "            uid = ";

            if (pointers_)
            {
                // Done this way for GCC:
                os_ << "static_cast<id_type>(reinterpret_cast<ptrdiff_t>(";
            }

            os_ << "*(ptr + " << *state_index::user_id << ")";

            if (pointers_)
            {
                os_ << "))";
            }

            os_ << ";\n";

            if (internals_._features & *feature_bit::recursive)
            {
                os_ << "            push_dfa = ";

                if (pointers_)
                {
                    // Done this way for GCC:
                    os_ << "static_cast<id_type>(reinterpret_cast<ptrdiff_t>(";
                }

                os_ << "*(ptr + " << *state_index::push_dfa << ')';

                if (pointers_)
                {
                    os_ << "))";
                }

                os_ << ";\n";
            }

            if (internals_._dfa.size() > 1)
            {
                os_ << "            start_state = ";

                if (pointers_)
                {
                    // Done this way for GCC:
                    os_ << "static_cast<id_type>(reinterpret_cast<ptrdiff_t>(";
                }

                os_ << "*(ptr + " << *state_index::next_dfa << ')';

                if (pointers_)
                {
                    os_ << "))";
                }

                os_ << ";\n";
            }

            if (internals_._features & *feature_bit::bol)
            {
                os_ << "            end_bol = bol;\n";
            }

            os_ << "            end_token = curr;\n";
            os_ << "        }\n";
            os_ << "    }\n\n";
            output_quit(os_, std::integral_constant<bool,
                (sizeof(typename sm::traits::input_char_type) > 1)>());

            if (internals_._features & *feature_bit::eol)
            {
                os_ << "    if (curr == results->eoi)\n";
                os_ << "    {\n";
                os_ << "        EOL_state = ";

                if (pointers_)
                {
                    os_ << "reinterpret_cast<const void * const *>(";
                }

                os_ << "ptr[" << *state_index::eol << ']';

                if (pointers_)
                {
                    os_ << ')';
                }

                os_ << ";\n";
                os_ << "\n";
                os_ << "        if (EOL_state)\n";
                os_ << "        {\n";
                os_ << "            ptr = ";

                if (pointers_)
                {
                    os_ << "EOL_state";
                }
                else
                {
                    os_ << "&dfa[EOL_state * dfa_alphabet]";
                }

                os_ << ";\n\n";
                os_ << "            if (*ptr)\n";
                os_ << "            {\n";
                os_ << "                end_state = true;\n";


                if (internals_._features & *feature_bit::recursive)
                {
                    os_ << "                pop = (";

                    if (pointers_)
                    {
                        // Done this way for GCC:
                        os_ << "static_cast<id_type>"
                            "(reinterpret_cast<ptrdiff_t>(";
                    }

                    os_ << "*ptr";

                    if (pointers_)
                    {
                        os_ << ')';
                    }

                    os_ << " & " << *state_bit::pop_dfa;

                    if (pointers_)
                    {
                        os_ << ')';
                    }

                    os_ << ") != 0;\n";
                }

                os_ << "                id = ";

                if (pointers_)
                {
                    // Done this way for GCC:
                    os_ << "static_cast<id_type>(reinterpret_cast<ptrdiff_t>(";
                }

                os_ << "*(ptr + " << *state_index::id << ")";

                if (pointers_)
                {
                    os_ << "))";
                }

                os_ << ";\n";
                os_ << "                uid = ";

                if (pointers_)
                {
                    // Done this way for GCC:
                    os_ << "static_cast<id_type>(reinterpret_cast<ptrdiff_t>(";
                }

                os_ << "*(ptr + " << *state_index::user_id << ")";

                if (pointers_)
                {
                    os_ << "))";
                }

                os_ << ";\n";

                if (internals_._features & *feature_bit::recursive)
                {
                    os_ << "                push_dfa = ";

                    if (pointers_)
                    {
                        // Done this way for GCC:
                        os_ << "static_cast<id_type>"
                            "(reinterpret_cast<ptrdiff_t>(";
                    }

                    os_ << "*(ptr + " << *state_index::push_dfa << ')';

                    if (pointers_)
                    {
                        os_ << "))";
                    }

                    os_ << ";\n";
                }

                if (internals_._dfa.size() > 1)
                {
                    os_ << "                start_state = ";

                    if (pointers_)
                    {
                        // Done this way for GCC:
                        os_ << "static_cast<id_type>"
                            "(reinterpret_cast<ptrdiff_t>(";
                    }

                    os_ << "*(ptr + " << *state_index::next_dfa << ')';

                    if (pointers_)
                    {
                        os_ << "))";
                    }

                    os_ << ";\n";
                }

                if (internals_._features & *feature_bit::bol)
                {
                    os_ << "                end_bol = bol;\n";
                }

                os_ << "                end_token = curr;\n";
                os_ << "            }\n";
                os_ << "        }\n";
                os_ << "    }\n\n";
            }

            os_ << "    if (end_state)\n";
            os_ << "    {\n";
            os_ << "        // Return longest match\n";

            if (internals_._features & *feature_bit::recursive)
            {
                os_ << "        if (pop)\n";
                os_ << "        {\n";
                os_ << "            start_state =  results->"
                    "stack.top().first;\n";
                os_ << "            results->stack.pop();\n";
                os_ << "        }\n";
                os_ << "        else if (push_dfa != results_npos)\n";
                os_ << "        {\n";
                os_ << "            results->stack.push(id_type_pair(push_dfa, id));\n";
                os_ << "        }\n\n";
            }

            if (internals_._dfa.size() > 1)
            {
                os_ << "        results->state = start_state;\n";
            }

            if (internals_._features & *feature_bit::bol)
            {
                os_ << "        results->bol = end_bol;\n";
            }

            os_ << "        results->second = end_token;\n";

            if (internals_._features & *feature_bit::skip)
            {
                // We want a number regardless of id_type.
                os_ << "\n        if (id == results_skip) goto skip;\n";
            }
            if (internals_._features & *feature_bit::reject)
            {
                os_ << "	else if (id == results_reject)\n"
                       "        {\n"
                       "            curr = results->second = results->first = saved_curr;\n"
                       "            results->bol = saved_bol;\n"
                       "            results->id = results_npos;\n"
                       "            goto reject;\n"
                       "        }\n";
            }

            if (internals_._features & *feature_bit::again)
            {
                // We want a number regardless of id_type.
                os_ << "\n        if (id == "
                    << static_cast<std::size_t>(internals_._eoi);

                if (internals_._features & *feature_bit::recursive)
                {
                    os_ << " || (pop && !results->stack.empty() &&\n";
                    // We want a number regardless of id_type.
                    os_ << "            results->stack.top().second == "
                        << static_cast<std::size_t>(internals_._eoi) << ')';
                }

                os_ << ")\n";
                os_ << "        {\n";
                os_ << "            curr = end_token;\n";
                os_ << "            goto again;\n";
                os_ << "        }\n";
            }

            os_ << "    }\n";
            os_ << "    else\n";
            os_ << "    {\n";
            os_ << "        // No match causes char to be skipped\n";
            os_ << "        results->second = end_token;\n";

            if (internals_._features & *feature_bit::bol)
            {
                os_ << "        results->bol = *results->second == '\\n';\n";
            }

            os_ << "        results->first = results->second;\n";
            os_ << "        ++results->second;\n";
            os_ << "        id = results_npos;\n";
            os_ << "        uid = results_npos;\n";
            os_ << "    }\n\n";
            os_ << "    results->id = id;\n";
            os_ << "    results->user_id = uid;\n";
            os_ << "}\n";
        }

        template<typename char_type, typename id_type>
        static void dump_tables
        (const basic_state_machine<char_type, id_type>& sm_,
            const std::size_t tabs_, const bool pointers_, std::ostream& os_)
        {
            const auto& internals_ = sm_.data();
            const std::size_t lookup_divisor_ = 8;
            // Lookup is always 256 entries long now
            const std::size_t lookup_quotient_ = LEXERTL_LOOKUP_SIZE / lookup_divisor_;
            const std::size_t dfas_ = internals_._lookup.size();

            output_tabs(tabs_, os_);
            os_ << "static const size_type lexer_dfa_count = " << std::dec << dfas_ << ";\n";
            os_ << "static const size_type lexer_dfa_lookup_count = "  << std::dec << LEXERTL_LOOKUP_SIZE << ";\n";
            os_ << "static const id_type lexer_lookups[" << std::dec << dfas_ << "][" << LEXERTL_LOOKUP_SIZE << "] =\n";
            output_tabs(tabs_ + 1, os_);
            os_ << '{';

            for (std::size_t l_ = 0; l_ < dfas_; ++l_)
            {
                const id_type* ptr_ = &internals_._lookup[l_].front();

                // We want numbers regardless of id_type.
                os_ << "{ // ["  << std::dec << l_ << "] " << lookup_quotient_
                        << " rows by " << lookup_divisor_ << " cols\n";
                output_tabs(tabs_ + 1, os_);
                os_ << "/*0*/ ";
                os_ << "0x" << std::hex << static_cast<std::size_t>(*ptr_++);

                for (std::size_t col_ = 1; col_ < lookup_divisor_; ++col_)
                {
                    // We want numbers regardless of id_type.
                    os_ << ", 0x" << std::hex <<
                        static_cast<std::size_t>(*ptr_++);
                }

                for (std::size_t row_ = 1; row_ < lookup_quotient_; ++row_)
                {
                    os_ << ",\n";
                    output_tabs(tabs_ + 1, os_);
                    os_ << "/*" << std::dec << row_ <<  "*/ ";
                    // We want numbers regardless of id_type.
                    os_ << "0x" << std::hex <<
                        static_cast<std::size_t>(*ptr_++);

                    for (std::size_t col_ = 1; col_ < lookup_divisor_; ++col_)
                    {
                        // We want numbers regardless of id_type.
                        os_ << ", 0x" << std::hex <<
                            static_cast<std::size_t>(*ptr_++);
                    }
                }

                os_ << "\n";
                output_tabs(tabs_ + 1, os_);
                os_ << '}';

                if (l_ + 1 < dfas_)
                {
                    os_ << ",\n";
                    output_tabs(tabs_ + 1, os_);
                }
            }
            os_ << "};\n";

            output_tabs(tabs_, os_);
            os_ << "static const id_type lexer_dfa_alphabets[" << std::dec << dfas_ << "] = {";

            // We want numbers regardless of id_type.
            os_ << "0x" << std::hex << static_cast<std::size_t>
                (internals_._dfa_alphabet[0])
                << " /*" << std::dec << internals_._dfa_alphabet[0] << "*/";

            for (std::size_t col_ = 1; col_ < dfas_; ++col_)
            {
                // We want numbers regardless of id_type.
                os_ << ", 0x" << std::hex <<
                    static_cast<std::size_t>(internals_._dfa_alphabet[col_])
                    << " /*" << std::dec << internals_._dfa_alphabet[col_] << "*/";
            }
            os_ << "};\n";

            // DFAs are usually different sizes, so dump separately
            for (std::size_t dfa_ = 0; dfa_ < dfas_; ++dfa_)
            {
                const id_type dfa_alphabet_ = internals_._dfa_alphabet[dfa_];
                const std::size_t rows_ = internals_._dfa[dfa_].size() /
                    dfa_alphabet_;
                const id_type* ptr_ = &internals_._dfa[dfa_].front();
                std::string dfa_name_ = "dfa";

                output_tabs(tabs_, os_);
                os_ << "static const ";

                if (pointers_)
                {
                    os_ << "void *";
                }
                else
                {
                    os_ << "id_type lexer_";
                }

                os_ << dfa_name_;

                if (dfas_ > 1)
                {
                    std::ostringstream ss_;

                    ss_ << dfa_;
                    dfa_name_ += ss_.str();
                    os_ << std::dec << dfa_;
                }
                else
                {
                    os_ << "0";
                }

                dfa_name_ += '_';
                os_ << "[" << std::dec << (rows_* dfa_alphabet_) << "] = { // "
                        << std::dec  << rows_ << " rows by "
                        << dfa_alphabet_ << " cols\n";
                output_tabs(tabs_ + 1, os_);

                for (std::size_t row_ = 0; row_ < rows_; ++row_)
                {
                    os_ << "/*" << std::dec << row_ <<  "*/ ";
                    dump_row(row_ == 0, ptr_, dfa_name_, dfa_alphabet_,
                        pointers_, os_);

                    if (row_ + 1 < rows_)
                    {
                        os_ << ",\n";
                        output_tabs(tabs_ + 1, os_);
                    }
                }
                os_ << "\n";
                output_tabs(tabs_ + 1, os_);
                os_ << "};\n";
            }

            output_tabs(tabs_, os_);
            os_ << "static const ";

            if (pointers_)
            {
                os_ << "void * const";
            }
            else
            {
                os_ << "id_type";
            }

            os_ << " *lexer_dfas["  << std::dec << dfas_ <<  "] = {lexer_dfa0";

            for (std::size_t col_ = 1; col_ < dfas_; ++col_)
            {
                os_ << ", lexer_dfa" << col_;
            }

            os_ << "};\n";

            os_ << std::dec;
        }

    protected:
        template<typename id_type>
        static void dump_row(const bool first_, const id_type*& ptr_,
            const std::string& dfa_name_, const id_type dfa_alphabet_,
            const bool pointers_, std::ostream& os_)
        {
            if (pointers_)
            {
                bool zero_ = *ptr_ == 0;

                if (first_)
                {
                    // We want numbers regardless of id_type.
                    os_ << dfa_name_ << " + 0x" << std::hex <<
                        static_cast<std::size_t>(*ptr_++) * dfa_alphabet_;
                }
                else if (!zero_)
                {
                    os_ << "reinterpret_cast<const void *>(0x"
                        // We want numbers regardless of id_type.
                        << std::hex << static_cast<std::size_t>(*ptr_++) << ')';
                }
                else
                {
                    // We want numbers regardless of id_type.
                    os_ << "0x" << std::hex <<
                        static_cast<std::size_t>(*ptr_++);
                }

                for (id_type id_index_ = *state_index::id;
                    id_index_ < *state_index::transitions; ++id_index_, ++ptr_)
                {
                    os_ << ", ";
                    zero_ = *ptr_ == 0;

                    if (!zero_)
                    {
                        os_ << "reinterpret_cast<const void *>(";
                    }

                    // We want numbers regardless of id_type.
                    os_ << "0x" << std::hex << static_cast<std::size_t>(*ptr_);

                    if (!zero_)
                    {
                        os_ << ')';
                    }
                }

                for (id_type alphabet_ = *state_index::transitions;
                    alphabet_ < dfa_alphabet_; ++alphabet_, ++ptr_)
                {
                    // We want numbers regardless of id_type.
                    os_ << ", ";

                    if (*ptr_ == 0)
                    {
                        os_ << 0;
                    }
                    else
                    {
                        // We want numbers regardless of id_type.
                        os_ << dfa_name_ + " + 0x" << std::hex <<
                            static_cast<std::size_t>(*ptr_) * dfa_alphabet_;
                    }
                }
            }
            else
            {
                // We want numbers regardless of id_type.
                os_ << "0x" << std::hex << static_cast<std::size_t>(*ptr_++);

                for (id_type alphabet_ = 1; alphabet_ < dfa_alphabet_;
                    ++alphabet_, ++ptr_)
                {
                    if(dfa_alphabet_ >= 20 && ((alphabet_ % 10) == 0))
                    {
                        os_ << " /*" << std::dec << alphabet_ << "*/ ";
                    }
                    // We want numbers regardless of id_type.
                    os_ << ", 0x" << std::hex <<
                        static_cast<std::size_t>(*ptr_);
                }
            }
        }

        static void output_tabs(const std::size_t tabs_, std::ostream& os_)
        {
            for (std::size_t i_ = 0; i_ < tabs_; ++i_)
            {
                os_ << "    ";
            }
        }

        template<typename id_type>
        static void output_char_loop(const id_type features_,
            const std::size_t additional_tabs_, const bool pointers_,
            std::ostream& os_, const std::false_type&)
        {
            output_tabs(additional_tabs_, os_);
            os_ << "        const char_type prev_char = "
                "*curr++;\n";
            output_tabs(additional_tabs_, os_);
            os_ << "        const ";

            if (pointers_)
            {
                os_ << "void * const *";
            }
            else
            {
                os_ << "id_type ";
            }

            os_ << "state = ";

            if (pointers_)
            {
                os_ << "reinterpret_cast<void * const *>\n            ";
                output_tabs(additional_tabs_, os_);
                os_ << '(';
            }

            os_ << "ptr[lookup";

            if (!pointers_)
            {
                os_ << "\n            ";
                output_tabs(additional_tabs_, os_);
            }

            os_ << "[static_cast<index_type>";

            if (pointers_)
            {
                os_ << "\n            ";
                output_tabs(additional_tabs_, os_);
            }

            os_ << "(prev_char)]]";

            if (pointers_)
            {
                os_ << ')';
            }

            os_ << ";\n\n";

            if (features_ & *feature_bit::bol)
            {
                output_tabs(additional_tabs_, os_);
                os_ << "        bol = prev_char == '\\n';\n\n";
            }

            output_tabs(additional_tabs_, os_);
            os_ << "        if (state == 0)\n";
            output_tabs(additional_tabs_, os_);
            os_ << "        {\n";

            if (features_ & *feature_bit::eol)
            {
                output_tabs(additional_tabs_, os_);
                os_ << "            EOL_state = 0;\n";
            }

            output_tabs(additional_tabs_, os_);
            os_ << "            break;\n";
            output_tabs(additional_tabs_, os_);
            os_ << "        }\n\n";
            output_tabs(additional_tabs_, os_);
            os_ << "        ptr = ";

            if (pointers_)
            {
                os_ << "state";
            }
            else
            {
                os_ << "&dfa[state * dfa_alphabet]";
            }

            os_ << ";\n";
        }

        template<typename id_type>
        static void output_char_loop(const id_type features_,
            const std::size_t additional_tabs_, const bool pointers_,
            std::ostream& os_, const std::true_type&)
        {
            output_tabs(additional_tabs_, os_);
            os_ << "        const std::size_t bytes =\n";
            output_tabs(additional_tabs_, os_);
            os_ << "            sizeof(char_type) < 3 ?\n";
            output_tabs(additional_tabs_, os_);
            os_ << "            sizeof(char_type) : 3;\n";
            output_tabs(additional_tabs_, os_);
            os_ << "        const std::size_t shift[] = {0, 8, 16};\n";
            output_tabs(additional_tabs_, os_);
            os_ << "        char_type prev_char = "
                "*curr++;\n\n";

            if (features_ & *feature_bit::bol)
            {
                output_tabs(additional_tabs_, os_);
                os_ << "        bol = prev_char == '\\n';\n\n";
            }

            output_tabs(additional_tabs_, os_);
            os_ << "        for (std::size_t i = 0; i < bytes; ++i)\n";
            output_tabs(additional_tabs_, os_);
            os_ << "        {\n";
            output_tabs(additional_tabs_, os_);
            os_ << "            const ";

            if (pointers_)
            {
                os_ << "void * const *";
            }
            else
            {
                os_ << "id_type ";
            }

            os_ << "state = ";

            if (pointers_)
            {
                os_ << "reinterpret_cast<void * const *>\n                ";
                output_tabs(additional_tabs_, os_);
                os_ << '(';
            }

            os_ << "ptr[lookup[static_cast\n";
            output_tabs(additional_tabs_, os_);
            os_ << "                <unsigned char>((prev_char >>\n"
                "                shift[bytes - 1 - i]) & 0xff)]]";

            if (pointers_)
            {
                os_ << ')';
            }

            os_ << ";\n\n";
            output_tabs(additional_tabs_, os_);
            os_ << "            if (state == 0)\n";
            output_tabs(additional_tabs_, os_);
            os_ << "            {\n";

            if (features_ & *feature_bit::eol)
            {
                output_tabs(additional_tabs_, os_);
                os_ << "                EOL_state = 0;\n";
            }

            output_tabs(additional_tabs_, os_);
            os_ << "                goto quit;\n";
            output_tabs(additional_tabs_, os_);
            os_ << "            }\n\n";
            output_tabs(additional_tabs_, os_);
            os_ << "            ptr = ";

            if (pointers_)
            {
                os_ << "state";
            }
            else
            {
                os_ << "&dfa[state * dfa_alphabet]";
            }

            os_ << ";\n";
            output_tabs(additional_tabs_, os_);
            os_ << "        }\n";
        }

        static void output_quit(std::ostream&, const std::false_type&)
        {
            // Nothing to do
        }

        static void output_quit(std::ostream& os_, const std::true_type&)
        {
            os_ << "quit:\n";
        }
    };
}

#endif
