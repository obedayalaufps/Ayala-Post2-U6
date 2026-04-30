; lab6_modos.asm - Ayala
; Demostración de modos de direccionamiento x86
org 100h

jmp inicio

; --- DATOS ---
array       dw 10, 20, 30, 40, 50   ; Array de 5 enteros (16 bits)
notal       dw 85                   ; Campo 1
nota2       dw 73                   ; Campo 2
promedio    dw 0                    ; Campo para resultado
var_x       dw 0FFFFh               ; Variable simple

inicio:
    ; 1. MODO INMEDIATO: El valor está en la instrucción
    mov ax, 100             ; AX = 100 (64h)
    mov bx, 0A5h            ; BX = 0xA5

    ; 2. MODO DIRECTO: Dirección fija en la instrucción
    mov ax, [var_x]         ; AX = mem[dir_var_x] = FFFFh
    mov cx, [notal]         ; CX = 85

    ; 3. MODO INDIRECTO POR REGISTRO: Registro como puntero
    mov si, notal           ; SI = dirección de notal
    mov ax, [si]            ; AX = mem[SI] = 85
    mov si, nota2           ; Apuntar a nota2
    mov bx, [si]            ; BX = 73
    
    ; Calcular promedio usando punteros
    add ax, bx              ; $AX = 85 + 73 = 158$
    shr ax, 1               ; $AX = 158 / 2 = 79$ (4Fh)
    mov si, promedio
    mov [si], ax            ; Guardar 79 en memoria vía SI

    ; 4. MODO INDEXADO: Base + Índice + Desplazamiento
    ; Suma acumulada normal (Checkpoint 3)
    xor ax, ax              ; AX = 0
    mov bx, array           ; BX = Base
    mov cx, 5               ; Contador
    xor si, si              ; SI = Índice (offset 0)

.bucle_suma:
    add ax, [bx + si]       ; AX += mem[BX + SI]
    add si, 2               ; Avanzar 2 bytes (word)
    loop .bucle_suma        ; Al final AX = 150 (96h)

    ; --- EXTENSIÓN: RECORRIDO INVERSO ---
    xor dx, dx              ; DX = 0 (acumulador inverso)
    mov bx, array
    mov cx, 5
    mov si, 8               ; SI = 8 (último elemento: 4 elementos * 2 bytes)

.bucle_inverso:
    add dx, [bx + si]       ; Sumar desde el final
    sub si, 2               ; Decrementar índice
    loop .bucle_inverso     ; Al final DX = 150 (96h)

    int 20h                 ; Retorno a DOS