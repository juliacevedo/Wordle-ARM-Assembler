.data
presentacion: .asciz "\033[31m*************************\033[33m*************************\033[32m\n\n\n\n\n\n***********\033[0;36m Bienvenido al juego WORDLE \033[32m***********\n\n\n\n\n\n\033[31m*************************\033[33m*************************\033[0m\n\n \033[0;36mLA PALABRA A ADIVINAR TIENE 5 LETRAS\n\033[0m\n\n"
lenpresentacion=.-presentacion
apoyo: .asciz "\033[0mSIGUE INTENTANDO TIENES  \n"
lenapoyo=.-apoyo
num: .space 4
lennum=.-num
intentos_restantes: .asciz "  INTENTOS RESTANTES\033[0m\n"
lenintentos_restantes=.-intentos_restantes
ingrese_palabra: .asciz "Ingrese una palabra: \n"
leningrese_palabra=.-ingrese_palabra
archivo: .asciz "palabras.txt" //Ruta del archivo txt
buffer1: .space 1000 // Guardamos listado de palabras
lenbuffer1=.-buffer1
palabra_elegida: .asciz "     \n"
lenpalabra_elegida=.-palabra_elegida
buffer_usuario: .asciz "     \n"
lenbuffer_usuario=.-buffer_usuario
mensaje_ganaste: .asciz "\n\033[32m*****************¡¡¡ GANASTE !!!*****************\033[0m\n\n\033[0;35m"
lenmensaje_ganaste=.-mensaje_ganaste
mensaje_perdiste: .asciz "\n\033[31m_____________________PERDISTE_____________________\033[0m\n\n"
lenmensaje_perdiste=.-mensaje_perdiste
puntos_jugador: .asciz "     PUNTOS OBTENIDOS.\n\033[0m\n"
lenpuntos_jugador=.-puntos_jugador
nombre_jugador: .asciz "                 \n\033[0;35m"
lennombre_jugador=.-nombre_jugador
pedir_nombre: .asciz "Ingrese su nombre:  \n"
lenpedir_nombre=.-pedir_nombre
pedir_numero: .asciz "\033[0;36mPARA COMENZAR INGRESE UN NUMERO AL AZAR ENTRE 1 Y 9:\n\033[0m"
lenpedir_numero=.-pedir_numero
falso_random: .asciz "   "
numero_elegido: .byte 0
jugar: .asciz "\033[0;35m\033[0;36m¿DESEA VOLVER A JUGAR? INGRESE SI O NO.\n"
lenjugar=.-jugar
contestacion: .asciz "    "
lencontestacion=.-contestacion
rojo: .asciz "\033[31m"
lenrojo=.-rojo
verde: .asciz "\033[32m"
lenverde=.-verde
amarillo: .asciz "\033[33m"
lenamarillo=.-amarillo
cadena_nueva: .asciz "                                                                        \n"
lencadena_nueva=.-cadena_nueva

.text

// SUBRUTINAS PARA COLORES
//recorremos la cadena vemos si es verde si no llamamos a la funcion amari$
verifica_letras_verdes:
.fnstart
        push {lr}
        ldr r0,=buffer_usuario
        ldr r1,=cadena_nueva
        ldr r3,=palabra_elegida
        mov r4,#0

        cicloColor:
        ldrb r2,[r0,r4]  //  R2 primer LETRA BUFFER   USUARIO
        ldrb r8,[r3,r4] //R8 Primer letra de PALABRA ELEGIDA
	cmp r8,#0
	beq fin10
        cmp r2,r8
        beq pintarVerde
        bl verifica_letras_amarillas
        add r4,#1
        b cicloColor

        pintarVerde:
        bl pintar_letra_verde
        add r4,#1
	b cicloColor

        fin10:
	pop {lr}
        bx lr
.fnend

verifica_letras_amarillas:
.fnstart
        push {lr}
        mov r12,#0                           //CONTADOR
        ldr r10,=palabra_elegida
        cicloAmarillo:
        ldrb r9,[r10,r12]                    //R9 primer LETRA OK
        cmp r9,#0
        beq pintarRojo
	cmp r9,r2                           //VEMOS SI GUARDO EL VALOR ORIGINAL DE R2
        beq pintarAmarillo
        add r12,#1
        b cicloAmarillo

        pintarAmarillo:
        bl pintar_letra_amarillo
        bal fin9

        pintarRojo:
        bl pintar_letra_rojo
	bal fin9

        fin9:
        pop {lr}
        bx lr
