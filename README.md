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
