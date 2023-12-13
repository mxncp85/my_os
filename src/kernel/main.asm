org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

start:
    jmp main

;
; Prints a string to the screen
; PARAMS:
;  ds:si - pointer to string
;
puts:
    ; save registers we will modify
    push si
    push ax

.loop:
    lodsb       ; load next byte from ds:si into al, increment si
    or al,al    ; check if next char is null
    jz .done    ; if so, we are done
    ;jmp .loop   ; otherwise, print it and loop

    mov ah, 0x0e ; BIOS tty print char
    ;mov bh, 0   ; page number
    int 0x10    ; call BIOS

    jmp .loop

.done:
    pop ax
    pop si
    ret

main:

    ; setup data segment
    mov ax, 0   ; cant write to ds/as directly
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss, ax
    mov sp, 0x7C00  ; stack grows downwards from where are loaded in memory

    ;print hello world
    mov si, msg_hello
    call puts

    hlt

.halt:
    jmp .halt

msg_hello: db 'Hello World!', ENDL, 0

times 510-($-$$) db 0
dw 0AA55h
