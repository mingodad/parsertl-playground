// Setup editors
function setupInfoArea(id) {
  const e = ace.edit(id);
  e.setShowPrintMargin(false);
  e.setOptions({
    readOnly: true,
    highlightActiveLine: false,
    highlightGutterLine: false
  })
  e.renderer.$cursorLayer.element.style.opacity=0;
  return e;
}

function setupEditorArea(id, lsKey) {
  const e = ace.edit(id);
  e.setShowPrintMargin(false);
  e.setValue(localStorage.getItem(lsKey) || '');
  e.moveCursorTo(0, 0);
  return e;
}

let userContentHasChanged = false;
let grammarContentHasChanged = false;
let inputContentHasChanged = false;
function grammarOnChange(delta) {
	if(!grammarContentHasChanged) {
		grammarContentHasChanged = true;
		userContentHasChanged = true;
	}
}
function inputOnChange(delta) {
	if(!inputContentHasChanged) {
		inputContentHasChanged = true;
		userContentHasChanged = true;
	}
}

const grammarEditor = setupEditorArea("grammar-editor", "grammarText");
grammarEditor.on("change", grammarOnChange);
grammarEditor.getSession().setMode("ace/mode/yaml");
const codeEditor = setupEditorArea("code-editor", "codeText");
codeEditor.on("change", inputOnChange);
userContentHasChanged = localStorage.getItem("userContentHasChanged");

const codeDbg = setupInfoArea("code-dbg");

onbeforeunload= function(event) { updateLocalStorage(); };

