/*
* PRINCE_T_V1.asm
*
* Created: 4/10/2014 17:37:50
* Author: Cong
*/

; This program is a free software: you can redistribute it
; and/or modify it under the terms of the GNU General Public
; License as published by the Free Software Foundation.
;
; It is distributed without any warranty of correctness nor
; fintess for any particular purpose. See the GNU General
; Public License for more details.
;
; <http://www.gnu.org/licenses/>.
;
; Description: T-Table PRINCE assembly code.
; Version 1 – November 2013.

;
;

#define cnt0 R16
#define iTmp0 R17
#define iTmp1 R18
#define iTmp2 R19
#define iTmp3 R20
#define iTmp4 R21
#define iTmp5 R28

jmp START

/*********************************************************************************************/
/*
* Table section
*/
.org 256
TBox1:
.db $3B, $7B, $33, $22, $2A, $48, $19, $11, $62, $73, $08, $00, $6A, $51, $59, $40
.db $9A, $DE, $12, $02, $8A, $CC, $98, $10, $46, $56, $88, $00, $CE, $54, $DC, $44
.db $B9, $BD, $31, $20, $A8, $8C, $99, $11, $24, $35, $88, $00, $AC, $15, $9D, $04
.db $A3, $E7, $23, $22, $A2, $C4, $81, $01, $66, $67, $80, $00, $E6, $45, $C5, $44
.db $9A, $DE, $12, $02, $8A, $CC, $98, $10, $46, $56, $88, $00, $CE, $54, $DC, $44
.db $3B, $7B, $33, $22, $2A, $48, $19, $11, $62, $73, $08, $00, $6A, $51, $59, $40
.db $A3, $E7, $23, $22, $A2, $C4, $81, $01, $66, $67, $80, $00, $E6, $45, $C5, $44
.db $B9, $BD, $31, $20, $A8, $8C, $99, $11, $24, $35, $88, $00, $AC, $15, $9D, $04
TBox2:
.db $3B, $73, $33, $22, $7B, $59, $08, $19, $2A, $62, $40, $00, $51, $6A, $48, $11
.db $9A, $56, $12, $02, $DE, $DC, $88, $98, $8A, $46, $44, $00, $54, $CE, $CC, $10
.db $B9, $35, $31, $20, $BD, $9D, $88, $99, $A8, $24, $04, $00, $15, $AC, $8C, $11
.db $A3, $67, $23, $22, $E7, $C5, $80, $81, $A2, $66, $44, $00, $45, $E6, $C4, $01
.db $9A, $56, $12, $02, $DE, $DC, $88, $98, $8A, $46, $44, $00, $54, $CE, $CC, $10
.db $3B, $73, $33, $22, $7B, $59, $08, $19, $2A, $62, $40, $00, $51, $6A, $48, $11
.db $A3, $67, $23, $22, $E7, $C5, $80, $81, $A2, $66, $44, $00, $45, $E6, $C4, $01
.db $B9, $35, $31, $20, $BD, $9D, $88, $99, $A8, $24, $04, $00, $15, $AC, $8C, $11
RC:
.db $01, $03, $01, $09, $08, $0A, $02, $0E, $00, $03, $07, $00, $07, $03, $04, $04
.db $0A, $04, $00, $09, $03, $08, $02, $02, $02, $09, $09, $0F, $03, $01, $0D, $00
.db $00, $08, $02, $0E, $0F, $0A, $09, $08, $0E, $0C, $04, $0E, $06, $0C, $08, $09
.db $04, $05, $02, $08, $02, $01, $0E, $06, $03, $08, $0D, $00, $01, $03, $07, $07
.db $0B, $0E, $05, $04, $06, $06, $0C, $0F, $03, $04, $0E, $09, $00, $0C, $06, $0C
.db $07, $0E, $0F, $08, $04, $0F, $07, $08, $0F, $0D, $09, $05, $05, $0C, $0B, $01
.db $08, $05, $08, $04, $00, $08, $05, $01, $0F, $01, $0A, $0C, $04, $03, $0A, $0A
.db $0C, $08, $08, $02, $0D, $03, $02, $0F, $02, $05, $03, $02, $03, $0C, $05, $04
.db $06, $04, $0A, $05, $01, $01, $09, $05, $0E, $00, $0E, $03, $06, $01, $00, $0D
.db $0D, $03, $0B, $05, $0A, $03, $09, $09, $0C, $0A, $00, $0C, $02, $03, $09, $09
.db $0C, $00, $0A, $0C, $02, $09, $0B, $07, $0C, $09, $07, $0C, $05, $00, $0D, $0D
SBox:
.db $0B, $07, $03, $02, $0F, $0D, $08, $09, $0A, $06, $04, $00, $05, $0E, $0C, $01
key:
.db $FE, $DC, $BA, $98, $76, $54, $32, $10, $83, $77, $AB, $69, $5D, $EE, $FC, $01

