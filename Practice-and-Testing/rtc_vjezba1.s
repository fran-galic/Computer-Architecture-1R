INIT    LDR R0,RTC      ; U R0 SE NALAZI ADRESA OD RTC-A
        MOV R1,#0       ; U R1 POSTVALJAM VRIJENDOST 0
        STR R1,[R0,#12] ; U LOAD REGISTER LR UPSIJUEM VRIJENDOT 0
        STR R1,[R0,#16] ; U CONTROL REGISTER CR SAM TAKODR UPISAO 0, ZA OVAJ PRIMJE RZADATKA CMEO RADITI BEZ PRKEIDA
        MOV R1,#20
        STR R1,[R0,#4]

WAIT    LDR R1,[R0,#8]
        TST R1,#1       ; TESTIRAJ MI NA JEDINICU, VIDI DALI JE SADRZAJ U R1 JEDNAK 1 ILI 0
        BEQ WAIT

        MOV R1,#0
        STR R1,[R0,#8]  ; OCISTIO SAM STATUSNI REGISTAR OD RTC-A
        STR R1,[R0,#12]   ;  U LOAD REGISTER LR SMA OPET UPISAO 0
        
        LDR R1,BOXES
        ADD R1,R1,#1
        STR R1,BOXES

        B WAIT

RTC DW 0xFFFF0E00
BOXES DW 0
