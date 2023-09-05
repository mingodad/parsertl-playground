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

const grammarEditor = setupEditorArea("grammar-editor", "grammarText");
grammarEditor.getSession().setMode("ace/mode/yaml");
const codeEditor = setupEditorArea("code-editor", "codeText");

const codeDbg = setupInfoArea("code-dbg");

const sampleList = [
	//title, grammar, input, input ace syntax
	["Calculator parser", "calculator.g", "test-calc.txt", "ace/mode/text"],
	["Playground parser", "playground-master.g", "calculator.g", "ace/mode/yaml"],
	["Playground3 parser", "playground-master3.g", "playground-master3.g", "ace/mode/yaml"],
	["GramGrep parser", "grammar.g", "calculator.g", "ace/mode/yaml"],
	["Cql parser", "cql.g", "test.cql", "ace/mode/sql"],
	["Postgresql parser (be patient)", "postgres16.g", "test.sql", "ace/mode/sql"],
	["Carbon parser (need review of '*')", "carbon-lang.g", "prelude.carbon", "ace/mode/typescript"],
	["Java11 parser", "java11.g", "test.java", "ace/mode/java"],
	["Json parser", "json.g", "test.json.txt", "ace/mode/json"],
	["Json lexer", "json-lexer.g", "test.json.txt", "ace/mode/json"],
	["Json5 parser", "json5.g", "test.json5.txt", "ace/mode/json"],
	["Ispc parser", "ispc.g", "test.ispc", "ace/mode/c_cpp"],
	["Linden Script parser", "lsl_ext.g", "test.lsl", "ace/mode/text"],
	["LALR parser", "lalr.g", "test.lalr", "ace/mode/yaml"],
	["XML parser", "xml.g", "test.xml.txt", "ace/mode/xml"],
	["Lua parser", "lua.g", "test.lua", "ace/mode/lua"],
	["Lua-5.3 parser", "lua-5.3.g", "test.lua", "ace/mode/lua"],
	["Lua2ljs parser", "lua2ljs.g", "test.lua", "ace/mode/lua"],
	["JavascriptCore parser", "javascript-core.g", "test.js.txt", "ace/mode/javascript"],
	["C3c  parser", "c3lang.g", "test.c3lang", "ace/mode/c_cpp"],
	["Ansi C parser", "cparser.g", "test.c", "ace/mode/c_cpp"],
	["Ansi C11 parser (partially working)", "c11-ansi-c.g", "test.c", "ace/mode/c_cpp"],
	["Ansi C18 parser (partially working)", "c18-ansi.g", "test.c", "ace/mode/c_cpp"],
	["PnetC parser", "pnet-c.g", "test.c", "ace/mode/c_cpp"],
	["PnetJava parser", "pnet-java.g", "test.java", "ace/mode/java"],
	["PnetVBasic parser", "pnet-vb.g", "test.vb", "ace/mode/vbscript"],
	["PnetCSHarp parser", "pnet-cs.g", "test.cs", "ace/mode/c_cpp"],
	["PnetDPas parser", "pnet-dpas.g", "test.dpas", "ace/mode/pascal"],
	["Rust parser", "rust.g", "test.rs.txt", "ace/mode/rust"], /*github send ext '.rs' as application/rls-services+xml */
	["Ada parser", "ada-adayacc.g", "test.adb", "ace/mode/ada"],
	["Souffle parser", "souffle.g", "test.souffle", "ace/mode/prolog"],
	["Chapel parser", "chapel.g", "test.chapel", "ace/mode/c_cpp"],
	["Textmapper parser", "textmapper.g", "test.tm", "ace/mode/yaml"],
	["Antlr4.5 parser", "antlr-v4.5.g", "test.antlr", "ace/mode/yaml"],
	["idl2cpp parser", "idl2cpp.g", "test.idl", "ace/mode/c_cpp"],
	["Doxygen code scanner torture", "code-doxygen.g", "test.c", "ace/mode/c_cpp"],
	["HTML parser", "html-parser.g", "index.html", "ace/mode/html"],
	["Lark parser", "lark.g", "test.lark", "ace/mode/yaml"],
	["MSTA parser", "msta.g", "test.msta", "ace/mode/yaml"],
	["Textdiagram parser", "textdiagram.g", "test.textdiagram", "ace/mode/text"],
	["Pikchr parser", "pikchr.g", "test.pikchr", "ace/mode/text"],
	["Scheme parser", "scheme.g", "test.scheme", "ace/mode/lisp"],
	["Minic parser", "minic.g", "test.minic", "ace/mode/c_cpp"],
	["Z80 assembler parser", "z80-asm.g", "test.z80-asm", "ace/mode/assembly_x86"],
	["Peg parser (partially working)", "peg.g", "test.peg", "ace/mode/yaml"],
	["LPegrex parser (partially working)", "lpegrex.g", "test.lpegrex", "ace/mode/yaml"],
	["CocoR parser (partially working)", "cocor.g", "test.cocor", "ace/mode/yaml"],
	["Openscad parser (partially working)", "openscad.g", "test.openscad", "ace/mode/text"],
	["LuaPP parser (partially working)", "luapp.g", "test.luapp", "ace/mode/lua"],
	["Bison parser (partially working)", "bison.g", "carbon-lang.y", "ace/mode/yaml"],
	["Lezer parser (partially working)", "lezer.g", "expression.lezer", "ace/mode/yaml"],
	["LFortran parser (partially working)", "lfortran.g", "test.fortran", "ace/mode/fortran"],
	["Blawn parser", "blawn-parser.g", "test.blawn", "ace/mode/python"],
	["Tameparse parser (not working)", "tameparser.g", "test.tameparser", "ace/mode/yaml"],
	["LPython parser (not working)", "lpython.g", "test.python", "ace/mode/python"],
	["Akwa parser (not working)", "akwa.g", "test.awk", "ace/mode/text"],
	["Ecere parser (not working)", "ecere.g", "test.ecere", "ace/mode/c_cpp"],
	["Cxx parser (not working)", "CxxParser.g", "test.cpp", "ace/mode/c_cpp"],
	["Cpp5-v2 parser (not working)", "cpp5-v2.g", "test.cpp", "ace/mode/c_cpp"],
	["Preprocessor parser (not working)", "pp.g", "test.pp", "ace/mode/c_cpp"],
	["Mulang parser (not working)", "mulang.g", "test.mulang", "ace/mode/text"],
	["Braille parser (not working)", "braille.g", "test.braille", "ace/mode/text"],
	["Minizinc parser (not working)", "minizinc.g", "test.mzn", "ace/mode/text"],
];

