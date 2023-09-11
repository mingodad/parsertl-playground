%{

open Stretch
open Syntax
open Positions

(* An injection of symbol expressions into choice expressions. *)

let inject (e : symbol_expression located) : expression =
  Positions.pmap (fun pos e ->
    let branch =
      Branch (
          Positions.with_pos pos (ESingleton e),
          ParserAux.new_production_level()
      )
    in
    EChoice [ branch ]
  ) e

(* When a stretch has been created by [Lexer.mk_stretch] with [parenthesize]
   set to [true], it includes parentheses. In some (rare) cases, this is
   undesirable. The following function removes the parentheses a posteriori.
   They are replaced with whitespace, so as to not alter column numbers. *)

let rec find s n i =
  assert (i < n);
  if s.[i] = '(' then i
  else begin
    assert (s.[i] = ' ');
    find s n (i+1)
  end

let unparenthesize (s : string) : string =
  let n = String.length s in
  (* The string [s] must end with a closing parenthesis. *)
  assert (n >= 2 && s.[n-1] = ')');
  (* The string [s] must begin with a certain amount of spaces
     followed with an opening parenthesis. Find its offset [i]. *)
  let i = find s n 0 in
  (* Create a copy without the parentheses. *)
  let b = Bytes.of_string s in
  Bytes.set b i ' ';
  Bytes.set b (n-1) ' ';
  Bytes.to_string b

let unparenthesize (s : Stretch.t) : Stretch.t =
  { s with stretch_content = unparenthesize s.stretch_content }

let unparenthesize (o : Stretch.t option) : Stretch.t option =
  Option.map unparenthesize o

%}
%start grammar
%token <Syntax.raw_action> ACTION
%token <Attribute.attribute> ATTRIBUTE
%token BAR
%token COLON
%token COLONEQUAL
%token COMMA
%token EOF
%token EQUAL
%token EQUALEQUAL
%token <Attribute.attribute> GRAMMARATTRIBUTE
%token <Stretch.t> HEADER
%token INLINE
%token LEFT
%token LET
%token <string Positions.located> LID
%token LPAREN
%token NONASSOC
%token <Stretch.ocamltype> OCAMLTYPE
%token ON_ERROR_REDUCE
%token PARAMETER
%token PERCENTATTRIBUTE
%token <Stretch.t Lazy.t> PERCENTPERCENT
%token PLUS
%token PREC
%token PUBLIC
%token <string Positions.located> QID
%token QUESTION
%token RIGHT
%token RPAREN
%token SEMI
%token STAR
%token START
%token TILDE
%token TOKEN
%token TYPE
%token <string Positions.located> UID
%token UNDERSCORE
%nonassoc no_optional_bar
%nonassoc BAR
%type <Syntax.partial_grammar> grammar
%type <ParserAux.early_producer> producer
%type <ParserAux.early_production> production
%%

option_COMMA_:
  
    {    ( None )}
| COMMA
    {let x = () in
    ( Some x )}

option_OCAMLTYPE_:
  
    {    ( None )}
| OCAMLTYPE
    {let x = $1 in
    ( Some x )}

option_QID_:
  
    {    ( None )}
| QID
    {let x = $1 in
    ( Some x )}

boption_PUBLIC_:
  
    {    ( false )}
| PUBLIC
    {let _1 = () in
    ( true )}

loption_delimited_LPAREN_separated_nonempty_list_COMMA_expression__RPAREN__:
  
    {    ( [] )}
| LPAREN separated_nonempty_list_COMMA_expression_ RPAREN
    {let (_1, x, _3) = ((), $2, ()) in
let x =     ( x ) in
    ( x )}

loption_delimited_LPAREN_separated_nonempty_list_COMMA_lax_actual__RPAREN__:
  
    {    ( [] )}
| LPAREN separated_nonempty_list_COMMA_lax_actual_ RPAREN
    {let (_1, x, _3) = ((), $2, ()) in
let x =     ( x ) in
    ( x )}

loption_delimited_LPAREN_separated_nonempty_list_COMMA_strict_actual__RPAREN__:
  
    {    ( [] )}
