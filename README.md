<!-- วางลิงก์รูปภาพหน้าปก UI ของโปรแกรมที่นี่ -->
<img width="1146" height="858" alt="image" src="https://github.com/user-attachments/assets/a5fcebb3-dbb8-4c0b-8a1e-99c9d1a43467" />
<!-- <img width="1600" height="900" alt="Robocopy Data Rescue" src="YOUR_IMAGE_URL_HERE" /> -->

# Robocopy Data Rescue (No Safe Mode)

เครื่องมือ GUI (PowerShell WPF) แบบ **One-Liner** สำหรับดึงข้อมูลออกจากโฟลเดอร์ `Users` ของฮาร์ดดิสก์/Windows เก่าที่ติดสิทธิ์ **Permission** โดยไม่ต้องรีสตาร์ทเข้า Safe Mode และไม่ต้องพกโปรแกรมเสริม

---

## 📌 ที่มาของโปรเจกต์ (Background)

**เคยประสบปัญหานี้ไหม?** เวลาถอดฮาร์ดดิสก์หรือ SSD จากเครื่องเก่ามาเสียบกับอีกเครื่องเพื่อ Backup ข้อมูลในโฟลเดอร์ `Users` แล้วดันติดล็อก **Access Denied / Permission** จนเปิดเข้าไปก๊อปปี้ไฟล์ไม่ได้

1. **ต้องเสียเวลาโหลดหรือพกโปรแกรมเสริม:** หลายครั้งต้องไปหาโหลดโปรแกรมอย่าง `Explorer++` หรือต้องมานั่งรอ Take Ownership ทีละโฟลเดอร์ซึ่งช้ามากเมื่อเจอไฟล์จำนวนเยอะๆ
2. **ใช้ Notepad แทนได้ แต่พลังยังสู้ไม่ได้:** จริงอยู่ที่เราสามารถใช้ทริคเปิด **Notepad แบบ Run as Administrator** แล้วกด `Ctrl + O` เพื่อทะลุสิทธิ์เข้าไปก๊อปปี้ไฟล์ได้ แต่ความเร็วในการก๊อปปี้ไฟล์ขนาดใหญ่และความเสถียรในการจัดการไฟล์ระบบ ก็ยังสู้พลังของ **Robocopy** ไม่ได้
3. **และนี่คือตัวเลือกที่ดีที่สุด:** โปรเจกต์ **Robocopy Data Rescue** จึงถูกสร้างขึ้นมาเพื่อรวมข้อดีของทั้ง 2 วิธีไว้ในหน้าต่างเดียว — ใช้พลังของ `Robocopy /ZB` ในการทะลุสิทธิ์และก๊อปปี้ความเร็วสูงแบบเลือกโฟลเดอร์ได้ พร้อมปุ่มลัดเปิด **Admin Notepad** เผื่อกรณีที่อยากเข้าไปเลือกดูไฟล์เองด้วยเมาส์ จบครบในคำสั่งเดียว ไม่ต้องติดตั้งโปรแกรมลงเครื่อง

---

## ✨ คุณสมบัติ (Features)

- **Auto-Scan Windows & Users:** สแกนหาไดรฟ์ที่มีโฟลเดอร์ `Windows` และ `Users` ให้อัตโนมัติ โดยเรียงลำดับไดรฟ์ภายนอก (ไม่ใช่ไดรฟ์ `C:`) ขึ้นมาให้เลือกก่อน พร้อมตัดโฟลเดอร์ระบบ (`Public`, `Default`) ออกให้เรียบร้อย
- **Auto Backup Folder (`BAK-DD-MM-YY`):** สร้างและตั้งชื่อโฟลเดอร์ปลายทางตามวันที่ปัจจุบันให้อัตโนมัติ (เช่น `D:\BAK-24-11-26`) ช่วยจัดระเบียบงานช่างได้ง่ายขึ้น
- **Robocopy Power (`/ZB` + `/MT:8`):**
  - ทะลุสิทธิ์ไฟล์ที่ล็อกด้วยโหมด Backup (`/ZB`)
  - ข้ามโฟลเดอร์ขยะ/ไฟล์ระบบที่ไม่จำเป็น (`/XD AppData`)
  - ก๊อปปี้ความเร็วสูงแบบ Multi-Thread (`/MT:8`)
  - เลือกติ๊กเฉพาะโฟลเดอร์สำคัญ (`Desktop`, `Documents`, `Downloads`, `Pictures`, `Videos`, `Music`) หรือสั่งก๊อปปี้ทั้งโปรไฟล์ได้ในคลิกเดียว
