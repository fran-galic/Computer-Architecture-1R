MAIN    MOV SP,#0x10000        ; INICIJALIZACIJA STOGA
        MOV R0,#0x100         ; U REGISTAR R0 UPISUJEM ADRESU OD POHRANJENOG STR
        LDR R1,GPIO1
        ADD R1,R1,#4           ; R1 IMA SPRMELJENU ADRESU OD PB_DR        

        BL PRNSTR
KRAJ    SWI 123456
        SWI 123456

GPIO1 DW 0xFFFF0F00
      ORG 0x100
STRING DSTR "ovo je zakon"




PRNSTR  STMFD SP!,{R0,R1,R2,R3,LR}
        MOV R2,#8       ; INICIJALAIZAICJA BROJACA
        MOV R3,R0       ; U R3 MI SE NALAZI ADRESA STIRNGA
        MOV R0,#0x0D
        BL LCDWR 

PETLJA  CMP R0,#0
        BEQ KRAJ_F
        CMP R2,#0
        BEQ KRAJ_F

        LDRB R0,[R3],#1 ; SPRMEI MI VIRJENDOST PRVOG CHARACHTERA I POVECAJ NA SLJEDECI
        SUB R2,R2,#1    ; SMANJUJEM BROJAC
        BL LCDWR
        B PETLJA

KRAJ_F  MOV R0,#0x0A
        BL LCDWR 
        LDMFD SP!,{R0,R2,R3,LR}
        MOV PC,LR





LCDWR STMFD SP!,{R0}

      BIC R0,R0,#0b10000000
      STR R0,[R1]
      
      ORR R0,R0,#0b10000000
      STR R0,[R1]
      
      BIC R0,R0,#0b10000000
      STR R0,[R1]

END   LDMFD SP!,{R0}
      MOV PC,LR



