org 100h

section .data
    ; [ส่วนของ นพรัตน์: ตัวแปรและ Buffer]
    ; --- Data Section ---
    prompt    db 'Enter text: $'
    result_m  db 0Dh, 0Ah, 'Encrypted: $'
    buffer    db 100, 0
    text_data times 101 db '$'

    ; [ส่วนของ อลงกต: ค่าคงที่]
    shift db 3

section .text
start:
    ; [ส่วนของ นพรัตน์: คำสั่งรับค่า]
    ; --- Input Section ---
    mov ah, 09h
    mov dx, prompt
    int 21h
    mov ah, 0Ah
    mov dx, buffer
    int 21h

    ; [ส่วนของ อลงกต: โครงสร้าง Loop หลัก]
    xor cx, cx
    mov cl, [buffer + 1] ; ความยาวจริง
    mov bx, 0

main_loop:
    cmp cl, 0
    je display_result
    mov al, [text_data + bx]
    
    call process_cipher   ; เรียกงานของจิรภัทร
    
    mov [text_data + bx], al
    inc bx
    dec cl
    jmp main_loop

    ; (ดึงข้อมูลจาก Buffer เข้า AL)
process_cipher:
    cmp al, 'A'
    jb  finish
    cmp al, 'z'
    ja  finish
    cmp al, 'Z'
    jbe is_upper
    cmp al, 'a'
    jae is_lower
    jmp finish

is_upper:
    add al, [shift]
    cmp al, 'Z'
    jbe finish
    sub al, 26
    ret

is_lower:
    add al, [shift]
    cmp al, 'z'
    jbe finish
    sub al, 26

finish:
    ret

    ; [ส่วนของ นพรัตน์: คำสั่งแสดงผล]
    ; --- Output Section ---
    mov ah, 09h
    mov dx, result_m
    int 21h
    mov dx, text_data
    int 21h