| LPAREN separated_nonempty_list_COMMA_strict_actual_ RPAREN
    {let (_1, x, _3) = ((), $2, ()) in
let x =     ( x ) in
    ( x )}

loption_delimited_LPAREN_separated_nonempty_list_COMMA_symbol__RPAREN__:
  
    {    ( [] )}
| LPAREN separated_nonempty_list_COMMA_symbol_ RPAREN
    {let (_1, x, _3) = ((), $2, ()) in
let x =     ( x ) in
    ( x )}

loption_separated_nonempty_list_COMMA_pattern__:
  
    {    ( [] )}
| separated_nonempty_list_COMMA_pattern_
    {let x = $1 in
    ( x )}

list_ATTRIBUTE_:
  
    {    ( [] )}
| ATTRIBUTE list_ATTRIBUTE_
    {let (x, xs) = ($1, $2) in
    ( x :: xs )}

list_SEMI_:
  
    {    ( [] )}
| SEMI list_SEMI_
    {let (x, xs) = ((), $2) in
    ( x :: xs )}

list_declaration_:
  
    {    ( [] )}
| declaration list_declaration_
    {let (x, xs) = ($1, $2) in
    ( x :: xs )}

list_producer_:
  
    {    ( [] )}
| producer list_producer_
    {let (x, xs) = ($1, $2) in
    ( x :: xs )}

list_rule_:
  
    {    ( [] )}
| old_rule list_rule_
    {let (_1, xs) = ($1, $2) in
let x =     ( _1 ) in
    ( x :: xs )}
| new_rule list_rule_
    {let (_1, xs) = ($1, $2) in
let x =     ( NewRuleSyntax.rule _1 ) in
    ( x :: xs )}

nonempty_list_ATTRIBUTE_:
  ATTRIBUTE
    {let x = $1 in
    ( [ x ] )}
| ATTRIBUTE nonempty_list_ATTRIBUTE_
    {let (x, xs) = ($1, $2) in
    ( x :: xs )}

separated_nonempty_list_BAR_production_:
  production
    {let x = $1 in
    ( [ x ] )}
| production BAR separated_nonempty_list_BAR_production_
    {let (x, _2, xs) = ($1, (), $3) in
    ( x :: xs )}

separated_nonempty_list_BAR_production_group_:
  production_group
    {let x = $1 in
    ( [ x ] )}
| production_group BAR separated_nonempty_list_BAR_production_group_
    {let (x, _2, xs) = ($1, (), $3) in
    ( x :: xs )}

separated_nonempty_list_COMMA_expression_:
  expression
    {let x = $1 in
    ( [ x ] )}
| expression COMMA separated_nonempty_list_COMMA_expression_
    {let (x, _2, xs) = ($1, (), $3) in
    ( x :: xs )}

separated_nonempty_list_COMMA_lax_actual_:
  lax_actual
    {let x = $1 in
    ( [ x ] )}
| lax_actual COMMA separated_nonempty_list_COMMA_lax_actual_
    {let (x, _2, xs) = ($1, (), $3) in
    ( x :: xs )}

separated_nonempty_list_COMMA_pattern_:
  pattern
    {let x = $1 in
    ( [ x ] )}
| pattern COMMA separated_nonempty_list_COMMA_pattern_
    {let (x, _2, xs) = ($1, (), $3) in
    ( x :: xs )}

separated_nonempty_list_COMMA_strict_actual_:
  strict_actual
    {let x = $1 in
    ( [ x ] )}
| strict_actual COMMA separated_nonempty_list_COMMA_strict_actual_
    {let (x, _2, xs) = ($1, (), $3) in
    ( x :: xs )}

separated_nonempty_list_COMMA_symbol_:
  symbol
    {let x = $1 in
    ( [ x ] )}
| symbol COMMA separated_nonempty_list_COMMA_symbol_
    {let (x, _2, xs) = ($1, (), $3) in
    ( x :: xs )}

separated_nonempty_list_option_COMMA__nonterminal_:
  LID
    {let id = $1 in
let x =     ( id ) in
    ( [ x ] )}
