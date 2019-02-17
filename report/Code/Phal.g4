/**
 * Define a grammar called Phal
 */
grammar Phal;

r 	: Includes? Setup Repeat Funcs? ;

Includes	: Include Includes 
			| Include
			;
			
Include 	: 'using' INCLUDE ;

Setup 		: 'setup' STARTBRACKET SetupCnts;

SetupCnts	: SetupCnt SetupCnts
			| ENDBRACKET
			;
			
SetupCnt	: Stmt
			| Dcl
			;

Dcl			: VarDcl 
			| CmpDcl
			| Group
			;
			
VarDcls		: VarDcl VarDcls
			| VarDcl
			;
			
VarDcl	 	: Type ID
			| Type ID ASSIGNMENT NUMBERVALUE
			| Type ID ASSIGNMENT BOOLVALUE
			| Type ID ASSIGNMENT TEXTVALUE
			| Type ID ASSIGNMENT ID
			;

Type		: 'number'
			| 'text'
			| 'letter'
			| 'bool' 
			;
			
CmpDcls		: CmpDcl CmpDcls
			| CmpDcl
			;
			
CmpDcl		: AdvType ID ASSIGNMENT 'pin' PINNUMBER;

AdvType		: 'lightBulb'
			| 'coffeeMachine'
			| 'temperatureSensor'
			;
			
Groups		: Group Groups
			| Group
			;

Group		: 'group' GROUPNAME  STARTBRACKET GrpCnts ENDBRACKET
			;

GrpCnts		: GrpCnt GrpCnts
			| GrpCnt
			;

GrpCnt		: ID
			| GROUPNAME ;

Stmts		: Stmt Stmts
			| Stmt
			;

Stmt		: Selective
			| Iterative
			| FuncCall
			| Assignment
			;

Selective	: Switch
			| IfStmt;
			
Switch		: 'switch' STARTPAREN ID ENDPAREN CaseList ENDBRACKET
			| 'switch' STARTPAREN NUMBERVALUE ENDPAREN CaseList ENDBRACKET
			| 'switch' STARTPAREN TEXTVALUE ENDPAREN CaseList ENDBRACKET
			;

CaseList	: Cases DefaultCase;

Cases		: Case Cases
			| Case
			;
			
Case		: 'number' COLON Stmts;

DefaultCase	: 'default' COLON Stmts;

IfStmt		: 'if' STARTPAREN LogicalStmt ENDPAREN 'then' STARTBRACKET Stmts ENDBRACKET
			| 'if' STARTPAREN LogicalStmt ENDPAREN 'then' STARTBRACKET Stmts ENDBRACKET 'else' STARTBRACKET Stmts ENDBRACKET
			| 'if' STARTPAREN LogicalStmt ENDPAREN 'then' STARTBRACKET Stmts ENDBRACKET 'else' IfStmt STARTBRACKET Stmts ENDBRACKET;

Iterative	: Loop;

Loop		: 'loop' NUMBERVALUE 'times' STARTBRACKET Stmts ENDBRACKET
			| 'loop' 'until' LogicalStmt STARTBRACKET Stmts ENDBRACKET;

FuncCall	: 'call' ID 'with' STARTPAREN CallParams ENDPAREN;

CallParams	: CallParam COMMA CallParams
			| CallParam
			| NONE
			;

CallParam	: ID
			| NUMBERVALUE
			| BOOLVALUE
			| TEXTVALUE;

Assignment	: ID ASSIGNMENT AssStmt
			| ID ASSIGNMENT LogicalStmt;
			
AssStmt		: ID Oper AssStmt
			| ID Oper NUMBERVALUE
			| ID Oper ID
			| NUMBERVALUE Oper NUMBERVALUE
			| NUMBERVALUE Oper ID
			| ID CompOp
			| NUMBERVALUE CompOp
			| NUMBERVALUE
			| ID;
			
CompOp		: INCREMENT
			| DECREMENT
			;

Oper		: PLUS 
			| MINUS 
			| TIMES
			| DIVIDE
			| MODULO
			;

LogicalStmt	: ID LogicOper LogicalStmt
			| ID LogicOper ID
			| ID LogicOper BOOLVALUE
			| BOOLVALUE LogicOper LogicalStmt
			| BOOLVALUE LogicOper ID
			| BOOLVALUE LogicOper BOOLVALUE
			| ID
			| BOOLVALUE;

LogicOper	: LESSTHAN
			| LESSTHANEQUAL
			| GREATERTHAN 
			| GREATERTHANEQUAL
			| NOTEQUAL
			| EQUALTO
			| AND
			| OR
			;

Repeat		: 'repeat' STARTBRACKET RepeatCnts 
			;

RepeatCnts  : RepeatCnt RepeatCnts
			| ENDBRACKET
			;

RepeatCnt	: Stmts
			;

Funcs		: Func Funcs
			| Func
			;
			
Func		: 'define' ID 'with' STARTPAREN Params ENDPAREN 'returnType' Type STARTBRACKET FuncContent 
			;
			
FuncContents: FuncContent FuncContents	
			| ReturnStmt ENDBRACKET
			;
			
FuncContent	: VarDcl 
			| Stmt 
			;

Params		: Param COMMA Params
			| Param
			| NONE
			;

Param		: Type ID
			;
			
ReturnStmt	: 'return' ID
			| 'return' TEXTVALUE
			| 'return' NUMBERVALUE
			| 'return' BOOLVALUE
			|  NONE
			;

EQUALTO		: 'is' | '==';
NOTEQUAL	: 'is not' | '!=' ;
LESSTHAN	: '<';
LESSTHANEQUAL: '<=';
GREATERTHAN	: '>';
GREATERTHANEQUAL : '>=';
AND			: 'and' | '&&' ;
OR			: 'or'  | '||'  ; 
PLUS        : '+';
MINUS        : '-';
TIMES        : '*';
DIVIDE        : '/';
MODULO        : '%';
INCREMENT	: '++';
DECREMENT	: '--';
ASSIGNMENT	: '=';
COLON		: ':';
STARTPAREN	: '(';
ENDPAREN	: ')';
COMMA		: ',';
STARTBRACKET: '{';
ENDBRACKET	: '}';
INCLUDE		: [a-zA-Z]+[a-zA-Z0-9]*;
GROUPNAME 	: [a-zA-Z]+[a-zA-Z0-9]*;
ID 			: [a-zA-Z]+[a-zA-Z0-9]*;
NONE 		: 'none' ;
TEXTVALUE 	: '"' ~('\r' | '\n' | '"')* '"' ;
NUMBERVALUE : [0-9]+ 
			| [0-9]+.[0-9]+;
BOOLVALUE 	: 'true'|'false'
			|'on' |'off'; 
PINNUMBER	: [0-9]+;
