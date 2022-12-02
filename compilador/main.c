#include <stdio.h> 
#include "compilador/sintactico.tab.h"
void parse(FILE *file);

void main(){
    FILE *file = fopen("entrada.txt", "r");
    parse(file);   
}