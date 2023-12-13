org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

;
; FAT12 header
;
jmp short start
nop

bdb_oem:                    db 'MSWIN4.1'           ; 8 bytes
bdb_bytes_per_sector:       dw 512                  ; 2 bytes
bdb_bytes_per_cluster:      db 1                    ; 1 byte
bdb_reserved_sectors:       dw 1                    ; 2 bytes
bdb_fat_count:              db 2                    ; 1 byte
bdb_dir_entries_count:      dw 0E0h
bdb_total_sectors:          dw 2880                 ; 2880 * 512 = 1.44MB
bdb_media_descriptor:       db 0F0h                 ; 9 sectors/fat
bdb_sectors_per_fat:        dw 9
bdb_sectors_per_track:      dw 18
bdb_heads:                  dw 2
bdb_hidden_sectors:         dd 0
bdb_large_sectors_count:    dd 0

; extended boot record
bdb_drive_number:           db 0                    ; 0x00 for floppy, 0x80 for hard disk
                            db 0                    ; reserved
ebr_signature:              db 29h                  ; extended boot record signature
ebr_volume_id:              dd 12h, 34h, 56h, 78h   ; volume id, value doesn't matter
ebr_volume_label:           db 'NO NAME    '        ; volume label, 11 bytes, padded with spaces
ebr_system_id               db 'FAT12   '           ; system id, 8 bytes, padded with spaces

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