| LID option_COMMA_ separated_nonempty_list_option_COMMA__nonterminal_
    {let (id, _2, xs) = ($1, $2, $3) in
let x =     ( id ) in
    ( x :: xs )}

separated_nonempty_list_option_COMMA__strict_actual_:
  strict_actual
    {let x = $1 in
    ( [ x ] )}
| strict_actual option_COMMA_ separated_nonempty_list_option_COMMA__strict_actual_
    {let (x, _2, xs) = ($1, $2, $3) in
    ( x :: xs )}

separated_nonempty_list_option_COMMA__symbol_:
  symbol
    {let x = $1 in
    ( [ x ] )}
| symbol option_COMMA_ separated_nonempty_list_option_COMMA__symbol_
    {let (x, _2, xs) = ($1, $2, $3) in
    ( x :: xs )}

separated_nonempty_list_option_COMMA__terminal_alias_attrs_:
  UID option_QID_ list_ATTRIBUTE_
    {let (id, alias, attrs) = ($1, $2, $3) in
let x =     ( let alias = Option.map Positions.value alias in
      Positions.map (fun uid -> uid, alias, attrs) id ) in
    ( [ x ] )}
| UID option_QID_ list_ATTRIBUTE_ option_COMMA_ separated_nonempty_list_option_COMMA__terminal_alias_attrs_
    {let (id, alias, attrs, _2, xs) = ($1, $2, $3, $4, $5) in
let x =     ( let alias = Option.map Positions.value alias in
      Positions.map (fun uid -> uid, alias, attrs) id ) in
    ( x :: xs )}

grammar:
  list_declaration_ PERCENTPERCENT list_rule_ postlude
    {let (xss, _2, rs, t) = ($1, $2, $3, $4) in
let ds =     ( List.flatten xss ) in
    (
      {
        pg_filename          = ""; (* filled in by the caller *)
        pg_declarations      = ds;
        pg_rules             = rs;
        pg_postlude          = t
      }
    )}

declaration:
  HEADER
    {let h = $1 in
let _endpos = _endpos_h_ in
let _startpos = _startpos_h_ in
let _loc = (_startpos, _endpos) in
    ( [ with_loc _loc (DCode h) ] )}
| TOKEN option_OCAMLTYPE_ separated_nonempty_list_option_COMMA__terminal_alias_attrs_
    {let (_1, ty, xs) = ((), $2, $3) in
let ts =     ( xs ) in
    ( List.map (Positions.map (fun (terminal, alias, attrs) ->
        DToken (ty, terminal, alias, attrs)
      )) ts )}
| START option_OCAMLTYPE_ separated_nonempty_list_option_COMMA__nonterminal_
    {let (_1, t, xs) = ((), $2, $3) in
let nts =     ( xs ) in
    (
      match t with
      | None ->
          List.map (Positions.map (fun nonterminal -> DStart nonterminal)) nts
      | Some t ->
          Misc.mapd (fun ntloc ->
            Positions.mapd (fun nt -> DStart nt, DType (t, ParameterVar ntloc)) ntloc) nts
    )}
| TYPE OCAMLTYPE separated_nonempty_list_option_COMMA__strict_actual_
    {let (_1, t, xs) = ((), $2, $3) in
let ss =     ( xs ) in
    ( List.map (Positions.map (fun nt -> DType (t, nt)))
        (List.map Parameters.with_pos ss) )}
| priority_keyword separated_nonempty_list_option_COMMA__symbol_
    {let (k, xs) = ($1, $2) in
let ss =     ( xs ) in
let _loc_k_ = (_startpos_k_, _endpos_k_) in
    ( let prec = ParserAux.new_precedence_level _loc_k_ in
      List.map (Positions.map (fun symbol -> DTokenProperties (symbol, k, prec))) ss )}
| PARAMETER OCAMLTYPE
    {let (_1, t) = ((), $2) in
let _endpos = _endpos_t_ in
let _startpos = _startpos__1_ in
let _loc = (_startpos, _endpos) in
    ( [ with_loc _loc (DParameter t) ] )}
