" Vim syntax file
" Language: Pug
" Maintainer: Joshua Borton
" Credits: Tim Pope
" Filenames: *.pug

if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'pug'
endif

silent! syntax include @htmlCoffeescript syntax/coffee.vim
unlet! b:current_syntax
silent! syntax include @htmlStylus syntax/stylus.vim
unlet! b:current_syntax
silent! syntax include @htmlMarkdown syntax/markdown.vim
unlet! b:current_syntax
silent! syntax include @htmlJS syntax/javascript.vim
unlet! b:current_syntax

syn case match

syntax match pugEnclosure "\(\[\|\]\|{\|}\|(\|)\)"
      \ contained

highlight def link pugEnclosure SpecialChar

syn region  javascriptParenthesisBlock matchgroup=pugEnclosure start="(" end=")" contains=@htmlJavascript contained keepend
syn cluster htmlJavascript add=javascriptParenthesisBlock

syn region  pugJavascript matchgroup=pugJavascriptOutputChar start="[!&]\==\|\~" skip=",\s*$" end="$" contained contains=@htmlJavascript keepend
syn region  pugJavascript matchgroup=pugJavascriptChar start="-" skip=",\s*$" end="$" contained contains=@htmlJavascript keepend
syn cluster pugTop contains=pugBegin,pugComment,pugHtmlComment,pugJavascript
syn match   pugBegin "^\s*\%([<>]\|&[^=~ ]\)\@!" nextgroup=PugElement,pugTag,pugClassChar,pugIdChar,pugPlainChar,pugJavascript,pugScriptConditional,pugScriptStatement,pugPipedText
syn match   pugTag "+\?\<[[:alnum:]_-]\+\%(:\w\+\)\=" contained nextgroup=@pugComponent,pugId,PugClass
execute 'syn match PugElement "+\?\<\(' . join(g:pug_elements, '\|') . '\)\(-\|\w\)\@!\%(:\w\+\)\=" contained nextgroup=@pugComponent,pugId,PugClass'
syn cluster pugComponent contains=pugAttributes,pugBlockExpansionChar,pugPlainChar,pugJavascript,pugTagBlockChar,pugTagInlineText
syntax keyword pugCommentTodo  contained TODO FIXME XXX TBD
syn match   pugComment '\(\s\+\|^\)\/\/.*$' contains=pugCommentTodo,@Spell
syn region  pugCommentBlock start="\z(\s\+\|^\)\/\/.*$" end="^\%(\z1\s\|\s*$\)\@!" contains=pugCommentTodo,@Spell keepend
syn region  pugHtmlConditionalComment start="<!--\%(.*\)>" end="<!\%(.*\)-->" contains=pugCommentTodo,@Spell
syn region  pugAngular2 matchgroup=pugEnclosure start="(" end=")" contains=htmlEvent
syn region  pugJavascriptString start=+"+  skip=+\\\("\|$\)+  end=+"\|$+ contained
syn region  pugJavascriptString start=+'+  skip=+\\\('\|$\)+  end=+'\|$+ contained
syn region  pugAttributes matchgroup=pugEnclosure start="(" end=")" contained contains=pugJavascriptString,pugHtmlArg,pugAngular2,htmlArg,htmlEvent,htmlCssDefinition,pugVueOn,pugVueBind,pugOperator,pugVueDir,pugAttribute nextgroup=@pugComponent
syn match   pugBlockExpansionChar ":\s\+" contained nextgroup=pugTag,pugClassChar,pugIdChar
syn match   pugClass "\.\%(\w\|-\)\+" contained nextgroup=@pugComponent,pugClass,pugId
syn match   pugId "#\%(\w\|-\)\+" contained nextgroup=@pugComponent,pugId,pugClass
syn region  pugDocType start="^\s*\(!!!\|doctype\)" end="$"
" Unless I'm mistaken, syntax/html.vim requires
" that the = sign be present for these matches.
" This adds the matches back for pug.
syn keyword pugHtmlArg contained href title

