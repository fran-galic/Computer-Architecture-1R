        LDRB R0, pod_1   ;ucitavam 1. podatak iz memorije
        LDRB R1, pod_2   ;ucitavam podatak 2 iz memorije

        ADD R2, R0, R1

        STRB R2, rez
        SWI 123456

        ORG 0x14  ; pseudonaredbe ne zauzimaju prsotro u memoriji, a svaka druga anredba zauzima po 4 byta u memoriji
pod_1   DB 15 
pod_2   DB -3
rez     DS 1
