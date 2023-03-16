grammar Module2FunList;

program : funlist sentlist;
funlist : funcdef funlist | ;
sentlist : mainhead | '{' code '}';

// Cosas del Módulo 1 necesarias:
simpvalue : NUMERIC_INTEGER_CONST | NUMERIC_REAL_CONST | STRING_CONST;
vardef : tbas IDENTIFIER  ('=' simpvalue)?;
tbas : 'integer' | 'float' | 'string' | tvoid;
tvoid : 'void';

// La zona de implementación de funciones es una lista de implementaciones de funciones con una
// estructura análoga al programa principal.
funclist : funcdef | funclist funcdef;
funcdef : funchead '{' code '}';
funchead : tbas IDENTIFIER '(' typedef1 ')';
typedef1 : typedef2 | ;
typedef2 : tbas IDENTIFIER | typedef2 ',' tbas IDENTIFIER;

// Necesitamos el Módulo 3 también:
// La zona de sentencias del programa principal es una lista de sentencias que pueden ser asignaciones
// y llamadas a procedimientos:
mainhead : tvoid 'Main' '(' typedef1 ')';
code : sent code | ;
sent : asig ';' | funccall ';' | vardef ';';
asig : IDENTIFIER '=' exp;
exp : exp op exp | factor;
op : '+' | '-' | '*' | 'DIV' | 'MOD';
factor : simpvalue | '(' exp ')' | IDENTIFIER subpparamlist;
funccall : IDENTIFIER subpparamlist | CONST_DEF_IDENTIFIER subpparamlist;
subpparamlist : '(' explist ')' | ;
explist : exp | exp ',' explist;

IG : [ \t\r\n]+ -> skip;
COMMENT : '//' ~[\r\n]* | '/*' .*? '*/';
IDENTIFIER : [a-z_][a-z0-9_]+;
CONST_DEF_IDENTIFIER : [A-Z_][A-Z0-9_]+;
NUMERIC_INTEGER_CONST : ('+'|'-')? [0-9]+;
NUMERIC_REAL_CONST : ('+'|'-')? (
                        [0-9]+'.'[0-9]+ | //punto fijo
                        '.'[0-9]+ | //punto inicial
                        [0-9]+('e'|'E')('+'|'-')?[0-9]+ | //exponencial
                        ([0-9]+'.'[0-9]+ | '.'[0-9]+)('e'|'E')('+'|'-')?[0-9]+ //mixto
                        ) ;
STRING_CONST : '"' ~[\r\n]+ '"';