syn match   pugPlainChar "\\" contained
syn region  pugInterpolation matchgroup=pugInterpolationDelimiter start="[#!]{" end="}" contains=@htmlJavascript
syn match   pugInterpolationEscape "\\\@<!\%(\\\\\)*\\\%(\\\ze#{\|#\ze{\)"
syn match   pugTagInlineText "\s.*$" contained contains=pugInterpolation,pugTextInlinePug,@Spell,pugVueInterpolation
syn region  pugPipedText matchgroup=pugPipeChar start="|" end="$" contained contains=pugInterpolation,pugTextInlinePug nextgroup=pugPipedText skipnl
syn match   pugTagBlockChar "\.$" contained nextgroup=pugTagBlockText,pugTagBlockEnd skipnl
syn region  pugTagBlockText start="\%(\s*\)\S" end="\ze\n" contained contains=pugInterpolation,pugTextInlinePug,@Spell nextgroup=pugTagBlockText,pugTagBlockEnd skipnl
syn region  pugTagBlockEnd start="\s*\S" end="$" contained contains=pugInterpolation,pugTextInlinePug nextgroup=pugBegin skipnl
syn region  pugTextInlinePug matchgroup=pugInlineDelimiter start="#\[" end="]" contains=pugTag keepend

syn region  pugJavascriptFilter matchgroup=pugFilter start="^\z(\s*\):javascript\s*$" end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlJavascript
syn region  pugMarkdownFilter matchgroup=pugFilter start=/^\z(\s*\):\%(markdown\|marked\)\s*$/ end=/^\%(\z1\s\|\s*$\)\@!/ contains=@htmlMarkdown
syn region  pugStylusFilter matchgroup=pugFilter start="^\z(\s*\):stylus\s*$" end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlStylus
syn region  pugPlainFilter matchgroup=pugFilter start="^\z(\s*\):\%(sass\|less\|cdata\)\s*$" end="^\%(\z1\s\|\s*$\)\@!"

syn match  pugScriptConditional "^\s*\<\%(if\|else\|else if\|elif\|unless\|while\|until\|case\|when\|default\)\>[?!]\@!"
syn match  pugScriptStatement "^\s*\<\%(each\|for\|block\|prepend\|append\|mixin\|extends\|include\)\>[?!]\@!"
syn region  pugScriptLoopRegion start="^\s*\(for \)" end="$" contains=pugScriptLoopKeywords
syn keyword  pugScriptLoopKeywords for in contained

syn region  pugJavascript start="^\z(\s*\)script\%(:\w\+\)\=" end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlJavascript,pugJavascriptTag,pugCoffeescriptFilter keepend

syn region  pugCoffeescriptFilter matchgroup=pugFilter start="^\z(\s*\):coffee-\?script\s*$" end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlCoffeescript contained
syn region  pugJavascriptTag contained start="^\z(\s*\)script\%(:\w\+\)\=" end="$" contains=pugBegin,pugTag
syn region  pugCssBlock        start="^\z(\s*\)style" nextgroup=@pugComponent,pugError  end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlStylus keepend

syn match  pugError "\$" contained

syn region pugVueInterpolation matchgroup=PugEnclosure start="{{" end="}}" contained contains=@htmlJS

syn match pugAttribute "\<\(\w\|-\)*\(\>\|=\@=\|)\@=\)" contained
syn match pugVueOn "@\(\w\|-\|\.\)*" contained
syn match pugVueBind ":\(\w\|-\|\.\)*" contained
syn match pugVueDir "v-\(\w\|-\|\.\)*" contained
syn match pugOperator "=" contained

hi def link pugPlainChar              Special
hi def link pugScriptConditional      PreProc
hi def link pugScriptLoopKeywords     PreProc
hi def link pugScriptStatement        PreProc
hi def link pugHtmlArg                htmlArg
hi def link pugAttributeString        String
hi def link pugAttribute              Type
hi def link pugAttributesDelimiter    Identifier
hi def link pugBlockExpansionChar     Special
hi def link pugPipeChar               Special
hi def link pugTagBlockChar           Special
hi def link pugId                     Identifier
hi def link pugClass                  Identifier
hi def link pugInterpolationDelimiter Delimiter
hi def link pugInlineDelimiter        Delimiter
hi def link pugFilter                 PreProc
hi def link pugDocType                PreProc
hi def link pugCommentTodo            Todo
hi def link pugComment                Comment
hi def link pugCommentBlock           Comment
hi def link pugHtmlConditionalComment pugComment
hi def link pugJavascriptString       String
hi def link pugVueOn                  Directory
hi def link pugVueBind                Directory
hi def link pugVueDir                 Directory
hi def link pugOperator               Operator
hi def link pugElement                Statement
hi def link pugTag                    Directory

let b:current_syntax = "pug"

if main_syntax == "pug"
  unlet main_syntax
endif