.org 2000
/*********************************************************************************************/
START:
/*********************************************************************************************/
/*
* Read the key from flash to RAM
*/
;read key
ldi ZH, high(key<<1)
ldi ZL, low(key<<1)
lpm R0, Z+
lpm R1, Z+
lpm R2, Z+
lpm R3, Z+
lpm R4, Z+
lpm R5, Z+
lpm R6, Z+
lpm R7, Z+
lpm R8, Z+
lpm R9, Z+
lpm R10, Z+
lpm R11, Z+
lpm R12, Z+
lpm R13, Z+
lpm R14, Z+
lpm R15, Z

;pointer to SRAM
ldi ZH, $20
ldi ZL, $00 //

;write plaintext
ldi R16,$00
ldi R17,$00
st Z+,R16
st Z+,R17
ldi R16,$00
ldi R17,$00
st Z+,R16
st Z+,R17
ldi R16,$00
ldi R17,$00
st Z+,R16
st Z+,R17
ldi R16,$00
ldi R17,$00
st Z+,R16
st Z+,R17
;set address of key
mov R22, ZL
mov R23, ZH
;set address of plaintext
ldi R25, $20
ldi R24, $00
;write key
st Z+, R0
st Z+, R1
st Z+, R2
st Z+, R3
st Z+, R4
st Z+, R5
st Z+, R6
st Z+, R7
st Z+, R8
st Z+, R9
st Z+, R10
st Z+, R11
st Z+, R12
st Z+, R13
st Z+, R14
st Z+, R15
prince_encrypt:
rcall KeySchedule
/*********************************************************************************************/
/*
* Main function
*/
//Read Plaintext as input
mov ZH, R25
mov ZL, R24
ld R0, Z+
ld R1, Z+
ld R2, Z+
ld R3, Z+
ld R4, Z+
ld R5, Z+
ld R6, Z+
ld R7, Z+
ld R8, Z+
ld R9, Z+
ld R10, Z+
ld R11, Z+
ld R12, Z+
ld R13, Z+
ld R14, Z+
ld R15, Z+
//First key addition
ldi ZH, $5D
ldi ZL, $10
rcall KeyXOR
rcall ShiftKey_1

clr cnt0
ldi iTmp5, $20
// First five rounds
Loop1:
ldi ZH, high(TBox1<<1)
ldi ZL, low(TBox1<<1)
rcall T_Lookup
CPI cnt0, $05
BREQ Loop2
ldi ZH, $5D
mov ZL, iTmp5
rcall KeyXOR
mov iTmp5, ZL
inc cnt0
rjmp Loop1
//Last five rounds
Loop2:
rcall ShiftKey_1
rcall ShiftKey_1
ldi ZH, high(TBox2<<1)
ldi ZL, low(TBox2<<1)
rcall T_Lookup
ldi ZH, $5D
mov ZL, iTmp5
rcall KeyXOR
mov iTmp5, ZL
CPI cnt0, $09
BREQ end
inc cnt0
rjmp Loop2
end:
rcall SBox_lookup
ldi ZH, $5D
mov ZL, iTmp5
rcall KeyXOR
mov ZH, R25
mov ZL, R24
rcall StoreData
rjmp over
over:
ret

