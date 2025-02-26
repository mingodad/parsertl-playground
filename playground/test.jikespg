%Options NOGOTODEFAULT
%Options ESC=$
%Options ACTFILENAME=lpgact.c
%Options FILEPREFIX=lpg
%Options GENERATEPARSER=c
%Options SUFFIX=_TK
%Options STACKSIZE=21
%Options HACTFILENAME=lpgact.h

$Define ----------------------------------------------------------------

$offset /.    ./

$location
/.

/// $rule_text
#line $next_line "$input_file"./

$action
/.act$rule_number, /* $rule_number */./

$null_action
/.$offset null_action, /* $rule_number */./

$no_action
/.$offset null_action, /* $rule_number */./

------------------------------------------------------------------------

$Terminals
    DEFINE_KEY TERMINALS_KEY ALIAS_KEY START_KEY RULES_KEY
    NAMES_KEY END_KEY

    EQUIVALENCE ARROW OR

    EMPTY_SYMBOL ERROR_SYMBOL EOL_SYMBOL EOF_SYMBOL

    MACRO_NAME SYMBOL BLOCK HBLOCK

    EOF

------------------------------------------------------------------------

$Alias

    '::=' ::= EQUIVALENCE
    '->'  ::= ARROW
    '|'   ::= OR
    $EOF  ::= EOF

------------------------------------------------------------------------

$Rules
/:#pragma once:/

/:

/// BUILD_SYMNO constructs the SYMNO table which is a mapping from each
/// symbol number into that symbol.
void build_symno(struct ParserState* ps) {
  const long symno_size = num_symbols + 1;
  calloc0p(&ps->symno, symno_size, struct symno_type);
  // Go through entire hash table. For each non_empty bucket, go through
  // linked list in that bucket.
  for (int i = 0; i < HT_SIZE; ++i) {
    for (const struct hash_type *p = ps->hash_table[i]; p != NULL; p = p->link) {
      const int symbol = p->number;
      // Not an alias
      if (symbol >= 0) {
        ps->symno[symbol].name_index = OMEGA;
        ps->symno[symbol].ptr = p->st_ptr;
      }
    }
  }
}

:/