| GRAMMARATTRIBUTE
    {let attr = $1 in
let _endpos = _endpos_attr_ in
let _startpos = _startpos_attr_ in
let _loc = (_startpos, _endpos) in
    ( [ with_loc _loc (DGrammarAttribute attr) ] )}
| PERCENTATTRIBUTE separated_nonempty_list_option_COMMA__strict_actual_ nonempty_list_ATTRIBUTE_
    {let (_1, xs, attrs) = ((), $2, $3) in
let actuals =     ( xs ) in
let _endpos = _endpos_attrs_ in
let _startpos = _startpos__1_ in
let _loc = (_startpos, _endpos) in
    ( [ with_loc _loc (DSymbolAttributes (actuals, attrs)) ] )}
| ON_ERROR_REDUCE separated_nonempty_list_option_COMMA__strict_actual_
    {let (_1, xs) = ((), $2) in
let ss =     ( xs ) in
    ( let prec = ParserAux.new_on_error_reduce_level() in
      List.map (Positions.map (fun nt -> DOnErrorReduce (nt, prec)))
        (List.map Parameters.with_pos ss) )}
| SEMI
    {let _1 = () in
    ( [] )}
| PUBLIC
    {let _1 = () in
let _1 =     ( () ) in
let _endpos = _endpos__1_ in
let _startpos = _startpos__1_ in
let _loc = (_startpos, _endpos) in
    (
      Error.error [Positions.import _loc]
        "syntax error inside a declaration.\n\
         Did you perhaps forget the %%%% that separates declarations and rules?"
    )}
| INLINE
    {let _1 = () in
let _1 =     ( () ) in
let _endpos = _endpos__1_ in
let _startpos = _startpos__1_ in
let _loc = (_startpos, _endpos) in
    (
      Error.error [Positions.import _loc]
        "syntax error inside a declaration.\n\
         Did you perhaps forget the %%%% that separates declarations and rules?"
    )}
| COLON
    {let _1 = () in
let _1 =     ( () ) in
let _endpos = _endpos__1_ in
let _startpos = _startpos__1_ in
let _loc = (_startpos, _endpos) in
    (
      Error.error [Positions.import _loc]
        "syntax error inside a declaration.\n\
         Did you perhaps forget the %%%% that separates declarations and rules?"
    )}
| LET
    {let _1 = () in
let _1 =     ( () ) in
let _endpos = _endpos__1_ in
let _startpos = _startpos__1_ in
let _loc = (_startpos, _endpos) in
    (
      Error.error [Positions.import _loc]
        "syntax error inside a declaration.\n\
         Did you perhaps forget the %%%% that separates declarations and rules?"
    )}
| EOF
    {let _1 = () in
let _1 =     ( () ) in
let _endpos = _endpos__1_ in
let _startpos = _startpos__1_ in
let _loc = (_startpos, _endpos) in
    (
      Error.error [Positions.import _loc]
        "syntax error inside a declaration.\n\
         Did you perhaps forget the %%%% that separates declarations and rules?"
    )}

priority_keyword:
  LEFT
    {let _1 = () in
    ( LeftAssoc )}
| RIGHT
    {let _1 = () in
    ( RightAssoc )}
| NONASSOC
    {let _1 = () in
    ( NonAssoc )}

symbol:
  LID
    {let id = $1 in
    ( id )}
| UID
    {let id = $1 in
    ( id )}
| QID
    {let id = $1 in
    ( id )}

old_rule:
  flags symbol list_ATTRIBUTE_ loption_delimited_LPAREN_separated_nonempty_list_COMMA_symbol__RPAREN__ COLON optional_bar separated_nonempty_list_BAR_production_group_ list_SEMI_
    {let (flags, symbol, attributes, params, _5, _6, prods, _8) = ($1, $2, $3, $4, (), $6, $7, $8) in
let branches =     ( List.flatten prods ) in
let params =     ( params ) in
    (
      let public, inline = flags in
      let rule = {
        pr_public_flag = public;
        pr_inline_flag = inline;
        pr_nt          = Positions.value symbol;
        pr_positions   = [ Positions.position symbol ];
        pr_attributes  = attributes;
        pr_parameters  = List.map Positions.value params;
        pr_branches    = branches
      }
      in rule
    )}