/*********************************************************************************************/
/*
*KeyScedule works on the key_0, key_1 and RCs to generate all the subkeys used in Cipher.
*1)Load k1, extend it from 8 bytes to 16 bytes. Store the new k1. Then load k0 and extend it. Load new k1 to xor
the new k0. Store the result.
*2)Load extended RCi (i:1-11) and the new k1, then XOR them; Reverse shift the result. Store the result.
*3)For the last 6 subkeys, do the mix column after the reverse shift.
*/
KeySchedule:
//Load K1
mov ZH,R23
mov ZL,R22
ldi iTmp0, $08
add ZL, iTmp0
ld R0, Z+
ld R1, Z+
ld R2, Z+
ld R3, Z+
ld R4, Z+
ld R5, Z+
ld R6, Z+
ld R7, Z+
//Extend
rcall DataExtend
//Store K1
ldi ZH, $5D
ldi ZL, $00
rcall StoreData
//Load K0
mov ZH, R23
mov ZL, R22
ld R0, Z+
ld R1, Z+
ld R2, Z+
ld R3, Z+
ld R4, Z+
ld R5, Z+
ld R6, Z+
ld R7, Z+
//Extend
rcall DataExtend
//Load extended K1 and xor K1
ldi ZH, $5D
ldi ZL, $00
rcall KeyXOR
ldi ZH, $5D
ldi ZL, $10
rcall StoreData
//Load RC and xor k1
clr cnt0
keyloop:
ldi ZH, high(RC<<1)
rcall lpmRC
ldi ZH, $5D
ldi ZL, $00
rcall KeyXOR
rcall ShiftKey_1
CPI cnt0, $05
BRLT keycontinue1
rcall MixKeys
keycontinue1:
ldi ZH, $5D
ldi iTmp3,$20
add iTmp5, iTmp3
mov ZL, iTmp5
rcall StoreData
CPI cnt0,$09
BREQ keycontinue2
inc cnt0
rjmp keyloop

keycontinue2:
//Load K0
mov ZH, R23
mov ZL, R22
rcall Key0_Expansion
rcall DataExtend
ldi ZH, $5D
ldi ZL, $00
rcall KeyXOR
ldi ZH, $5D
ldi ZL, $00
rcall StoreData
inc cnt0
ldi ZH, high(RC<<1)
rcall lpmRC
ldi ZH, $5D
ldi ZL, $00
rcall KeyXOR
ldi ZH, $5D
ldi iTmp3,$20
add iTmp5, iTmp3
mov ZL, iTmp5
rcall StoreData
ret
/*********************************************************************************************/
/*
* Key0_Expansion:Rotate key0 to generate final whitening key key0′
*/
Key0_Expansion:
ld R0, Z+ // move key to R0:R7
ld R1, Z+
ld R2, Z+
ld R3, Z+
ld R4, Z+
ld R5, Z+
ld R6, Z+
ld R7, Z+

mov iTmp0, R0
mov iTmp1, R7
ror iTmp1
ror R0
ror R1
ror R2
ror R3
ror R4
ror R5
ror R6
ror R7

rol iTmp0
brcc ok
ldi iTmp1, $01
eor R7, iTmp1

ok:
ret
/*********************************************************************************************/
/*
*Extend the data from 8 bytes to 16 bytes.
*/
DataExtend:

ldi iTmp0, $0F
ldi iTmp1, $F0
mov R15, R7
mov R14, R7
and R15, iTmp0
and R14, iTmp1
swap R14

mov R13, R6
mov R12, R6
and R13, iTmp0
and R12, iTmp1
swap R12

mov R11, R5
mov R10, R5
and R11, iTmp0
and R10, iTmp1
swap R10

mov R9, R4
mov R8, R4
and R9, iTmp0
and R8, iTmp1
swap R8

mov R7, R3
mov R6, R3
and R7, iTmp0
and R6, iTmp1
swap R6

mov R5, R2
mov R4, R2
and R5, iTmp0
and R4, iTmp1
swap R4

mov R3, R1
mov R2, R1
and R3, iTmp0
and R2, iTmp1
swap R2

mov R1, R0
and R1, iTmp0
and R0, iTmp1
swap R0

ret
/*********************************************************************************************/
/*
*Reverse shift rows on subkeys
*/
ShiftKey_1:
mov iTmp0, R5
mov R5, R1
mov R1, R13
mov R13, R9
mov R9, iTmp0
mov iTmp0, R10
mov R10, R2
mov R2, iTmp0
mov iTmp0, R15
mov R15, R3
mov R3, R7
mov R7, R11
mov R11, iTmp0
mov iTmp0, R14
mov R14, R6
mov R6, iTmp0
ret
/*********************************************************************************************/
/*
*MixColumn on roundkeys
*/
MixKeys:
//Mix subkey0 to subkey3
ldi iTmp0, $07
and iTmp0, R0
ldi iTmp4, $0B
and iTmp4, R1
eor iTmp0, iTmp4
ldi iTmp4, $0D
and iTmp4, R2
eor iTmp0, iTmp4
ldi iTmp4, $0E
and iTmp4, R3
eor iTmp0, iTmp4