const sampleList = [
	//title, grammar, input, input ace syntax
	["Abnf parser", "abnf.g", "test.abnf", "ace/mode/text"],
	["Abnf-ebnf parser", "abnf-ebnf.g", "test.abnf-ebnf", "ace/mode/text"],
	["Abnf-bnf parser", "abnf-bnf.g", "test.abnf-ebnf", "ace/mode/text"],
	["Ada parser", "ada-adayacc.g", "test.adb", "ace/mode/ada"],
	["Age parser", "cypher_gram.g", "test.cypher_gram", "ace/mode/sql"],
	["Akwa parser (partially working)", "akwa.g", "test.awk", "ace/mode/text"],
	["AlaSQL parser", "alasql-parser.g", "test.alasql", "ace/mode/sql"],
	["Aliceml parser (partially working)", "aliceml.g", "test.aliceml", "ace/mode/ocaml"],
	["AM parser", "am-parser.g", "test.am-parser", "ace/mode/Makefile"],
	["Anna parser ", "anna-parser.g", "test.anna", "ace/mode/Go"],
	["Any-dl parser ", "any-dl-klartext.g", "test.any-dl-klartext", "ace/mode/text"],
	["Ansi C11 parser (partially working)", "c11-ansi-c.g", "test.c", "ace/mode/c_cpp"],
	["Ansi C18 parser (partially working)", "c18-ansi.g", "test.c", "ace/mode/c_cpp"],
	["Ansi C parser", "cparser.g", "test.c", "ace/mode/c_cpp"],
	["Ansi C c2go parser", "cc-c2go.g", "test.c", "ace/mode/c_cpp"],
	["Antlr4.5 parser", "antlr-v4.5.g", "test.antlr", "ace/mode/yaml"],
	["Apla-lang parser", "apla-lang.g", "test.apla-lang", "ace/mode/text"],
	["ArangoDB AQL parser", "arangodb-aql.g", "test.arangodb-aql", "ace/mode/text"],
	["AS3 parser (partially working)", "as3-parser.g", "test.as3-parser", "ace/mode/c_cpp"],
	["ASN1 parser", "asn1p_y.g", "test.asn1p_y", "ace/mode/text"],
	["Asymptote camp parser", "asymptote-camp.g", "test.asymptote-camp", "ace/mode/text"],
	["Austral parser (partially working)", "austral-parser.g", "test.austral", "ace/mode/text"],
	["BaikalDB SQL parser", "BaikalDB-sql.g", "test.BaikalDB-sql", "ace/mode/sql"],
	["Basil parser", "basil-grammar.g", "test.basil-grammar", "ace/mode/yaml"],
	["Batsh parser", "batsh.g", "test.batsh", "ace/mode/c_cpp"],
	["Bayeslite parser", "bayeslite.g", "test.bayeslite", "ace/mode/text"],
	["BC calculator", "bc.g", "test.bc-calculator", "ace/mode/sh"],
	["Beaver parser", "beaver-grammar.g", "test.beaver-grammar", "ace/mode/yaml"],
	["Bison parser", "bison.g", "carbon-lang.y", "ace/mode/yaml"],
	["Bison strict parser", "bison-strict.g", "carbon-lang.y", "ace/mode/yaml"],
	["Blawn parser", "blawn-parser.g", "test.blawn", "ace/mode/python"],
	["Blech parser (partially working)", "blech-parser.g", "test.blech-parser", "ace/mode/text"],
	["Blink GPU-lang parser", "blink-robertfeliciano.g", "test.blink-robertfeliciano", "ace/mode/text"],
	["Blog-lang parser", "blog-lang.g", "test.blog-lang", "ace/mode/text"],
	["BNFC parser", "bnfc.g", "test.bnfc", "ace/mode/yaml"],
	["BNFGen parser", "bnfgen.g", "test.bnfgen", "ace/mode/yaml"],
	["Bolt parser", "bolt-parser.g", "test.bolt", "ace/mode/c_cpp"],
	["Braille parser", "braille.g", "test.braille", "ace/mode/text"],
	["Build your own prog. lang. CH13 parser", "build-your-own-programming-language-ch13.g", "test-ch13.java", "ace/mode/java"],
	["C2c-err-transpiler  parser", "c2c-err-transpiler.g", "test.c", "ace/mode/c_cpp"],
	["C3c  parser", "c3lang.g", "test.c3lang", "ace/mode/c_cpp"],
	["Calculator parser", "calculator.g", "test-calc.txt", "ace/mode/text"],
	["Capnproto parser", "capnproto-antlr4.g", "test.capnproto", "ace/mode/text"],
	["Carbon parser (need review of '*')", "carbon-lang.g", "prelude.carbon", "ace/mode/typescript"],
	["Cdecl parser", "cdecl.g", "test.cdecl", "ace/mode/c_cpp"],
	["Cerberus-core parser (partially working)", "cerberus-core-rems-project.g", "test.cerberus-core-rems-project", "ace/mode/ocaml"],
	["Cforall parser (partially working)", "cforall.g", "test.c", "ace/mode/c_cpp"],
	["CG-CQL-author parser", "cg-cql-author.g", "test.cg-cql-author", "ace/mode/sql"],
	["CG-CQL-old parser", "cql.g", "test.cql", "ace/mode/sql"],
	["Chaos parser", "chaos-parser.g", "test.chaos-parser", "ace/mode/c_cpp"],
	["Chapel parser", "chapel.g", "test.chapel", "ace/mode/c_cpp"],
	["CIL C parser", "cil-cparser.g", "test.c", "ace/mode/c_cpp"],
	["CIL C parser old", "cil-cparser-origin.g", "test.c", "ace/mode/c_cpp"],
	["CLanguage parser", "clanguage.g", "test.clanguage", "ace/mode/c_cpp"],
	["CLaro-lang parser", "claro-lang.g", "test.claro-lang", "ace/mode/c_cpp"],
	["CleverLang  parser", "clever-parser.g", "test.clever-parser", "ace/mode/c_cpp"],
	["CocoR parser (partially working)", "cocor.g", "test.cocor", "ace/mode/yaml"],
	["Codeql parser (partially working)", "codeql.g", "test.codeql", "ace/mode/java"],
	["condb2 sql parser", "condb2-sql.g", "test.sqlite3", "ace/mode/sql"],
	["CoqPP parser", "coqpp_parse.g", "test.coqpp", "ace/mode/yaml"],
	["Cowgol parser", "cowgol-cowfe.g", "test.cowgol-cowfe", "ace/mode/ada"],
	["C lexer Puma", "clexer-puma.g", "test.frama-c", "ace/mode/c_cpp"],
	["CC C99 parser (partially working)", "cc-parser-cznic.g", "test.frama-c", "ace/mode/c_cpp"],
	["C parser frama-c (partially working)", "cparser-frama-c.g", "test.frama-c", "ace/mode/c_cpp"],
	["C parser (c-to-json) (partially working)", "c-to-json.g", "test.frama-c", "ace/mode/c_cpp"],
	["C parser (coccinelle) (partially working)", "coccinelle-parser_c.g", "test.frama-c", "ace/mode/c_cpp"],
	["Cpp-semgrep parser (partially working)", "cpp-semgrep.g", "test.c", "ace/mode/c_cpp"],
	["Cpp5-v2 parser (not working)", "cpp5-v2.g", "test.cpp", "ace/mode/c_cpp"],
	["Cryptol parser (partially working)", "cryptol-GaloisInc.g", "test.cryptol-GaloisInc", "ace/mode/text"],
	["CSS parser from VLC", "CSSGrammar-vlc.g", "style.css", "ace/mode/css"],
	["CSS parser from Webkit", "css-webkit.g", "style.css", "ace/mode/css"],
	["CSS parser from Webkit NO-WHITESPACE", "css-webkit-no-whitespace.g", "style.css", "ace/mode/css"],
	["Cup parser", "java-cup.g", "test.java-cup", "ace/mode/txt"],
	["Cx parser (partially working)", "cxpartialparsing.g", "test.cxpartialparsing", "ace/mode/c_cpp"],
	["Cxx parser (not working)", "CxxParser.g", "test.cpp", "ace/mode/c_cpp"],
	["Cyclone parser (partially working)", "cyclone.g", "test.cyclone", "ace/mode/c_cpp"],
	["Cycipt parser (be patient) (partially working)", "cycriptC.g", "test.cycriptC", "ace/mode/javascript"],
	["D parser (partially working)", "dlang-uaiso.g", "test.d", "ace/mode/c_cpp"],
	["Datalog parser", "datalog.g", "test.datalog", "ace/mode/text"],
	["DateTime parser (core)", "core-date-time-parser.g", "test.core-date-time-parser", "ace/mode/text"],
	["Dart lexer (partially working)", "dart-lexer.g", "test.dart", "ace/mode/dart"],
	["Delphi parser (partially working)", "delphi.g", "test.delphi", "ace/mode/pascal"],
	["Dino-lang parser", "dino-lang.g", "test.dino-lang", "ace/mode/c_cpp"],
	["DMEngine parser", "dmengine-dm.g", "test.dmengine-dm", "ace/mode/sh"],
	["Dparser (partially working)", "dparser.g", "test.dparser", "ace/mode/text"],
	["Doby parser", "doby-jxwr.g", "test.doby-jxwr", "ace/mode/golang"],
	["Doxygen code scanner torture", "code-doxygen.g", "test.c", "ace/mode/c_cpp"],
	["Dtu parser", "dtu.g", "test.dtu", "ace/mode/text"],
	["DuckDB SQL parser (be patient)", "duckdb-pgsql.g", "test.duckdb", "ace/mode/sql"],
	["Dunnart parser", "dunnart.g", "test.dunnart", "ace/mode/text"],
	["Dynare preprocessor parser (partially working)", "dynare-pp.g", "test.dynare-pp", "ace/mode/javascript"],
	["Ebnf2bnf parser", "ebnf2bnf.g", "test.ebnf2bnf", "ace/mode/yaml"],
	["EbnfToBison parser", "ebnftobison.g", "test.ebnftobison", "ace/mode/yaml"],
	["Ecere parser (not working)", "ecere.g", "test.ecere", "ace/mode/c_cpp"],
	["Eiffel parser (partially working)", "eiffel_parser.g", "test.eiffel_parser", "ace/mode/eiffel"],
	["Epic EpiVM parser (partially working)", "EpiVM-epic.g", "test.EpiVM-epic", "ace/mode/haskell"],
	["Estree parser", "estree.g", "test.estree", "ace/mode/txt"],
	["Event comiler parser", "event-compiler.g", "test.event-compiler", "ace/mode/txt"],
	["Expr-lang parser", "expr-lang.g", "test.expr-lang", "ace/mode/txt"],
	["Fakego parser", "fakego-esrrhs.g", "test.fakego-esrrhs", "ace/mode/golang"],
	["Fault-lang parser (partially working)", "fault-lang-ext.g", "test.fault-lang", "ace/mode/txt"],
	["Faust parser", "faustparser.g", "test.faustparser", "ace/mode/txt"],
	["Firebird DSQL parser", "firebird-dsql.g", "test.firebird-dsql", "ace/mode/sql"],
	["Flatbuffers parser", "flatbuffers.g", "test.flatbuffers", "ace/mode/txt"],
	["Fortune sheet formula parser", "fortune-sheet-formula.g", "test.fortune-sheet-formula", "ace/mode/txt"],
	["FrontC parser", "frontc.g", "test.c", "ace/mode/c_cpp"],
	["FsLex parser", "fslex.g", "test.fslex", "ace/mode/yaml"],
	["FsYacc parser", "fsyacc.g", "test.fsyacc", "ace/mode/yaml"],
	["Futhark parser (partially working)", "futhark.g", "test.futhark", "ace/mode/txt"],
	["GAEA-QL parser (be patient)(partially working)", "Gaea-ql.g", "test.Gaea-ql", "ace/mode/sql"],
	["GameMonkey parser", "gmscript.g", "test.gmscript", "ace/mode/javascript"],
	["GGML parser", "ggml.g", "test.ggml", "ace/mode/yaml"],
	["Glcpp parser (partially working)", "glcpp-parse.g", "test.glcpp-parse", "ace/mode/c_cpp"],
	["Glslang parser (partially working)", "glslang.g", "test.glslang", "ace/mode/c_cpp"],
	["Gocc parser", "gocc.g", "test.gocc", "ace/mode/yaml"],
	["Go-amanda parser (partially working)", "go-amanda.g", "test.go", "ace/mode/golang"],
	["Go-semgrep parser (partially working)", "go-semgrep.g", "test.go", "ace/mode/golang"],
	["Go lexer (partially working)", "go-lexer.g", "test.go", "ace/mode/golang"],
	["Goyacc-cznic parser", "goyacc-cznic.g", "test.goyacc-cznic", "ace/mode/yaml"],
	["Grain-lang parser (partially working)", "grain-lang.g", "test.grain-lang", "ace/mode/text"],
	["Grammar-Kit parser", "Grammar-Kit-grammar.g", "test.Grammar-Kit-grammar", "ace/mode/yaml"],
	["GramGrep parser", "gram_grep.g", "calculator.g", "ace/mode/yaml"],
	["Graphql parser", "libgraphql.g", "test.libgraphql", "ace/mode/yaml"],
	["Gringo-Clingo parser non grounding (partially working)", "gringo-ngp.g", "test.gringo-ngp", "ace/mode/text"],
	["Gusa parser", "gusa-lang.g", "test.gusa-lang", "ace/mode/txt"],
	["Happy parser (literate script)", "happy-parser.g", "test.happy-parser", "ace/mode/yaml"],
	["Happy parser", "happy-parser2.g", "test.happy-parser2", "ace/mode/yaml"],
	["Hawq SQL parser (be patient)", "hawq-sql.g", "test.sql", "ace/mode/sql"],
	["Hare-ang parser (partially working)", "hare-lang.g", "test.hare-lang", "ace/mode/c_cpp"],
	["Hime parser", "hime-grammar.g", "test.hime-grammar", "ace/mode/yaml"],
	["HQL (ECL) parser (be patient)", "hqlgram.g", "test.hqlgram", "ace/mode/pascal"],
	["HTML parser", "html-parser.g", "index.html", "ace/mode/html"],
	["Hue SQL generic parser", "hue-generic.g", "test.hue-generic", "ace/mode/sql"],
	["Hurl parser", "hurl-lang.g", "test.hurl-lang", "ace/mode/text"],
	["idl2cpp parser", "idl2cpp.g", "test.idl", "ace/mode/c_cpp"],
	["Influxql parser", "influxql-sql.g", "test.influxql-sql", "ace/mode/sql"],
	["Island parser example", "island-example-koopa.g", "test.island-example-koopa", "ace/mode/text"],
	["Ispc parser", "ispc.g", "test.ispc", "ace/mode/c_cpp"],
	["Ixml parser (partially working)", "ixml.g", "test.ixml", "ace/mode/yaml"],
	["Jacc parser", "jacc-grammar.g", "test.jacc-grammar", "ace/mode/yaml"],
	["Jaime Gaza Syntax parser", "jaimegarza-syntax.g", "test.jaimegarza-syntax", "ace/mode/yaml"],
	["Java11 parser", "java11.g", "test.java", "ace/mode/java"],
	["Java-codinuum parser (partially working)", "java-parser-codinuum.g", "test.java", "ace/mode/java"],
	["Java-semgrep parser (partially working)", "java-semgrep.g", "test.java", "ace/mode/java"],
	["Javascript-database parser", "javascript-database-js.g", "test.js.txt", "ace/mode/javascript"],
	["JavascriptCore parser", "javascript-core.g", "test.js.txt", "ace/mode/javascript"],
	["Javascript-pff parser", "javascript-pff.g", "test.js-ts", "ace/mode/typescript"],
	["Javascript-semgrep parser", "javascript-semgrep.g", "test.js-ts", "ace/mode/typescript"],
	["Jikespg parser (partially working)", "jikespg.g", "test.jikespg", "ace/mode/yaml"],
	["Jq parser (partially working)", "jq-parser.g", "test.jq", "ace/mode/text"],
	["Jscc parser", "jscc-parse.g", "test.jscc-parse", "ace/mode/yaml"],
	["Json5 parser", "json5.g", "test.json5.txt", "ace/mode/json"],
	["Json lexer", "json-lexer.g", "test.json.txt", "ace/mode/json"],
	["Json parser", "json.g", "test.json.txt", "ace/mode/json"],
	["JsonLint parser", "jsonlint.g", "test.json.txt", "ace/mode/json"],
	["JsSql parser", "js-sql-parser.g", "test.js-sql-parser", "ace/mode/sql"],
	["Kinx parser (partially working)", "kinx.g", "test.kinx", "ace/mode/c_cpp"],
	["Kitlang parser (partially working)", "kitlang-ghc.g", "test.kitlang-ghc", "ace/mode/c_cpp"],
	["Koka-lang parser (partially working)", "koka-lang.g", "test.koka-lang", "ace/mode/text"],
	["Koa-lang parser", "koa-nirvanan.g", "test.koa-nirvanan", "ace/mode/c_cpp"],
	["Kotlin lexer (partially working)", "kotlin-lexer.g", "test.kotlin", "ace/mode/kotlin"],
	["LALR parser", "lalr.g", "test.lalr", "ace/mode/yaml"],
	["Langcc parser (partially working)", "langcc-meta.g", "test.langcc-meta", "ace/mode/yaml"],
	["Langium parser (partially working)", "langium.g", "test.langium", "ace/mode/yaml"],
	["Lark parser expanded", "lark.g", "test.lark", "ace/mode/yaml"],
	["Lark parser", "lark-00.g", "test.lark", "ace/mode/yaml"],
	["Left recursion demo", "tree-sitter-lr-dad.g", "test.lr-dad", "ace/mode/yaml"],
	["Lezer parser", "lezer.g", "test.lezer", "ace/mode/yaml"],
	["LFortran parser (partially working)", "lfortran.g", "test.fortran", "ace/mode/fortran"],
	["Libfsm lx parser", "libfsm-lx.g", "test.libfsm-lx", "ace/mode/text"],
	["Lightgrep parser (partially working)", "lightgrep-re.g", "test.lightgrep-re", "ace/mode/text"],
	["Limbo-Inferno parser", "limbo-inferno.g", "test.limbo-inferno", "ace/mode/sh"],
	["Linden Script parser", "lsl_ext.g", "test.lsl", "ace/mode/text"],
	["Little-lang parser (partially working)", "little-lang.g", "test.little-lang", "ace/mode/c_cpp"],
	["Lox parser", "lox-lalrpop.g", "test.lox", "ace/mode/javascript"],
	["LPegrex parser (partially working)", "lpegrex.g", "test.lpegrex", "ace/mode/yaml"],
	["LPG2 parser (partially working)", "lpg2.g", "test.lpg2", "ace/mode/yaml"],
	["LPython parser (not working)", "lpython.g", "test.python", "ace/mode/python"],
	["LRSTAR-DFA parser", "lrstar-dfa.g", "test.lrstar-dfa", "ace/mode/yaml"],
	["LRSTAR-24 parser (partially working)", "lrstar.g", "test.lrstar", "ace/mode/yaml"],
	["LRSTAR-6.3 parser (partially working)", "lrstar-6.3.g", "test.lrstar-6.3", "ace/mode/yaml"],
	["Lua2ljs parser", "lua2ljs.g", "test.lua", "ace/mode/lua"],
	["Lua-5.3 parser", "lua-5.3.g", "test.lua", "ace/mode/lua"],
	["Lua-lark parser", "lua-parser-lark.g", "test.lua", "ace/mode/lua"],
	["Lua parser", "lua.g", "test.lua", "ace/mode/lua"],
	["LuaPP parser (partially working)", "luapp.g", "test.luapp", "ace/mode/lua"],
	["Luban parser", "luban.g", "test.luban", "ace/mode/c_cpp"],
	["Lucid-lang parser (partially working)", "lucid-parser.g", "test.lucid-parser", "ace/mode/c_cpp"],
	["LunarML parser (partially working)", "LunarML.g", "test.LunarML", "ace/mode/ocaml"],
	["Make parser (from anjuta)", "mk-parser.g", "test.mk-parser", "ace/mode/Makefile"],
	["Mangle (datalog) parser", "mangle.g", "test.mangle", "ace/mode/prolog"],
	["MangoFix parser", "mangofix.g", "test.mangofix", "ace/mode/c_cpp"],
	["Matrixone MYSQL parser (be patient)(partially working)", "matrixone-mysql.g", "test.mysql", "ace/mode/sql"],
	["Menhir fancy parser left recursion", "menhir-fancy-parser-left-rec.g", "menhir-fancy-parser.mly", "ace/mode/yaml"],
	["Menhir fancy parser", "menhir-fancy-parser.g", "menhir-fancy-parser.mly", "ace/mode/yaml"],
	["Menhir stage1 parser", "menhir-stage1-parser.g", "menhir-stage1-parser.mly", "ace/mode/yaml"],
	["MetaDSL parser", "MetaDSL.g", "test.MetaDSL", "ace/mode/txt"],
	["Mewa parser", "mewa-grammar.g", "test.mewa-grammar", "ace/mode/txt"],
	["Mgmt-config parser", "mgmt-purpleidea.g", "test.mgmt-purpleidea", "ace/mode/txt"],
	["Mimosa http request parser", "mimosa_http_request.g", "test.mimosa_http_request", "ace/mode/yaml"],
	["Minic parser", "minic.g", "test.minic", "ace/mode/c_cpp"],
	["Minilog parser", "minilog.g", "test.minilog", "ace/mode/text"],
	["Minizinc parser (partially working)", "minizinc.g", "test.mzn", "ace/mode/text"],
	["Mlton parser", "mlton.g", "test.mlton", "ace/mode/ocaml"],
	["MLyacc parser", "mlyacc.g", "test.mlyacc", "ace/mode/yaml"],
	["Mocc QSS-Solver parser (partially working)", "qss-solver-mocc.g", "test.qss-solver-mocc", "ace/mode/txt"],
	["Moirai lang parser (partially working)", "moirai-lang.g", "test.moirai-lang", "ace/mode/text"],
	["Monetdb SQL parser (partially working)", "monetdb-sql_parser.g", "test.monetdb-sql_parser", "ace/mode/sql"],
	["Mono CSHarp parser (partially working)", "cs-parser.g", "test.cs", "ace/mode/csharp"],
	["Moonbitlang parser  (be patient)(partially working)", "moonbitlang.g", "test.moonbitlang", "ace/mode/yaml"],
	["Moonyacc parser", "moonyacc.g", "test.moonyacc", "ace/mode/yaml"],
	["Mosml parser (partially working)", "mosml-lr.g", "test.mosml", "ace/mode/ocaml"],
	["MSTA parser", "msta.g", "test.msta", "ace/mode/yaml"],
	["mtail parser", "mtail.g", "test.mtail", "ace/mode/yaml"],
	["Mulang parser (not working)", "mulang.g", "test.mulang", "ace/mode/text"],
	["Myrddin parser", "myrddin.g", "test.myrddin", "ace/mode/text"],
	["Mysql parser (be patient)(partially working)", "mysql.g", "test.mysql", "ace/mode/sql"],
	["N1QL parser", "n1ql.g", "test.n1ql", "ace/mode/sql"],
	["Nandlang parser", "Nandlang.g", "test.Nandlang", "ace/mode/javascript"],
	["NASL parser", "nasl-parser.g", "test.nasl", "ace/mode/shell"],
	["Nearley parser", "nearley.g", "test.nearley", "ace/mode/yaml"],
	["Nebula parser", "nebula-parser.g", "test.nebula-parser", "ace/mode/sql"],
	["Network simulator demikernel parser", "network_simulator-demikernel.g", "test.network_simulator-demikernel", "ace/mode/text"],
	["Never language parser", "never-parser.g", "test.never-parser", "ace/mode/text"],
	["Numscript parser", "Numscript.g", "test.Numscript", "ace/mode/text"],
	["Oberon parser", "oberon.g", "test.oberon", "ace/mode/pascal"],
	["Ocaml5 parser (partially working)", "ocaml5-parser.g", "test.ocaml", "ace/mode/ocaml"],
	["OcamlLex parser (partially working)", "ocaml-lex.g", "test.ocamllex", "ace/mode/ocaml"],
	["Ocaml parser from rescript (partially working)", "rescript-ocaml-parser.g", "test.ocaml", "ace/mode/ocaml"],
	["Octave parser (partially working)", "oct-parse.g", "test.oct-parse", "ace/mode/matlab"],
	["OctoSQL parser (partially working)", "OctoSQL-parser.g", "test.OctoSQL-parser", "ace/mode/sql"],
	["Openddl parser", "openddl-spec.g", "test.openddl-spec", "ace/mode/text"],
	["Openscad parser (partially working)", "openscad.g", "test.openscad", "ace/mode/text"],
	["OpenShadingLanguage parser (partially working)", "OpenShadingLanguage.g", "test.OpenShadingLanguage", "ace/mode/c_cpp"],
	["OpenUSD parser", "openUSD-textFileFormat.g", "test.openUSD-textFileFormat", "ace/mode/c_cpp"],
	["Owl parser generator (partially working)", "owl-parser.g", "test.owl-parser", "ace/mode/text"],
	["P parser (partially working)", "p-parser.g", "test.p-parser", "ace/mode/c_cpp"],
	["Panda3d cppparser (partially working)", "cppBison-panda3d.g", "test.c", "ace/mode/c_cpp"],
	["Panda3d dcparser", "panda3d-dcparser.g", "test.panda3d-dcparser", "ace/mode/c_cpp"],
	["Panda3d eggparser", "panda3d-eggparser.g", "test.panda3d-eggparser", "ace/mode/text"],
	["Parol parser", "parol.g", "test.parol", "ace/mode/yaml"],
	["Parseland parser", "parseland.g", "test.parseland", "ace/mode/text"],
	["Parser-Gianmarco-Todesco parser", "parser-gianmarco-todesco.g", "test.parser-gianmarco-todesco", "ace/mode/text"],
	["PCC cccom parser (partially working)", "pcc-cccom.g", "test.c", "ace/mode/c_cpp"],
	["PCC cxxcom parser (partially working)", "pcc-cxxcom.g", "test.c", "ace/mode/c_cpp"],
	["PDC calculator parser", "pdc-calculator.g", "test.pdc-calculator", "ace/mode/text"],
	["Peg parser (partially working)", "peg.g", "test.peg", "ace/mode/yaml"],
	["Peg2 parser (partially working)", "peg2.g", "test.peg", "ace/mode/yaml"],
	["Peggy parser", "peggy-eaburns.g", "test.peggy-eaburns", "ace/mode/yaml"],
	["Pegjs parser", "pegjs.g", "test.pegjs", "ace/mode/yaml"],
	["Peglib (cpp-peglib) parser", "cpp-peglib.g", "test.cpp-peglib", "ace/mode/yaml"],
	["Pest peg parser", "pest-peg.g", "test.pest-peg", "ace/mode/yaml"],
	["PHP-8.2 parser (partially working)", "php-8.2.g", "test.php", "ace/mode/php"],
	["Pikchr parser", "pikchr.g", "test.pikchr", "ace/mode/text"],
	["Pike-lang parser", "pike-lang.g", "test.pike", "ace/mode/c_cpp"],
	["Playground3 parser", "playground-master3.g", "playground-master3.g", "ace/mode/yaml"],
	["Playground-Error parser", "playground-master-error.g", "test.playground-master-error", "ace/mode/yaml"],
	["Playground parser", "playground-master.g", "calc-alias.g", "ace/mode/yaml"],
	["PnetC parser", "pnet-c.g", "test.c", "ace/mode/c_cpp"],
	["PnetCSHarp parser", "pnet-cs.g", "test.cs", "ace/mode/csharp"],
	["PnetDPas parser", "pnet-dpas.g", "test.dpas", "ace/mode/pascal"],
	["PnetJava parser", "pnet-java.g", "test.java", "ace/mode/java"],
	["PnetVBasic parser", "pnet-vb.g", "test.vb", "ace/mode/vbscript"],
	["Polyglot parser", "ppg_parser.g", "test.ppg_parser", "ace/mode/text"],
	["Postgresql parser (be patient)", "postgres16.g", "test.sql", "ace/mode/sql"],
	["Postgresql parser with fallback", "postgres16-fallback.g", "test.sql", "ace/mode/sql"],
	["Preprocessor parser (not working)", "pp.g", "test.pp", "ace/mode/c_cpp"],
	["Prolog0 parser", "prolog-parser0.g", "test.prolog-parser0", "ace/mode/text"],
	["Prolog1 parser", "prolog-parser1.g", "test.prolog-parser1", "ace/mode/text"],
	["Prolog2 parser", "prolog-parser2.g", "test.prolog-parser2", "ace/mode/text"],
	["Promql parser  (partially working)", "promql.g", "test.promql", "ace/mode/text"],
	["Protobuf3 parser", "pb_parsing_parser.g", "test.proto3", "ace/mode/c_cpp"],
	["Protocompile parser", "protocompile.g", "test.protocompile", "ace/mode/c_cpp"],
	["Qasm parser (be patient) (partially working)", "QasmParser.g", "test.QasmParser", "ace/mode/text"],
	["Qlalr QT LALR parser", "qlalr.g", "test.qlalr", "ace/mode/text"],
	["Qqmljs parser (partially working)", "qqmljs.g", "test.qqmljs", "ace/mode/actionscript"],
	["Quakeforge QC parser (partially working)", "quakeforge-qc-parse.g", "test.quakeforge-qc-parse", "ace/mode/c_cpp"],
	["RCL config language parser (partially working)", "rcl-config-lang.g", "test.rcl-config-lang", "ace/mode/txt"],
	["ReasonML parser (partially working)", "reason_parser.g", "test.reason", "ace/mode/javascript"],
	["R parser (partially working)", "r-parser.g", "test.r-parser", "ace/mode/r"],
	["Re2c parser (partially working)", "re2c.g", "test.re2c", "ace/mode/text"],
	["Rell-lang parser (partially working)", "rell-lang.g", "test.rell-lang", "ace/mode/text"],
	["Rivar-lang parser", "rivar-lang.g", "test.rivar-lang", "ace/mode/text"],
	["Ruby parser (not working)", "ruby-0bced53a.g", "test.ruby", "ace/mode/ruby"],
	["Rune parser", "rune-deparse.g", "test.rune-deparse", "ace/mode/text"],
	["Rust parser", "rust.g", "test.rs.txt", "ace/mode/rust"], /*github send ext '.rs' as application/rls-services+xml */
	["SableCC parser", "sablecc3x.g", "test.sablecc3x", "ace/mode/text"],
	["Scheme parser", "scheme.g", "test.scheme", "ace/mode/lisp"],
	["SC-im spreadsheet parser", "sc-im.g", "test.sc-im", "ace/mode/text"],
	["SDCC C parser (partially working)", "sdcc.g", "test.c", "ace/mode/c_cpp"],
	["SLK parser", "slk-parser.g", "test.slk-parser", "ace/mode/yaml"],
	["Smalltalk parser", "smalltalk-shikantaza.g", "test.smalltalk", "ace/mode/text"],
	["SMLSharp parser", "smlsharp-iml.g", "test.smlsharp-iml", "ace/mode/ocaml"],
	["Souffle parser", "souffle.g", "test.souffle", "ace/mode/prolog"],
	["SQLite3 PIPES modified parser (partially working)", "sqlite3-pipe-dad.g", "test.sqlite3-pipe-dad", "ace/mode/sql"],
	["SQLite3 modified parser (partially working)", "sqlite3-dad.g", "test.sqlite3", "ace/mode/sql"],
	["SQLite3 parser (partially working)", "sqlite3.g", "test.sqlite3", "ace/mode/sql"],
	["S/SL parser", "s-sl.g", "test.s-sl", "ace/mode/tex"],
	["Stanc3 parser", "stanc3-parser.g", "test.stanc3", "ace/mode/text"],
	["Streem-lang parser", "streem-lang.g", "test.streem-lang", "ace/mode/text"],
	["SuperC C parser", "SuperC_cparser.g", "test.c", "ace/mode/c_cpp"],
	["Swift lexer (partially working)", "swift-lexer.g", "test.swift", "ace/mode/swift"],
	["Tc parser", "tc-eaburns.g", "test.tc-eaburns", "ace/mode/c_cpp"],
	["Tablegen-LLVM parser (partially working)", "tablegen-llvm.g", "test.tablegen-llvm", "ace/mode/yaml"],
	["Tang parser (partially working)", "tangParser.g", "test.tangParser", "ace/mode/c_cpp"],
	["Tameparse parser (not working)", "tameparser.g", "test.tameparser", "ace/mode/yaml"],
	["Tarantol SQL parser (partially working)", "tarantol-sql.g", "test.tarantol-sql", "ace/mode/sql"],
	["TDengine SQL parser", "tdengine-sql.g", "test.tdengine-sql", "ace/mode/sql"],
	["Tendra sid parser", "tendra-sid.g", "test.tendra-sid", "ace/mode/text"],
	["Textdiagram parser", "textdiagram.g", "test.textdiagram", "ace/mode/text"],
	["Textmapper parser", "textmapper.g", "test.tm", "ace/mode/yaml"],
	["Thrift nano parser", "thrift-nano.g", "test.thrift-nano", "ace/mode/text"],
	["Thrift parser", "thrift.g", "test.thrift-nano", "ace/mode/text"],
	["Tidb SQL parser (be patient)(partially working)", "tidb-sql.g", "test.mysql", "ace/mode/sql"],
	["Tinycompiler parser", "tinycompiler-parser.g", "test.tinycompiler-parser", "ace/mode/c_cpp"],
	["TJS parser", "tjs.g", "test.tjs", "ace/mode/c_cpp"],
	["Toucan cpu/gpu parser", "toucan-gpu-cpu.g", "test.toucan-gpu-cpu", "ace/mode/c_cpp"],
	["Tradofion SQL parser (be patient)(partially working)", "tradofion-sqlparser.g", "test.tradofion-sql", "ace/mode/sql"],
	["Tradofion SQL parser fallback (be patient)(partially working)", "tradofion-sqlparser-fallback.g", "test.tradofion-sql", "ace/mode/sql"],
	["Treelang parser", "treelang.g", "test.treelang", "ace/mode/c_cpp"],
	["Typedmoon parser", "typedmoon.g", "test.typedmoon", "ace/mode/lua"],
	["Typeling parser", "typeling.g", "test.typeling", "ace/mode/rust"],
	["Typescript lexer", "typescript-dad.g", "test.typescript-dad", "ace/mode/typescript"],
	["Unicc parser", "unicc.g", "test.unicc", "ace/mode/yaml"],
	["Urweb parser (partially working)", "urweb.g", "test.urweb", "ace/mode/text"],
	["Vitess SQL parser (be patient)(partially working)", "sql-vitess.g", "test.sql-vitess", "ace/mode/sql"],
	["Vitess SQL parser with fallback (partially working)", "sql-vitess-fallback.g", "test.sql-vitess", "ace/mode/sql"],
	["Vlang lexer (partially working)", "vlang-lexer.g", "test.vlang", "ace/mode/text"],
	["Webassembly interpreter parser", "wasm-interpreter.g", "test.wast", "ace/mode/lisp"],
	["Webassembly wat owi parser", "wasm-owi.g", "test.wasm-owi", "ace/mode/lisp"],
	["Wisey parser", "wisey.g", "test.wisey", "ace/mode/c_cpp"],
	["WisiToken parser", "WisiToken.g", "test.WisiToken", "ace/mode/lisp"],
	["X64 ASM ATT parser", "x64asm-att.g", "test.x64asm-att", "ace/mode/assembly_x86"],
	["XMC parser", "xmc-model-checker.g", "test.xmc-model-checker", "ace/mode/text"],
	["XML parser", "xml.g", "test.xml.txt", "ace/mode/xml"],
	["XML parser Eiffel", "xml_eiffel_parser.g", "test.xml_eiffel_parser", "ace/mode/xml"],
	["Yaep parser", "yaep.g", "test.yaep", "ace/mode/yaml"],
	["Yecc parser erlang", "yecc.g", "test.yecc", "ace/mode/erlang"],
	["Z80 assembler parser", "z80-asm.g", "test.z80-asm", "ace/mode/assembly_x86"],
	["ZScript parser", "ffscript.g", "test.ffscript", "ace/mode/c_cpp"],
	["ZetaSQL parser (be patient)(partially working)", "zetasql.g", "test.zetasql", "ace/mode/sql"],
];

