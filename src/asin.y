%{
/*****************************************************************************/
/*  Analizador sintactico para MenosC                                        */
/*****************************************************************************/
#include <stdio.h>
#include <string.h>
#include "header.h"
%}

%union {
  char *ident;   /* Nombre del identificador */
  int cent;      /* Valor de la cte numerica entera */
}

%token <ident> ID_
%token <cent>  CTE_

/* Palabras reservadas */
%token INT_ BOOL_ TRUE_ FALSE_
%token RETURN_ READ_ PRINT_ IF_ ELSE_ FOR_
%token SWITCH_ LESS_ EQUAL_ GREATER_

/* Delimitadores y separadores */
%token PCOMA_ COMA_ AP_ CP_ AL_ CL_ AC_ CC_

/* Operadores */
%token ASIG_
%token MAS_ MENOS_ POR_ DIV_ NOT_
%token AND_ OR_ IGUAL_ DIST_
%token MAYOR_ MENOR_ MAYORIG_ MENORIG_

%%

/* ========================================================================= */
/* BLOQUE 1: Entorno, declaraciones y Tipos                                  */
/* ========================================================================= */

/* ========================================================================= */
/* BLOQUE 2: Funciones y bloques de codigo                                   */
/* ========================================================================= */

declaFunc
  : tipoSimp ID_ AP_ paramForm CP_ bloque
  ;

paramForm
  : /* vacio */
  | listParamForm
  ;

listParamForm
  : tipoSimp ID_
  | tipoSimp ID_ COMA_ listParamForm
  ;

bloque
  : AL_ declaVarLocal listInst RETURN_ expre PCOMA_ CL_
  ;

declaVarLocal
  : /* vacio */
  | declaVarLocal declaVar
  ;

listInst
  : /* vacio */
  | listInst inst
  ;

/* ========================================================================= */
/* BLOQUE 3: Instrucciones de control                                        */
/* ========================================================================= */



/* ========================================================================= */
/* BLOQUE 4: Expresiones y operaciones                                       */
/* ========================================================================= */



%%
