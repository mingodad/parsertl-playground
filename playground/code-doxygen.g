//From: https://github.com/doxygen/doxygen/blob/master/src/code.l
/******************************************************************************
 *
 * Copyright (C) 1997-2020 by Dimitri van Heesch.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation under the terms of the GNU General Public License is hereby
 * granted. No representations are made about the suitability of this software
 * for any purpose. It is provided "as is" without express or implied warranty.
 * See the GNU General Public License for more details.
 *
 * Documents produced by Doxygen are derivative works derived from the
 * input used in their production; they are not affected by this license.
 *
 */

%token ILLEGAL_CHARACTER

%%
%%

%x      SkipString
%x      SkipStringS
%x      SkipVerbString
%x      SkipCPP
%x      SkipComment
%x      SkipCxxComment
%x      RemoveSpecialCComment
%x      Body
%x      FuncCall
%x      MemberCall
%x      MemberCall2
%x      SkipInits
%x      ClassName
%x      AlignAs
%x      AlignAsEnd
%x      PackageName
%x      ClassVar
%x      CppCliTypeModifierFollowup
%x      Bases
%x      SkipSharp
%x      ReadInclude
%x      TemplDecl
%x      TemplCast
%x      CallEnd
%x      ObjCMethod
%x      ObjCParams
%x      ObjCParamType
%x      ObjCCall
%x      ObjCMName
%x      ObjCSkipStr
%x      ObjCCallComment
%x      OldStyleArgs
%x      ConceptName
%x      UsingName
%x      RawString
%x      InlineInit
%x      ModuleName
%x      ModuleImport

