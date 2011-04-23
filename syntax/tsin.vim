" VIM Syntax File
" Language:	ICL/Fujitsu TPMS Termianl SImulator input files
" Maintainer:	Andy Long (Andrew.Long@Yahoo.com)
" LastChange:	$Date$
" Version:	$Revision$
" Remarks:	TPMS is the Transaction Processing system for VME mainframe
"		systems. Terminal Simulator is a program that feeds messages
"		to the service at specified intervals.
" $Log: tsin.vim,v $
"
if version<600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syntax	match	tsinError
	\	/\S\+/
"
"	Relative Times determins how long after the start of the service that
"	the message will be input. It can be omitted in which case the message
"	will be input as soon as the preceding message finishes. The
"	terminating Comma must be included, however
"
syntax	match	tsinRelativeFlag contained nextgroup=tsinTimeStamp
	\	/\<R/
syntax	match	tsinTimeStamp contained
	\	/\d\{2}:\=[0-5][0-9]:\=[0-5][0-9]\%(\.\d\+\)\=\>/
syntax	match	tsinRelativeTime contained contains=tsinRelativeFlag,tsinError,tsinComma skipwhite nextgroup=tsinRepeats,tsinStringConst
	\	/\(\<R.\{-}\)\=,\s*/
"
"	The terminal name may be omitted, in which case the message is assumed
"	to be for the same terminal as the previous message. The terminating
"	Comma must be included, however.
"
syntax	match	tsinTerminalName contained
	\	/\<\a\k\{,11}\>/
syntax	match	tsinSourceTerminal contained contains=tsinTerminalName,tsinError,tsinComma skipwhite nextgroup=tsinRelativeTime
	\	/^.\{-},\s*/
"
"	The message will be submitted 'Repeats' times, with 'Interval' 10ths
"	of a second between them. If 'Repeats' is omitted then 'INterval' must
"	also be omitted, along with both of their Commas.
"
syntax	match	tsinRepeats contained skipwhite nextgroup=tsinInterval,tsinError
	\	/\<\d\+\>\s*,\s*/
syntax	match	tsinInterval contained skipwhite nextgroup=tsinStringConst,tsinError
	\	/\<\d\+\>\s*,\s*/

syntax	region	tsinHexError contained
	\	start=/@/ end=/@/ end=/$/
syntax	match	tsinHexEsc contained
	\	/@/
syntax	match	tsinHexNumber contained contains=tsinHexEsc
	\	/@\%([0-9A-F][0-9A-F]\)*@/

syntax	match	tsinStringEsc
	\	contained
	\	/''/

syntax	region	tsinError oneline keepend extend
	\	start=/'/ end=/'/ end=/$/
syntax	region	tsinStringConst oneline keepend extend contains=tsinQuote,tsinStringEsc,tsinHexNumber,tsinHexError
	\	start=/'/ skip=/''/ end=/'/

syntax	keyword	tsinTodo containedin=tsinComment
	\	TODO	FIXME	FIXTHIS

syntax	match	tsinQuote contained
	\	/'/
syntax	match	tsinComma contained
	\	/,/
"
"	Terminal Simulator input lines are up to 80 characters long. The first
"	line of any message must contain information that allows TPMS to
"	schedule the message (i.e. originating terminal, the time that the
"	message can be submitted, and how many times it shoyld be submitted.
"
"	Long messages can be broken up by terminating the data string at any
"	point up to column 79 and putting a 'C' in column 80. The data string
"	is then continued on the next line.
"
syntax	match	tsinContinuationFlag contained
	\	/\<C\s*$/
syntax	match	tsinLine contains=tsinSourceTerminal,tsinRelativeTime,tsinStringConst,tsinError
	\	/^.\{,79} */
syntax	match	tsinLine contains=tsinSourceTerminal,tsinStringConst,tsinError skipwhite nextgroup=tsinContinuationFlag
	\	/^.\{79}/
"
"	Any lines longer than 80 characters are ERRORS.
"
syntax	match	tsinError
	\	/^.\{81,}/

if version >= 508 || !exists("did_c_syn_inits")
	if version < 508
		let did_c_syn_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	HiLink	tsinTerminalName	Identifier

	HiLink	tsinRepeats		Number
	HiLink	tsinInterval		Number
	HiLink	tsinHexNumber		Number
	HiLink	tsinTimeStamp		Number

	HiLink	tsinComment		Comment

	HiLink	tsinLine		Comment

	HiLink	tsinConstant		Constant

	HiLink	tsinStringConst		String

	HiLink	tsinStatement		Statement

	HiLink	tsinSpecial		Special
	HiLink	tsinSpecialChar		SpecialChar
	HiLink	tsinHexEsc		Delimiter
	HiLink	tsinQuote		Delimiter
	HiLink	tsinStringEsc		Delimiter
	HiLink	tsinContinuationFlag	Delimiter
	HiLink	tsinRelativeFlag	Delimiter
	HiLink	tsinDelimiter		Delimiter
	HiLink	tsinComma		Delimiter
	HiLink	tsinTag			Tag
	HiLink	tsinSpecialComment	SpecialComment
	HiLink	tsinDebug		Debug

	HiLink	tsinUnderlined		Underlined

	HiLink	tsinIgnore		Ignore

	HiLink	tsinError		Error
	HiLink	tsinHexError		Error

	HiLink	tsinTodo		Todo

	delcommand HiLink
endif

let b:current_syntax = "tsin"

