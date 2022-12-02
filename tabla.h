#include <stdio.h>
#include <string.h>
#define MAX 1000

typedef struct simbolo {
    char lexema[MAX];
    char tipo[MAX];
    int valorE;
    char valorC;
    char valorS[80]; // si es arreglo o estructura se guarda como S en tabla de simbolos
    float valorR;
    int basico; // 0> entero, real, char, bool 2> arreglo 3> estructura
} tS;