.fnend

// SUBRUTINAS AUXILIARES DE LA CATEDRA

 pintar_letra_rojo:
 .fnstart 
	push {r3, r4, lr}
        ldr r3, =rojo 
        ciclo_pintar_letra_rojo:
                ldrb r4, [r3]
                cmp r4, #0
                beq fin_pintar_letra_rojo
                strb r4, [r1]
                add r1, #1
                add r3, #1
                b ciclo_pintar_letra_rojo
        fin_pintar_letra_rojo:
                strb r2, [r1]
                add r1, #1
	        pop {r3, r4, lr}
                bx lr
 .fnend

 pintar_letra_amarillo:
 .fnstart 
	push {r4, r5, lr}
        ldr r5, =amarillo                               // Codigo de color del amarillo
        ciclo_pintar_letra_amarillo:
                 ldrb r4, [r5]
                 cmp r4, #0
                 beq fin_pintar_letra_amarillo
                 strb r4, [r1]
                 add r1, #1
                 add r5, #1
                 b ciclo_pintar_letra_amarillo
        fin_pintar_letra_amarillo: 
                strb r2, [r1]
                add r1, #1

	pop {r4, r5, lr}
        bx lr
.fnend
pintar_letra_verde:
 .fnstart
                push {r4, r5, lr}
        	ldr r5, =verde                       // Codigo de color del verde
        ciclo_pintar_letra_verde:
                ldrb r4, [r5]
                cmp r4, #0
                beq fin_pintar_letra_verde
                strb r4, [r1]
                add r1, #1
		add r5,#1
                b ciclo_pintar_letra_verde
 	 fin_pintar_letra_verde:
                strb r2, [r1]
                add r1, #1

		pop {r4, r5, lr}
      		bx lr
.fnend

// SUBRUTINA CALCULA PUNTOS

calcular_puntos:
.fnstart
	push {lr}
	mov r5,#5                                       //guarda el 5 de la cantidad de letras
	sub r11,r11,#'0'
	mul r3,r11,r5                                   //5 por r11 intentos.
	cmp r3,#5                                       //si tiene solo un digito lo convertimos directo en ascii
	beq transformar
	bl transforma_a_ascii
	ldr r1,=puntos_jugador
        strb r2,[r1],#1
        strb r4,[r1],#1
	bal fin5

	transformar:
		add r3,r3,#'0'
		ldr r4,=puntos_jugador
		strb r3,[r4]
		bal fin5
	fin5:
	mov r7,#4                                     //MUESTRA EN PANTALLA
        mov r0,#1
        ldr r1,=nombre_jugador
        ldr r2,=lennombre_jugador
        swi 0
	mov r7,#4                                     //MUESTRA EN PANTALLA
        mov r0,#1
        ldr r1,=puntos_jugador
        ldr r2,=lenpuntos_jugador
        swi 0

	pop {lr}
	bx lr
.fnend

transforma_a_ascii:
.fnstart
	push {lr}
	mov r1,#10
	udiv r2,r3,r1
	mul r0,r2,r1
	sub r4,r3,r0
	// Transformo ahora cada digito en asci
	add r2,r2,#'0'
	add r4,r4,#'0'
	pop {lr}
	bx lr
.fnend

//SUBRUTINA guarda el nombre del jugador  para ranking

ingrese_nombre:
.fnstart
           push {lr}
         mov r7,#4
         mov r0,#1
         ldr r2,=lenpedir_nombre
         ldr r1,=pedir_nombre
         swi 0
         mov r7, #3                    // syscall sys_read
         mov r0, #0                    // Leer desde entrada estándar (stdin)
         ldr r1, =nombre_jugador       // Almacenar entrada en buffer_usuario
         mov r2,#10
         svc 0                        // Llamada al sistema
         pop {lr}
         bx lr 
.fnend

// SUBRUTINA si adivina en la primera.

