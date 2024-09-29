      MOV   R13, #0x10000
        
      MOV   R5, #OPRND
      LDR   R3, [R5]
      LDR   R4, [R5,#4]

      STMFD R13!, {R3,R4}
      BL    FUNC
      STR   R0, REZ

      SWI   0x123456


FUNC  STMFD R13!, {R1, R2}
      LDR   R1, [SP, #8]
      LDR   R2, [SP, #12]
      ADD   R0, R1, R2
      LDMFD R13!, {R1, R2}
      MOV   PC, LR

OPRND DW    15, 3
REZ   DW    0