/:static void (*rule_action[]) (struct ParserState* ps) = {NULL,:/

/.
#include "common.h"

#line $next_line "$input_file"

#define SYM1 (ps->terminal[ps->stack_top + 1])
#define SYM2 (ps->terminal[ps->stack_top + 2])
#define SYM3 (ps->terminal[ps->stack_top + 3])

static void null_action(struct ParserState* ps)
{
}

static void add_macro_definition(const char *name, const struct terminal_type *term, struct ParserState* ps)
{
    if (ps->num_defs >= (int)ps->defelmt_size)
    {
        ps->defelmt_size += DEFELMT_INCREMENT;
        ps->defelmt = (struct defelmt_type *)
            (ps->defelmt == (struct defelmt_type *) NULL
             ? malloc(ps->defelmt_size * sizeof(struct defelmt_type))
             : realloc(ps->defelmt, ps->defelmt_size * sizeof(struct defelmt_type)));
        if (ps->defelmt == (struct defelmt_type *) NULL)
            nospace();
    }

    ps->defelmt[ps->num_defs].length       = term->length;
    ps->defelmt[ps->num_defs].start_line   = term->start_line;
    ps->defelmt[ps->num_defs].start_column = term->start_column;
    ps->defelmt[ps->num_defs].end_line     = term->end_line;
    ps->defelmt[ps->num_defs].end_column   = term->end_column;
    strcpy(ps->defelmt[ps->num_defs].name, name);
    ps->num_defs++;
}

static void add_block_definition(const struct terminal_type *term, struct ParserState* ps)
{
    if (ps->num_acts >= (int) ps->actelmt_size)
    {
        ps->actelmt_size += ACTELMT_INCREMENT;
        ps->actelmt = (struct actelmt_type *)
            (ps->actelmt == (struct actelmt_type *) NULL
             ? malloc(ps->actelmt_size * sizeof(struct actelmt_type))
             : realloc(ps->actelmt, ps->actelmt_size * sizeof(struct actelmt_type)));
        if (ps->actelmt == (struct actelmt_type *) NULL)
            nospace();
    }

    ps->actelmt[ps->num_acts].rule_number  = num_rules;
    ps->actelmt[ps->num_acts].start_line   = term->start_line;
    ps->actelmt[ps->num_acts].start_column = term->start_column;
    ps->actelmt[ps->num_acts].end_line     = term->end_line;
    ps->actelmt[ps->num_acts].end_column   = term->end_column;
    ps->actelmt[ps->num_acts].header_block = term->kind == HBLOCK_TK;
    ps->num_acts++;
}
./
    LPG_INPUT ::= [define_block]
                  [terminals_block]
                  [alias_block]
                  [start_block]
                  [rules_block]
                  [names_block]
                  [%END]
/:$no_action:/
                | bad_symbol
/:$no_action:/

    bad_symbol ::= EQUIVALENCE
/:$offset bad_first_symbol, /* $rule_number */:/
/.$location
static void bad_first_symbol(struct ParserState* ps)
{
    PRNTERR2("First symbol: \"%s\" found in file is illegal. Line %ld, column %d", SYM1.name, SYM1.start_line, SYM1.start_column);
    exit(12);
}
./
                 | ARROW
/:$offset bad_first_symbol, /* $rule_number */:/
                 | OR
/:$offset bad_first_symbol, /* $rule_number */:/
                 | EMPTY_SYMBOL
/:$offset bad_first_symbol, /* $rule_number */:/
                 | ERROR_SYMBOL
/:$offset bad_first_symbol, /* $rule_number */:/
                 | MACRO_NAME
/:$offset bad_first_symbol, /* $rule_number */:/
                 | SYMBOL
/:$offset bad_first_symbol, /* $rule_number */:/
                 | BLOCK
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    PRNTERR2("Action block cannot be first object in file. Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./

    define_block ::= DEFINE_KEY
/:$no_action:/
                   | DEFINE_KEY macro_list
/:$no_action:/

    macro_list ::= macro_name_symbol macro_block
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    add_macro_definition(SYM1.name, &(SYM2), ps);
}
./
                 | macro_list macro_name_symbol macro_block
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    add_macro_definition(SYM2.name, &(SYM3), ps);
}
./

    macro_name_symbol ::= MACRO_NAME
/:$no_action:/
                        | SYMBOL          -- Warning, Escape missing !
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    PRNTWNG2("Macro name \"%s\" does not start with the escape character. Line %ld, column %d", SYM1.name, SYM1.start_line, SYM1.start_column);
}
./
                        | '|'             -- No Good !!!
