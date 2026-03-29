org 100h

section .data
    ; [ส่วนของ นพรัตน์: ตัวแปรและ Buffer]
    ; (นพรัตน์เขียนส่งมา)

    ; [ส่วนของ อลงกต: ค่าคงที่]
    shift db 3

section .text
start:
    ; [ส่วนของ นพรัตน์: คำสั่งรับค่า]
    ; (นพรัตน์เขียนส่งมา)

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
    ; (นพรัตน์เขียนส่งมา)
