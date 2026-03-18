# 🛡️ Caesar Cipher Project (8086 Assembly)

โปรเจคนี้คือการนำอัลกอริทึม **Caesar Cipher** มาประยุกต์ใช้ในระดับ Low-level ด้วยภาษา **Assembly** โดยรันบนสภาพแวดล้อม **DOSBox** เพื่อศึกษาการทำงานของ CPU, Registers และการจัดการหน่วยความจำ (Memory)

---

## 🛠️ รายละเอียดเครื่องมือ (Tools)
* **Assembler:** NASM (The Netwide Assembler)
* **Emulator:** DOSBox (16-bit DOS Environment)
* **Target File:** .COM (Tiny Memory Model)

---

## 🧠 สรุปการทำงานของ Register (Registers Breakdown)
ในการนำเสนอโปรเจค การเข้าใจหน้าที่ของแต่ละ Register จะช่วยให้ดูเป็นมือโปรมากครับ:

| Register | หน้าที่ในโปรเจคนี้ |
| :--- | :--- |
| **AL** | ใช้เป็นตัวพักข้อมูลตัวอักษร 1 Byte เพื่อทำการคำนวณบวกค่า Shift |
| **BX** | ใช้เป็นตัวชี้ตำแหน่ง (Index) ของตัวอักษรในหน่วยความจำ |
| **CL** | ใช้เป็นตัวนับรอบ (Loop Counter) ตามความยาวของข้อความ |
| **DX** | ใช้เก็บตำแหน่ง Address ของข้อความเพื่อส่งให้ Interrupt แสดงผล |
| **AH** | ใช้ระบุหมายเลขฟังก์ชันของ **INT 21h** (เช่น 09h = แสดงผล, 0Ah = รับค่า) |

---

## 📜 Source Code (`cipher.asm`)

```assembly
org 100h            ; DOS .COM file offset

section .data
    msg1 db 'Enter text: $'
    msg2 db 0Dh, 0Ah, 'Encrypted: $'
    buffer db 100       ; Buffer structure for INT 21h/0Ah
    actual_len db 0     ; Storage for actual input length
    text_data times 100 db 0
    shift db 3          ; Shift value

section .text
start:
    ; --- แสดงข้อความ "Enter text:" ---
    mov ah, 09h
    mov dx, msg1
    int 21h

    ; --- รับ Input จาก Keyboard ---
    mov ah, 0Ah
    mov dx, buffer
    int 21h

    ; --- เตรียม Register สำหรับ Loop ---
    xor cx, cx
    mov cl, [actual_len] ; ดึงค่าความยาวข้อความมาเป็นตัวนับ
    mov bx, 0           ; เริ่มที่ตำแหน่งแรก

cipher_loop:
    cmp cl, 0           ; ถ้าทำครบแล้ว ให้จบ Loop
    je display_result
    
    mov al, [text_data + bx] 

    ; ตรวจสอบและจัดการตัวพิมพ์ใหญ่ (A-Z)
    cmp al, 'A'
    jl next_char
    cmp al, 'Z'
    jg check_lower
    add al, [shift]
    cmp al, 'Z'
    jbe store_char
    sub al, 26          ; Wrap-around กลับไป A
    jmp store_char

check_lower:
    ; ตรวจสอบและจัดการตัวพิมพ์เล็ก (a-z)
    cmp al, 'a'
    jl next_char
    cmp al, 'z'
    jg next_char
    add al, [shift]
    cmp al, 'z'
    jbe store_char
    sub al, 26          ; Wrap-around กลับไป a

store_char:
    mov [text_data + bx], al ; บันทึกค่าที่เข้ารหัสแล้วกลับลงไป

next_char:
    inc bx              ; เลื่อนตำแหน่ง Index
    dec cl              ; ลดจำนวนรอบ
    jmp cipher_loop

display_result:
    mov byte [text_data + bx], '$' ; ปิดท้าย String สำหรับแสดงผล

    ; --- แสดงผลลัพธ์ "Encrypted:" ---
    mov ah, 09h
    mov dx, msg2
    int 21h
    
    mov dx, text_data
    int 21h

    ; จบโปรแกรม
    mov ax, 4C00h
    int 21h