ldi iTmp1, $07
and iTmp1, R3
ldi iTmp4, $0B
and iTmp4, R0
eor iTmp1, iTmp4
ldi iTmp4, $0D
and iTmp4, R1
eor iTmp1, iTmp4
ldi iTmp4, $0E
and iTmp4, R2
eor iTmp1, iTmp4

ldi iTmp2, $07
and iTmp2, R2
ldi iTmp4, $0B
and iTmp4, R3
eor iTmp2, iTmp4
ldi iTmp4, $0D
and iTmp4, R0
eor iTmp2, iTmp4
ldi iTmp4, $0E
and iTmp4, R1
eor iTmp2, iTmp4

ldi iTmp3, $07
and iTmp3, R1
ldi iTmp4, $0B
and iTmp4, R2
eor iTmp3, iTmp4
ldi iTmp4, $0D
and iTmp4, R3
eor iTmp3, iTmp4
ldi iTmp4, $0E
and iTmp4, R0
eor iTmp3, iTmp4

mov R0, iTmp0
mov R1, iTmp1
mov R2, iTmp2
mov R3, iTmp3
//Mix subkey4 to subkey7
ldi iTmp0, $07
and iTmp0, R7
ldi iTmp4, $0B
and iTmp4, R4
eor iTmp0, iTmp4
ldi iTmp4, $0D
and iTmp4, R5
eor iTmp0, iTmp4
ldi iTmp4, $0E
and iTmp4, R6
eor iTmp0, iTmp4

ldi iTmp1, $07
and iTmp1, R6
ldi iTmp4, $0B
and iTmp4, R7
eor iTmp1, iTmp4
ldi iTmp4, $0D
and iTmp4, R4
eor iTmp1, iTmp4
ldi iTmp4, $0E
and iTmp4, R5
eor iTmp1, iTmp4

ldi iTmp2, $07
and iTmp2, R5
ldi iTmp4, $0B
and iTmp4, R6
eor iTmp2, iTmp4
ldi iTmp4, $0D
and iTmp4, R7
eor iTmp2, iTmp4
ldi iTmp4, $0E
and iTmp4, R4
eor iTmp2, iTmp4

ldi iTmp3, $07
and iTmp3, R4
ldi iTmp4, $0B
and iTmp4, R5
eor iTmp3, iTmp4
ldi iTmp4, $0D
and iTmp4, R6
eor iTmp3, iTmp4
ldi iTmp4, $0E
and iTmp4, R7
eor iTmp3, iTmp4

mov R4, iTmp0
mov R5, iTmp1
mov R6, iTmp2
mov R7, iTmp3
//Mix subkey8 to subkey11
ldi iTmp0, $07
and iTmp0, R11
ldi iTmp4, $0B
and iTmp4, R8
eor iTmp0, iTmp4
ldi iTmp4, $0D
and iTmp4, R9
eor iTmp0, iTmp4
ldi iTmp4, $0E
and iTmp4, R10
eor iTmp0, iTmp4

ldi iTmp1, $07
and iTmp1, R10
ldi iTmp4, $0B
and iTmp4, R11
eor iTmp1, iTmp4
ldi iTmp4, $0D
and iTmp4, R8
eor iTmp1, iTmp4
ldi iTmp4, $0E
and iTmp4, R9
eor iTmp1, iTmp4

ldi iTmp2, $07
and iTmp2, R9
ldi iTmp4, $0B
and iTmp4, R10
eor iTmp2, iTmp4
ldi iTmp4, $0D
and iTmp4, R11
eor iTmp2, iTmp4
ldi iTmp4, $0E
and iTmp4, R8
eor iTmp2, iTmp4

ldi iTmp3, $07
and iTmp3, R8
ldi iTmp4, $0B
and iTmp4, R9
eor iTmp3, iTmp4
ldi iTmp4, $0D
and iTmp4, R10
eor iTmp3, iTmp4
ldi iTmp4, $0E
and iTmp4, R11
eor iTmp3, iTmp4

