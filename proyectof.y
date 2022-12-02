%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "tabla.h"
int yylex();
void yyerror(char *s);
int yyparse();
int indTabla=0;
tS tabla[MAX];
extern int yylineno;

// inserta elemento
void insElem(char lex[],char tipo[]){
    strcpy(tabla[indTabla].lexema,lex);
    strcpy(tabla[indTabla].tipo,tipo);
    indTabla++;
}

// busca, dado el id busca el indice en la tabla
int busca(char var[]){
    int i=0;
    while(i<indTabla){
        //printf("Tabla[%i] = %s\n",i,tabla[i].lexema);
        if(strcmp(tabla[i].lexema,var)!=0){
           i++;
        }
        else break;
    }
    if(i<indTabla) return i; //lo encontró
    else return -1; //no lo encontró
}

void imprimeTabla(void){
    int i;
    printf("\nTABLA DE SIMBOLOS\n");
    printf("Pos\tID\t\tTIPO\t\tVALOR\n");
    for(i=0; i<indTabla; i++){
        printf("%2i\t%12s\t%12s\t",i,tabla[i].lexema,tabla[i].tipo);
	if(strcmp(tabla[i].tipo,"code")==0){
        printf("%4i\n",tabla[i].valorE);
    }
    if(strcmp(tabla[i].tipo,"message")==0){
        printf("%s\n",tabla[i].valorS);
    }       
	if(strcmp(tabla[i].tipo,"space-coordinates")==0){
         printf("%.2f\n",tabla[i].valorR);
    }
    if(strcmp(tabla[i].tipo,"ufo")==0){
         printf("%s\n",tabla[i].valorS);
    }
    if(strcmp(tabla[i].tipo,"fligt-journal")==0){
         printf("%s\n",tabla[i].valorS);
    }
    }
}
%}

%union{ int dval;
	    float fval; 
        char sval[80];
    }

%token countdown ignition coma over abor out ret finprogra pyc opcomp asig opar corc cora lla llc pc pa oplog
%token <dval> entero
%token <fval> real
%token <sval> str
%token <sval> id
%token <sval> tip
%token <sval> fj
%token <sval> ufo
%start S

%%
S: MAIN finprogra
	| MAIN { yyerror("es necesario concluir el programa con: onesmallstep ");}
   ;

MAIN: LINE
	| MAIN LINE
	;

LINE: DECLARACION pyc { printf("declaración correcta \n");}
    | ASIGNACION pyc { printf("asignación correcta \n");}
    | LLAMADA pyc { printf("llamada correcta \n");}
    | OPERACION pyc { printf("operación correcta \n");}
    | CONDICONAL { printf("condicional correcto \n");}
    | CICLOS  { printf("ciclo correcto \n ");}
    | IO pyc { printf("io correcto \n ");}
    | FUNCION  { printf("funcion correcta \n ");}
    | RETURN pyc { printf("return correcto \n ");}
    | DECLARACION { yyerror("declaración error sintáctico: falta ; \n");}
    | ASIGNACION { yyerror("asignación error sintáctico: falta ; \n");}
    | LLAMADA { yyerror("llamada error sintáctico: falta ; \n");}
    | OPERACION { yyerror("error sintáctico: falta ; \n");}
    | IO { yyerror("io error sintáctico: falta ; \n");}
    ;

FUNCION: tip id pa DECLARACIONES pc lla MAIN llc
    |  tip pa DECLARACIONES pc lla MAIN llc  { yyerror(" error sintáctico en funcion: es necesario ponerle nombre a la funcion \n");}
    ;

DECLARACIONES: DECLARACIONES coma DECLARACION
    | DECLARACION
    ;

DECLARACION: tip id  { int val;
                   val=busca($2);
	           if(val==-1) { //No está en la tabla
			insElem($2,$1);
			imprimeTabla();
		   }
		   else { //si está en la tabla
		      printf("La variable %s ya fue declarada",$2);
		      yyerror(" ERROR: Variable duplicada");
	           }
		 }
	| ARREGLO
    | ESTRUCTURA
    ;

ARREGLO: fj id cora entero corc {
        int val;
        val=busca($2);
        if(val==-1) {
        insElem($2,"flight-journal");
        imprimeTabla();
		}
    }
    ;

ATRIBUTOS: DECLARACION pyc
    | DECLARACION pyc ATRIBUTOS
    ;

