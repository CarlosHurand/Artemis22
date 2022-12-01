%{
#include "sintactico.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
char *p;
// char *lineptr = NULL;

// size_t n = 0;
// static int next_column = 1;
// int column = 1;
// size_t consumed = 0;
// #define HANDLE_COLUMN column = next_column; next_column += strlen(yytext)


%}

%option noyywrap
%option yylineno
espacios [\t]+
digito [0-9]
car [a-zA-Z]
num {digito}+
id {car}({car}|{digito})* 
cadena \"(.*?)\"

%%

{espacios} {/*se ignoran espacios*/}

"code"                    {return CODE;}
"message"                 {return(MESSAGE);}
"space-coordinates"       {return(SPACECOORDINATES);}
"mission-status"          {return(MISSIONSTATUS);}
"BOOL"                    {return(BOOL);}
"flight-journal"          {return(FLIGHTJOURNAL);}
"ufo"                     {return(UFO);}
"ignition"                {return(IGNITION);}
"abort"                   {return(ABORT);}
"countdown"               {return(COUNTDOWN);}
"autopilot"               {return(AUTOPILOT);}
"takeoff"                 {return(TAKEOFF);} 
"onesmallstep"            {return(ONESMALLSTEP);}
"return"                  {return(RET);}
"//"                      {return(IGN);}
"not"                     {return(NOT);}
"("                       {return(PAA);}
")"                       {return(PAC);}
"{"                       {return(COA);}
"}"                       {return(COC);}
"["                       {return(CORA);}
"]"                       {return(CORC);}
","                       {return(COMA);}
";"                       {return(PCOMA);}
"'"                       {return(COMM);}
"and"                     {return(AND);}
"or"                      {return(OR);}
"."                       {return(PUNTO);}
":"                       {return(DOSPUNTOS);}
"over"                    {return(OVER);}
"out"                     {return(OUT);}
"string"                  {return(STRING);}
"regular"                 {return(REGULAR);}
"="                       {return(IGUAL);}
"=="                      {return(IGUALIGUAL);}
"<"                       {return(MENORA);}
">"                       {return(MAYORA);}
"<="                      {return(MENORI);}
">="                      {return(MAYORI);}
"-"                       {return(MENOS);}
"+"                       {return(MAS);}
"/"                       {return(ENTRE);}
"%"                       {return(PORCENT);}
"*"                       {return(POR);}
"**"                      {return(POTENCIA);}
"+="                      {return(MASIGUAL);}
"-="                      {return(MENOSIGUAL);}

{car}                     {return(CAR);}
{num}                     {yylval.dval= atoi(yytext);return NUM;}
{id}                      {
                            p=(char *)calloc(strlen(yytext)+1,sizeof(char));
                            strcpy(p,yytext);
                            yylval.id=p;
                            return ID;}
%%


