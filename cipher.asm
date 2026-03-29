org 100h

; ==========================================================
; PART: ALONGKOT - Main Execution Flow
; ==========================================================
start:
    ; --- STEP 1: Get Input String (Nopparat's Part) ---
    mov ah, 09h
    mov dx, offset prompt
    int 21h
    
    mov ah, 0Ah
    mov dx, offset buffer
    int 21h

    ; --- STEP 2: Encryption Process (Alongkot's Loop Control) ---
    xor cx, cx
    mov cl, [buffer + 1]       ; Get length of input string
    mov bx, 0                  ; Set index to 0

encrypt_loop:
    cmp cl, 0
    je  display_enc            ; If no characters left, display result
    
    mov si, offset buffer + 2
    mov al, [si + bx]          ; Load original character
    
    call encrypt_logic         ; Process: Jiraphat's Logic
    
    mov [enc_data + bx], al    ; Store in encrypted buffer
    inc bx
    dec cl
    jmp encrypt_loop

display_enc:
    mov byte ptr [enc_data + bx], '$' ; Mark end of string
    mov ah, 09h
    mov dx, offset msg_enc
    int 21h
    mov dx, offset enc_data
    int 21h

    ; --- STEP 3: Decryption Process (Automatic Reversal) ---
    xor cx, cx
    mov cl, [buffer + 1]       ; Use the same string length
    mov bx, 0                  ; Reset index to 0

decrypt_loop:
    cmp cl, 0
    je  display_dec
    
    mov al, [enc_data + bx]    ; Load the ENCRYPTED character
    
    call decrypt_logic         ; Process: Jiraphat's Logic
    
    mov [dec_data + bx], al    ; Store in decrypted buffer
    inc bx
    dec cl
    jmp decrypt_loop

display_dec:
    mov byte ptr [dec_data + bx], '$' ; Mark end of string
    mov ah, 09h
    mov dx, offset msg_dec
    int 21h
    mov dx, offset dec_data
    int 21h

    ; Exit Program
    mov ax, 4C00h
    int 21h

; ==========================================================
; PART: JIRAPHAT - Mathematical Logic (Shift Calculations)
; ==========================================================

; --- Function: Encrypt Character ---
encrypt_logic:
    cmp al, 'A'
    jb  f_enc
    cmp al, 'z'
    ja  f_enc
    cmp al, 'Z'
    jbe e_up
    cmp al, 'a'
    jae e_low
    jmp f_enc
e_up:
    add al, [shift]
    cmp al, 'Z'
    jbe f_enc
    sub al, 26                 ; Wrap around if past 'Z'
    ret
e_low:
    add al, [shift]
    cmp al, 'z'
    jbe f_enc
    sub al, 26                 ; Wrap around if past 'z'
f_enc:
    ret

; --- Function: Decrypt Character ---
decrypt_logic:
    cmp al, 'A'
    jb  f_dec
    cmp al, 'z'
    ja  f_dec
    cmp al, 'Z'
    jbe d_up
    cmp al, 'a'
    jae d_low
    jmp f_dec
d_up:
    sub al, [shift]
    cmp al, 'A'
    jae f_dec
    add al, 26                 ; Wrap around if before 'A'
    ret
d_low:
    sub al, [shift]
    cmp al, 'a'
    jae f_dec
    add al, 26                 ; Wrap around if before 'a'
f_dec:
    ret

; ==========================================================
; PART: NOPPARAT - Memory & String Management
; ==========================================================
prompt      db 'Input original text: $'
msg_enc     db 0Dh, 0Ah, 'Phase 1 - Encrypted: $'
msg_dec     db 0Dh, 0Ah, 'Phase 2 - Decrypted: $'
shift       db 3               ; The Key
buffer      db 100, 0          ; Standard input buffer
enc_data    db 101 DUP('$')    ; Buffer for encrypted results
dec_data    db 101 DUP('$')    ; Buffer for decrypted results
