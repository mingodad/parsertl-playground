# parsertl lexertl playground

### You can try it here https://mingodad.github.io/parsertl-playground/playground/ .
A web based playground for https://github.com/BenHanson/parsertl14 and https://github.com/BenHanson/lexertl14 based on https://github.com/BenHanson/gram_grep .

The playground website is based on https://yhirose.github.io/cpp-peglib/ and also with modifications based on https://chrishixon.github.io/chpeg/playground/ .

The playground save the grammar and the input in the local storage when you click `Parse`.

The playground has the following main elements:
- A select labeled `Examples` to choose one available example to start with.
- A select labeled `Generate` to optionally export Yacc/EBNF (for railroad diagrams).
- A button labeled `Parse` to build/execute the parser/grammar in the top left side editor over the input in the top right side editor.
- A bottom right side area to display info about the grammar (errors are clickable links to jump to line in the editor).
- A bottom left side area to display info about the input source parsing results (errors are clickabel to jump to line in the editor).
- A center left side foldable read only editor to show debug info about lexing/parsing the grammar or the input.

The availabel debugging options are:
- Input parse tree pruned
- Input parse tree full
- Input lexer dump
- Input parse trace
- Grammar parse tree pruned
- Grammar parse tree full
- Grammar lexer dump
- Grammar parse trace
- Grammar lexer state machine
- Grammar parse state machine

This project can also be built as a command line tool (see [build.sh](https://github.com/mingodad/parsertl-playground/blob/main/playground/build.sh)) then you can use it to check grammar/input on your disc:
```
./parsertl-playground
usage: ./parsertl-playground [options] grammar_fname input_fname
options can be:
-dumpil        Dump input lexer
-dumpiptree    Dump input parser tree
-dumpiptrace   Dump input parser trace
-dumpgl        Dump grammar lexer
-dumpgptree    Dump grammar parser tree
-dumpgptrace   Dump grammar parser trace
-dumpglsm      Dump grammar lexer state machine
-dumpgsm       Dump grammar parser state machine
-dumpAsEbnfRR  Dump grammar as EBNF for railroad diagram
-dumpAsYacc    Dump grammar as Yacc
-pruneptree    Do not show empty parser tree nodes
-verbose       Show several metrics for debug

```

The grammar used internally to parse the user grammar is this one [playground-master.g](https://github.com/mingodad/parsertl-playground/blob/main/playground/playground-master.g) the grammar has 4 sections:
```
/*Grammar header*/
%%
/*Grammar rules*/
%%
/*Lex header*/
%%
/*Lex rules*/
%%
```
The first two sections are equivalent to `yacc/bison` format and the other two sections are equivalent to `lex/flex` format.

Related projects:
- ANTLR Lab http://lab.antlr.org/
- Lezer playground https://lezer-playground.vercel.app/
- JS-based AST explorer https://astexplorer.net/
- clang visualizer [https://godblot.org](https://godbolt.org/z/dbMoE8nKM)
- Tree-sitter https://tree-sitter.github.io/tree-sitter/playground
- Lpegrex/Lua https://mingodad.github.io/lua-wasm-playground/ (tree-sitter-ebnf are supported. LPEG/dkjson is the default parser of luvit.io)
- CocoR https://mingodad.github.io/CocoR-Typescript/playground (nice JSON bnf)
- CHPEG https://chrishixon.github.io/chpeg/playground/
- Cpp-Peglib https://yhirose.github.io/cpp-peglib/
- PCRE Regex [https://regex101.com](https://regex101.com/library/tA9pM8) (nice JSON bnf)
- Pest [https://pest.rs/](https://pest.rs/?g=N4Ig5gTghgtjURALhBA9gdwLzAMZoBsA-ACgB0QAaCo-AgSgCoBfMgOzpwEEBlAYQCSAgPoARAQHEBAFQDUrNlRABLNgAcArgBdkIAIyUATJQDMAAnZKAzgFMCN3FpsATAEob7u9BhDMgA#editor)
- Jison https://gerhobbelt.github.io/jison/try/
- PeggyJS https://peggyjs.org/online.html
- Lark https://www.lark-parser.org/ide/ ([py3 grammar supported](https://github.com/lark-parser/lark/blob/master/lark/grammars/python.lark))
- Ohm https://ohmjs.org/editor/ ([es5 tree supported](https://github.com/ohmjs/ohm/blob/main/examples/ecmascript/src/es5.ohm))
- Owl https://ianh.github.io/owl/try/#example (operators infix precedence supported)
- Nearley Parser https://omrelli.ug/nearley-playground/ (NO web playgrounds below)
- Lalrpop http://lalrpop.github.io/lalrpop/
- Lezer https://lezer.codemirror.net/examples/basic/
- Syntax https://github.com/DmitrySoshnikov/syntax
- Antlr https://github.com/antlr/antlr4
- Textmapper https://textmapper.org/
- Railroad generator https://bottlecaps.de/rr/ui (json.org diagram)
- Convert (grammar conversion) https://www.bottlecaps.de/convert/
- Rex parser generator https://www.bottlecaps.de/rex/
- LALR https://github.com/cwbaker/lalr
- Ebnf Studio Qt https://github.com/rochus-keller/EbnfStudio
- Flexcpp https://gitlab.com/fbb-git/flexcpp
- Reflex https://www.genivia.com/doc/reflex/html/
- Bison https://www.gnu.org/software/bison/
- Flex https://github.com/westes/flex
- Byacc https://www.invisible-island.net/byacc/byacc.html
- BNF playground https://bnfplayground.pauliankline.com/
- Lrstar an LR(*) parser generator for C++ https://github.com/VestniK/lrstar/blob/master/README.md
- LangCC "A Next-Generation Compiler Compiler" https://github.com/jzimmerman/langcc