mov R8, iTmp0
mov R9, iTmp1
mov R10, iTmp2
mov R11, iTmp3
//Mix subkey12 to subkey15
ldi iTmp0, $07
and iTmp0, R12
ldi iTmp4, $0B
and iTmp4, R13
eor iTmp0, iTmp4
ldi iTmp4, $0D
and iTmp4, R14
eor iTmp0, iTmp4
ldi iTmp4, $0E
and iTmp4, R15
eor iTmp0, iTmp4

ldi iTmp1, $07
and iTmp1, R15
ldi iTmp4, $0B
and iTmp4, R12
eor iTmp1, iTmp4
ldi iTmp4, $0D
and iTmp4, R13
eor iTmp1, iTmp4
ldi iTmp4, $0E
and iTmp4, R14
eor iTmp1, iTmp4

ldi iTmp2, $07
and iTmp2, R14
ldi iTmp4, $0B
and iTmp4, R15
eor iTmp2, iTmp4
ldi iTmp4, $0D
and iTmp4, R12
eor iTmp2, iTmp4
ldi iTmp4, $0E
and iTmp4, R13
eor iTmp2, iTmp4

ldi iTmp3, $07
and iTmp3, R13
ldi iTmp4, $0B
and iTmp4, R14
eor iTmp3, iTmp4
ldi iTmp4, $0D
and iTmp4, R15
eor iTmp3, iTmp4
ldi iTmp4, $0E
and iTmp4, R12
eor iTmp3, iTmp4

mov R12, iTmp0
mov R13, iTmp1
mov R14, iTmp2
mov R15, iTmp3
ret
/*********************************************************************************************/
/*
*Store the 16 bytes data
*/
StoreData:
st Z+, R0
st Z+, R1
st Z+, R2
st Z+, R3
st Z+, R4
st Z+, R5
st Z+, R6
st Z+, R7
st Z+, R8
st Z+, R9
st Z+, R10
st Z+, R11
st Z+, R12
st Z+, R13
st Z+, R14
st Z+, R15
ret
/*********************************************************************************************/
/*
*XOR keys
*/
KeyXOR:
ld iTmp0, Z+
eor R0, iTmp0
ld iTmp0, Z+
eor R1, iTmp0
ld iTmp0, Z+
eor R2, iTmp0
ld iTmp0, Z+
eor R3, iTmp0
ld iTmp0, Z+
eor R4, iTmp0
ld iTmp0, Z+
eor R5, iTmp0
ld iTmp0, Z+
eor R6, iTmp0
ld iTmp0, Z+
eor R7, iTmp0
ld iTmp0, Z+
eor R8, iTmp0
ld iTmp0, Z+
eor R9, iTmp0
ld iTmp0, Z+
eor R10, iTmp0
ld iTmp0, Z+
eor R11, iTmp0
ld iTmp0, Z+
eor R12, iTmp0
ld iTmp0, Z+
eor R13, iTmp0
ld iTmp0, Z+
eor R14, iTmp0
ld iTmp0, Z+
eor R15, iTmp0
ret
/*********************************************************************************************/
/*
*LD RC
*/
lpmRC:
mov iTmp2, cnt0
ldi iTmp5, $00
ldi iTmp3, $10
clr iTmp1
again:
cp iTmp1, iTmp2
breq fine
add iTmp5, iTmp3
dec iTmp2
jmp again

fine:
mov ZL, iTmp5
lpm R0, Z+
lpm R1, Z+
lpm R2, Z+
lpm R3, Z+
lpm R4, Z+
lpm R5, Z+
lpm R6, Z+
lpm R7, Z+
lpm R8, Z+
lpm R9, Z+
lpm R10, Z+
lpm R11, Z+
lpm R12, Z+
lpm R13, Z+
lpm R14, Z+
lpm R15, Z+
ret
/*********************************************************************************************/
/*
*T_Table look up
*/
T_Lookup:

//First column
mov iTmp3, ZL
mov ZL, R0
add ZL, iTmp3
lpm iTmp1, Z
ldi iTmp0, $10
add ZL, iTmp0
lpm iTmp2, Z

mov ZL, R5
add ZL, iTmp3
ldi iTmp0, $20
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp1, iTmp0
ldi iTmp0, $10
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp2, iTmp0