function loadLalr_sample(self) {
  let base_url = "./"
  if(self.selectedIndex > 0) {
      let sample_to_use = sampleList[self.selectedIndex-1];
      $.get(base_url + sample_to_use[1], function( data ) {
        grammarEditor.setValue( data );
      });
      $.get(base_url + sample_to_use[2], function( data ) {
        codeEditor.setValue( data );
	codeEditor.getSession().setMode(sample_to_use[3]);
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
  localStorage.setItem('grammarText', grammarEditor.getValue());
  localStorage.setItem('codeText', codeEditor.getValue());
  //localStorage.setItem('optimizationMode', $('#opt-mode').val());
  localStorage.setItem('autoRefresh', $('#auto-refresh').prop('checked'));
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
    let dump_grammar_parse_tree = false;
    let dump_grammar_parse_trace = false;
    let dump_input_lexer = false;
    let dump_input_parse_tree = false;
    let dump_input_parse_trace = false;
    let dump_ebnf_yacc = false;

    if(show_dbg)
    {
	switch(dbgMode)
	{
		case 'iptree': dump_input_parse_tree = true; break;
		case 'iptrace': dump_input_parse_trace = true; break;
		case 'il': dump_input_lexer = true; break;
		case 'gptree': dump_grammar_parse_tree = true; break;
		case 'gptrace': dump_grammar_parse_trace = true; break;
		case 'gl': dump_grammar_lexer = true; break;
		case 'glsm': dump_grammar_lsm = true; break;
		case 'ggsm': dump_grammar_gsm = true; break;
	}
    }
    if(generate_ebnf) dump_ebnf_yacc = 1;
    else if(generate_yacc) dump_ebnf_yacc = 2;
    else if(generate_yacc_html) dump_ebnf_yacc = 3;

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
