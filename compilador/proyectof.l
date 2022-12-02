%{
#include "proyectof.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int nL=0;

%}

%option yylineno
%option noyywrap
espacios	[ \t]+
digito 		[0-9]
letra		[A-Za-z]  

%%

{espacios}	{/* se ignoran */}
"\n"        { nL++; }
countdown	{ return(countdown); }
ignition	{ return(ignition); }
over	    { return(over); }
abort	    { return(abor); }
out	        { return(out); }
return	    { return(ret); }
ufo	        { return(ufo); }
flight-journal	{ return(fj); }
(space-coordinates|mission-status|message|code)	{ strcpy(yylval.sval,yytext); return(tip);}
(and|or)                                                        {return(oplog);} 
onesmallstep                                                    {return(finprogra);}
\"(\\.|[^"\\])*\"                                               {strcpy(yylval.sval, yytext); return(str);} 
{letra}({letra}|{digito})*		                                {strcpy(yylval.sval, yytext); return(id);} 
{digito}+		                                                {yylval.dval=atoi(yytext); return(entero);} 
{digito}+(\.{digito}+)	                                        {yylval.fval=atof(yytext); return(real);} 
";"				                                                {return(pyc);} 
"("				                                                {return(pa);} 
")"				                                                {return(pc);} 
"{"				                                                {return(lla);} 
"}"				                                                {return(llc);} 
"["				                                                {return(cora);} 
"]"				                                                {return(corc);} 
(\+)(\+)?|(\-)(\-)?|(\*)(\*)?|\/|%                              {return(opar);}
("=="|"<="|">="|"<"|">")                                        {return(opcomp);}
"="                                                             {return(asig);}
","                                                             {return(coma);}
.                                                               { }
%%