flags:
  
    {    ( false, false )}
| PUBLIC
    {let _1 = () in
    ( true, false )}
| INLINE
    {let _1 = () in
    ( false, true )}
| PUBLIC INLINE
    {let (_1, _2) = ((), ()) in
    ( true, true )}
| INLINE PUBLIC
    {let (_1, _2) = ((), ()) in
    ( true, true )}

optional_bar:
   %prec no_optional_bar
    {    ( () )}
| BAR
    {let _1 = () in
    ( () )}

production_group:
  separated_nonempty_list_BAR_production_ ACTION list_ATTRIBUTE_
    {let (productions, action, attrs) = ($1, $2, $3) in
let oprec2 =     ( None ) in
    (
      (* If multiple productions share a single semantic action, check
         that all of them bind the same names. *)
      ParserAux.check_production_group productions;
      (* Then, *)
      List.map (fun (producers, oprec1, level, pos) ->
        (* Replace [$i] with [_i]. *)
        let pb_producers = ParserAux.normalize_producers producers in
        (* Distribute the semantic action and attributes onto every production.
           Also, check that every [$i] is within bounds. *)
        let names = ParserAux.producer_names producers in
        let pb_action = action Settings.dollars names in
        {
          pb_producers;
          pb_action;
          pb_prec_annotation  = ParserAux.override pos oprec1 oprec2;
          pb_production_level = level;
          pb_position         = pos;
          pb_attributes       = attrs;
        })
      productions
    )}
| separated_nonempty_list_BAR_production_ ACTION precedence list_ATTRIBUTE_
    {let (productions, action, x, attrs) = ($1, $2, $3, $4) in
let oprec2 =     ( Some x ) in
    (
      (* If multiple productions share a single semantic action, check
         that all of them bind the same names. *)
      ParserAux.check_production_group productions;
      (* Then, *)
      List.map (fun (producers, oprec1, level, pos) ->
        (* Replace [$i] with [_i]. *)
        let pb_producers = ParserAux.normalize_producers producers in
        (* Distribute the semantic action and attributes onto every production.
           Also, check that every [$i] is within bounds. *)
        let names = ParserAux.producer_names producers in
        let pb_action = action Settings.dollars names in
        {
          pb_producers;
          pb_action;
          pb_prec_annotation  = ParserAux.override pos oprec1 oprec2;
          pb_production_level = level;
          pb_position         = pos;
          pb_attributes       = attrs;
        })
      productions
    )}

precedence:
  PREC symbol
    {let (_1, symbol) = ((), $2) in
    ( symbol )}

production:
  list_producer_
    {let producers = $1 in
let oprec =     ( None ) in
let _endpos_oprec_ = _endpos_producers_ in
let _endpos = _endpos_oprec_ in
let _startpos = _startpos_producers_ in
let _loc = (_startpos, _endpos) in
    ( producers,
      oprec,
      ParserAux.new_production_level(),
      Positions.import _loc
    )}
| list_producer_ precedence
    {let (producers, x) = ($1, $2) in
let oprec =     ( Some x ) in
let _endpos_oprec_ = _endpos_x_ in
let _endpos = _endpos_oprec_ in
let _startpos = _startpos_producers_ in
let _loc = (_startpos, _endpos) in
    ( producers,
      oprec,
      ParserAux.new_production_level(),
      Positions.import _loc
    )}

producer:
  actual list_ATTRIBUTE_ list_SEMI_
    {let (p, attrs, _4) = ($1, $2, $3) in
let id =     ( None ) in
let _startpos_id_ = _endpos__0_ in
let _endpos = _endpos__4_ in
let _startpos = _startpos_id_ in
let _loc = (_startpos, _endpos) in
    ( position (with_loc _loc ()), id, p, attrs )}
| LID EQUAL actual list_ATTRIBUTE_ list_SEMI_
    {let (x, _2, p, attrs, _4) = ($1, (), $3, $4, $5) in
let id =
  let x =     ( x ) in
      ( Some x )
in
let _startpos_id_ = _startpos_x_ in
let _endpos = _endpos__4_ in
let _startpos = _startpos_id_ in
let _loc = (_startpos, _endpos) in
    ( position (with_loc _loc ()), id, p, attrs )}