function loadLalr_sample(self) {
  if(userContentHasChanged)
  {
	let ok = confirm("Your changes will be lost !\nIf the changes you've made are important save then before proceed.\nCopy and paste to your prefered editor and save it.\nEither OK or Cancel.");
	if(!ok) return false;
  }
  let base_url = "./"
  if(self.selectedIndex > 0) {
      let sample_to_use = sampleList[self.selectedIndex-1];
      $.get(base_url + sample_to_use[1], function( data ) {
        grammarEditor.setValue( data );
	grammarContentHasChanged = false;
	userContentHasChanged = false;
      });
      $.get(base_url + sample_to_use[2], function( data ) {
        codeEditor.setValue( data );
	codeEditor.getSession().setMode(sample_to_use[3]);
	inputContentHasChanged = false;
	userContentHasChanged = false;
      });
  }
}

//$('#ast-mode').val(localStorage.getItem('optimizationMode') || '2');
$('#auto-refresh').prop('checked', localStorage.getItem('autoRefresh') === 'true');
$('#parse').prop('disabled', $('#auto-refresh').prop('checked'));

// Parse
function escapeHtml(unsafe) {
  return unsafe
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

function nl2br(str) {
  return str.replace(/\n/g, '<br>\n')
}

function textToErrors(str) {
  let errors = [];
  var regExp = /([^\n]+?)\n/g, match;
  while (match = regExp.exec(str)) {
    let msg = match[1];
    let line_col = msg.match(/error:(\d+):(\d+):/);
    if (line_col) {
      errors.push({"ln": line_col[1], "col":line_col[2], "msg": msg});
    } else {
      errors.push({"msg": msg});
    }
  }
  return errors;
}

function generateErrorListHTML(errors) {
  let html = '<ul>';

  html += $.map(errors, function (x) {
    if (x.ln > 0) {
      return '<li data-ln="' + x.ln + '" data-col="' + x.col +
        '"><span>' + escapeHtml(x.msg) + '</span></li>';
    } else {
      return '<li><span>' + escapeHtml(x.msg) + '</span></li>';
    }
  }).join('');

  html += '<ul>';

  return html;
}

function updateLocalStorage() {
  if(grammarContentHasChanged || inputContentHasChanged)
  {
    localStorage.setItem('grammarText', grammarEditor.getValue());
    localStorage.setItem('codeText', codeEditor.getValue());
    grammarContentHasChanged = false;
    inputContentHasChanged = false;
    localStorage.setItem('userContentHasChanged', userContentHasChanged);
  }
  //localStorage.setItem('optimizationMode', $('#opt-mode').val());
  //localStorage.setItem('autoRefresh', $('#auto-refresh').prop('checked'));
}

var parse_start_time = 0;

function parse() {
  const $grammarValidation = $('#grammar-validation');
  const $grammarInfo = $('#grammar-info');
  const grammarText = grammarEditor.getValue();

  const $codeValidation = $('#code-validation');
  const $codeInfo = $('#code-info');
  const codeText = codeEditor.getValue();

  const dbgMode = $('#dbg-mode').val();
  const show_dbg = $('#show-dbg').prop('checked');

  const generate_ebnf = $('#generate-action').val() == 'ebnf';
  const generate_yacc = $('#generate-action').val() == 'yacc';
  const generate_lex = $('#generate-action').val() == 'lex';
  const generate_lex_me = $('#generate-action').val() == 'lex_me';
  const generate_sql = $('#generate-action').val() == 'sql';
  const generate_yacc_html = $('#generate-action').val() == 'yacc_html';
  const generate_master = $('#generate-action').val() == 'master';
  const generate_cpp_parser = $('#generate-action').val() == 'cpp_parser';

  $grammarInfo.html('');
  $grammarValidation.hide();
  $codeInfo.html('');
  $codeValidation.hide();
  codeDbg.setValue('');

  outputs.compile_status = '';
  outputs.parse_status = '';
  outputs.parse_stats = '';
  outputs.parse_debug = '';
  outputs.parse_time = '';
  outputs.parse_ebnf_yacc = '';

  if (grammarText.length === 0) {
    return;
  }

  $('#overlay').css({
    'z-index': '1',
    'display': 'block',
    'background-color': 'rgba(0, 0, 0, 0.1)'
  });

  window.setTimeout(() => {
    parse_start_time = new Date().getTime();
    let dump_grammar_lexer = false;
    let dump_grammar_regexes = false;
    let dump_grammar_lsm = false;
    let dump_grammar_gsm = false;
    let dump_grammar_parse_tree = 0;
    let dump_grammar_parse_trace = false;
    let dump_input_lexer = false;
    let dump_input_parse_tree = 0;
    let dump_input_parse_trace = false;
    let dump_ebnf_yacc = false;

    if(show_dbg)
    {
	switch(dbgMode)
	{
		case 'iptreep': dump_input_parse_tree = 1; break;
		case 'iptreef': dump_input_parse_tree = 2; break;
		case 'iptrace': dump_input_parse_trace = true; break;
		case 'il': dump_input_lexer = true; break;
		case 'gptreep': dump_grammar_parse_tree = 1; break;
		case 'gptreef': dump_grammar_parse_tree = 2; break;
		case 'gptrace': dump_grammar_parse_trace = true; break;
		case 'gl': dump_grammar_lexer = true; break;
		case 'glrx': dump_grammar_regexes = true; break;
		case 'glsm': dump_grammar_lsm = true; break;
		case 'ggsm': dump_grammar_gsm = true; break;
	}
    }
    if(generate_ebnf) dump_ebnf_yacc = 1;
    else if(generate_yacc) dump_ebnf_yacc = 2;
    else if(generate_lex) dump_ebnf_yacc = 3;
    else if(generate_lex_me) dump_ebnf_yacc = 4;
    else if(generate_yacc_html) dump_ebnf_yacc = 5;
    else if(generate_sql) dump_ebnf_yacc = 6;

    parsertl(
        grammarText,
        codeText,
        dump_grammar_lexer,
        dump_grammar_regexes,
        dump_grammar_lsm,
        dump_grammar_gsm,
        dump_grammar_parse_tree,
        dump_grammar_parse_trace,
        dump_input_lexer,
        dump_input_parse_tree,
        dump_input_parse_trace,
        generate_master,
        generate_cpp_parser,
        dump_ebnf_yacc);

    $('#overlay').css({
      'z-index': '-1',
      'display': 'none',
      'background-color': 'rgba(1, 1, 1, 1.0)'
    });

    const isGenEBNF = result.parse == -3;
    if (result.compile == 0 || isGenEBNF) {
      $grammarValidation.removeClass('validation-invalid').show();

      //codeLexer.insert(outputs.lexer);

      if (result.parse == 0) {
        $codeValidation.removeClass('validation-invalid').show();
      } else {
        $codeValidation.addClass('validation-invalid').show();
      }

      if(outputs.parse_ebnf_yacc.length) {
	//if(generate_yacc_html)
	//{
	//	const win = window.open('', 'Yacc_HTML_linked');
	//	win.document.write(outputs.compile_status);
	//	win.document.close();
	//	win.focus();
	//}
	//else
	      $grammarInfo.html("<pre>" + escapeHtml(outputs.parse_ebnf_yacc.replaceAll("'\\''", '"\'"')) + "</pre>");
	      try {
		navigator.clipboard.writeText(outputs.parse_ebnf_yacc);
	      }
	      catch(e)
	      {
		      console.log("Failed to copy generated EBNF/YACC to clipboard");
	      }
        return;
      }

      if (outputs.parse_stats.length > 0) {
        const errors = textToErrors(outputs.parse_stats);
        const html = generateErrorListHTML(errors);
        $codeInfo.html(html);
      }
      else {
        //const parse_end_time = new Date().getTime();
        //$codeInfo.html('Execution time: ' + (parse_end_time - parse_start_time) + ' ms');
        $codeInfo.html(outputs.parse_time);
	$grammarInfo.html("<pre>" + outputs.parse_stats + "</pre>");
      }
    } else {
      $grammarValidation.addClass('validation-invalid').show();
    }

    if (outputs.compile_status.length > 0) {
      const errors = textToErrors(outputs.compile_status);
      const html = generateErrorListHTML(errors);
      $grammarInfo.html(html);
    }

    if (outputs.parse_debug.length > 0) {
      codeDbg.setValue(outputs.parse_debug);
    }
  }, 0);
}

// Event handing for text editing
let timer;
function setupTimer() {
  clearTimeout(timer);
  timer = setTimeout(() => {
    updateLocalStorage();
    if ($('#auto-refresh').prop('checked')) {
      parse();
    }
  }, 200);
};
grammarEditor.getSession().on('change', setupTimer);
codeEditor.getSession().on('change', setupTimer);

// Event handing in the info area
function makeOnClickInInfo(editor) {
  return function () {
    const el = $(this);
    let line = el.data('ln') - 1;
    let col = el.data('col') - 1;
    editor.navigateTo(line, col);
    editor.scrollToLine(line, true, false, null);
    editor.focus();
  }
};
$('#grammar-info').on('click', 'li[data-ln]', makeOnClickInInfo(grammarEditor));
$('#code-info').on('click', 'li[data-ln]', makeOnClickInInfo(codeEditor));

// Event handing in the AST optimization
$('#opt-mode').on('change', setupTimer);
$('#generate-action').on('change', setupTimer);
$('#show-dbg').on('change', setupTimer);
$('#auto-refresh').on('change', () => {
  updateLocalStorage();
  $('#parse').prop('disabled', $('#auto-refresh').prop('checked'));
  setupTimer();
});
$('#parse').on('click', parse);

// Resize editors to fit their parents
function resizeEditorsToParent() {
  codeEditor.resize();
  codeEditor.renderer.updateFull();
  codeDbg.resize();
  codeDbg.renderer.updateFull();
}

// Show windows
function setupToolWindow(lsKeyName, buttonSel, codeSel, showDefault) {
  let storedValue = localStorage.getItem(lsKeyName);
  if (!storedValue) {
    localStorage.setItem(lsKeyName, showDefault);
    storedValue = localStorage.getItem(lsKeyName);
  }
  let show = storedValue === 'true';
  $(buttonSel).prop('checked', show);
  $(codeSel).css({ 'display': show ? 'block' : 'none' });

  $(buttonSel).on('change', () => {
    show = !show;
    localStorage.setItem(lsKeyName, show);
    $(codeSel).css({ 'display': show ? 'block' : 'none' });
    resizeEditorsToParent();
  });
}

setupToolWindow('show-dbg', '#show-dbg', '#code-dbg', true);

// Show page
$('#main').css({
  'display': 'flex',
});

// used to collect output from C
var outputs = {
  'default': '',
  'compile_status': '',
  'parse_debug': '',
  'parse_status': '',
  'parse_stats': '',
  'parse_time': '',
  'parse_ebnf_yacc': '',
};

// current output (key in `outputs`)
var output = "default";

// results of the various stages
var result = {
  'compile': 0,
  'parse': 0,
  'ast': 0,
};

// gram_grep function: initialized when emscripten runtime loads
var parsertl = null;

// Emscripten
var Module = {

  // intercept stdout (print) and stderr (printErr)
  // note: text received is line based and missing final '\n'

  'print': function(text) {
    outputs[output] += text + "\n";
  },
  'printErr': function(text) {
    outputs[output] += text + "\n";
  },

  // called when emscripten runtime is initialized
  'onRuntimeInitialized': function() {
    // wrap the C `parse` function
    parsertl = cwrap('main_playground', 'number', ['string', 'string',
	  'number', 'number', 'number', 'number', 'number', 'number',
	  'number', 'number', 'number']);
    // Initial parse
    if ($('#auto-refresh').prop('checked')) {
      parse();
    }
  },
};

function doFinalSettings() {
	let select_samples = document.getElementById('opt-samples');
	sampleList.map( (lang, i) => {
           let opt = document.createElement("option");
           opt.value = i; // the index
           opt.innerHTML = lang[0];
           select_samples.append(opt);
        });
}

// vim: sw=2:sts=2
