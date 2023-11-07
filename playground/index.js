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
	["Ada parser", "ada-adayacc.g", "test.adb", "ace/mode/ada"],
	["Age parser", "cypher_gram.g", "test.cypher_gram", "ace/mode/sql"],
	["Akwa parser (not working)", "akwa.g", "test.awk", "ace/mode/text"],
	["AlaSQL parser", "alasql-parser.g", "test.alasql", "ace/mode/sql"],
	["Aliceml parser (partially working)", "aliceml.g", "test.aliceml", "ace/mode/ocaml"],
	["Anna parser ", "anna-parser.g", "test.anna", "ace/mode/Go"],
	["Ansi C11 parser (partially working)", "c11-ansi-c.g", "test.c", "ace/mode/c_cpp"],
	["Ansi C18 parser (partially working)", "c18-ansi.g", "test.c", "ace/mode/c_cpp"],
	["Ansi C parser", "cparser.g", "test.c", "ace/mode/c_cpp"],
	["Antlr4.5 parser", "antlr-v4.5.g", "test.antlr", "ace/mode/yaml"],
	["AM parser", "am-parser.g", "test.am-parser", "ace/mode/Makefile"],
	["ArangoDB AQL parser", "arangodb-aql.g", "test.arangodb-aql", "ace/mode/text"],
	["Austral parser (partially working)", "austral-parser.g", "test.austral", "ace/mode/text"],
	["BaikalDB SQL parser", "BaikalDB-sql.g", "test.BaikalDB-sql", "ace/mode/sql"],
	["Basil parser", "basil-grammar.g", "test.basil-grammar", "ace/mode/yaml"],
	["Bayeslite parser", "bayeslite.g", "test.bayeslite", "ace/mode/text"],
	["BC calculator", "bc.g", "test.bc-calculator", "ace/mode/sh"],
	["Beaver parser", "beaver-grammar.g", "test.beaver-grammar", "ace/mode/yaml"],
	["Bison parser", "bison.g", "carbon-lang.y", "ace/mode/yaml"],
	["Blog-lang parser", "blog-lang.g", "test.blog-lang", "ace/mode/text"],
	["BNFGen parser", "bnfgen.g", "test.bnfgen", "ace/mode/yaml"],
	["Bolt parser", "bolt-parser.g", "test.bolt", "ace/mode/c_cpp"],
	["Blawn parser", "blawn-parser.g", "test.blawn", "ace/mode/python"],
	["Braille parser (not working)", "braille.g", "test.braille", "ace/mode/text"],
	["Build your own prog. lang. CH13 parser", "build-your-own-programming-language-ch13.g", "test-ch13.java", "ace/mode/java"],
	["C3c  parser", "c3lang.g", "test.c3lang", "ace/mode/c_cpp"],
	["Calculator parser", "calculator.g", "test-calc.txt", "ace/mode/text"],
	["Carbon parser (need review of '*')", "carbon-lang.g", "prelude.carbon", "ace/mode/typescript"],
	["CG-CQL-old parser", "cql.g", "test.cql", "ace/mode/sql"],
	["CG-CQL-author parser", "cg-cql-author.g", "test.cg-cql-author", "ace/mode/sql"],
	["Chapel parser", "chapel.g", "test.chapel", "ace/mode/c_cpp"],
	["CocoR parser (partially working)", "cocor.g", "test.cocor", "ace/mode/yaml"],
	["condb2 sql parser", "condb2-sql.g", "test.sqlite3", "ace/mode/sql"],
	["CoqPP parser", "coqpp_parse.g", "test.coqpp", "ace/mode/yaml"],
	["Cpp5-v2 parser (not working)", "cpp5-v2.g", "test.cpp", "ace/mode/c_cpp"],
	["C parser frama-c (partially working)", "cparser-frama-c.g", "test.frama-c", "ace/mode/c_cpp"],
	["CSS parser from VLC", "CSSGrammar-vlc.g", "style.css", "ace/mode/css"],
	["Cxx parser (not working)", "CxxParser.g", "test.cpp", "ace/mode/c_cpp"],
	["Cyclone parser (partially working)", "cyclone.g", "test.cyclone", "ace/mode/c_cpp"],
	["D parser (partially working)", "dlang-uaiso.g", "test.d", "ace/mode/c_cpp"],
	["Delphi parser (partially working)", "delphi.g", "test.delphi", "ace/mode/pascal"],
	["Dino-lang parser", "dino-lang.g", "test.dino-lang", "ace/mode/c_cpp"],
	["Doxygen code scanner torture", "code-doxygen.g", "test.c", "ace/mode/c_cpp"],
	["DuckDB SQL parser (be patient)", "duckdb-pgsql.g", "test.duckdb", "ace/mode/sql"],
	["Dynare preprocessor parser (partially working)", "dynare-pp.g", "test.dynare-pp", "ace/mode/javascript"],
	["Ebnf2bnf parser", "ebnf2bnf.g", "test.ebnf2bnf", "ace/mode/yaml"],
	["Ecere parser (not working)", "ecere.g", "test.ecere", "ace/mode/c_cpp"],
	["Estree parser", "estree.g", "test.estree", "ace/mode/txt"],
	["Expr-lang parser", "expr-lang.g", "test.expr-lang", "ace/mode/txt"],
	["Fault-lang parser (partially working)", "fault-lang-ext.g", "test.fault-lang", "ace/mode/txt"],
	["Faust parser", "faustparser.g", "test.faustparser", "ace/mode/txt"],
	["Firebird DSQL parser", "firebird-dsql.g", "test.firebird-dsql", "ace/mode/sql"],
	["Fortune sheet formula parser", "fortune-sheet-formula.g", "test.fortune-sheet-formula", "ace/mode/txt"],
	["FsLex parser", "fslex.g", "test.fslex", "ace/mode/yaml"],
	["FsYacc parser", "fsyacc.g", "test.fsyacc", "ace/mode/yaml"],
	["GramGrep parser", "grammar.g", "calculator.g", "ace/mode/yaml"],
	["Graphql parser", "libgraphql.g", "test.libgraphql", "ace/mode/yaml"],
	["Gringo-Clingo parser non grounding (partially working)", "gringo-ngp.g", "test.gringo-ngp", "ace/mode/text"],
	["Hawq SQL parser (be patient)", "hawq-sql.g", "test.sql", "ace/mode/sql"],
	["Hime parser", "hime-grammar.g", "test.hime-grammar", "ace/mode/yaml"],
	["HQL (ECL) parser (be patient)", "hqlgram.g", "test.hqlgram", "ace/mode/pascal"],
	["HTML parser", "html-parser.g", "index.html", "ace/mode/html"],
	["Hue SQL generic parser", "hue-generic.g", "test.hue-generic", "ace/mode/sql"],
	["idl2cpp parser", "idl2cpp.g", "test.idl", "ace/mode/c_cpp"],
	["Influxql parser", "influxql-sql.g", "test.influxql-sql", "ace/mode/sql"],
	["Ispc parser", "ispc.g", "test.ispc", "ace/mode/c_cpp"],
	["Java11 parser", "java11.g", "test.java", "ace/mode/java"],
	["JavascriptCore parser", "javascript-core.g", "test.js.txt", "ace/mode/javascript"],
	["Jq parser (partially working)", "jq-parser.g", "test.jq", "ace/mode/text"],
	["Json5 parser", "json5.g", "test.json5.txt", "ace/mode/json"],
	["Json lexer", "json-lexer.g", "test.json.txt", "ace/mode/json"],
	["Json parser", "json.g", "test.json.txt", "ace/mode/json"],
	["Koka-lang parser (partially working)", "koka-lang.g", "test.koka-lang", "ace/mode/text"],
	["LALR parser", "lalr.g", "test.lalr", "ace/mode/yaml"],
	["Lark parser", "lark.g", "test.lark", "ace/mode/yaml"],
	["Lezer parser (partially working)", "lezer.g", "test.lezer", "ace/mode/yaml"],
	["LFortran parser (partially working)", "lfortran.g", "test.fortran", "ace/mode/fortran"],
	["Linden Script parser", "lsl_ext.g", "test.lsl", "ace/mode/text"],
	["Lox parser", "lox-lalrpop.g", "test.lox", "ace/mode/javascript"],
	["LPegrex parser (partially working)", "lpegrex.g", "test.lpegrex", "ace/mode/yaml"],
	["LPython parser (not working)", "lpython.g", "test.python", "ace/mode/python"],
	["Lua2ljs parser", "lua2ljs.g", "test.lua", "ace/mode/lua"],
	["Lua-5.3 parser", "lua-5.3.g", "test.lua", "ace/mode/lua"],
	["Lua parser", "lua.g", "test.lua", "ace/mode/lua"],
	["LuaPP parser (partially working)", "luapp.g", "test.luapp", "ace/mode/lua"],
	["Make parser (from anjuta)", "mk-parser.g", "test.mk-parser", "ace/mode/Makefile"],
	["MangoFix parser", "mangofix.g", "test.mangofix", "ace/mode/c_cpp"],
	["Matrixone MYSQL parser (be patient)(partially working)", "matrixone-mysql.g", "test.mysql", "ace/mode/sql"],
	["Menhir stage1 parser", "menhir-stage1-parser.g", "menhir-stage1-parser.mly", "ace/mode/yaml"],
	["Menhir fancy parser", "menhir-fancy-parser.g", "menhir-fancy-parser.mly", "ace/mode/yaml"],
	["Menhir fancy parser left recursion", "menhir-fancy-parser-left-rec.g", "menhir-fancy-parser.mly", "ace/mode/yaml"],
	["Minic parser", "minic.g", "test.minic", "ace/mode/c_cpp"],
	["Minizinc parser (not working)", "minizinc.g", "test.mzn", "ace/mode/text"],
	["MSTA parser", "msta.g", "test.msta", "ace/mode/yaml"],
	["mtail parser", "mtail.g", "test.mtail", "ace/mode/yaml"],
	["Mulang parser (not working)", "mulang.g", "test.mulang", "ace/mode/text"],
	["Mysql parser (be patient)(partially working)", "mysql.g", "test.mysql", "ace/mode/sql"],
	["N1QL parser", "n1ql.g", "test.n1ql", "ace/mode/sql"],
	["NASL parser", "nasl-parser.g", "test.nasl", "ace/mode/shell"],
	["Nearley parser", "nearley.g", "test.nearley", "ace/mode/yaml"],
	["Nebula parser", "nebula-parser.g", "test.nebula-parser", "ace/mode/sql"],
	["OcamlLex parser (partially working)", "ocaml-lex.g", "test.ocamllex", "ace/mode/ocaml"],
	["Oberon parser", "oberon.g", "test.oberon", "ace/mode/pascal"],
	["Ocaml parser from rescript (partially working)", "rescript-ocaml-parser.g", "test.ocaml", "ace/mode/ocaml"],
	["OctoSQL parser (partially working)", "OctoSQL-parser.g", "test.OctoSQL-parser", "ace/mode/sql"],
	["Openscad parser (partially working)", "openscad.g", "test.openscad", "ace/mode/text"],
	["PCC cccom parser (partially working)", "pcc-cccom.g", "test.c", "ace/mode/c_cpp"],
	["PCC cxxcom parser (partially working)", "pcc-cxxcom.g", "test.c", "ace/mode/c_cpp"],
	["Peg parser (partially working)", "peg.g", "test.peg", "ace/mode/yaml"],
	["PHP-8.2 parser (partially working)", "php-8.2.g", "test.php", "ace/mode/php"],
	["Pike-lang parser", "pike-lang.g", "test.pike", "ace/mode/c_cpp"],
	["Pikchr parser", "pikchr.g", "test.pikchr", "ace/mode/text"],
	["Playground3 parser", "playground-master3.g", "playground-master3.g", "ace/mode/yaml"],
	["Playground parser", "playground-master.g", "calc-alias.g", "ace/mode/yaml"],
	["PnetC parser", "pnet-c.g", "test.c", "ace/mode/c_cpp"],
	["PnetCSHarp parser", "pnet-cs.g", "test.cs", "ace/mode/c_cpp"],
	["PnetDPas parser", "pnet-dpas.g", "test.dpas", "ace/mode/pascal"],
	["PnetJava parser", "pnet-java.g", "test.java", "ace/mode/java"],
	["PnetVBasic parser", "pnet-vb.g", "test.vb", "ace/mode/vbscript"],
	["Postgresql parser (be patient)", "postgres16.g", "test.sql", "ace/mode/sql"],
	["Postgresql parser with fallback", "postgres16-fallback.g", "test.sql", "ace/mode/sql"],
	["Preprocessor parser (not working)", "pp.g", "test.pp", "ace/mode/c_cpp"],
	["Protobuf3 parser", "pb_parsing_parser.g", "test.proto3", "ace/mode/c_cpp"],
	["Pyethon parser", "pyethon.g", "test.pyethon", "ace/mode/python"],
	["R parser (partially working)", "r-parser.g", "test.r-parser", "ace/mode/r"],
	["ReasonML parser (partially working)", "reason_parser.g", "test.reason", "ace/mode/javascript"],
	["Rune parser", "rune-deparse.g", "test.rune-deparse", "ace/mode/text"],
	["Rust parser", "rust.g", "test.rs.txt", "ace/mode/rust"], /*github send ext '.rs' as application/rls-services+xml */
	["SC-im spreadsheet parser", "sc-im.g", "test.sc-im", "ace/mode/text"],
	["Scheme parser", "scheme.g", "test.scheme", "ace/mode/lisp"],
	["SDCC C parser (partially working)", "sdcc.g", "test.c", "ace/mode/c_cpp"],
	["SLK parser", "slk-parser.g", "test.slk-parser", "ace/mode/yaml"],
	["Souffle parser", "souffle.g", "test.souffle", "ace/mode/prolog"],
	["SQLite3 parser (partially working)", "sqlite3.g", "test.sqlite3", "ace/mode/sql"],
	["SQLite3 modified parser (partially working)", "sqlite3-dad.g", "test.sqlite3", "ace/mode/sql"],
	["Stanc3 parser", "stanc3-parser.g", "test.stanc3", "ace/mode/text"],
	["Tameparse parser (not working)", "tameparser.g", "test.tameparser", "ace/mode/yaml"],
	["Tarantol SQL parser (partially working)", "tarantol-sql.g", "test.tarantol-sql", "ace/mode/sql"],
	["TDengine SQL parser", "tdengine-sql.g", "test.tdengine-sql", "ace/mode/sql"],
	["Textdiagram parser", "textdiagram.g", "test.textdiagram", "ace/mode/text"],
	["Textmapper parser", "textmapper.g", "test.tm", "ace/mode/yaml"],
	["Thrift nano parser", "thrift-nano.g", "test.thrift-nano", "ace/mode/text"],
	["Thrift parser", "thrift.g", "test.thrift-nano", "ace/mode/text"],
	["Tidb SQL parser (be patient)(partially working)", "tidb-sql.g", "test.mysql", "ace/mode/sql"],
	["Tradofion SQL parser (be patient)(partially working)", "tradofion-sqlparser.g", "test.tradofion-sql", "ace/mode/sql"],
	["Tradofion SQL parser fallback (be patient)(partially working)", "tradofion-sqlparser-fallback.g", "test.tradofion-sql", "ace/mode/sql"],
	["Treelang parser", "treelang.g", "test.treelang", "ace/mode/c_cpp"],
	["Typedmoon parser", "typedmoon.g", "test.typedmoon", "ace/mode/lua"],
	["Webassembly interpreter parser", "wasm-interpreter.g", "test.wast", "ace/mode/lisp"],
	["Vitess SQL parser (be patient)(partially working)", "sql-vitess.g", "test.sql-vitess", "ace/mode/sql"],
	["X64 ASM ATT parser", "x64asm-att.g", "test.x64asm-att", "ace/mode/assembly_x86"],
	["XML parser", "xml.g", "test.xml.txt", "ace/mode/xml"],
	["Z80 assembler parser", "z80-asm.g", "test.z80-asm", "ace/mode/assembly_x86"],
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
  const generate_yacc_html = $('#generate-action').val() == 'yacc_html';

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
		case 'glsm': dump_grammar_lsm = true; break;
		case 'ggsm': dump_grammar_gsm = true; break;
	}
    }
    if(generate_ebnf) dump_ebnf_yacc = 1;
    else if(generate_yacc) dump_ebnf_yacc = 2;
    else if(generate_lex) dump_ebnf_yacc = 3;
    else if(generate_yacc_html) dump_ebnf_yacc = 4;

    parsertl(
        grammarText,
        codeText,
        dump_grammar_lexer,
        dump_grammar_lsm,
        dump_grammar_gsm,
        dump_grammar_parse_tree,
        dump_grammar_parse_trace,
        dump_input_lexer,
        dump_input_parse_tree,
        dump_input_parse_trace,
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
