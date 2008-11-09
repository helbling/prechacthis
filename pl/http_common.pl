	
	
/*** html_throw(Throw, Options)
*    Options:
*       colorThrow(Length),
*       hideIndex(Persons),
*       absoluteIndex(Persons, ThrowingJuggler),
*       magic(Position, MagicPositions),
*       id(Prefix),
*/	
html_throw(Multiplex, Options) -->
	html_list(Multiplex, [throw|Options]).
	
	
html_throw_process_options(Throw, Options) -->
	html_throw_process_options(Throw, Options, Options).

html_throw_process_options(Throw, [], OriginalOptions) -->
	html_throw_content(Throw, OriginalOptions), !.
html_throw_process_options(Throw, [Option|Options], OriginalOptions) -->
	html_throw_option(Throw, Option, \html_throw_process_options(Throw, Options, OriginalOptions)).
	
	
	
html_throw_option(p(_Throw,0,_Origen), colorThrow(_Length), InnerHTML) -->
	html(InnerHTML), !.
html_throw_option(Throw, colorThrow(Length), InnerHTML) -->
	{
		Throw = p(_, Index, Origen),
		Index \= 0,
		pStyle(Length, Origen, Index, Style)
	},
	html(
		span([class(Style)],[InnerHTML])
	),!.
html_throw_option(_Throw, magic(Position, MagicPositions), InnerHTML) -->
	{
		memberchk(Position, MagicPositions)
	},
	html(
		span([class(magic), title('it\'s magic')],[InnerHTML])
	),!.
html_throw_option(_Throw, id(Prefix), InnerHTML) -->
	{
		html_throw_id_next(Prefix, Next),
		atom_concat(Prefix, Next, ID)
	},
	html(
		span([id(ID)],[InnerHTML])
	),!.
html_throw_option(_Throw, _Option, InnerHTML) -->
	html(InnerHTML).


html_throw_content(p(Throw, 0, _Origen), _Options) -->
	{
		ThrowPrint is round(Throw)		
	},
	html(ThrowPrint), !.
html_throw_content(p(Throw, Index, _Origen), Options) -->
	{
		Index \= 0,
		memberchk(hideIndex(Persons), Options),
		number(Persons),
		Persons < 3, !,
		float_to_shortpass(Throw, ThrowShort),
		a2Atom(ThrowShort, ThrowAtom)
	},
	html([ThrowAtom, 'p']).
html_throw_content(p(Throw, Index, _Origen), Options) -->
	{
		Index \= 0,
		memberchk(absoluteIndex(Persons, ThrowingJuggler), Options),
		number(ThrowingJuggler),
		number(Persons), !,
		CatchingJuggler is (ThrowingJuggler + Index) mod Persons,
		jugglerShown(CatchingJuggler, PrintIndex),
		float_to_shortpass(Throw, ThrowShort),
		a2Atom(ThrowShort, ThrowAtom)
	},
	html([ThrowAtom, 'p', sub([], [PrintIndex])]).
html_throw_content(p(Throw, Index, _Origen), _Options) -->
	{
		Index \= 0,
		float_to_shortpass(Throw, ThrowShort),
		a2Atom(ThrowShort, ThrowAtom),
		a2Atom(Index, IndexAtom)
	},
	html([ThrowAtom, 'p', sub([], [IndexAtom])]).



init_html_throw_id :-
	forall(recorded(html_throw_id, _, R), erase(R)).


html_throw_id_next(Prefix, Next) :-
	recorded(html_throw_id, id(Prefix, Last), LastRef),
	Next is Last + 1,
	erase(LastRef),
	recorda(html_throw_id, id(Prefix, Next)), !.
html_throw_id_next(Prefix, 0) :-
	recorda(html_throw_id, id(Prefix, 0)).
	





/*** html_list(List, Options)
*    Options:
*       td(Attributes)
*       list_seperator(Seperator)
*       list_left(Left)
*       list_right(Right)
*       befor(Befor)
*       after(After)
*/	
html_list(List, Options) -->
	{
		is_list(List), !
	},
	html_list_first_middle_last(List, Options).
html_list(NoList, Options) -->
	html_list_process_element_options(NoList, Options).


html_list_first_middle_last(List, Options) -->
	{
		append([First|Middle], [Last], List)
	},
	html_list_first(First, Options),
	html_list_seperator(Options),
	html_list_content(Middle, Options),
	html_list_last(Last, Options).


html_list_first(First, Options) -->
	{
		append(Options, [befor(\html_list_left(Options))], OptionsFirst)
	},
	html_list(First, OptionsFirst).

html_list_last(Last, Options) -->
	{
		append(Options, [after(\html_list_right(Options))], OptionsLast)
	},
	html_list(Last, OptionsLast).

html_list_content([], _Options) -->
	[], !.
html_list_content([Element], Options) --> 
	html_list(Element, Options), !.
html_list_content([Element|List], Options) -->
	html_list(Element, Options),
	html_list_seperator(Options),
	html_list_content(List, Options).


html_list_process_element_options(Throw, Options) -->
	html_list_process_element_options(Throw, Options, Options).

html_list_process_element_options(Element, [], OriginalOptions) -->
	html_list_element(Element, OriginalOptions), !.
html_list_process_element_options(Element, [Option|Options], OriginalOptions) -->
	html_list_element_option(Element, Option, \html_list_process_element_options(Element, Options, OriginalOptions)).



html_list_element_option(_Element, td(Attributes), InnerHTML) -->
	html(
		td(Attributes, [InnerHTML])
	),!.
