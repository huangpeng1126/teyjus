(**********************************************************************
*Absyn:
*	The abstract syntax representation.
**********************************************************************)
type pos = Errormsg.pos
type symbol = Symbol.symbol

(********************************************************************
*atypevar:
*	Information about a type variable.
********************************************************************)
type atypevar = 
		TypeVar of (atype * atype * bool * bool * bool * int * int * int)


(********************************************************************
*Kinds:
********************************************************************)
and akindmap =
		KindIndex of int
	|	KindMapping of akindmap

and akind =
		LocalKind of (symbol * int option * akindmap * pos)
	|	GlobalKind of (symbol * int option * akindmap * pos)
	|	PervasiveKind of (symbol * int option * akindmap * pos)


(********************************************************************
*Type Abbreviations:
********************************************************************)
and atypeabbrev =
	TypeAbbrev of (symbol * symbol list * atype * pos)

(********************************************************************
*Type Skeleton:
********************************************************************)
and askeleton = Skeleton of (atype * int * bool)

(********************************************************************
*Types:
********************************************************************)
and atype =
		ArrowType of (atype * atype)
	|	TypeVarType of (atypevar option * bool)
	| AppType of (akind * atype list)
	|	SkeletonVarType of (int)
	|	TypeRefType of (atype)
	|	ErrorType

(********************************************************************
*Constants:
*	Symbol
*	Fixity
*	Precedence
*	Export
*	Use Only
*	No Defs
*	Closed
*	Type Preserving
*	Skeleton
*	Type
*	Code Info
*	Constant Type
********************************************************************)
and acodeinfo =
		BuiltinIndex of int
	|	Clauses of aclause list
	
and aconstant =
		Constant of (symbol * afixity * int * bool * bool * bool * bool * bool * askeleton list * atype list * acodeinfo * aconstanttype * pos)

and aconstanttype = 
		GlobalConstant
	|	LocalConstant
	|	PervasiveConstant
	|	NewConstant
	| HiddenConstant
	|	AnonymousConstant

and atypesymboltype =
		RawType of atype
	|	SkeletonType of (askeleton list * atype list * int)

and atypesymbol =
		ImplicitTypeSymbol of (bool * aconstant * symbol * atypesymboltype)
	|	AnonymousTypeSymbol of (bool * aconstant * symbol * atypesymboltype)
	|	BoundTypeSymbol of (bool * aconstant * symbol * atypesymboltype)

and afixity =
		Infix
	|	Infixl
	|	Infixr
	|	Prefix
	|	Prefixr
	|	Postfix
	|	Postfixl
	|	NoFixity

(********************************************************************
*Variables:
*	Representation of explicitly or implicitly quantified variables in 
*	clauses; this is used during code generation for clauses.
********************************************************************)
and avar = Var of (bool * bool * bool * bool * int * askeleton list * int * int * int * aterm)

(********************************************************************
*Terms:
********************************************************************)
and aterm =
		IntTerm of (int * pos)
	|	FixedIntTerm of (int)
	|	StringTerm of (string * pos)
	|	FixedStringTerm of (string list)
	|	RealTerm of (float * pos)
	|	FixedRealTerm of (float)
	
	|	AbstractionTerm of (atypesymbol * aterm * pos)
	|	SansAbstractionTerm of (atypesymbol * aterm)
	|	FixedAbstractionTerm of (atypesymbol * aterm)
	|	NNAbstractionTerm of (aterm)
	
	|	ConstTerm of (aconstant * atype list * pos)
	|	SansConstTerm of (aconstant * atype list)
	|	FixedConstTerm of (aconstant * atype list)
	
	|	FreeVarTerm of (atypesymbol * pos)
	|	SansFreeVarTerm of (atypesymbol)
	
	|	BoundVarTerm of (atypesymbol * pos)
	|	SansBoundVarTerm of (atypesymbol)
	|	FixedBoundVarTerm of (int)
	
	|	ApplyTerm of (aterm * aterm list * int * pos)
	|	SansApplyTerm of (aterm * aterm list * int)
	|	FixedApplyTerm of (aterm * aterm list * int)
	
	|	ErrorTerm

and ahcvarpair = HCVarPair of (avar * atype list * aconstant)

and adefinition = (aconstant * aclause list)

(********************************************************************
*
********************************************************************)
and avarinit = (avar * atype list)

(********************************************************************
*Goals:
********************************************************************)
and agoal =
		AtomicGoal of (aconstant * int * int * aterm list * atype list)
	|	ImplicationGoal of (adefinition list * avarinit list * agoal)
	|	AndGoal of (agoal * agoal)
	|	AllGoal of (ahcvarpair list * agoal)
	|	SomeGoal of (avar * atype list * agoal)

(********************************************************************
*
********************************************************************)
and atermvarmap =  TermVarMap of (avar * avar) list

(********************************************************************
*Clauses:
********************************************************************)
and aclause =
		Clause of (aconstant * aterm list * atype list * int * int *
			agoal * int * agoal list * atermvarmap * atermvarmap * bool)

(********************************************************************
*String:
********************************************************************)
and astring = (string * int * bool)

(********************************************************************
*Module:
********************************************************************)
and amodule =
		Module of (string * aconstant Table.SymbolTable.t *
			akind Table.SymbolTable.t * atypeabbrev Table.SymbolTable.t * 
			astring list * aconstant list * 
			aconstant list * aconstant list * akind list * akind list *
			askeleton list * askeleton list * aclause list)
|		Signature

val getKindArity : akind -> int
val getKindPos : akind -> pos
val printAbsyn : amodule -> out_channel -> unit

val string_of_fixity : afixity -> string