mov ZL, R10
add ZL, iTmp3
ldi iTmp0, $40
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp1, iTmp0
ldi iTmp0, $10
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp2, iTmp0

mov ZL, R15
add ZL, iTmp3
ldi iTmp0, $60
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp1, iTmp0
ldi iTmp0, $10
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp2, iTmp0
mov R0, iTmp1
mov R5, iTmp2
//Second column
mov ZL, R3
add ZL, iTmp3
lpm iTmp1, Z
ldi iTmp0, $10
add ZL, iTmp0
lpm iTmp2, Z

mov ZL, R4
add ZL, iTmp3
ldi iTmp0, $20
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp1, iTmp0
ldi iTmp0, $10
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp2, iTmp0

mov ZL, R9
add ZL, iTmp3
ldi iTmp0, $40
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp1, iTmp0
ldi iTmp0, $10
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp2, iTmp0

mov ZL, R14
add ZL, iTmp3
ldi iTmp0, $60
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp1, iTmp0
ldi iTmp0, $10
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp2, iTmp0
mov R3, iTmp1
mov R4, iTmp2
//Third column
mov ZL, R7
add ZL, iTmp3
lpm iTmp1, Z
ldi iTmp0, $10
add ZL, iTmp0
lpm iTmp2, Z

mov ZL, R8
add ZL, iTmp3
ldi iTmp0, $20
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp1, iTmp0
ldi iTmp0, $10
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp2, iTmp0

mov ZL, R13
add ZL, iTmp3
ldi iTmp0, $40
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp1, iTmp0
ldi iTmp0, $10
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp2, iTmp0

mov ZL, R2
add ZL, iTmp3
ldi iTmp0, $60
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp1, iTmp0
ldi iTmp0, $10
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp2, iTmp0
mov R2, iTmp1
mov R7, iTmp2
//4th column
mov ZL, R12
add ZL, iTmp3
lpm iTmp1, Z
ldi iTmp0, $10
add ZL, iTmp0
lpm iTmp2, Z

mov ZL, R1
add ZL, iTmp3
ldi iTmp0, $20
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp1, iTmp0
ldi iTmp0, $10
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp2, iTmp0

mov ZL, R6
add ZL, iTmp3
ldi iTmp0, $40
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp1, iTmp0
ldi iTmp0, $10
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp2, iTmp0

mov ZL, R11
add ZL, iTmp3
ldi iTmp0, $60
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp1, iTmp0
ldi iTmp0, $10
add ZL, iTmp0
lpm iTmp0, Z
eor iTmp2, iTmp0
mov R1, iTmp1
mov R6, iTmp2
//Ordering
mov iTmp0, R1
mov R1, R5
mov R5, R7
mov R7, R6
mov R6, iTmp0
mov iTmp0, R2
mov R2, R3
mov R3, R4
mov R4, iTmp0
rcall DataExtend
ret
/*********************************************************************************************/
/*
*Final SBOX look up
*/
SBox_lookup:
ldi ZH, high(SBox<<1)
ldi iTmp3, low(SBox<<1)
mov ZL, R0
add ZL, iTmp3
lpm R0, Z
mov ZL, R1
add ZL, iTmp3
lpm R1, Z
mov ZL, R2
add ZL, iTmp3
lpm R2, Z
mov ZL, R3
add ZL, iTmp3
lpm R3, Z
mov ZL, R4
add ZL, iTmp3
lpm R4, Z
mov ZL, R5
add ZL, iTmp3
lpm R5, Z
mov ZL, R6
add ZL, iTmp3
lpm R6, Z
mov ZL, R7
add ZL, iTmp3
lpm R7, Z
mov ZL, R8
add ZL, iTmp3
lpm R8, Z
mov ZL, R9
add ZL, iTmp3
lpm R9, Z
mov ZL, R10
add ZL, iTmp3
lpm R10, Z
mov ZL, R11
add ZL, iTmp3
lpm R11, Z
mov ZL, R12
add ZL, iTmp3
lpm R12, Z
mov ZL, R13
add ZL, iTmp3
lpm R13, Z
mov ZL, R14
add ZL, iTmp3
lpm R14, Z
mov ZL, R15
add ZL, iTmp3
lpm R15, Z
ret