B       [ \t]
Bopt    {B}
BN      [ \t\n\r]
ID      [$a-z_A-Z\x80-\xFF][$a-z_A-Z0-9\x80-\xFF]*
SEP     ("::"|"\\")
SCOPENAME ("::"{BN}*)?({ID}{BN}*{SEP}{BN}*)*("~"{BN}*)?{ID}
TEMPLIST "<"[^\"\}\{\(\)\/\n\>]*">"
SCOPETNAME (((({ID}{TEMPLIST}?){BN}*)?{SEP}{BN}*)*)((~{BN}*)?{ID})
SCOPEPREFIX ({ID}{TEMPLIST}?{BN}*{SEP}{BN}*)+
KEYWORD_OBJC ("@public"|"@private"|"@protected"|"@class"|"@implementation"|"@interface"|"@end"|"@selector"|"@protocol"|"@optional"|"@required"|"@throw"|"@synthesize"|"@property")
  /* please also pay attention to skipLanguageSpecificKeyword when changing the list of keywords. */
KEYWORD ("asm"|"__assume"|"auto"|"class"|"const"|"delete"|"enum"|"explicit"|"extern"|"false"|"friend"|"gcnew"|"gcroot"|"set"|"get"|"inline"|"internal"|"mutable"|"namespace"|"new"|"null"|"nullptr"|"override"|"operator"|"pin_ptr"|"private"|"protected"|"public"|"raise"|"register"|"remove"|"self"|"sizeof"|"static"|"struct"|"__super"|"function"|"template"|"generic"|"this"|"true"|"typedef"|"typeid"|"typename"|"union"|"using"|"virtual"|"volatile"|"abstract"|"sealed"|"final"|"import"|"synchronized"|"transient"|"alignas"|"alignof"|"concept"|"requires"|"decltype"|{KEYWORD_OBJC}|"constexpr"|"consteval"|"constinit"|"co_await"|"co_return"|"co_yield"|"static_assert"|"_Static_assert"|"noexcept"|"thread_local"|"enum"{B}+("class"|"struct"))
FLOWKW  ("break"|"catch"|"continue"|"default"|"do"|"else"|"finally"|"return"|"switch"|"throw"|"throws"|"@catch"|"@finally")
FLOWCONDITION  ("case"|"for"|"foreach"|"for each"|"goto"|"if"|"try"|"while"|"@try")
TYPEKW  ("bool"|"byte"|"char"|"char8_t"|"char16_t"|"char32_t"|"double"|"float"|"int"|"long"|"object"|"short"|"signed"|"unsigned"|"void"|"wchar_t"|"size_t"|"boolean"|"id"|"SEL"|"string"|"nullptr")
TYPEKWSL ("LocalObject"|"Object"|"Value")
CASTKW ("const_cast"|"dynamic_cast"|"reinterpret_cast"|"static_cast")
CHARLIT   (("'"\\[0-7]{1,3}"'")|("'"\\."'")|("'"[^' \\\n]{1,4}"'"))
ARITHOP "+"|"-"|"/"|"*"|"%"|"--"|"++"
ASSIGNOP "="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="
LOGICOP "=="|"!="|">"|"<"|">="|"<="|"&&"|"||"|"!"|"<=>"
BITOP   "&"|"|"|"^"|"<<"|">>"|"~"
OPERATOR {ARITHOP}|{ASSIGNOP}|{LOGICOP}|{BITOP}
RAWBEGIN  (u|U|L|u8)?R\"[^ \t\(\)\\]{0,16}"("
RAWEND    ")"[^ \t\(\)\\]{0,16}\"
MODULE_ID ({ID}".")*{ID}

  /* no comment start / end signs inside square brackets */
NCOMM [^/\*]
  //- start: NUMBER -------------------------------------------------------------------------
  // Note same defines in commentcnv.l: keep in sync
DECIMAL_INTEGER  [1-9][0-9']*[0-9]?[uU]?[lL]?[lL]?
HEXADECIMAL_INTEGER  "0"[xX][0-9a-zA-Z']+[0-9a-zA-Z]?
OCTAL_INTEGER  "0"[0-7][0-7']+[0-7]?
BINARY_INTEGER  "0"[bB][01][01']*[01]?
INTEGER_NUMBER {DECIMAL_INTEGER}|{HEXADECIMAL_INTEGER}|{OCTAL_INTEGER}|{BINARY_INTEGER}

FP_SUF [fFlL]

DIGIT_SEQ [0-9][0-9']*[0-9]?
FRAC_CONST {DIGIT_SEQ}"."|{DIGIT_SEQ}?"."{DIGIT_SEQ}
FP_EXP [eE][+-]?{DIGIT_SEQ}
DEC_FP1 {FRAC_CONST}{FP_EXP}?{FP_SUF}?
DEC_FP2 {DIGIT_SEQ}{FP_EXP}{FP_SUF}

HEX_DIGIT_SEQ [0-9a-fA-F][0-9a-fA-F']*[0-9a-fA-F]?
HEX_FRAC_CONST {HEX_DIGIT_SEQ}"."|{HEX_DIGIT_SEQ}?"."{HEX_DIGIT_SEQ}
BIN_EXP [pP][+-]?{DIGIT_SEQ}
HEX_FP1 "0"[xX]{HEX_FRAC_CONST}{BIN_EXP}{FP_SUF}?
HEX_FP2 "0"[xX]{HEX_DIGIT_SEQ}{BIN_EXP}{FP_SUF}?

FLOAT_DECIMAL {DEC_FP1}|{DEC_FP2}
FLOAT_HEXADECIMAL {HEX_FP1}|{HEX_FP2}
FLOAT_NUMBER {FLOAT_DECIMAL}|{FLOAT_HEXADECIMAL}
NUMBER {INTEGER_NUMBER}|{FLOAT_NUMBER}
  //- end: NUMBER ---------------------------------------------------------------------------

  // C start comment
CCS   "/\*"
  // C end comment
CCE   "*\/"
  // Cpp comment
CPPC  "/\/"

  // ENDIDopt
ENDIDopt ("::"{ID})
  // Optional end qualifiers
ENDQopt ("const"|"volatile"|"sealed"|"override")({BN}+("const"|"volatile"|"sealed"|"override"))

%%

<*>\x0d	skip()
<Body>^([ \t]*"#"[ \t]*("include"|"import")[ \t]*)("<"|"\"")<ReadInclude>
<Body>("@interface"|"@implementation"|"@protocol")[ \t\n]+<ClassName>
<Body>(("public"|"private"){B}+)?("ref"|"value"|"interface"|"enum"){B}+("class"|"struct")<ClassName>
/*<Body>"property"|"event"/{BN}*<.>*/
<Body>("partial"{B}+)?("class"|"struct"|"union"|"namespace"|"interface"){B}+<ClassName>
<Body>("package")[ \t\n]+<PackageName>
<ClassVar>\n<Body>
<Body,ClassVar,Bases>"-"|"+"<ObjCMethod>
<ObjCMethod>":"<ObjCParams>
<ObjCParams>"("<ObjCParamType>
<ObjCParams,ObjCMethod>";"|"{"<Body>
<ObjCParams>{ID}{B}*":"<.>
<ObjCParamType>{TYPEKW}<.>
<ObjCParamType>{ID}<.>
<ObjCParamType>")"<ObjCParams>
<ObjCParams>{ID}<.>
<ObjCMethod,ObjCParams,ObjCParamType>{ID}<.>
<ObjCMethod,ObjCParams,ObjCParamType>.<.>
<ObjCMethod,ObjCParams,ObjCParamType>\n<.>
/*<ReadInclude>[^\n\"\>]+/(">"|"\"")<Body>*/
<Body,Bases>^[ \t]*"#"<SkipCPP>
<SkipCPP>\"<SkipString>
<SkipCPP>.<.>
<SkipCPP>[^\n\/\\\"]+<.>
<SkipCPP>\\[\r]?\n<.>
/*<SkipCPP>{CPPC}/[^/!]<.>*/
<Body,FuncCall>"{"<Body>
<Body,FuncCall,MemberCall,MemberCall2>"}"<Body>
<Body,ClassVar>"@end"<Body>
<ClassName,ClassVar>";"<Body>
<ClassName,ClassVar>[*&^%]+<Body>
<ClassName>"__declspec"{B}*"("{B}*{ID}{B}*")"<.>
<ClassName>{ID}("."{ID})*<ClassVar>
<ClassName>{ID}("::"{ID})*<ClassVar>
<AlignAs>"("<AlignAsEnd>
<AlignAs>\n<.>
<AlignAs>.<.>
<AlignAsEnd>"("<.>
<AlignAsEnd>")"<ClassName>
<AlignAsEnd>\n<.>
<AlignAsEnd>.<.>
<ClassName>{ID}("\\"{ID})*<ClassVar>               // PHP namespace
<ClassName>{ID}{B}*"("{ID}")"<ClassVar>            // Obj-C category
<PackageName>{ID}("."{ID})*<.>
<ClassVar>"="<Body>
<ClassVar>("extends"|"implements")<Bases>       // Java, Slice
/*<ClassVar>("sealed"|"abstract")/{BN}*(":"|"{")<CppCliTypeModifierFollowup>*/
<ClassVar>{ID}<.>
<ClassName,ClassVar,CppCliTypeModifierFollowup>{B}*":"{B}*<Bases>
<PackageName>[ \t]*";"<Body>
/*<Bases>^{Bopt}/"@"{ID}<Body> // Objective-C interface*/
<Bases,ClassName,ClassVar,CppCliTypeModifierFollowup>{B}*"{"{B}*<Body>
<Bases>"virtual"|"public"|"protected"|"private"|"@public"|"@private"|"@protected"<.>
<Bases>{SEP}?({ID}{SEP})*{ID}<.>
<Bases>"<"<SkipSharp>
<Bases>">"<.>
<SkipSharp>"<"<.>
<SkipSharp>">"<Bases>
<SkipSharp>"\""<SkipString>
<SkipSharp>"\'"<SkipStringS>
<Bases>"("<SkipSharp>
<SkipSharp>"("<.>
<SkipSharp>")"<Bases>
<Bases>","<.>

/*
<Body>{SCOPEPREFIX}?"operator"{B}*"()"{Bopt}/"("<FuncCall>
<Body>{SCOPEPREFIX}?"operator"/"("<FuncCall>
<Body>{SCOPEPREFIX}?"operator"[^a-z_A-Z0-9\(\n]+/"("<FuncCall>
<Body,TemplDecl>("template"|"generic")/([^a-zA-Z0-9])<.>
*/
<Body>"concept"{BN}+<ConceptName>
<Body>"using"{BN}+"namespace"{BN}+<UsingName>
<Body>"using"{BN}+<UsingName>
/*
<Body>"module"/{B}*[:;]?<ModuleName>                // 'module X' or 'module : private' or 'module;'
<Body>"import"/{B}*[<":]?<ModuleImport>
*/
<ConceptName>{ID}("::"{ID})*<.>
<ConceptName>"="<Body>
<UsingName>{ID}(("::"|"."){ID})*<Body>
<UsingName>\n<Body>
<UsingName>.<Body>
<Body,FuncCall>"$"?"this"("->"|".")<.>
/*
<Body>{KEYWORD}/([^a-z_A-Z0-9])<.>
<Body>{KEYWORD}/{B}*<.>
<Body>{KEYWORD}/{BN}*"("<.>
<FuncCall>"in"/{BN}*<.>
<Body>{FLOWKW}/{BN}*"("<FuncCall>
<Body>{FLOWCONDITION}/{BN}*"("<FuncCall>
<Body>{FLOWKW}/([^a-z_A-Z0-9])<.>
<Body>{FLOWCONDITION}/([^a-z_A-Z0-9])<.>
<Body>{FLOWKW}/{B}*<.>
<Body>{FLOWCONDITION}/{B}*<.>
*/
<Body>"*"{B}*")"<FuncCall>                         // end of cast?
<Body>"\\)"|"\\("<.>
<Body>[\\|\)\+\-\/\%\~\!]<FuncCall>
/*
<Body,TemplDecl,ObjCMethod>{TYPEKW}/{B}*<.>
<Body,TemplDecl,ObjCMethod>{TYPEKWSL}/{B}*<.>
<Body>"generic"/{B}*"<"[^\n\/\-\.\{\"\>]*">"{B}*<TemplDecl>
<Body>"template"/{B}*"<"[^\n\/\-\.\{\"\>]*">"{B}*<TemplDecl>  // template<...>
*/
<TemplDecl>"class"|"typename"<.>
<TemplDecl>"<"<.>
<TemplDecl>">"<Body>
<TemplCast>">"<.>
<TemplCast>{ID}("::"{ID})*<.>
<TemplCast>("const"|"volatile"){B}*<.>
<TemplCast>[*^]*<.>
<Body,MemberCall2,FuncCall>{CASTKW}{B}*"<"<TemplCast>   // static_cast<T>(
//<Body>"$this->"{SCOPENAME}/{BN}*[;,)\]]<.>  // PHP member variable
//<Body,TemplCast>{SCOPENAME}{B}*"<"[^\n\/\-\.\{\"\>\(']*">"{ENDIDopt}/{B}*<.>  // A<T> *pt;
<ModuleName,ModuleImport>{MODULE_ID}({BN}*":"{BN}*{MODULE_ID})?<.>
<ModuleName>":"{BN}+"private"<.>
<ModuleName>";"<Body>
<ModuleName>.<.>
<ModuleName>\n<.>
<ModuleImport>["<]<ReadInclude>
<ModuleImport>";"<Body>
<ModuleImport>.<.>
<ModuleImport>\n                        skip()
/*
<Body>{SCOPENAME}/{BN}*[:;,)\]]<.>          // "int var;" or "var, var2" or "debug(f) macro" , or int var : 5;
<Body>{ID}("."{ID})+/{BN}+<.>               // CSharp/Java scope
<Body>"export"/{B}*<.>
<Body>{SCOPENAME}/{B}*<.>                   // p->func()
<Body>"("{B}*("*"{B}*)+{SCOPENAME}+{B}*")"/{B}*<.>   // (*p)->func() but not "if (p) ..."
<Body>{SCOPETNAME}{B}*"<"[^\n\/\-\.\{\"\>]*">"/{BN}*"("<FuncCall>
<Body>{SCOPETNAME}/{BN}*"("<FuncCall>              // a() or c::a() or t<A,B>::a() or A\B\foo()
*/
<FuncCall,Body,MemberCall,MemberCall2,SkipInits,InlineInit>{RAWBEGIN}<RawString>
<FuncCall,Body,MemberCall,MemberCall2,SkipInits,InlineInit,ClassVar>\"<SkipString>
<FuncCall,Body,MemberCall,MemberCall2,SkipInits,InlineInit>{NUMBER}<.>  //Note similar code in commentcnv.l
<FuncCall,Body,MemberCall,MemberCall2,SkipInits,InlineInit>\'<SkipStringS>
<SkipString>[^\"\\\r\n]*<.>
<SkipStringS>[^\'\\\r\n]*<.>
<SkipString,SkipStringS>{CPPC}|{CCS}<.>
<SkipString>@?\"<.>
<SkipStringS>\'<.>
<SkipString,SkipStringS>\\.<.>
<RawString>{RAWEND}<.>
<RawString>[^)\n]+<.>
<RawString>.<.>
<RawString>\n<.>
<SkipVerbString>[^"\n]+<.>
<SkipVerbString>\"\"<.>                     // escaped quote
<SkipVerbString>\"<.>                       // end of string
<SkipVerbString>.<.>
<SkipVerbString>\n<.>
<Body>":"<.>
<Body>"<"<.>
<Body>">"<.>
<Body,MemberCall,MemberCall2,FuncCall>"'"((\\0[Xx0-9]+)|(\\.)|(.))"'"<.>
<Body>"."|"->"<MemberCall>
/*
<MemberCall>{SCOPETNAME}/{BN}*"("<.>
<MemberCall>{SCOPENAME}/{B}*<.>
*/
<Body>[,=;\[]<ObjCCall>
<ObjCCall,ObjCMName>"["|"{"<ObjCCall>
<ObjCCall,ObjCMName>"]"|"}"<ObjCMName>
<ObjCCall,ObjCMName>{CPPC}.*<.>
<ObjCCall,ObjCMName>{CCS}<ObjCCallComment>
<ObjCCallComment>{CCE}<.>
<ObjCCallComment>[^*\n]+          skip()
<ObjCCallComment>{CPPC}|{CCS}<.>
<ObjCCallComment>\n<.>
<ObjCCallComment>.<.>
<ObjCCall>{ID}<ObjCMName>
/*
<ObjCMName>{ID}/{BN}*"]"<.>
<ObjCMName>{ID}/{BN}*":"<.>
*/
<ObjCSkipStr>[^\n\"$\\]*<.>
<ObjCSkipStr>\\.<.>
<ObjCSkipStr>"\""<.>
<ObjCCall,ObjCMName>{CHARLIT}<.>
<ObjCCall,ObjCMName>"@"?"\""<ObjCSkipStr>
<ObjCCall,ObjCMName,ObjCSkipStr>"$"<.>
<ObjCCall,ObjCMName>"("<.>
<ObjCCall,ObjCMName>")"<.>
//<ObjCSkipStr>"@"/"\""<.>               // needed to prevent matching the global rule (for C#)
<ObjCCall,ObjCMName,ObjCSkipStr>{ID}<.>
<ObjCCall,ObjCMName,ObjCSkipStr>.<.>
<ObjCCall,ObjCMName,ObjCSkipStr>\n skip()

<Body>"]"<.>
<Body>[0-9]+<.>
<Body>[0-9]+[xX][0-9A-Fa-f]+<.>
/*
<MemberCall2,FuncCall>{KEYWORD}/([^a-z_A-Z0-9])<.>
<MemberCall2,FuncCall,OldStyleArgs,TemplCast>{TYPEKW}/([^a-z_A-Z0-9])<.>
<MemberCall2,FuncCall,OldStyleArgs,TemplCast>{TYPEKWSL}/([^a-z_A-Z0-9])<.>
<MemberCall2,FuncCall>{FLOWKW}/([^a-z_A-Z0-9])<.>
<MemberCall2,FuncCall>{FLOWCONDITION}/([^a-z_A-Z0-9])<.>
*/
<MemberCall2,FuncCall>("::")?{ID}(({B}*"<"[^\n\[\](){}<>']*">")?({B}*"::"{B}*{ID})?)*<.>
<FuncCall>";"<Body>                            // probably a cast, not a function call
<MemberCall2,FuncCall>,<.>
<MemberCall2,FuncCall>"{"<InlineInit>
<InlineInit>"{"<.>
<InlineInit>"}"<.>
<InlineInit>\n                          skip()
<InlineInit>.<.>
<MemberCall2,FuncCall>"("<.>
<MemberCall2,FuncCall>{OPERATOR}<.>         // operator
<MemberCall,MemberCall2,FuncCall>("*"{B}*)?")"<CallEnd>
<MemberCall,MemberCall2,FuncCall>[;:]<CallEnd>   // recover from unexpected end of call
<CallEnd>[ \t\n]*                       skip()
<CallEnd>[;:]<SkipInits>
//<CallEnd>{ENDQopt}/{BN}*(";"|"="|"throw"{BN}*"(")<.>
<CallEnd,OldStyleArgs>("const"|"volatile"|"sealed"|"override")*({BN}+("const"|"volatile"|"sealed"|"override"))*{BN}*"{"<Body>
<CallEnd>"try"<.>                           // function-try-block
<CallEnd>"requires"<.>                      // function-try-block
<CallEnd>{ID}<OldStyleArgs>
<OldStyleArgs>{ID}<.>
<OldStyleArgs>[,;]<.>
<CallEnd,OldStyleArgs>"#"<SkipCPP>
<CallEnd>.<Body>
<SkipInits>";"<Body>
<SkipInits>"{"<Body>
<SkipInits>{ID}{B}*"{"<.>
<SkipInits>{ID}<.>
/*
<FuncCall>{ID}/"("<.>
<FuncCall>{ID}/("."|"->")<MemberCall2>
<FuncCall,MemberCall2>("("{B}*("*"{B}*)+{ID}+{B}*")"{B}*)/("."|"->")<MemberCall2>
<MemberCall2>{ID}/([ \t\n]*"(")<FuncCall>
<MemberCall2>{ID}/([ \t\n]*("."|"->"))<MemberCall2>
*/
<MemberCall2>"->"|"."<MemberCall>
<SkipComment>{CCS}("!"?){CCE}           skip()
<SkipComment>{CPPC}|{CCS}               skip()
<SkipComment>[^*\/\n]+                  skip()
<SkipComment>[ \t]*{CCE}                skip()
<SkipCxxComment>[^\r\n]*"\\"[\r]?\n     skip() // line continuation
<SkipCxxComment>[^\r\n]+                skip()
<SkipCxxComment>\r<.>   skip()
<SkipCxxComment>\n<.>                      skip()
<SkipCxxComment>.                       skip()
//<RemoveSpecialCComment>{CCE}{B}*\n({B}*\n)*({B}*(({CPPC}"@"[{}])|({CCS}"@"[{}]{CCE})){B}*\n)?{B}*{CCS}[*!]/{NCOMM} skip()
<RemoveSpecialCComment>{CCE}{B}*\n({B}*\n)*({B}*(({CPPC}"@"[{}])|({CCS}"@"[{}]{CCE})){B}*\n)? skip()
<RemoveSpecialCComment>{CCE}             skip()
<RemoveSpecialCComment>[^*\n]+  skip()
<RemoveSpecialCComment>{CPPC}|{CCS}<.>
<RemoveSpecialCComment>\n  skip()
<RemoveSpecialCComment>.<.>
<MemberCall>[^a-z_A-Z0-9(\n]<.>
<*>\n({B}*{CPPC}[!/][^\n]*\n)+            skip() // remove special one-line comment
//<SkipCPP>\n/(.|\n)                      skip()
<*>\n{B}*{CPPC}"@"[{}].*\n                  skip() // remove one-line group marker
<*>\n{B}*{CCS}"@"[{}]<SkipComment>                      // remove one-line group marker
<*>^{B}*{CPPC}"@"[{}].*\n                   skip() // remove one-line group marker
<*>^{B}*{CCS}"@"[{}]<SkipComment>                       // remove multi-line group marker
<*>^{B}*{CPPC}[!/][^\n]*                  skip() // remove special one-line comment
<*>{CPPC}[!/][^\n]*<.>                       // strip special one-line comment
/*
<*>\n{B}*{CCS}[!*]/{NCOMM}<SkipComment>
<*>^{B}*{CCS}"*"[*]+/[^/]<SkipComment>                  // special C "banner" comment block at a new line
<*>^{B}*{CCS}[!*]/{NCOMM}<SkipComment>               // special C comment block at a new line
<*>{CCS}[!*]/{NCOMM}<SkipComment>                    // special C comment block half way a line
*/
<*>{CCS}("!"?){CCE}<.>
<SkipComment>[^\*\n]+                   skip()
<*>{CCS}<SkipComment>                // check is to prevent getting stuck in skipping C++ comments
<*>@\"<SkipVerbString>                                  // C# verbatim string
<*>{CPPC}<SkipCxxComment>
<*>"("|"["<.>                               //yyextra->theCallContext.pushScope(yyextra->name, yyextra->type);
<*>")"|"]"<.>                              //yyextra->theCallContext.popScope(yyextra->name, yyextra->type);
<*>\n                                   skip()
<*>[\x80-\xFF]*<.> // keep utf8 characters together...
<*>.                                    ILLEGAL_CHARACTER

%%
