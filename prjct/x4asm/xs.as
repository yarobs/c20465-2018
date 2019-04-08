;file ps.as

;################################################################################;###

   .entry LENGTH
   .entry STR2
   .extern W
MAIN:    mov r3, LENGTH ;sdfsd comment my comment as many comments as you wish
LOOP:    jmp L1(#-1,r6)
         prn #-5
         bne W(r4 ,r5)
         sub r1, r4
         bne L3
L1:      inc K
.entry LOOP
         bne LOOP(K,W)
         mov #-5,  r6
         lea STR2, r3
         mov r3, r2
         cmp r2, #5
         bne END
         bne L1(STR3,r5)

																												                   

																																   
				;hgfhgfhgfhgfhgfhgfhgfhgfhgfh												   

; jhkkjhkj kjhkjhkjh kjh kjh
; jhkkjhkj kjhkjhkjh kjh kjh
END:     stop ; hjghg
LENGTH: .data 6,-9,15,-1
K:      .data 22,-1
X:      .data -56,19,45,78
STR2:   .string "Hello world!"
STR3:   .string "error"
;LABEL_NO_COLON:
.extern L3
;.extern Bname name
;.extern MYLONLONGLONGLONGLONGLONGLONGLABEL