/:$offset bad_macro_name, /* $rule_number */:/
/.$location
static void bad_macro_name(struct ParserState* ps)
{
    PRNTERR2("Reserved symbol cannot be used as macro name. Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./
                        | EMPTY_SYMBOL    -- No good !!!
/:$offset bad_macro_name, /* $rule_number */:/
                        | ERROR_SYMBOL    -- No good !!!
/:$offset bad_macro_name, /* $rule_number */:/
                        | produces        -- No good !!!
/:$offset bad_macro_name, /* $rule_number */:/
                        | BLOCK           -- No good !!!
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    PRNTERR2("Macro name not supplied for macro definition. Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./
                        | DEFINE_KEY         -- No good !!!
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    PRNTERR2("Macro keyword misplaced. Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./

    macro_block ::= BLOCK
/:$no_action:/
                  | '|'            -- No Good !!!
/:$offset definition_expected, /* $rule_number */:/
/.$location
static void definition_expected(struct ParserState* ps)
{
    PRNTERR2("Definition block expected where symbol found. Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./
                  | EMPTY_SYMBOL   -- No good !!!
/:$offset definition_expected, /* $rule_number */:/
                  | ERROR_SYMBOL   -- No good !!!
/:$offset definition_expected, /* $rule_number */:/
                  | produces       -- No good !!!
/:$offset definition_expected, /* $rule_number */:/
                  | SYMBOL         -- No good !!!
/:$offset definition_expected, /* $rule_number */:/
                  | keyword        -- No good !!!
/:$offset definition_expected, /* $rule_number */:/
                  | END_KEY        -- No good !
/:$offset definition_expected, /* $rule_number */:/


    terminals_block ::= TERMINALS_KEY {terminal_symbol}
/:$no_action:/

    terminal_symbol ::= SYMBOL
/:$offset process_terminal, /* $rule_number */:/
/.$location
static void process_terminal(struct ParserState* ps)
{
    assign_symbol_no(SYM1.name, OMEGA, ps);
}
./
                      | '|'
/:$offset process_terminal, /* $rule_number */:/
                      | produces
/:$offset process_terminal, /* $rule_number */:/
                      | DEFINE_KEY         -- No Good !!!
/:$offset bad_terminal, /* $rule_number */:/
/.$location
static void bad_terminal(struct ParserState* ps)
{
    PRNTERR2("Keyword  has been misplaced in Terminal section.  Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./
                      | TERMINALS_KEY      -- No Good !!!
/:$offset bad_terminal, /* $rule_number */:/
                      | BLOCK           -- No good !!!
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    PRNTERR2("Misplaced block found in TERMINALS section.  Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./

    alias_block ::= ALIAS_KEY {alias_definition}
/:$no_action:/

   alias_definition ::= alias_lhs produces alias_rhs
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    int image;
    char tok_string[SYMBOL_SIZE + 1];

    switch(SYM3.kind)
    {
        case EMPTY_SYMBOL_TK:
            image = empty;
            break;

        case SYMBOL_TK:
            assign_symbol_no(SYM3.name, OMEGA, ps);
            image = symbol_image(SYM3.name, ps);
            break;

        case ERROR_SYMBOL_TK:
            if (error_image > num_terminals)
            {
                restore_symbol(tok_string, kerror, ps->ormark, ps->escape);
                PRNTERR2("Illegal aliasing to %s prior to its definition.  Line %ld, column %d", tok_string, SYM3.start_line, SYM3.start_column);
                exit(12);
            }
            image = error_image;
            break;

        case EOF_SYMBOL_TK:
            if (eoft_image > num_terminals)
            {
                restore_symbol(tok_string, keoft, ps->ormark, ps->escape);
                PRNTERR2("Illegal aliasing to %s prior to its definition. Line %ld, column %d", tok_string, SYM3.start_line, SYM3.start_column);
                exit(12);
            }
            image = eoft_image;
            break;

        case EOL_SYMBOL_TK:
            if (eolt_image == OMEGA)
            {
                PRNTERR2("Illegal aliasing to EOL prior to its definition. Line %ld, column %d", SYM3.start_line, SYM3.start_column);
                exit(12);
            }
            image = eolt_image;
            break;

        default: /* if SYM3.kind == symbol */
            image = symbol_image(SYM3.name, ps);
            break;
    }

    switch(SYM1.kind)
    {
        case SYMBOL_TK:
            if (symbol_image(SYM1.name, ps) != OMEGA)
            {
                restore_symbol(tok_string, SYM1.name, ps->ormark, ps->escape);
                PRNTERR2("Symbol %s was previously defined. Line %ld, column %d", tok_string, SYM1.start_line, SYM1.start_column);
                exit(12);
            }
            assign_symbol_no(SYM1.name, image, ps);
            break;

        case ERROR_SYMBOL_TK:
            if (error_image > num_terminals || ! ps->error_maps_bit)
            {
                if (image == empty      || image == eolt_image ||
                    image == eoft_image || image > num_terminals)
                {
                    restore_symbol(tok_string, kerror, ps->ormark, ps->escape);
                    PRNTERR2("Illegal alias for symbol %s. Line %ld, column %d.", tok_string, SYM1.start_line, SYM1.start_column);
                    exit(12);
                }
                alias_map(kerror, image, ps);
                error_image = image;
            }
            else
            {
                restore_symbol(tok_string, kerror, ps->ormark, ps->escape);
                PRNTERR2("Symbol %s was previously defined. Line %ld, column %d", tok_string, SYM1.start_line, SYM1.start_column);
                exit(12);
            }
            break;

        case EOF_SYMBOL_TK:
            if (eoft_image > num_terminals)
            {
                if (image == empty       || image == eolt_image  ||
                    image == error_image || image > num_terminals)
                {
                    restore_symbol(tok_string, keoft, ps->ormark, ps->escape);
                    PRNTERR2("Illegal alias for symbol %s. Line %ld, column %d.", tok_string, SYM1.start_line, SYM1.start_column);
                    exit(12);
                }
                alias_map(keoft, image, ps);
                eoft_image = image;
            }
            else
            {
                restore_symbol(tok_string, keoft, ps->ormark, ps->escape);
                PRNTERR2("Symbol %s was previously defined.  %ld, column %d", tok_string, SYM1.start_line, SYM1.start_column);
                exit(12);
            }
            break;

        default: /* if SYM1.kind == EOL_SYMBOL */
            if (eolt_image == OMEGA)
            {
                if (image == empty ||
                    image == eoft_image ||
                    image == error_image ||
                    image > num_terminals)
                {
                    PRNTERR2("Illegal alias for symbol EOL. Line %ld, column %d.", SYM1.start_line, SYM1.start_column);
                    exit(12);
                }
                eolt_image = image;
            }
            else
            {
                PRNTERR2("Symbol EOL was previously defined. Line %ld, column %d", SYM1.start_line, SYM1.start_column);
                exit(12);
            }
            break;
    }
}
./
                       | bad_alias_lhs
/:$no_action:/
                       | alias_lhs bad_alias_rhs
/:$no_action:/
                       | alias_lhs produces bad_alias_rhs
/:$no_action:/

    alias_lhs ::= SYMBOL
/:$no_action:/
                | ERROR_SYMBOL
/:$no_action:/
                | EOL_SYMBOL
/:$no_action:/
                | EOF_SYMBOL
/:$no_action:/

    alias_rhs ::= SYMBOL
/:$no_action:/
                | ERROR_SYMBOL
/:$no_action:/
                | EOL_SYMBOL
/:$no_action:/
                | EOF_SYMBOL
/:$no_action:/
                | EMPTY_SYMBOL
/:$no_action:/
                | '|'
/:$no_action:/
                | produces
/:$no_action:/

    bad_alias_rhs ::= DEFINE_KEY
/:$offset bad_alias_rhs, /* $rule_number */:/
/.$location
static void bad_alias_rhs(struct ParserState* ps)
{
    PRNTERR2("Misplaced keyword found in Alias section. Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./
                    | TERMINALS_KEY
/:$offset bad_alias_rhs, /* $rule_number */:/
                    | ALIAS_KEY
/:$offset bad_alias_rhs, /* $rule_number */:/
                    | BLOCK
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    PRNTERR2("Misplaced block found in Alias section. Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./


    bad_alias_lhs ::= bad_alias_rhs
/:$no_action:/
                    | EMPTY_SYMBOL
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    PRNTERR2("Empty symbol cannot be aliased. Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./
                    | produces
/:$offset missing_quote, /* $rule_number */:/
/.$location
static void missing_quote(struct ParserState* ps)
{
    PRNTERR2("Symbol must be quoted when used as a grammar symbol. Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./
                    | '|'
/:$offset missing_quote, /* $rule_number */:/


    start_block ::= START_KEY {start_symbol}
/:$no_action:/

    start_symbol ::= SYMBOL
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    assign_symbol_no(SYM1.name, OMEGA, ps);
    struct node *q = Allocate_node();
    q -> value = symbol_image(SYM1.name, ps);
    if (ps->start_symbol_root == NULL)
        q -> next = q;
    else
    {
        q -> next = ps->start_symbol_root -> next;
        ps->start_symbol_root -> next = q;
    }
    ps->start_symbol_root = q;
    num_rules++;
    num_items++;
}
./
                  | '|'            -- No Good !!!
/:$offset bad_start_symbol, /* $rule_number */:/
/.$location
static void bad_start_symbol(struct ParserState* ps)
{
    PRNTERR2("Symbol cannot be used as Start symbol. Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./
                  | EMPTY_SYMBOL   -- No good !!!
/:$offset bad_start_symbol, /* $rule_number */:/
                  | ERROR_SYMBOL   -- No good !!!
/:$offset bad_start_symbol, /* $rule_number */:/
                  | produces       -- No good !!!
/:$offset bad_start_symbol, /* $rule_number */:/
                  | BLOCK          -- No good !!!
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    PRNTERR2("Misplaced block found in Start section. Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./
                  | DEFINE_KEY        -- No good !!!
/:$offset misplaced_keyword_found_in_START_section, /* $rule_number */:/
/.$location
static void misplaced_keyword_found_in_START_section(struct ParserState* ps)
{
    PRNTERR2("Misplaced keyword found in START section. Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./
                  | TERMINALS_KEY     -- No good !!!
/:$offset misplaced_keyword_found_in_START_section, /* $rule_number */:/
                  | ALIAS_KEY         -- No good !!!
/:$offset misplaced_keyword_found_in_START_section, /* $rule_number */:/
                  | START_KEY         -- No good !!!
/:$offset misplaced_keyword_found_in_START_section, /* $rule_number */:/

    rules_block ::= RULES_KEY
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{

    if (ps->start_symbol_root == NULL)
    {
        struct node *q = Allocate_node();
        q -> value = empty;
        q -> next = q;
        ps->start_symbol_root = q;
        num_rules = 0;                 // One rule
        num_items = 0;                 // 0 items
    }
    build_symno(ps);
}
./
                  | RULES_KEY rule_list
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    build_symno(ps);
}
./

    produces ::= '::='
/:$no_action:/
               | '->'
/:$no_action:/

    rule_list ::= {action_block} SYMBOL produces
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    assign_symbol_no(SYM2.name, OMEGA, ps);
    if (ps->start_symbol_root == NULL)
    {
        struct node *q = Allocate_node();
        q -> value = symbol_image(SYM2.name, ps);
        q -> next = q;

        ps->start_symbol_root = q;

        num_rules = 1;
        num_items = 1;
    }

/// Since we don't know for sure how many start symbols we have, a
/// "while" loop is used to increment the size of rulehdr. However,
/// it is highly unlikely that this loop would ever execute more than
/// once if the size of RULE_INCREMENT is reasonable.
    while (num_rules >= (int)ps->rulehdr_size)
    {
        ps->rulehdr_size += RULEHDR_INCREMENT;
        ps->rulehdr = (struct rulehdr_type *)
            (ps->rulehdr == (struct rulehdr_type *) NULL
             ? malloc(ps->rulehdr_size * sizeof(struct rulehdr_type))
             : realloc(ps->rulehdr, ps->rulehdr_size * sizeof(struct rulehdr_type)));
        if (ps->rulehdr == (struct rulehdr_type *) NULL)
            nospace();
    }

    ps->rulehdr[num_rules].sp = ((SYM3.kind == ARROW_TK) ? true : false);
    ps->rulehdr[num_rules].lhs = symbol_image(SYM2.name, ps);
    ps->rulehdr[num_rules].rhs_root = NULL;
}
./

                | rule_list '|'
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    num_rules++;
    if (num_rules >= (int)ps->rulehdr_size)
    {
        ps->rulehdr_size += RULEHDR_INCREMENT;
        ps->rulehdr = (struct rulehdr_type *)
            (ps->rulehdr == (struct rulehdr_type *) NULL
             ? malloc(ps->rulehdr_size * sizeof(struct rulehdr_type))
             : realloc(ps->rulehdr, ps->rulehdr_size * sizeof(struct rulehdr_type)));
        if (ps->rulehdr == (struct rulehdr_type *) NULL)
            nospace();
    }
    ps->rulehdr[num_rules].sp = ps->rulehdr[num_rules - 1].sp;
    ps->rulehdr[num_rules].lhs = OMEGA;
    ps->rulehdr[num_rules].rhs_root = NULL;
}
./
                | rule_list SYMBOL produces
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    num_rules++;
    if (num_rules >= (int)ps->rulehdr_size)
    {
        ps->rulehdr_size += RULEHDR_INCREMENT;
        ps->rulehdr = (struct rulehdr_type *)
            (ps->rulehdr == (struct rulehdr_type *) NULL
             ? malloc(ps->rulehdr_size * sizeof(struct rulehdr_type))
             : realloc(ps->rulehdr, ps->rulehdr_size * sizeof(struct rulehdr_type)));
        if (ps->rulehdr == (struct rulehdr_type *) NULL)
            nospace();
    }
    ps->rulehdr[num_rules].sp = ((SYM3.kind == ARROW_TK) ? true : false);
    assign_symbol_no(SYM2.name, OMEGA, ps);
    ps->rulehdr[num_rules].lhs = symbol_image(SYM2.name, ps);
    ps->rulehdr[num_rules].rhs_root = NULL;
}
./

                | rule_list EMPTY_SYMBOL
/:$no_action:/
                | rule_list action_block
/:$no_action:/
                | rule_list ERROR_SYMBOL
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    if (error_image == DEFAULT_SYMBOL)
    {
        char tok_string[SYMBOL_SIZE + 1];
        restore_symbol(tok_string, kerror, ps->ormark, ps->escape);
        PRNTERR2("%s not declared or aliased to terminal symbol. Line %ld, column %d", tok_string, SYM2.start_line, SYM2.start_column);
        exit(12);
    }
    struct node *q = Allocate_node();
    q -> value = error_image;
    num_items++;
    if (ps->rulehdr[num_rules].rhs_root == NULL)
        q -> next = q;
    else
    {
        q -> next = ps->rulehdr[num_rules].rhs_root -> next;
         ps->rulehdr[num_rules].rhs_root -> next = q;
    }
    ps->rulehdr[num_rules].rhs_root = q;
}
./
                | rule_list SYMBOL
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    assign_symbol_no(SYM2.name, OMEGA, ps);
    int sym = symbol_image(SYM2.name, ps);
    if (sym != empty)
    {
        if (sym == eoft_image)
        {
            PRNTERR2("End-of-file symbol cannot be used in rule. Line %ld, column %d", SYM2.start_line, SYM2.start_column);
            exit(12);
        }
        struct node *q = Allocate_node();
        q -> value = sym;
        num_items++;
        if (ps->rulehdr[num_rules].rhs_root == NULL)
            q -> next = q;
        else
        {
            q -> next = ps->rulehdr[num_rules].rhs_root -> next;
            ps->rulehdr[num_rules].rhs_root -> next = q;
        }
        ps->rulehdr[num_rules].rhs_root = q;
    }
}
./
                | '|'                    -- can't be first SYMBOL
/:$offset bad_first_symbol_in_RULES_section, /* $rule_number */:/
/.$location
static void bad_first_symbol_in_RULES_section(struct ParserState* ps)
{
    PRNTERR2("First symbol in Rules section is not a valid left-hand side.\n Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./
                | EMPTY_SYMBOL           -- can't be first SYMBOL
/:$offset bad_first_symbol_in_RULES_section, /* $rule_number */:/
                | ERROR_SYMBOL           -- can't be first SYMBOL
/:$offset bad_first_symbol_in_RULES_section, /* $rule_number */:/
                | keyword                -- keyword out of place
/:$offset bad_first_symbol_in_RULES_section, /* $rule_number */:/
                | rule_list '|' produces            -- No good !!!
/:$offset rule_without_left_hand_side, /* $rule_number */:/
/.$location
static void rule_without_left_hand_side(struct ParserState* ps)
{
    PRNTERR2("Rule without left-hand-side.  Line %ld, column %d", SYM3.start_line, SYM3.start_column);
    exit(12);
}
./
                | rule_list action_block produces          -- No good !!!
/:$offset rule_without_left_hand_side, /* $rule_number */:/
                | rule_list EMPTY_SYMBOL produces   -- No good !!!
/:$offset rule_without_left_hand_side, /* $rule_number */:/
                | rule_list keyword produces        -- No good !!!
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    PRNTWNG2("Misplaced keyword found in Rules section Line %ld, column %d",  SYM2.start_line, SYM2.start_column);
    exit(12);
}
./

    action_block ::= BLOCK
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    add_block_definition(&(SYM1), ps);
}
./
                   | HBLOCK
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    add_block_definition(&(SYM1), ps);
}
./

    keyword ::= DEFINE_KEY
/:$offset misplaced_keyword_found_in_RULES_section, /* $rule_number */:/
/.$location
static void misplaced_keyword_found_in_RULES_section(struct ParserState* ps)
{
    PRNTWNG2("Misplaced keyword found in RULES section. Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./
              | TERMINALS_KEY
/:$offset misplaced_keyword_found_in_RULES_section, /* $rule_number */:/
              | ALIAS_KEY
/:$offset misplaced_keyword_found_in_RULES_section, /* $rule_number */:/
              | START_KEY
/:$offset misplaced_keyword_found_in_RULES_section, /* $rule_number */:/
              | RULES_KEY
/:$offset misplaced_keyword_found_in_RULES_section, /* $rule_number */:/

    names_block ::= NAMES_KEY {names_definition}
/:$no_action:/

    names_definition ::= name produces name
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    if (ps->error_maps_bit)
    {
        int symbol;

        switch(SYM1.kind)
        {
            case EMPTY_SYMBOL_TK:
                symbol = empty;
                break;

            case ERROR_SYMBOL_TK:
                symbol = error_image;
                break;

            case EOL_SYMBOL_TK:
                symbol = eolt_image;
                break;

            case EOF_SYMBOL_TK:
                symbol = eoft_image;
                break;

            default:
                symbol = symbol_image(SYM1.name, ps);
                break;
        }

        if (symbol == OMEGA)
        {
            PRNTERR2("Symbol %s is undefined. Line %ld, column %d", SYM1.name, SYM1.start_line, SYM1.start_column);
            exit(12);
        }

        if (ps->symno[symbol].name_index != OMEGA)
        {
            PRNTERR2("Symbol %s has been named more than once. Line %ld, column %d.", SYM1.name, SYM1.start_line, SYM1.start_column);
            exit(12);
        }
        ps->symno[symbol].name_index = name_map(SYM3.name, ps);
     }
}
./
                       | bad_name produces name
/:$no_action:/
                       | name produces bad_name
/:$no_action:/

    name ::= SYMBOL
/:$no_action:/
           | EMPTY_SYMBOL
/:$no_action:/
           | ERROR_SYMBOL
/:$no_action:/
           | EOL_SYMBOL
/:$no_action:/
           | EOF_SYMBOL
/:$no_action:/
           | '|'
/:$no_action:/
           | produces
/:$no_action:/

      bad_name ::= DEFINE_KEY
/:$offset misplaced_keyword_found_in_NAMES_section, /* $rule_number */:/
/.$location
static void misplaced_keyword_found_in_NAMES_section(struct ParserState* ps)
{
    PRNTERR2("Keyword  has been misplaced in NAMES section.  Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./
                 | TERMINALS_KEY
/:$offset misplaced_keyword_found_in_NAMES_section, /* $rule_number */:/
                 | ALIAS_KEY
/:$offset misplaced_keyword_found_in_NAMES_section, /* $rule_number */:/
                 | START_KEY
/:$offset misplaced_keyword_found_in_NAMES_section, /* $rule_number */:/
                 | RULES_KEY
/:$offset misplaced_keyword_found_in_NAMES_section, /* $rule_number */:/
                 | NAMES_KEY
/:$offset misplaced_keyword_found_in_NAMES_section, /* $rule_number */:/
                 | BLOCK
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    PRNTERR2("Misplaced action block found in NAMES section. Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./
                 | MACRO_NAME
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    PRNTERR2("Misplaced macro name found in NAMES section. Line %ld, column %d", SYM1.start_line, SYM1.start_column);
    exit(12);
}
./

------------------------------------------------------------------------

[define_block] ::= $EMPTY
/:$no_action:/
                 | define_block
/:$no_action:/

[terminals_block] ::= $EMPTY
/:$offset process_TERMINALS_section, /* $rule_number */:/
/.$location
static void process_TERMINALS_section(struct ParserState* ps)
{
    num_terminals = num_symbols;
    assign_symbol_no(keoft, OMEGA, ps);
    eoft_image = symbol_image(keoft, ps);
    if (ps->error_maps_bit) {
        assign_symbol_no(kerror, OMEGA, ps);
        error_image = symbol_image(kerror, ps);
    } else {
      error_image = DEFAULT_SYMBOL;   // should be 0
    }
    assign_symbol_no(kaccept, OMEGA, ps);
    accept_image = symbol_image(kaccept, ps);
}
./
                    | terminals_block
/:$offset process_TERMINALS_section, /* $rule_number */:/

[alias_block] ::= $EMPTY
/:$offset process_ALIAS_section, /* $rule_number */:/
/.$location
static void process_ALIAS_section(struct ParserState* ps)
{

    int k = 0;
    if (eoft_image <= num_terminals) {
        k++;
    } else {
        num_terminals++;
    }

    if (ps->error_maps_bit)
    {
        if (error_image <= num_terminals)
            k++;
        else
        {
            num_terminals++;
            if (k == 1)
                error_image--;
        }
    }

    if (k > 0)
    {
        for (int i = 0; i < HT_SIZE; i++)
        {
            struct hash_type* p = ps->hash_table[i];
            while(p != NULL)
            {
                if (p -> number > num_terminals)
                    p -> number -= k;
                else if (p -> number < -num_terminals)
                    p -> number += k;
                p = p -> link;
            }
        }
        num_symbols -= k;
        accept_image -= k;
    }
    if (eolt_image == OMEGA)
        eolt_image = eoft_image;
    if (error_image == DEFAULT_SYMBOL)
        alias_map(kerror, DEFAULT_SYMBOL, ps);
}
./
                | alias_block
/:$offset process_ALIAS_section, /* $rule_number */:/

[start_block] ::= $EMPTY
/:$no_action:/
                | start_block
/:$no_action:/

[rules_block] ::= $EMPTY
/:$no_action:/
                | rules_block
/:$no_action:/

[names_block] ::= $EMPTY
/:$no_action:/
                | names_block
/:$no_action:/

[%END] ::= $EMPTY
/:$no_action:/
         | END_KEY
/:$no_action:/

------------------------------------------------------------------------

{terminal_symbol} ::= $EMPTY
/:$offset $action:/
/.$location
static void act$rule_number(struct ParserState* ps)
{
    assign_symbol_no(kempty, OMEGA, ps);
    empty = symbol_image(kempty, ps);
}
./
                    | {terminal_symbol} terminal_symbol
/:$no_action:/

{start_symbol} ::= $EMPTY
/:$no_action:/
                 | {start_symbol} start_symbol
/:$no_action:/

{alias_definition} ::= $EMPTY
/:$no_action:/
                     | {alias_definition} alias_definition
/:$no_action:/

{names_definition} ::= $EMPTY
/:$no_action:/
                     | {names_definition} names_definition
/:$no_action:/

{action_block} ::= $EMPTY
/:$no_action:/
                 | {action_block} action_block
/:$no_action:/

/:$offset NULL};:/
$End