html_list_element_option(_Element, befor(Befor), InnerHTML) -->
	html([
		Befor,
		InnerHTML
	]),!.
html_list_element_option(_Element, after(After), InnerHTML) -->
	html([
		InnerHTML,
		After
	]),!.
html_list_element_option(_Element, _Option, InnerHTML) -->
	html(InnerHTML).
	
	
	
html_list_element(Throw, Options) -->
	{
		memberchk(throw, Options), !
	},
	html_throw_process_options(Throw, Options).
html_list_element(Element, _Options) -->
	html(Element).


html_list_seperator(Options) -->
	{
		memberchk(td(_), Options), !
	},
	[].
html_list_seperator(Options) -->
	{
		memberchk(list_seperator(Seperator), Options),!
	},
	html([Seperator]).
html_list_seperator(_Options) -->
	html(&(nbsp)).


html_list_left(Options) -->
	{
		memberchk(list_left(Left), Options), !
	},
	html([Left]).
html_list_left(_Options) -->
	html('['),!.


html_list_right(Options) -->
	{
		memberchk(list_right(Right), Options), !
	},
	html([Right]).
html_list_right(_Options) -->
	html(']'),!.






pattern_to_string(Pattern, PatternStr) :-
	list_to_string(Pattern, PatternStr).
list_to_string(Pattern, PatternStr) :-
	format(atom(TempStr), "~w", [Pattern]),
	string_to_list(TempStr, TempLst),
	remove_whitespace(TempLst, PatternStr).




pStyle(_Length, _Origen, 0, self) :- !.
pStyle(Length, Origen, _Index, classic) :- 
	even(Length),
	odd(Origen).
pStyle(Length, Origen, _Index, equi) :-
	even(Length),
	even(Origen).
pStyle(Length, Origen, Index, bi) :-
	odd(Length),
	even(Origen), 
	odd(Index).
pStyle(Length, Origen, Index, bi) :-
	odd(Length),
	odd(Origen), 
	even(Index).
pStyle(Length, Origen, Index, instantbi) :-
	odd(Length),
	even(Origen),
	even(Index).
pStyle(Length, Origen, Index, instantbi) :-
	odd(Length),
	odd(Origen),
	odd(Index).



www_siteswap_encode(Pattern, Encoded) :-
	nonvar(Pattern),
	var(Encoded),
	float_to_shortpass(Pattern, PatternShort),
	atom2Pattern(Decoded, PatternShort),
	www_form_encode(Decoded, Encoded).
www_siteswap_encode(Pattern, Encoded) :-
	var(Pattern),
	nonvar(Encoded),
	www_form_encode(Decoded, Encoded),
	atom2Pattern(Decoded, Pattern).


www_swaplist_encode(SwapList, Encoded) :-
	nonvar(SwapList),
	var(Encoded),
	atom2SwapList(Decoded, SwapList),
	www_form_encode(Decoded, Encoded).
www_swaplist_encode(SwapList, Encoded) :-
	var(SwapList),
	nonvar(Encoded),
	www_form_encode(Decoded, Encoded),
	atom2SwapList(Decoded, SwapList).



atom2Pattern(Atom, Pattern) :-
	var(Pattern),
	nonvar(Atom),
	atom_codes(Atom, String),
	a2P_dcg_pattern(Pattern, String, []), !.
atom2Pattern(Atom, Pattern) :-
	nonvar(Pattern),
	var(Atom),
	a2P_dcg_pattern(Pattern, String, []), !,
	atom_codes(Atom, String).

atom2SwapList(Atom, SwapList) :-
	var(Atom),
	nonvar(SwapList),
	a2S_dcg_swap_list(SwapList, String, []), !,
	atom_codes(Atom, String).
atom2SwapList(Atom, SwapList) :-
	nonvar(Atom),
	var(SwapList),
	atom_codes(Atom, String),
	a2S_dcg_swap_list(SwapList, String, []), !.


a2P_dcg_pattern([Throw|Pattern]) -->
	dcg_left_bracket,
	a2P_dcg_throw(Throw),
	a2P_dcg_more_throws(Pattern),
	dcg_right_bracket.

a2P_dcg_throw(Throw) -->
	{
		var(Throw)
	},
	dcg_throw(Throw).
a2P_dcg_throw(p(Throw, Index, Origen)) -->
	{
		nonvar(Throw)
	},
	dcg_p,
	dcg_left_parenthesis,
	dcg_float(Throw),
	dcg_comma,
	dcg_integer(Index),
	dcg_comma,
	dcg_integer(Origen),
	dcg_right_parenthesis.
a2P_dcg_throw(Multiplex) -->
	a2P_dcg_multiplex(Multiplex).

a2P_dcg_more_throws([]) -->
	[].
a2P_dcg_more_throws([Throw|Pattern]) -->
	dcg_comma,
	a2P_dcg_throw(Throw),
	a2P_dcg_more_throws(Pattern).


a2P_dcg_multiplex([Throw|Multiplex]) -->
	dcg_left_bracket,
	a2P_dcg_throw(Throw),
	a2P_dcg_more_throws(Multiplex),
	dcg_right_bracket.

a2S_dcg_swap_list([]) -->
	dcg_left_bracket,
	dcg_right_bracket.
a2S_dcg_swap_list([I|List]) -->
	dcg_left_bracket,
	dcg_integer(I),
	a2S_dcg_more_integers(List),
	dcg_right_bracket.

a2S_dcg_more_integers([]) -->
	[].
a2S_dcg_more_integers([I|List]) -->
	dcg_comma,
	dcg_integer(I),
	a2S_dcg_more_integers(List).