strict_actual:
  symbol loption_delimited_LPAREN_separated_nonempty_list_COMMA_strict_actual__RPAREN__
    {let (symbol, params) = ($1, $2) in
let p =
  let actuals =     ( params ) in
      ( Parameters.app symbol actuals )
in
    ( p )}
| strict_actual located_modifier_
    {let (p, m) = ($1, $2) in
let p =     ( ParameterApp (m, [ p ]) ) in
    ( p )}

actual:
  symbol loption_delimited_LPAREN_separated_nonempty_list_COMMA_lax_actual__RPAREN__
    {let (symbol, params) = ($1, $2) in
let p =
  let actuals =     ( params ) in
      ( Parameters.app symbol actuals )
in
    ( p )}
| actual located_modifier_
    {let (p, m) = ($1, $2) in
let p =     ( ParameterApp (m, [ p ]) ) in
    ( p )}

lax_actual:
  symbol loption_delimited_LPAREN_separated_nonempty_list_COMMA_lax_actual__RPAREN__
    {let (symbol, params) = ($1, $2) in
let p =
  let actuals =     ( params ) in
      ( Parameters.app symbol actuals )
in
    ( p )}
| actual located_modifier_
    {let (p, m) = ($1, $2) in
let p =     ( ParameterApp (m, [ p ]) ) in
    ( p )}
| located_branches_
    {let branches = $1 in
    ( ParameterAnonymous branches )}

modifier:
  QUESTION
    {let _1 = () in
    ( "option" )}
| PLUS
    {let _1 = () in
    ( "nonempty_list" )}
| STAR
    {let _1 = () in
    ( "list" )}

postlude:
  EOF
    {let _1 = () in
    ( None )}
| PERCENTPERCENT
    {let p = $1 in
    ( Some (Lazy.force p) )}

new_rule:
  boption_PUBLIC_ LET LID list_ATTRIBUTE_ loption_delimited_LPAREN_separated_nonempty_list_COMMA_symbol__RPAREN__ equality_symbol expression
    {let (rule_public, _2, rule_lhs, rule_attributes, params, rule_inline, rule_rhs) = ($1, (), $3, $4, $5, $6, $7) in
let rule_formals =     ( params ) in
    ({
       rule_public;
       rule_inline;
       rule_lhs;
       rule_attributes;
       rule_formals;
       rule_rhs;
    })}

equality_symbol:
  COLONEQUAL
    {let _1 = () in
    ( false )}
| EQUALEQUAL
    {let _1 = () in
    ( true  )}

expression:
  located_choice_expression_
    {let e = $1 in
    ( e )}

raw_seq_expression:
  symbol_expression SEMI located_raw_seq_expression_
    {let (e1, _1, e) = ($1, (), $3) in
let e2 =
  let e2 =     ( e ) in
      ( e2 )
in
    ( ECons (SemPatWildcard, e1, e2) )}
| pattern EQUAL symbol_expression SEMI located_raw_seq_expression_
    {let (p1, _2, e1, _1, e) = ($1, (), $3, (), $5) in
let e2 =
  let e2 =     ( e ) in
      ( e2 )
in
    ( ECons (p1, e1, e2) )}
| symbol_expression
    {let e = $1 in
    ( ESingleton e )}
| action_expression
    {let e = $1 in
    ( e )}

symbol_expression:
  symbol loption_delimited_LPAREN_separated_nonempty_list_COMMA_expression__RPAREN__ list_ATTRIBUTE_
    {let (symbol, params, attrs) = ($1, $2, $3) in
let es =     ( params ) in
    ( ESymbol (symbol, es, attrs) )}
| located_symbol_expression_ located_modifier_ list_ATTRIBUTE_
    {let (e, m, attrs) = ($1, $2, $3) in
    ( ESymbol (m, [ inject e ], attrs) )}

action_expression:
  action list_ATTRIBUTE_
    {let (action, attrs) = ($1, $2) in
    ( EAction (action, None, attrs) )}
