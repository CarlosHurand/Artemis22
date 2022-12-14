# Artemis22
Lenguaje de programación basado en la NASA

## Manual de Usuario 
### Versión 0.7 beta

Gracias al equipo desarrollador de Artemis22:            
- Carla Pérez Gavilán Del Castillo - A01023033
- Vicente Santamaría Velasco - A01421801
- Juan Carlos Hurtado Andrade - A01025193  

Proyecto final de la clase Diseño de compiladores.

---------------------------
### Comandos para correr el programa en terminal:
- Para correr el bison (extensión .y):
```
bison -vd sintactico.y 
```

- Para correr el programa completo:
```
flex lexico.l
gcc lex.yy.c sintactico.tab.c -o compilado
.\compilado.exe
```

- Para correr el flex (extensión .l):
```
flex lexico.l
gcc lex.yy.c
.\a.exe
```


### Comandos para correr el programa desde un archivo .txt: 

Estando en la carpeta del código una vez descargado, correr los comandos en el siguiente orden:

```sh
cd compilador  
bison -vd sintactico.y  
flex ./Lexico.l  
cd ..  
gcc main.c ./compilador/*.c  
./a.exe  
```

--------------------
**Recuerda que las funciones y variables no pueden ser de más de 10 caracteres**