compara_palabra:
.fnstart
	push {lr}
	ldr r1,=buffer_usuario
	ldr r2,=palabra_elegida
	mov r5,#0

	cicloPalabra:
		ldrb r3,[r1,r5]
		ldrb r4,[r2,r5]
		cmp r3,#0
		beq final
		cmp r3,r4
		bne falso
		add r5,#1
		b cicloPalabra

	falso:
		mov r9,#1
		bal final
	final:
		pop {lr}
		bx lr
.fnend

// Subrutina para leer la palabra del usuario y guardarla en buffer_usuario

Leer_cadena:
.fnstart
         push {lr}
         mov r7, #3                      // syscall sys_read
         mov r0, #0                       // Leer desde entrada estándar (stdin)
         ldr r1, =buffer_usuario          // Almacenar entrada en buffer_usuario
         mov r2,#7
         svc 0                         // Llamada al sistema
         pop {lr}
         bx lr                        // Vol
.fnend

//SUBRUTINAS PARA GENERAR NUMERO ALEATORIO

genera_random:
.fnstart
         push {lr}
	 mov r7,#4
         mov r0,#1
         ldr r2,=lenpedir_numero
         ldr r1,=pedir_numero
         swi 0
         mov r7, #3			 // syscall sys_read
         mov r0, #0                      // Leer desde entrada estándar (stdin)
         ldr r1, =falso_random 		// Almacenar entrada en buffer_usuario
         mov r2, #4
         svc 0 				// Llamada al sistema
         ldr r8,=falso_random
         ldrb r4,[r8]
         sub r4,r4,#'0'
         ldr r12,=numero_elegido
         strb r4,[r12]
         pop {lr}
         bx lr
.fnend

//Sortear palabra, divide las palabras con ',' y guarda en palabra_elegida

sortear_palabras:
.fnstart
        push {lr}
        ldr r8,=numero_elegido
        ldrb r0,[r8]
        ldr r1,=buffer1
        ldrb r10,[r1]			 //primer letra del archivo
        mov r5,#0			 // offset
        mov r4,#0			 // Va a guardar el numero de palabra
        ldr r3,=palabra_elegida
        mov r9,#','
        mov r2,#0			 //offset de la palabra elegida

        ciclo1:
                cmp r10,#0		 // Termino la cadena si es igual a 0
                beq fin_txt
                cmp r10,r9		 // si es una coma empieza una palabra
                beq incrementoContador
                add r5,#1
                ldrb r10,[r1,r5]
                b ciclo1
	incrementoContador:
                add r4,#1 		//incremento el contador de comar para dividir palabr$
                cmp r0,r4 		// comparo numero elegido con contador de comas
                beq guardoLetra 	// es el numero de palabra elegida lo guardo en$
                add r5,#1
                ldrb r10,[r1,r5]	 // Siguiente letra
                b ciclo1

        guardoLetra:
                add r5,#1 		// sumo uno para no agarrar la coma
                ldrb r10,[r1,r5]
                cmp r10,r9 		//si es una coma voy a fin, termino la palabra
                beq fin_txt
                cmp r10,#0
                beq fin_txt		 //termino el txt
                strb r10,[r3,r2]
                add r2,#1
                b guardoLetra
 	fin_txt:
                pop {lr}
                bx lr
.fnend

// Subrutinas para manejar archivo TXT

leer_palabras:
.fnstart
        push {lr}
        bl abrir_archivo
        bl leer_archivo
        bl cerrar_archivo
        pop {lr}
        bx lr
.fnend

abrir_archivo:
.fnstart
        push {lr}
        mov r7,#5
        ldr r0,=archivo
        mov r1,#0
        swi 0
        pop {lr}
        bx lr
.fnend

cerrar_archivo:
.fnstart
        push {lr}
        mov r0,r6
        mov r7,#6
        swi 0
        pop {lr}
        bx lr
.fnend

leer_archivo:
.fnstart
        push {lr}
        mov r7,#3
        ldr r1,=buffer1
        mov r2,#55 			 //CANTIDAD DE CARACTERES DEL ARCHIVO
        swi 0
        pop {lr}
        bx lr
.fnend

