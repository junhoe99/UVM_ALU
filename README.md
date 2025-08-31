# 🌐UVM_ALU

> SystemVerilog를 기반으로한 UVM을 활용해 간단한 ALU design 동작을 Verification하는 프로젝트입니다. 

---

## 🔎 Overview
- Architecture  
  <img src="https://github.com/user-attachments/assets/2ab22e16-1ceb-462c-aa5e-42a1e4e95eab" width="900" />

---

## 📌 DUT Spec Analysis

---

## 🔁 Verification Plan

---

## 📚 TB Architecture

---

## 📋 Testcase & Scenario

---

## 🏛️ Development Archive

### **Run#0**
> Run success, EPWaveform generation success  

<img src="https://github.com/user-attachments/assets/94e653f8-5368-4505-b796-d9d91800fffe" width="700" />

- **[☑️Overview]**
    - 기본적인 UVM Architecture 구성 성공
    - Run 성공
    - EPWave form 생성 성공      
- **[❌Trouble Shooting]**
    - Waveform만을 활용해 단순 timing 검증만이 가능함
    - Edge case 등, 더 다양한 case에 대한 검증 필요(more test scenario)
    
- **[🛠️Solution]**
     - assertion, coverage 컴포넌트 추가
     - Directed scenario를 추가해 다양한 case에 대한 검증 수행

- **[🎯Expecting Improvement]**
    -  SVA, CDV 검증 환경 구축

---

### **Run#1**
> CDV, SVA 검증 환경 구축  

<img src="https://github.com/user-attachments/assets/0105fa5e-1bad-480c-9c7c-33bd88d892e1" width="900" />

- **[☑️Overview]**
    - assertion, coverage 컴포넌트 추가

- **[❌Trouble Shooting]**
    - **Functional Coverage**가 너무 낮음  
      <img src="https://github.com/user-attachments/assets/3d369c71-e8a1-4a11-a0bb-0428e9237b1e" width="550" />  
      <img width="462" height="436" alt="1" src="https://github.com/user-attachments/assets/5d717f31-679e-409c-a158-1a7db53237d3" />

      
    - **Carry Flag logic 오류(Most critical)**
        - Multplication 동작에서도 ADD carry가 적용되어서 올바르지 않은 값이 출력됨. 
    - **Assertion 타이밍 문제**  
    - **Multiplication Truncation 문제**  
      <img src="https://github.com/user-attachments/assets/1b93a723-30cb-4b81-8e3d-b523733f0fda" width="250" />  
      <img src="https://github.com/user-attachments/assets/41388676-3d64-40c4-9b00-35a084a4cfb7" width="280" />



- **[🛠️Solution]**
     - **1. ALU Design Debugging :** 연산별로 Carry 계산 logic 분리
     - **2. sequence_item의 input 및 op code값에 대한 Constraint 완화 :**
     - **3. Assertion 타이밍 수정 :** clk 동기화 고려  
     - **4. Directed Test추가**  
      
- **[🎯Expecting Improvement]**
    -  Assertion failures 감소
    -  Carry Mismatch 오류 해결
    -  Functional Coverage 목표(90%) 달성

---

### **Run#2**
> Functional Coverage 수정, DUT의 RTL 코드 디버깅  

- **[☑️Overview]**
    - Functional Coverage ~% 개선
    - Multiplication Result Truncation 해결

      
- **[🛠️Solution]**
     - **ALU Design Debugging :** 각 연산별 carry 로직 수정  
     - **Assertion 타이밍 수정 :** 지연 추가  
     - **Scoreboard 수정 :** carry/borrow 계산 개선  
      
- **[🎯Expecting Improvement]**
    -  Assertion failures 감소
    -  Carry Mismatch 오류 해결
    -  Coverage 목표(90%) 달성
    -  Pass rate(95%) 달성

---

## ✨ Verification Results
   - **1. 최종 Functional Coverage 값 :**
   - **2. 각 연산별 Edge Case(Simulation 기반) :**
       - Addition (op_code == 0)
       - Subtraction (op_code == 1)
       - Multiplication (op_code == 2)
       - Division  (op_code == 3)
    
   - **3. SVA기반 ALU 프로토콜 검증 :**
        - Addition (op_code == 0)
       - Subtraction (op_code == 1)
       - Multiplication (op_code == 2)
       - Division  (op_code == 3)
---

## 🔥 Insights
