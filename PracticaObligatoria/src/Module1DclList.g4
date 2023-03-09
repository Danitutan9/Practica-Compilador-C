grammar Module1DclList;

/*
Ya funciona.
Cosas que faltan:
- Reconocer más símbolos en los STRING_CONST y en otras partes
- Que en los identificadores no puedan aparecer nombres de tipos primitivos de C ('integer', 'float', 'string' , 'void')
*/

// Zona para probar el primer módulo de la gramática: la zona de declaraciones.
program : dcllist; //funlist sentlist;
dcllist : dcl dcllist | ;

// La zona de declaraciones es una lista de declaraciones de constantes:
dcl : ctelist | varlist | jump | comment;
ctelist : '#define' CONST_DEF_IDENTIFIER simpvalue;
simpvalue : NUMERIC_INTEGER_CONST | NUMERIC_REAL_CONST | STRING_CONST;
varlist : vardef ';';
vardef : tbas IDENTIFIER  ('=' simpvalue)?;
tbas : 'integer' | 'float' | 'string' | tvoid;
tvoid : 'void';
jump : IG;
comment : COMMENT;

IG : [ \t\r\n]+ -> skip;
COMMENT : ('//'[a-zA-Z_0-9]+ | '/*' [a-zA-Z_0-9 \t\r\n]+ '*/');
IDENTIFIER : [a-z_][a-z0-9_]+; // Hay que indicar también que no se permiten las palabras reservadas del lenguaje: ~[...];
CONST_DEF_IDENTIFIER : [A-Z_][A-Z0-9_]+;
NUMERIC_INTEGER_CONST : ('+'|'-')? [0-9]+;
NUMERIC_REAL_CONST : ('+'|'-')? (
                        [0-9]+'.'[0-9]+ | //punto fijo
                        '.'[0-9]+ | //punto inicial
                        [0-9]+('e'|'E')('+'|'-')?[0-9]+ | //exponencial
                        ([0-9]+'.'[0-9]+ | '.'[0-9]+)('e'|'E')('+'|'-')?[0-9]+ //mixto
                        ) ;
STRING_CONST : '"' [a-zA-Z0-9_]+ '"';

/* CÓDIGO DE PRUEBA:

#define FECHA 2023
#define CODIGO 10
integer n_alumnos;
float __valor_real;
string nombre = "alumno1";

string codificar_cadena(string cadena, integer desplazamiento){
    string cadena2;
    cadena2 = (cadena + desplazamiento) * random(desplazamiento);
    return(cadena2);
}

void save(string nombre){
    fopen("file.txt", "w");
    printf(nombre);
}

void Main (){
    string codificado;
    codificado = codificar_cadena(nombre, FECHA);
    save(codificado);
    n_alumnos = n_alumnos + 1;
    codificado = codificar_cadena(nombre, (CODIGO DIV codificado));
}

*/