%{
/*****************************************************************************/
/*  Analizador lexico para MenosC                                            */
/*****************************************************************************/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "header.h"
#include "asin.h"

int ultimoToken = 0;
static int parenDepth = 0;
static int callDepth[100];

#define DEVUELVE(tok) { if (verbosidad) ECHO; ultimoToken = (tok); return (tok); }
%}

%option yylineno
%option noyywrap
%option nounput
%option noinput

%%

  /* ======================================================================= */
  /* BLOQUE 2: Delimitadores blancos, saltos de linea y palabras de bloque   */
  /* ======================================================================= */

[ \t]+          { if (verbosidad) ECHO; }
\n              { if (verbosidad) fprintf(stdout, "\n%3d.- ", yylineno); }

"return"        { DEVUELVE(RETURN_); }

  /* ======================================================================= */
  /* BLOQUE 2: Constantes numericas (enteras y reales sin signo)             */
  /* ======================================================================= */

[0-9]+\.[0-9]*  { yylval.cent = atoi(yytext); DEVUELVE(CTE_); }
\.[0-9]+        { yylval.cent = 0; DEVUELVE(CTE_); }
[0-9]+,[0-9]+   {
                  if ((parenDepth > 0 && callDepth[parenDepth]) || ultimoToken == COMA_) {
                    char *c = strchr(yytext, ',');
                    yyless(c - yytext);
                    yylval.cent = atoi(yytext);
                    DEVUELVE(CTE_);
                  } else {
                    yylval.cent = atoi(yytext);
                    DEVUELVE(CTE_);
                  }
                }
,[0-9]+         {
                  if (ultimoToken == ID_ || ultimoToken == CTE_ || 
                      ultimoToken == TRUE_ || ultimoToken == FALSE_ || 
                      ultimoToken == CP_ || ultimoToken == CC_) {
                    if (verbosidad) fputc(',', stdout);
                    yyless(1);
                    ultimoToken = COMA_;
                    return (COMA_);
                  } else {
                    yylval.cent = 0;
                    DEVUELVE(CTE_);
                  }
                }
[0-9]+          { yylval.cent = atoi(yytext); DEVUELVE(CTE_); }

  /* ======================================================================= */
  /* BLOQUE 1: Tipos, constantes logicas e identificadores                   */
  /* ======================================================================= */


  /* ======================================================================= */
  /* BLOQUE 3: Comentarios, palabras de control y operadores rel/log         */
  /* ======================================================================= */

  /* ======================================================================= */
  /* BLOQUE 4: Entrada/Salida, operadores aritmeticos y delimitadores        */
  /* ======================================================================= */
  
"("             {
                  if (parenDepth < 99) parenDepth++;
                  callDepth[parenDepth] = (ultimoToken == ID_);
                  DEVUELVE(AP_);
                }
")"             {
                  if (parenDepth > 0) parenDepth--;
                  DEVUELVE(CP_);
                }

.               { yyerror("Caracter desconocido"); }

%%