- **Built-in Admin Notepad:** มีปุ่มลัดเปิด Notepad ด้วยสิทธิ์ Administrator ทันที สำหรับงานที่ต้องการกด `Ctrl + O` เลือกก๊อปปี้ไฟล์เองแบบเห็นภาพ
- **Bilingual UI (TH / EN):** ตรวจจับภาษาเครื่องอัตโนมัติ และกดสลับภาษาไทย/อังกฤษได้ทันทีบนหน้าจอ
- **Side-by-Side Log Console:** แสดงหน้าต่าง Console คู่ขนานกับหน้าต่าง GUI เพื่อติดตามสถานะการสแกนและคำสั่งที่รันแบบ Real-time

---

## 🚀 วิธีใช้งาน (Usage)

1. เปิด **PowerShell** หรือ **Windows Terminal** ด้วยสิทธิ์ **Run as Administrator**
2. คัดลอกคำสั่งด้านล่างไปวางแล้วกด **Enter**

### แบบลิงก์ย่อ (แนะนำ)
```powershell
iex (irm bit.ly/Robocopy)
```

### แบบลิงก์ตรงจาก GitHub
```powershell
iex (irm https://raw.githubusercontent.com/itgroceries-sudo/RobocopyRescue/main/RobocopyRescue.ps1)
```

3. เมื่อหน้าต่างโปรแกรมเปิดขึ้นมา:
   - **เลือกต้นทาง:** เลือกโฟลเดอร์ User เก่าจากช่อง **Auto-Scan** (หรือกดปุ่ม `Browse / เลือก` เอง)
   - **เลือกปลายทาง:** ระบบจะตั้งชื่อโฟลเดอร์ `BAK-DD-MM-YY` ไว้ให้แล้ว (สามารถกด `Browse / เลือก` เปลี่ยนไดรฟ์ได้)
   - **เลือกรูปแบบการทำงาน:**
     - ติ๊กเลือกโฟลเดอร์ที่ต้องการ แล้วกดปุ่มสีเขียว **Start Copy / เริ่มก๊อปปี้** เพื่อรัน Robocopy ทันที
     - หรือกดปุ่มสีน้ำเงิน **Admin Notepad / เปิด Notepad แอดมิน** แล้วกด `Ctrl + O` (เปลี่ยนเป็น `All Files`) เพื่อเข้าไปเลือกก๊อปปี้ไฟล์เอง

<details>
  <summary>Click to View UI</summary>
  <p align="center">
    <img width="48%" alt="UI Main Options" src="https://github.com/user-attachments/assets/826776e1-f801-4bbd-bdbf-a813719fae52" />
    <img width="48%" alt="UI Classic Apps" src="https://github.com/user-attachments/assets/77f85894-51b5-4038-a9d5-df4e3af48555" />
  </p>
</details>

---

## ⚠️ หมายเหตุ (Notes)

- จำเป็นต้องรันด้วยสิทธิ์ **Administrator** เพื่อให้พารามิเตอร์ `/ZB` ของ Robocopy และ Admin Notepad สามารถทะลุสิทธิ์ Permission ของ Windows เก่าได้
- เครื่องที่รันคำสั่ง `iex (irm ...)` จำเป็นต้องเชื่อมต่ออินเทอร์เน็ตเพื่อดึงสคริปต์จาก GitHub

---

## 👨‍💻 เครดิตและช่องทางติดตาม (Credits & Contact)

พัฒนาและดูแลโดย **IT Groceries Shop**

- **GitHub:** [itgroceries-sudo/RobocopyRescue](https://github.com/itgroceries-sudo/RobocopyRescue)
- **Facebook:** [Adm1n1straTOE](https://www.facebook.com/Adm1n1straTOE/)
- **YouTube:** [@itgroceries](https://www.youtube.com/@itgroceries)

---

## 📄 License

โปรเจกต์นี้เผยแพร่ภายใต้สัญญาอนุญาต [MIT License](LICENSE) — สามารถนำไปใช้งาน ดัดแปลง หรือแจกจ่ายต่อได้โดยอิสระ
