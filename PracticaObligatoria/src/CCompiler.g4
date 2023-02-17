grammar CCompiler;

/* NOTAS:
    - ʎ lo estoy representando como regla opcional (<regla>)?
    - Lo único que no viene en el enunciado es la especificación de la regla <func>
    - No sé dónde añadir la regla de <comentarios>
*/

//Tres partes del programa:
//    - Zona de declaraciones de constantes y variables (dcllist).
//    - Zona de declaración e implementación de funciones (funlist).
//    - Zona de sentencias del programa principal (sentlist).
program : dcllist funlist sentlist;
dcllist : (dcllist dcl)?; // | ʎ
funlist : (funlist func)?; // | ʎ
sentlist : mainhead | '{' code '}';

// La zona de declaraciones es una lista de declaraciones de constantes:
dcl : ctelist | varlist;
ctelist : '#define' CONST_DEF_IDENTIFIER simpvalue '\n' | ctelist '#define' CONST_DEF_IDENTIFIER simpvalue '\n';
simpvalue : NUMERIC_INTEGER_CONST | NUMERIC_REAL_CONST | STRING_CONST;
varlist : vardef ';'| varlist vardef ';';
vardef : tbas IDENTIFIER | tbas IDENTIFIER '=' simpvalue;
tbas : 'integer' | 'float' | 'string' | tvoid;
tvoid : 'void';

// La zona de implementación de funciones es una lista de implementaciones de funciones con una
// estructura análoga al programa principal.
funclist : funcdef | funclist funcdef;
funcdef : funchead '{' code '}';
funchead : tbas IDENTIFIER '(' typedef ')';
typedef : (typedef tbas IDENTIFIER)?; // | ʎ

// La zona de sentencias del programa principal es una lista de sentencias que pueden ser asignaciones
// y llamadas a procedimientos:
mainhead : tvoid 'Main' '(' typedef ')';
code : (code sent)?; // | ʎ
sent : asig ';' | func_call ';';
asig : IDENTIFIER '=' exp;
exp : exp op exp | factor;
op : '+' | '-' | '*' | 'DIV' | 'MOD';
factor : simpvalue | '(' exp ')' | IDENTIFIER subpparamlist;
subpparamlist : ('(' explist ')')?; // | ʎ
explist : exp | exp ',' explist;
func_call : IDENTIFIER subpparamlist;

// Añadido por nosotros:
IDENTIFIER : [a-z_][a-z0-9_]+; // Hay que indicar también que no se permiten las palabras reservadas del lenguaje: ~[...];
CONST_DEF_IDENTIFIER : [A-Z_][a-z0-9_]+;
NUMERIC_INTEGER_CONST : ('+'|'-')? ('+'|'-')?;
NUMERIC_REAL_CONST : ('+'|'-')? ([0-9]+'.'[0-9]+ | '.'[0-9]+ | [0-9]+('e'|'E')('+'|'-')?[0-9]+ | ('.')?[0-9]+('.')?('e'|'E')('+'|'-')?('+'|'-')?) ;
STRING_CONST : ('"' [a-zA-Z]+ '"'); // Esto me da error:  | ''' [a-zA-Z]+ ''');
                // Hay que añadir también la funcionalidad de añadir delimitadores al propio string_const.