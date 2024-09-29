        lui s1,%hi(0xFFFF0F00)          ; adresa od GPIO-0
        addi s1,s1,%lo(0xFFFF0F00)      ;

        ;inicijalzaicja smjera GPIO-0:
            ; smjer za lcd na portu B je po defoultu dobro nariktan

        lui s2,%hi(0xFFFF0B00)          ; adresa od GPIO-1
        addi s2,s2,%lo(0xFFFF0B00)      ;

        ;inicijalzaicja smjera GPIO-1:
        ; smjer za portA za tipkalo i prekidac su takoder dobro po defultu odredeni, ali je potrebno postavit smjerove ledica
        addi s4,x0,0b11100000
        sw s4,8(s2)

        lui sp,%hi(0x10000)          ; inicijalizacija stack pointera
        addi sp,sp,%lo(0x10000)      ;

        ;inicijalzacija drugih varijabli:
        addi s3,x0,0    ; inicijalizacija BROJACA
        addi s4,x0,0    ; inicijalizacija ZASTAVICE
        addi t0,x0,3    ; u t0 spremam broj 3
        addi t1,x0,1    ; u t1 spremam broj 1
        addi t2,x0,16    ; u t2 spremam broj 16
        addi t3,x0,10    ; u t3 spremam broj 10
        addi t5,x0,0x30    ; u t5 spremam broj 0x30 tj 48, sto je asscii kod od "0"

; glavni dio programa:
petlja  lw s5,0(s2)      ; u s5 spremam vrijednost PA_GPIO-1
        andi s5,s5,0b0000011    ; u s5 mi izoliraj samo vrijednosti od tipkala i prkeidaca
        beq s5,t0,pot_dupli
        addi s4,x0,0    ; ako nisu oba dvoje pritisnuti, postavi zastavicu na 0
        jal x0,petlja   ; i takoder vrti peltju dok se oba dva gumba ne stisnu u isto vrijeme    

br_reset        addi s3,x0,0    ; brojac resetiram na 0
                beq s3,x0,vrati        


pot_dupli       beq s4,t1,petlja        ; ukoliko je zastavica vec jednom setirana onda se samo vrati na petlju
                ; inace:
                addi s4,x0,1            ; zastavicu postavljam na 1
                addi s3,s3,1            ; brojac povecavam za 1
                beq s3,t2,br_reset      ; ako je brojac postao 16, vrati ga na 0
vrati           add x13,x0,s3           ; u x13 spremam vrijendost brojaca za poziv podprograma obradi
                jal ra,obradi           ; podprogrma u x10 vraca asci vrijednost desetice i u x11 vracam asci vrijendost broja jednica
                jal ra,lcd              ; podprogrma za ipis znamenke destice i jedinice na lcdu
                jal x0,petlja           ; nastavi sa izvrsavanjem petlje




obradi  addi sp,sp,-4    ; smanjujem adresu od stack pointera i na tu novu adresu spremam retrun adress ra
        sw ra,0(sp)      ;

        jal ra,div10  ; skacem u podprogram za podijeliti s 10, vrijednost brojaca s euzima iz x13, a podprogram u x10 vraca broj desetica a u x11 vraca broj jedinica

        ; uvecavamo vrijendosti registra desetic ai jednica za 0x30 kako bi dobili njihove assci vriejdnosti i vracao se u glavni podprogram
        addi x10,x10,0x30
        addi x11,x11,0x30

        lw ra,0(sp)     ; ucitaj mi tsaru vrijednost ra iz stacka 
        addi sp,sp,4    ; ocisti mi stog

        jalr x0,0(ra)   ; vracam se nazad u glavni program



div10   addi x10,x0,0            ; broj desetica x10 postavljam na 0
        add x11,x0,x13          ; postavljam broj jedinica na x13 i onda kada se podprogram provede do kraja ono sto ostane ce biti broj jedinica
l1      bge x11,t3,l2           ; ako je broj veci od 10
        jalr x0,0(ra)           ; kada s eprogram izvrsi vrati se u podporgram obradi

l2      addi x11,x11,-10        ; oduzmi mu 10 i povecaj broj desetica za 1, vrait se nazad u l1
        addi x10,x10,1          ; 
        jal x0,l1               ;

       


lcd     addi sp,sp,-4           ; smanjujem adresu od stack pointera i na tu novu adresu spremam retrun adress ra
        sw ra,0(sp)             ;

        addi s7,x0,0x0D         ; u s7 spremam vrijendosit koje cu ispisivati na lcd; najprije upisujem znak za carriage clean
        jal ra,lcdwr            ; ipisi mi sadrzaj s7 na lcd

        beq x10,t5,jedinice
        add s7,x0,x10           ; u s7 spremi vrijendost assci znaka od broja desetica ako je on razlicit o 0
        jal ra,lcdwr            ; ipisi mi sadrzaj s7 na lcd
        
jedinice add s7,x0,x11          ; u s7 spremi vrijendost assci znaka jedinica
         jal ra,lcdwr           ; ipisi mi sadrzaj s7 na lcd

        addi s7,x0,0x0A         ; u s7 spremam feed line charachter fd
        jal ra,lcdwr            ; ipisi mi sadrzaj s7 na lcd
 
        lw ra, 0(sp)            ; obnovi mi vrijndost ra iz konteksta sa stoga
        addi sp,sp,4            ; obrisi podatke sa stoga
        jalr x0,0(ra)           ; povratak u glavni program




lcdwr   andi t4,s7,0x7F         ; micem zandji bit i spremam vriejdnost s7 u t4
        sw t4,4(s1)             ; spremam t4 na adresu od PB_GPIO0
        ori t4,s7,0x80          ; dizem brid
        sw t4,4(s1)             ; opet spremam ovaj put s podignutim birdom
        andi t4,s7,0x7F         ; ponavljam opet i spustam brid
        sw t4,4(s1)             ; 

        jalr x0,0(ra)           ; vracam se u glavni podprogram