| precedence action list_ATTRIBUTE_
    {let (prec, action, attrs) = ($1, $2, $3) in
    ( EAction (action, Some prec, attrs) )}
| action precedence list_ATTRIBUTE_
    {let (action, prec, attrs) = ($1, $2, $3) in
    ( EAction (action, Some prec, attrs) )}

action:
  ACTION
    {let action = $1 in
    ( XATraditional action )}
| OCAMLTYPE
    {let action = $1 in
let _endpos = _endpos_action_ in
let _startpos = _startpos_action_ in
let _loc = (_startpos, _endpos) in
    ( match ParserAux.validate_pointfree_action action with
      | os ->
          XAPointFree (unparenthesize os)
      | exception Lexpointfree.InvalidPointFreeAction ->
          Error.error [Positions.import _loc]
            "A point-free semantic action must consist \
             of a single OCaml identifier." (* or whitespace *)
    )}

pattern:
  LID
    {let x = $1 in
    ( SemPatVar x )}
| UNDERSCORE
    {let _1 = () in
    ( SemPatWildcard )}
| TILDE
    {let _1 = () in
let _endpos = _endpos__1_ in
let _startpos = _startpos__1_ in
let _loc = (_startpos, _endpos) in
    ( SemPatTilde (Positions.import _loc) )}
| LPAREN loption_separated_nonempty_list_COMMA_pattern__ RPAREN
    {let (_1, xs, _3) = ((), $2, ()) in
let ps =     ( xs ) in
    ( SemPatTuple ps )}

reversed_preceded_or_separated_nonempty_llist_BAR_branch_:
  located_raw_seq_expression_
    {let e = $1 in
let x =
  let e =     ( e ) in
      ( Branch (e, ParserAux.new_production_level()) )
in
let _1 =     ( None ) in
    ( [x] )}
| BAR located_raw_seq_expression_
    {let (x_inlined1, e) = ((), $2) in
let x =
  let e =     ( e ) in
      ( Branch (e, ParserAux.new_production_level()) )
in
let _1 =
  let x = x_inlined1 in
      ( Some x )
in
    ( [x] )}
| reversed_preceded_or_separated_nonempty_llist_BAR_branch_ BAR located_raw_seq_expression_
    {let (xs, _2, e) = ($1, (), $3) in
let x =
  let e =     ( e ) in
      ( Branch (e, ParserAux.new_production_level()) )
in
    ( x :: xs )}

located_branches_:
  separated_nonempty_list_BAR_production_group_
    {let prods = $1 in
let x =     ( List.flatten prods ) in
let (_endpos_x_, _startpos_x_) = (_endpos_prods_, _startpos_prods_) in
let _endpos = _endpos_x_ in
let _startpos = _startpos_x_ in
let _loc = (_startpos, _endpos) in
    ( with_loc _loc x )}

located_choice_expression_:
  reversed_preceded_or_separated_nonempty_llist_BAR_branch_
    {let xs = $1 in
let x =
  let branches =
    let xs =     ( List.rev xs ) in
        ( xs )
  in
      ( EChoice branches )
in
let (_endpos_x_, _startpos_x_) = (_endpos_xs_, _startpos_xs_) in
let _endpos = _endpos_x_ in
let _startpos = _startpos_x_ in
let _loc = (_startpos, _endpos) in
    ( with_loc _loc x )}

located_modifier_:
  modifier
    {let x = $1 in
let _endpos = _endpos_x_ in
let _startpos = _startpos_x_ in
let _loc = (_startpos, _endpos) in
    ( with_loc _loc x )}

located_raw_seq_expression_:
  raw_seq_expression
    {let x = $1 in
let _endpos = _endpos_x_ in
let _startpos = _startpos_x_ in
let _loc = (_startpos, _endpos) in
    ( with_loc _loc x )}

located_symbol_expression_:
  symbol_expression
    {let x = $1 in
let _endpos = _endpos_x_ in
let _startpos = _startpos_x_ in
let _loc = (_startpos, _endpos) in
    ( with_loc _loc x )}

%%