// Subrutinas para imprimir cadenas

imprime_presentacion:
.fnstart
	push {lr}
	mov r7,#4
	mov r0,#1
	ldr r2,=lenpresentacion
	ldr r1,=presentacion
	swi 0
	pop {lr}
	bx lr
.fnend

imprimir_num:
.fnstart
	push {lr}
	ldr r8,=num
	mov r6,r11
	add r11,r11,#0x30			 // CONVIERTE EN ASCIi LOS INTENTOS
	str r11,[r8]
	mov r7,#4				  //salida por pantalla
	mov r0,#1
	ldr r1,=num
	ldr r2,=lennum
	swi 0
	pop {lr}
	bx lr
.fnend

imprimir_intentos:
.fnstart
        push {lr}
        mov r7,#4
        mov r0,#1
        ldr r1,=intentos_restantes
        ldr r2,=lenintentos_restantes
        swi 0
        pop {lr}
        bx lr
.fnend
imprimir_ingrese_palabra:
.fnstart
        push {lr}
        mov r7,#4
        mov r0,#1
        ldr r1,=ingrese_palabra
        ldr r2,=leningrese_palabra
        swi 0
        pop {lr}
        bx lr
.fnend

imprimir_ganaste:
.fnstart
        push {lr}
        mov r7,#4
        mov r0,#1
        ldr r1,=mensaje_ganaste
        ldr r2,=lenmensaje_ganaste
        swi 0
        pop {lr}
        bx lr
.fnend

imprimir_perdiste:
.fnstart
        push {lr}
        mov r7,#4
        mov r0,#1
        ldr r1,=mensaje_perdiste
        ldr r2,=lenmensaje_perdiste
        swi 0
        pop {lr}
        bx lr
.fnend

imprimir_deapoyo:
.fnstart
        push {lr}
        mov r7,#4
        mov r0,#1
        ldr r1,=apoyo
        ldr r2,=lenapoyo
        swi 0
        pop {lr}
        bx lr
.fnend

// SUBRUTINA volver a jugar

volver_a_jugar:
.fnstart
        push {lr}
        mov r7,#4
        mov r0,#1
        ldr r1,=jugar
        ldr r2,=lenjugar
        swi 0
	mov r7, #3 			// syscall sys_read
        mov r0, #0			 // Leer desde entrada estándar (stdin)
        ldr r1, =contestacion 		// Almacenar entrada en buffer_usuario
        mov r2, #4
        svc 0 				// Llamada al sistema
	ldr r3,=contestacion
	ldrb r1,[r3] 			//aca guarda una S si dijo que si.
        pop {lr}
        bx lr
.fnend

informar_resultado:
.fnstart
	push {lr}
	ldr r1, =cadena_nueva
	ldr r2, =lencadena_nueva
	mov r7, #4
	mov r0, #1
	swi 0
	pop {lr}
	bx lr
.fnend


.global main

main:
bl ingrese_nombre
bl imprime_presentacion
bl leer_palabras		 //Abre archivo y guarda palabras en el buffer.

volverAJugar:
mov r11,#5
// R11 Inicializa cantidad de intentos.
// R6 tambien uso para los intentos, no UTILIZAR.
bl genera_random
bl sortear_palabras

intentos:
bl imprimir_num
bl imprimir_intentos
bl imprimir_ingrese_palabra
bl Leer_cadena
bl compara_palabra
cmp r9,#1 			//si hay un 1 es pror que alguna letra no es la misma, si no adivino.
bne adivino
bl verifica_letras_verdes
bl informar_resultado
sub r6,#1			 //resta un intento VER SI ACIERTA SUMAR UNO AL PUNTAJE
mov r11,r6 			//ACA r11 ya tiene un intento menos
cmp r11,#0
beq perdio
bl imprimir_deapoyo
b intentos

adivino:
	bl verifica_letras_verdes
	bl informar_resultado
	bl imprimir_ganaste 		// tiene 5*5 = 25 puntos (RANKING)
	bl calcular_puntos
	bal fin
perdio:
	bl imprimir_perdiste
	bal fin

fin:
bl volver_a_jugar
cmp r1,#'s'
beq volverAJugar

mov r7,#1
swi 0

