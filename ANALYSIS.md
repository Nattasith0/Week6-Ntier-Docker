# 📊 การวิเคราะห์เปรียบเทียบ: VM vs Docker Deployment
## ENGSE207 - Week 6 N-Tier Architecture

**ชื่อ-นามสกุล:** ณัฐสิทธิ์ มะโนชัย 
**รหัสนักศึกษา:** 67543210056-7  
**วันที่:** 26/01/2569

---

## 1. ตารางเปรียบเทียบ Setup Process

| ขั้นตอน | Version 1 (VM) | Version 2 (Docker) |
|---------|----------------|-------------------|
| ติดตั้ง PostgreSQL | ติดตั้งผ่าน `apt install postgresql` และตั้งค่า user, database, port ด้วยตนเองใน VM | ใช้ image จาก Docker Hub (`postgres`) และกำหนดค่าใน `docker-compose.yml` |
| ติดตั้ง Node.js | ติดตั้งด้วย `curl` + `apt install nodejs npm` | ไม่ต้องติดตั้งในเครื่อง ใช้ Node.js ภายใน container |
| ติดตั้ง Nginx | ติดตั้งผ่าน `apt install nginx` และตั้งค่า reverse proxy | ใช้ image `nginx` และ mount config file เข้า container |
| Configure Database | แก้ไฟล์ config และ environment variable บน VM | กำหนดผ่าน `environment:` ใน Docker Compose |
| Configure SSL | ติดตั้ง Certbot และตั้งค่า SSL ใน Nginx | สามารถเพิ่ม service สำหรับ Certbot หรือ config ผ่าน container |
| Start Services | รันแต่ละ service ด้วยคำสั่งแยกกัน (postgres, node, nginx) | ใช้คำสั่งเดียว `docker compose up -d` |
| **เวลาทั้งหมด** | ประมาณ 60–90 นาที | ประมาณ 15–30 นาที |

---

## 2. ตารางเปรียบเทียบ Resource Usage

| Resource | Version 1 (VM) | Version 2 (Docker) |
|----------|----------------|-------------------|
| Memory Usage | ใช้ `free -h` พบว่า VM ใช้ RAM ค่อนข้างสูงเพราะมี OS เต็มรูปแบบ | ใช้ `docker stats` พบว่าแต่ละ container ใช้ RAM เฉพาะส่วนที่จำเป็น |
| Disk Usage | ใช้ `df -h` เห็นว่าพื้นที่ถูกใช้มากจาก OS และ package | ใช้ `docker system df` ใช้พื้นที่เฉพาะ image และ volume |
| CPU Usage | ใช้ CPU สูงขึ้นเมื่อรันหลาย service พร้อมกัน | ใช้ CPU น้อยกว่าเพราะ container แชร์ kernel |
| Startup Time | ประมาณ 30–60 วินาที | ประมาณ 5–15 วินาที |

---

## 3. ข้อดีของ Docker Deployment (5 ข้อ)

1. **ติดตั้งรวดเร็ว:** ใช้ Docker Compose สั่งรันทุก service พร้อมกันในคำสั่งเดียว ลดเวลาการ setup จากเป็นชั่วโมงเหลือไม่กี่นาที  
2. **สภาพแวดล้อมเหมือนกันทุกเครื่อง:** ทุกคนใช้ image เดียวกัน ทำให้ปัญหา “รันได้บนเครื่องฉัน แต่เครื่องเธอไม่ได้” ลดลง  
3. **แยกส่วนชัดเจนตาม N-Tier:** Frontend, Backend, Database อยู่คนละ container ทำให้ดูสถาปัตยกรรมได้ชัดเจน  
4. **ง่ายต่อการ Scale:** สามารถเพิ่มจำนวน backend container ได้ง่ายด้วยการแก้ compose file  
5. **ลบและสร้างใหม่ได้สะดวก:** ถ้าพังสามารถ `docker compose down` แล้ว `up` ใหม่ได้ทันที 

---

## 4. ข้อเสียของ Docker Deployment (3 ข้อ)

1. **ต้องเรียนรู้คำสั่งใหม่:** ต้องเข้าใจ Docker, Dockerfile และ Docker Compose เพิ่มจาก Linux ปกติ  
2. **Debug ยากกว่า:** ถ้า service มีปัญหา ต้องเข้าไปดู log ใน container แทนที่จะดู log บนเครื่องตรงๆ  
3. **ใช้พื้นที่จาก Image และ Volume:** ถ้ามีหลาย image หรือไม่ได้ลบของเก่า อาจกินพื้นที่ disk มาก

---

## 5. เมื่อไหร่ควรใช้ VM vs Docker?

### ควรใช้ VM เมื่อ:
- ต้องการระบบปฏิบัติการเต็มรูปแบบ (เช่น ทดสอบ Kernel/Driver)
- ต้องรัน Software ที่ต้องการ OS เฉพาะ
- ระบบ Production ขนาดใหญ่ที่ต้องแยกเครื่องจริงชัดเจน

### ควรใช้ Docker เมื่อ:
- ต้องการ Deploy เร็วและซ้ำได้หลายครั้ง
- ใช้ Microservices หรือ N-Tier Architecture
- ต้องการทดสอบ/พัฒนาในหลายเครื่องให้เหมือนกัน

---

## 6. สิ่งที่ได้เรียนรู้จาก Lab นี้

จาก Lab นี้ได้เรียนรู้ความแตกต่างระหว่างการ Deploy ระบบแบบใช้ VM และ Docker อย่างชัดเจน  
เข้าใจว่า Docker ช่วยลดเวลาในการติดตั้งและจัดการระบบได้มาก  
เห็นภาพการแยก Tier ของระบบผ่าน container ทำให้เข้าใจ N-Tier Architecture ในเชิงปฏิบัติ  
และได้ฝึกการใช้ Docker Compose เพื่อควบคุมหลาย service พร้อมกันในโปรเจคเดียว  

---

## 7. คำสั่ง Docker ที่ใช้บ่อย (Quick Reference)

```bash
# ดู container ที่กำลังรัน
docker ps

# สร้างและรันทุก service
docker compose up -d

# หยุดและลบ container ทั้งหมด
docker compose down

# ดู log ของ backend
docker logs backend-container

# เข้าไปใน container
docker exec -it backend-container bash

# ดู image ทั้งหมด
docker images

# ลบ image ที่ไม่ใช้
docker image prune

---

### 8.2 คำสั่งสำหรับเก็บข้อมูล

```bash
# ดู memory usage ของ Docker
docker stats --no-stream

# ดู disk usage
docker system df

# ดู container sizes
docker ps -s

# ดู image sizes
docker images

# ดู network
docker network ls
docker network inspect taskboard-network


---


สร้างโดย: ณัฐสิทธิ์ มะโนชัย
ENGSE207 Software Architecture - Week 6 EOF