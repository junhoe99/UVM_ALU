# 🌐UVM_ALU

> SystemVerilog를 기반으로한 UVM을 활용해 간단한 ALU design 동작을 Verification하는 프로젝트입니다. 


## 🔎 Overview
- Architecture
<img width="6128" height="3624" alt="image" src="https://github.com/user-attachments/assets/98d33e28-3ff5-436b-ab04-81a6646e9b6f" />



## 📌 DUT Spec Analysis

## 🔁 Verification Plan

## 📚 TB Architecture

## 📋 Testcase & Scenario

## 🏛️ Development Archive
### **Run#0**
> Run success, EPWaveform generation success
<img width="630" height="160" alt="image" src="https://github.com/user-attachments/assets/94e653f8-5368-4505-b796-d9d91800fffe" />

- **[☑️Overview]**
    - 기본적인 UVM Architecture 구성 성공
    - Run 성공
    - EPWave form 생성 성공      
- **[❌Trouble Shooting]**
    - Waveform만을 활용해 단순 timing 검증만이 가능함
    - Edge case 등, 더 다양한 case에 대한 검증 필요(more test scenario)
    
- **[🛠️Solution]**
     - assertion, coverage 컴포넌트 추가

- **[🎯Expecting Improvement]**
    -  SVA, CDV 검증 환경 구축
### **Run#1**
> CDV, SVA 검증 환경 구축

- **[☑️Overview]**
    - assertion, coverage 컴포넌트 추가
     <img width="3000" height="1500" alt="image" src="https://github.com/user-attachments/assets/0105fa5e-1bad-480c-9c7c-33bd88d892e1" />


- **[❌Trouble Shooting]**
    - Carry Flag logic 오류(Most critical)
       - 모든 연산에서도 add carry가 적용되어 잘못된 carry 값이 출력
    - Assertion 타이밍 문제
       - assertion이 combinational logic 결과와 clk 동기화된 출력 간의 1 clk delay를 고려하지 못함
    - Multiplication Overflow 문제
         - 15 x 11 = 165(8비트 초과)에서 carry =1 이어야 하는데 carry =0으로 출력       
    - 목표 coverage에 한참 못 미치는 coverage.
      
- **[🛠️Solution]**
     - 1. ALU Design Debugging
       - carry logic을 각  연산별로 올바르게 수정
       - Addition : 9bit 결과의 MSB를 carry로 사용
       - Multiplication : 16비트 결과의 9번째 비트를 carry로 사용
       - Subtraction : Borrow flag 구현
       - Division : Carry = 0 (나눗셈은 carry 미생성)
     - 2. Assertion 타이밍 수정:
       - 지연 추가로 클럭 동기화 고려
       - Combinational logic과 clk 동기 출력 간의 타이밍 문제 해결
     - 3. Scoreboard 수정 :
       - Multiplication carry 계산 방식 개선
       - Subtraction borrow flag 로직 추가
      
- **[🎯Expecting Improvement]**
    -  Assertion failures 감소
    -  Carry Mismatch 오류 해결
    -  Coverage 목표(90%) 달성
    -  Pass rate(95%) 달성
 
    -  
## ✨ Verification Results