ESTRUCTURA: ufo id lla ATRIBUTOS llc { int val;
                   val=busca($2);
	        if(val==-1) { 
			insElem($2,"ufo");
			imprimeTabla();
		   }
		   else {
		      printf("La variable %s ya fue declarada",$2);
		      yyerror(" ERROR: Variable duplicada");
	           }
		 }
    ;

LLAMADA: id pa PARAMS pc 
    | id pa OPERACION pc 
    ;

PARAMS: entero coma PARAMS 
    | real coma PARAMS 
    | str coma PARAMS 
    | real
    | entero
    | str
    ;

RETURN: ret
    | ret id 
    | ret entero
    | ret real
    | ret str
    | ret OPERACION
    ;

ASIGNACION: id asig entero { 
		int val;
        val=busca($1);
		printf("id: %s, val: %i\n",$1, val);
	if(val!=-1) 
    { //se encuentra en la tabla
		if(strcmp(tabla[val].tipo,"code")==0) 
        {
			tabla[val].valorE=$3;
			imprimeTabla();
		}
		else { //error de tipo
		      printf("La variable %s es de tipo %s y el valor es entero\n",$1,tabla[val].tipo);
		      yyerror("ERROR:  error de tipo");
	    }
	}
	else {
		   printf("La variable no ha sido declarada\n");
		   yyerror("ERROR:  error semantico");
	}
	}
    | id asig real {
		int val;
                val=busca($1);
	        if(val!=-1) { //se encuentra en la tabla
		   if(strcmp(tabla[val].tipo,"space-coordinates")==0) {
			tabla[val].valorR=$3;
			imprimeTabla();
		   }
		   else { //error de tipo
		      printf("La variable %s es de tipo %s y el valor es real\n",$1,tabla[val].tipo);
		      yyerror("ERROR:  error de tipo");
	           }
		}
		else {
		   printf("La variable no ha sido declarada\n");
		   yyerror("ERROR: error semantico");
		}
	}
    | id asig str {
		int val;
        val=busca($1);
	    if(val!=-1) { //se encuentra en la tabla
		   if(strcmp(tabla[val].tipo,"message")==0) {
			strcpy(tabla[val].valorS, $3);
			imprimeTabla();
		   }
		   else { //error de tipo
		      printf("La variable %s es de tipo %s y el valor es real\n",$1,tabla[val].tipo);
		      yyerror("ERROR: error de tipo");
	           }
		}
		else {
		   printf("La variable %s no ha sido declarada\n", $1);
		   yyerror("ERROR: error semantico");
		}
	}
    | id cora entero corc asig entero
    | id asig cora LISTA corc {
		int val;
        val=busca($1);
	    if(val!=-1) { //se encuentra en la tabla
		   if(strcmp(tabla[val].tipo,"flight-journal")==0) {
			strcpy(tabla[val].valorS, "asignado");
			imprimeTabla();
		   }
		   else { //error de tipo
		      printf("La variable %s es de tipo %s y el valor es real\n",$1,tabla[val].tipo);
		      yyerror("ERROR: error de tipo");
	           }
		}
		else {
		   printf("La variable %s no ha sido declarada\n", $1);
		   yyerror("ERROR: error semantico");
		}
	}
    | id asig LLAMADA
    | id asig OPERACION
    ;

LISTA: LISTA coma entero 
    | LISTA coma str
    | LISTA coma real
    | entero 
    | str 
    | real 
    ;

OPERACION: id opar id
    | id opar entero
    | id opar real
    | id opar str
    ;

CONDICONAL: ignition pa COMPARACIONES pc lla MAIN llc
    | ignition pa COMPARACIONES pc lla MAIN llc abor lla MAIN llc
    | ignition pa COMPARACIONES lla MAIN llc {yyerror("ERROR condicional: es necesario cerrar el paréntesis )");}
    ;

CICLOS: countdown pa COMPARACIONES pc lla MAIN llc

COMPARACION: id opcomp id 
    | id opcomp entero 
    | id opcomp real
    | id opcomp str
    | entero opcomp id
    | str opcomp id    
    | real opcomp id
    ;

COMPARACIONES: COMPARACION oplog COMPARACIONES 
    | COMPARACION
    ;

IO: over pa str pc 
    | id asig out pa str pc 
    | tip id asig out pa str pc
    | over pa entero pc  {yyerror("ERROR io: no es posible imprimir enteros");}
    | over pa real pc  {yyerror("ERROR io: no es posible imprimir reales");}
    ;

%%

void yyerror(char *s) {
  printf("%s\n | Line: %d\n", s , yylineno);
  exit(1);
}

int main(void) {
  yyparse();
  printf("0 errores");
}

