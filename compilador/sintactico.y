%{
#include <stdio.h>
#include <math.h>
#include <string.h>
#define YYERROR_VERBOSE 1
int yylex();
int yyparse();
void yyerror(char *s);
// FILE *yyin;
int column;
char *lineptr;
extern int yylineno;

%}

%union{int dval;  char *id ;}
%token ID CODE MESSAGE SPACECOORDINATES MISSIONSTATUS FLIGHTJOURNAL UFO IGNITION ABORT COUNTDOWN AUTOPILOT TAKEOFF ONESMALLSTEP RET IGN NOT PAA PAC COA COC CORA CORC COMA PCOMA COMM AND OR PUNTO DOSPUNTOS OVER OUT CAR BOOL STRING REGULAR IGUAL IGUALIGUAL MENORA MAYORA MENORI MAYORI MENOS MAS ENTRE PORCENT POR POTENCIA MASIGUAL MENOSIGUAL
%token <dval> NUM 

%type <id> ID 
%left CAR


%type <dval> ASIGNACION OPERADOR VALOR
%start S 

%%


S: 			MAIN ONESMALLSTEP {return 0;}
			;

MAIN:	 	LINE
			| MAIN LINE
			;

LINE: 		DECLARACION 
			| ASIGNACION
			| OPERACION
			| CONDICIONAL
			| CICLOS 
			| IO 
			| FUNCION
			| RETURN 
			;

FUNCION:	TIPO ID PAA PAA TIPO ID PAC POR PAC COA MAIN COC
			;

LLAMADA: 	ID PAA VALOR POR PAC
			;

RETURN: 	RET
			| RET ID 
			| RET VALOR 
			| RET OPERACION
			;

DECLARACION: 	TIPO PAA ID PAC
				| TIPO PAA ARREGLO PAC
				| TIPO PAA ESTRUCTURA PAC 
				;

ARREGLO: 		FLIGHTJOURNAL ID CORA VALOR CORC
				;

ESTRUCTURA:		UFO COA ESTRUCTURAS
				;

ESTRUCTURAS: 	DECLARACION ESTRUCTURAS
				| DECLARACION COC
				;


ASIGNACION: 	DECLARACION IGUAL VALOR
				| ID IGUAL VALOR
				| ID CORA NUM CORC IGUAL VALOR				
				;

OPERACION: 		PAA ID PAC OPERADOR PAA ID PAC
				| PAA VALOR PAC OPERADOR PAA VALOR PAC
				;

OPERADOR: 		 MAS
				| MENOS
				| POR
				| ENTRE 
				| PORCENT 
				| POTENCIA
				| MASIGUAL
				| MENOSIGUAL
				;


OPERADOR_LOGICO:	OR
					| AND 
					;

CONDICIONAL: 	IGNITION PAA COMPARACIONES PAC COA MAIN COC
				| IGNITION PAA COMPARACIONES PAC COA MAIN COC ABORT COA MAIN COC
				;

CICLOS: 		COUNTDOWN PAA COMPARACIONES PAC COA MAIN COC
				;

COMPARACIONES: 	PAA ID PAC COMPAR PAA ID PAC 
				| PAA VALOR PAC COMPAR PAA VALOR PAC 
				| COMPARACIONES OPERADOR_LOGICO COMPARACIONES
				;

COMPAR: 		IGUALIGUAL
				| MENORA
				| MAYORA
				| MENORI 
				| MAYORI
				;

IO:				OVER PAA VALOR PAC 
				| ID IGUAL OUT PAA VALOR PAC
				| TIPO ID IGUAL OUT PAA VALOR PAC

TIPO: 			CODE {printf("INT") ;}
				| MESSAGE 
				| SPACECOORDINATES 
				| MISSIONSTATUS
				| FLIGHTJOURNAL
				| UFO
				| REGULAR
				;

VALOR: 			NUM 
				| CAR 
				| BOOL 
				| STRING 
				| REAL 
				| ARREGLO
				| OPERACION 
				| LLAMADA 
				;

REAL: 			NUM PUNTO NUM 
				| PUNTO NUM
				;


IGNORAR: 		IGN {printf("Esta linea esta comentada"); }

%%


void yyerror(char *str) {
	fprintf(stderr,"Error: %s \n ERROR en la linea %d, columna %d\n", str, yylineno, column);
    fprintf(stderr,"%s", lineptr);
	for(int i = 0; i < column + 1; i++)
        fprintf(stderr,"_");
    fprintf(stderr,"^\n");
}

int main(void){
	yyparse();
}