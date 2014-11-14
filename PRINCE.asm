/*
* PRINCE.asm
*
* Created: 1/23/2014 12:30:06 PM
* Author: Aria Shahverdi
*/

;
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
; Description: PRINCE encryption/decryption.
; Version 1 – November 2013.

; Input values: // STAY UNCHANGED!!!
; Pointer on Data : R26:R27
; Pointer on Key : R26:R27 + 8 !!!
; Pointer on RCs : ZH:ZL + Round!!!

; Memory Management: MSB:LSB always!
; 8 data bytes: R8:R15 (DATA = 64 bit)
; 8 key bytes: R0:R7 (KEY = 64 bit)

; 8 tmp byte : R17 ~ R24
; 1 cnt0 : R16

; Z (ZH) points on sbox/invSbox and data/key

;
; User Interface:
;
; —————————————————-
; | User interface: |
; |—————————————————-|
; | ENCRYPTION: |
; |(1) Load plaintext/key in SRAM at the address |
; | pointed by X register (r27:r26): |
; | -> The 8 first bytes are the plaintext, |
; | -> The 16 last bytes are the key. (K0:K1) |
; |(2) Call the encrypt routine >>encrypt<< |
; | After the call, the plaintext is overloaded |
; | by its corresponding ciphertext in SRAM, the |
; | key is untouched. |
; |—————————————————-|
; | DECRYPTION: |
; |(1) Load ciphertext/key in SRAM at the address |
; | pointed by X register (r27:r26): |
; | -> The 8 first bytes are the ciphertext, |
; | -> The 8 last bytes are the key. |
; |(2) Call the encrypt routine >>decrypt<< |
; | After the call, the ciphertext is overloaded |
; | by its corresponding plaintext in SRAM, the |
; | key is untouched. |
; |—————————————————-|
; |Enjoy |
; |—————————————————-|
;
rjmp START

.org 256

sbox:
.db 0xBB, 0xBF, 0xB3, 0xB2, 0xBA, 0xBC, 0xB9, 0xB1, 0xB6, 0xB7, 0xB8, 0xB0, 0xBE, 0xB5, 0xBD, 0xB4
.db 0xFB, 0xFF, 0xF3, 0xF2, 0xFA, 0xFC, 0xF9, 0xF1, 0xF6, 0xF7, 0xF8, 0xF0, 0xFE, 0xF5, 0xFD, 0xF4
.db 0x3B, 0x3F, 0x33, 0x32, 0x3A, 0x3C, 0x39, 0x31, 0x36, 0x37, 0x38, 0x30, 0x3E, 0x35, 0x3D, 0x34
.db 0x2B, 0x2F, 0x23, 0x22, 0x2A, 0x2C, 0x29, 0x21, 0x26, 0x27, 0x28, 0x20, 0x2E, 0x25, 0x2D, 0x24
.db 0xAB, 0xAF, 0xA3, 0xA2, 0xAA, 0xAC, 0xA9, 0xA1, 0xA6, 0xA7, 0xA8, 0xA0, 0xAE, 0xA5, 0xAD, 0xA4
.db 0xCB, 0xCF, 0xC3, 0xC2, 0xCA, 0xCC, 0xC9, 0xC1, 0xC6, 0xC7, 0xC8, 0xC0, 0xCE, 0xC5, 0xCD, 0xC4
.db 0x9B, 0x9F, 0x93, 0x92, 0x9A, 0x9C, 0x99, 0x91, 0x96, 0x97, 0x98, 0x90, 0x9E, 0x95, 0x9D, 0x94
.db 0x1B, 0x1F, 0x13, 0x12, 0x1A, 0x1C, 0x19, 0x11, 0x16, 0x17, 0x18, 0x10, 0x1E, 0x15, 0x1D, 0x14
.db 0x6B, 0x6F, 0x63, 0x62, 0x6A, 0x6C, 0x69, 0x61, 0x66, 0x67, 0x68, 0x60, 0x6E, 0x65, 0x6D, 0x64
.db 0x7B, 0x7F, 0x73, 0x72, 0x7A, 0x7C, 0x79, 0x71, 0x76, 0x77, 0x78, 0x70, 0x7E, 0x75, 0x7D, 0x74
.db 0x8B, 0x8F, 0x83, 0x82, 0x8A, 0x8C, 0x89, 0x81, 0x86, 0x87, 0x88, 0x80, 0x8E, 0x85, 0x8D, 0x84
.db 0x0B, 0x0F, 0x03, 0x02, 0x0A, 0x0C, 0x09, 0x01, 0x06, 0x07, 0x08, 0x00, 0x0E, 0x05, 0x0D, 0x04
.db 0xEB, 0xEF, 0xE3, 0xE2, 0xEA, 0xEC, 0xE9, 0xE1, 0xE6, 0xE7, 0xE8, 0xE0, 0xEE, 0xE5, 0xED, 0xE4
.db 0x5B, 0x5F, 0x53, 0x52, 0x5A, 0x5C, 0x59, 0x51, 0x56, 0x57, 0x58, 0x50, 0x5E, 0x55, 0x5D, 0x54
.db 0xDB, 0xDF, 0xD3, 0xD2, 0xDA, 0xDC, 0xD9, 0xD1, 0xD6, 0xD7, 0xD8, 0xD0, 0xDE, 0xD5, 0xDD, 0xD4
.db 0x4B, 0x4F, 0x43, 0x42, 0x4A, 0x4C, 0x49, 0x41, 0x46, 0x47, 0x48, 0x40, 0x4E, 0x45, 0x4D, 0x44

invsbox:
.db 0xBB, 0xB7, 0xB3, 0xB2, 0xBF, 0xBD, 0xB8, 0xB9, 0xBA, 0xB6, 0xB4, 0xB0, 0xB5, 0xBE, 0xBC, 0xB1
.db 0x7B, 0x77, 0x73, 0x72, 0x7F, 0x7D, 0x78, 0x79, 0x7A, 0x76, 0x74, 0x70, 0x75, 0x7E, 0x7C, 0x71
.db 0x3B, 0x37, 0x33, 0x32, 0x3F, 0x3D, 0x38, 0x39, 0x3A, 0x36, 0x34, 0x30, 0x35, 0x3E, 0x3C, 0x31
.db 0x2B, 0x27, 0x23, 0x22, 0x2F, 0x2D, 0x28, 0x29, 0x2A, 0x26, 0x24, 0x20, 0x25, 0x2E, 0x2C, 0x21
.db 0xFB, 0xF7, 0xF3, 0xF2, 0xFF, 0xFD, 0xF8, 0xF9, 0xFA, 0xF6, 0xF4, 0xF0, 0xF5, 0xFE, 0xFC, 0xF1
.db 0xDB, 0xD7, 0xD3, 0xD2, 0xDF, 0xDD, 0xD8, 0xD9, 0xDA, 0xD6, 0xD4, 0xD0, 0xD5, 0xDE, 0xDC, 0xD1
.db 0x8B, 0x87, 0x83, 0x82, 0x8F, 0x8D, 0x88, 0x89, 0x8A, 0x86, 0x84, 0x80, 0x85, 0x8E, 0x8C, 0x81
.db 0x9B, 0x97, 0x93, 0x92, 0x9F, 0x9D, 0x98, 0x99, 0x9A, 0x96, 0x94, 0x90, 0x95, 0x9E, 0x9C, 0x91
.db 0xAB, 0xA7, 0xA3, 0xA2, 0xAF, 0xAD, 0xA8, 0xA9, 0xAA, 0xA6, 0xA4, 0xA0, 0xA5, 0xAE, 0xAC, 0xA1
.db 0x6B, 0x67, 0x63, 0x62, 0x6F, 0x6D, 0x68, 0x69, 0x6A, 0x66, 0x64, 0x60, 0x65, 0x6E, 0x6C, 0x61
.db 0x4B, 0x47, 0x43, 0x42, 0x4F, 0x4D, 0x48, 0x49, 0x4A, 0x46, 0x44, 0x40, 0x45, 0x4E, 0x4C, 0x41
.db 0x0B, 0x07, 0x03, 0x02, 0x0F, 0x0D, 0x08, 0x09, 0x0A, 0x06, 0x04, 0x00, 0x05, 0x0E, 0x0C, 0x01
.db 0x5B, 0x57, 0x53, 0x52, 0x5F, 0x5D, 0x58, 0x59, 0x5A, 0x56, 0x54, 0x50, 0x55, 0x5E, 0x5C, 0x51
.db 0xEB, 0xE7, 0xE3, 0xE2, 0xEF, 0xED, 0xE8, 0xE9, 0xEA, 0xE6, 0xE4, 0xE0, 0xE5, 0xEE, 0xEC, 0xE1
.db 0xCB, 0xC7, 0xC3, 0xC2, 0xCF, 0xCD, 0xC8, 0xC9, 0xCA, 0xC6, 0xC4, 0xC0, 0xC5, 0xCE, 0xCC, 0xC1
.db 0x1B, 0x17, 0x13, 0x12, 0x1F, 0x1D, 0x18, 0x19, 0x1A, 0x16, 0x14, 0x10, 0x15, 0x1E, 0x1C, 0x11

RC: //reordered round constants
.db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 //RC0
.db 0x17, 0x33, 0x14, 0x94, 0x80, 0xA3, 0x27, 0xE0 //RC1
.db 0xA3, 0x41, 0x0D, 0x90, 0x32, 0x89, 0x29, 0x2F //RC2
.db 0x06, 0x8C, 0x28, 0xE9, 0xFE, 0xAC, 0x94, 0x8E //RC3
.db 0x41, 0x53, 0x27, 0x87, 0x23, 0x18, 0xED, 0x60 //RC4
.db 0xB0, 0xEC, 0x56, 0x4C, 0x63, 0x64, 0xCE, 0xF9 //RC5
.db 0x75, 0xEC, 0xFB, 0x81, 0x4F, 0xFD, 0x79, 0x85 //RC6
.db 0x84, 0x53, 0x8A, 0x4A, 0x0F, 0x81, 0x5A, 0x1C //RC7
.db 0xC3, 0x8C, 0x85, 0x24, 0xD2, 0x35, 0x23, 0xF2 //RC8
.db 0x66, 0x41, 0xA0, 0x5D, 0x1E, 0x10, 0x9E, 0x53 //RC9
.db 0xD2, 0x33, 0xB9, 0x59, 0xAC, 0x3A, 0x90, 0x9C //RC10
.db 0xC5, 0x00, 0xAD, 0xCD, 0x2C, 0x99, 0xB7, 0x7C //RC11

 

START:
rjmp prince_encrypt
;
; Constants
;
;.EQU PTEXT_NUM_BYTE = 8
;.EQU CTEXT_NUM_BYTE = 8
;.EQU KEY_NUM_BYTE = 8
;.EQU ADD_MEM_NUM_BYTE = 0 ;Additional memory for internal computation
;.EQU TOT_NUM_BYTE = PTEXT_NUM_BYTE+KEY_NUM_BYTE+ADD_MEM_NUM_BYTE
;.EQU SRAM_PTEXT = SRAM_DATA
;.EQU SRAM_KEY = SRAM_DATA + PTEXT_NUM_BYTE
;.EQU SRAM_CTEXT = SRAM_PTEXT

#define cnt0 R16
#define iTmp0 R17
#define iTmp1 R18
#define iTmp2 R19
#define iTmp3 R20

#define S_0 R21
#define S_1 R22
#define S_2 R23
#define S_3 R24
cipher_core:
clr cnt0 //Init round counter

//Rounds begin here
rjmp add_key

cipher_loop:
inc cnt0 //Increase round counter //needed for key schedule!!!
ldi ZH, high(sbox<<1) // Z points on sbox in program memory
rcall SBoxLayer //one call for sBoxLayer
rcall MLayer
ldi ZH, high(RC<<1) // Z points on sbox in program memory
rcall addRC
add_key:
eor R8, R0 // xor key and plaintext
eor R9, R1
eor R10, R2
eor R11, R3
eor R12, R4
eor R13, R5
eor R14, R6
eor R15, R7
//done after counter = 5
CPI cnt0,0x5 //5 Rounds
BRNE cipher_loop

ldi ZH, high(sbox<<1) // Z points on sbox in program memory
rcall SBoxLayer
rcall MixColumn //M’ = MicColumn
ldi ZH, high(invsbox<<1) // Z points on sbox in program memory
rcall SBoxLayer

inc cnt0
rjmp add_key_1

cipher_loop_1:
rcall M_1_Layer
ldi ZH, high(invsbox<<1) // Z points on sbox in program memory
rcall SBoxLayer
inc cnt0
add_key_1:
eor R8, R0 // xor key and plaintext
eor R9, R1
eor R10, R2
eor R11, R3
eor R12, R4
eor R13, R5
eor R14, R6
eor R15, R7
ldi ZH, high(RC<<1) // Z points on sbox in program memory
rcall addRC
CPI cnt0,0xB
BRNE cipher_loop_1

rcall reordering

ret
prince_encrypt:
//Should be Enabled For Testing
mov R26, R22
mov R27, R23
rcall load_data // Load plaintext to state
rcall addRoundKey // Add with K0
rcall orderize_data
rcall load_key_enc // loads and reorders key

rcall cipher_core

rcall keyexpansion
rcall addRoundKey

rjmp store_data
prince_decrypt:
mov R26, R22
mov R27, R23
rcall load_data
rcall keyexpansion
rcall addRoundKey
rcall orderize_data
rcall load_key_dec

rcall cipher_core

rcall keyload
rcall addRoundKey
////////////////////////////////////////////////////////////////////////
store_data: // write ciphertext and return
andi R26, $0
movw Z,R26 //move Z pointer on data
st Z+, R8
st Z+, R9
st Z+, R10
st Z+, R11
st Z+, R12
st Z+, R13
st Z+, R14
st Z+, R15
ret // end program
////////////////////////////////////////////////////////////////////////

rjmp end

//////////////////////////////////////////////////////////////
addRoundKey:
eor R8, R0 // xor key and plaintext
eor R9, R1
eor R10, R2
eor R11, R3
eor R12, R4
eor R13, R5
eor R14, R6
eor R15, R7
ret //done: add round key
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
addRC:
/*
mov iTmp2, cnt0
ldi iTmp0, $00
ldi iTmp3, $08
clr iTmp1
again:
cp iTmp1, iTmp2
breq fine
add iTmp0, iTmp3
dec iTmp2
jmp again
*/
mov iTmp0, cnt0
lsl iTmp0
lsl iTmp0
lsl iTmp0
fine:
mov ZL, iTmp0
lpm iTmp0, Z+
eor R8, iTmp0
lpm iTmp0, Z+
eor R9, iTmp0
lpm iTmp0, Z+
eor R10, iTmp0
lpm iTmp0, Z+
eor R11, iTmp0
lpm iTmp0, Z+
eor R12, iTmp0
lpm iTmp0, Z+
eor R13, iTmp0
lpm iTmp0, Z+
eor R14, iTmp0
lpm iTmp0, Z+
eor R15, iTmp0

ret //done; addRC
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
load_data:
movw Z,R22 //move Z pointer on data
ld R8, Z+ // move data to R8:R15
ld R9, Z+
ld R10, Z+
ld R11, Z+
ld R12, Z+
ld R13, Z+
ld R14, Z+
ld R15, Z+

ld R0, Z+ // move key to R0:R7
ld R1, Z+
ld R2, Z+
ld R3, Z+
ld R4, Z+
ld R5, Z+
ld R6, Z+
ld R7, Z+
ret //done:load_data
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
orderize_data:
//reorder the data
mov R0, R14
mov R1, R15
mov iTmp0, R11
mov iTmp1, R13
rcall ordering
mov R14, iTmp0
mov R15, iTmp1
mov iTmp0, R10
mov iTmp1, R12
rcall ordering
mov R12, iTmp0
mov R13, iTmp1
mov iTmp0, R9
mov iTmp1, R1 //Saved in The First Line
rcall ordering
mov R10, iTmp0
mov R11, iTmp1
mov iTmp0, R8
mov iTmp1, R0 //Saved in The First Line
rcall ordering
mov R8, iTmp0
mov R9, iTmp1
ret //done: orderize_data
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//load and order the key
load_key_enc: //Load K1
ld R0, Z+ // move key to R0:R7
ld R1, Z+
ld iTmp0, Z+
ld R2, Z+
ld iTmp1, Z+
rcall ordering
mov R4, iTmp0
mov R5, iTmp1
mov iTmp0, R2
ld iTmp1, Z+
rcall ordering
mov R6, iTmp0
mov R7, iTmp1
mov iTmp0, R0
ld iTmp1, Z+
rcall ordering
mov R0, iTmp0
mov R2, R1
mov R1, iTmp1
mov iTmp0, R2
ld iTmp1, Z+
rcall ordering
mov R2, iTmp0
mov R3, iTmp1
ret//done:load_key_enc
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//load and order the key
load_key_dec: //Load K1
ld R0, Z+ // move key to R0:R7
ld R1, Z+
ld iTmp0, Z+
ld R2, Z+
ld iTmp1, Z+
rcall ordering
ldi iTmp2, $2C
ldi iTmp3, $99
eor iTmp0, iTmp2
eor iTmp1, iTmp3
mov R4, iTmp0
mov R5, iTmp1
mov iTmp0, R2
ld iTmp1, Z+
rcall ordering
ldi iTmp2, $B7
ldi iTmp3, $7C
eor iTmp0, iTmp2
eor iTmp1, iTmp3
mov R6, iTmp0
mov R7, iTmp1
mov iTmp0, R0
ld iTmp1, Z+
rcall ordering
ldi iTmp2, $C5
ldi iTmp3, $00
eor iTmp0, iTmp2
eor iTmp1, iTmp3
mov R0, iTmp0
mov R2, R1
mov R1, iTmp1
mov iTmp0, R2
ld iTmp1, Z+
rcall ordering
ldi iTmp2, $AD
ldi iTmp3, $CD
eor iTmp0, iTmp2
eor iTmp1, iTmp3
mov R2, iTmp0
mov R3, iTmp1
ret // done:load_key_dec
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
ordering: //iTmp0[X,Y], iTmp1[A,B] = iTmp0[X,A] iTmp1[Y,B]
mov iTmp2, iTmp0
andi iTmp0, $F0
andi iTmp2, $0F
swap iTmp2
mov iTmp3, iTmp1
andi iTmp1, $F0
swap iTmp1
andi iTmp3, $0F
eor iTmp0, iTmp1
eor iTmp2, iTmp3
mov iTmp1, iTmp2
ret //done: ordering
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
reordering:
mov R0, R14
mov R1, R15
mov iTmp0, R8
mov iTmp1, R9
rcall ordering
mov R8, iTmp0
mov R14, iTmp1
mov iTmp0, R10
mov iTmp1, R11
rcall ordering
mov R9, iTmp0
mov R15, iTmp1
mov iTmp0, R12
mov iTmp1, R13
rcall ordering
mov R10, iTmp0
mov R12, iTmp1
mov iTmp0, R0 //Saved Before
mov iTmp1, R1 //Saved Before
rcall ordering
mov R11, iTmp0
mov R13, iTmp1
ret //done: reorder
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
MLayer:
rcall MixColumn
rcall ShiftRow
ret //done MLayer

M_1_Layer:
rcall ShiftRow_1
rcall MixColumn
ret //done M_1_Layer
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
MixColumn:
mov iTmp0, R8
andi iTmp0, $77 ; 119d = 77h = 01110111b
mov iTmp1, R9
andi iTmp1, $BB ; 187d = BBh = 10111011b
eor iTmp0, iTmp1
mov iTmp1, R10
andi iTmp1, $DD ; 221d = DDh = 11011101b
eor iTmp0, iTmp1
mov iTmp1, R11
andi iTmp1, $EE ; 238d = EEh = 11101110b
eor iTmp0, iTmp1
mov S_0, iTmp0

mov iTmp0, R8
andi iTmp0, $BB ; 187d = BBh = 10111011b
mov iTmp1, R9
andi iTmp1, $DD ; 221d = DDh = 11011101b
eor iTmp0, iTmp1
mov iTmp1, R10
andi iTmp1, $EE ; 238d = EEh = 11101110b
eor iTmp0, iTmp1
mov iTmp1, R11
andi iTmp1, $77 ; 119d = 77h = 01110111b
eor iTmp0, iTmp1
mov S_1, iTmp0

mov iTmp0, R8
andi iTmp0, $DD ; 221d = DDh = 11011101b
mov iTmp1, R9
andi iTmp1, $EE ; 238d = EEh = 11101110b
eor iTmp0, iTmp1
mov iTmp1, R10
andi iTmp1, $77 ; 119d = 77h = 01110111b
eor iTmp0, iTmp1
mov iTmp1, R11
andi iTmp1, $BB ; 187d = BBh = 10111011b
eor iTmp0, iTmp1
mov S_2, iTmp0

mov iTmp0, R8
andi iTmp0, $EE ; 238d = EEh = 11101110b
mov iTmp1, R9
andi iTmp1, $77 ; 119d = 77h = 01110111b
eor iTmp0, iTmp1
mov iTmp1, R10
andi iTmp1, $BB ; 187d = BBh = 10111011b
eor iTmp0, iTmp1
mov iTmp1, R11
andi iTmp1, $DD ; 221d = DDh = 11011101b
eor iTmp0, iTmp1
mov S_3, iTmp0

mov R8, S_0
mov R9, S_1
mov R10, S_2
mov R11, S_3

mov iTmp0, R12
andi iTmp0, $BB ; 187d = BBh = 10111011b
mov iTmp1, R13
andi iTmp1, $DD ; 221d = DDh = 11011101b
eor iTmp0, iTmp1
mov iTmp1, R14
andi iTmp1, $EE ; 238d = EEh = 11101110b
eor iTmp0, iTmp1
mov iTmp1, R15
andi iTmp1, $77 ; 119d = 77h = 01110111b
eor iTmp0, iTmp1
mov S_0, iTmp0

mov iTmp0, R12
andi iTmp0, $DD ; 221d = DDh = 11011101b
mov iTmp1, R13
andi iTmp1, $EE ; 238d = EEh = 11101110b
eor iTmp0, iTmp1
mov iTmp1, R14
andi iTmp1, $77 ; 119d = 77h = 01110111b
eor iTmp0, iTmp1
mov iTmp1, R15
andi iTmp1, $BB ; 187d = BBh = 10111011b
eor iTmp0, iTmp1
mov S_1, iTmp0

mov iTmp0, R12
andi iTmp0, $EE ; 238d = EEh = 11101110b
mov iTmp1, R13
andi iTmp1, $77 ; 119d = 77h = 01110111b
eor iTmp0, iTmp1
mov iTmp1, R14
andi iTmp1, $BB ; 187d = BBh = 10111011b
eor iTmp0, iTmp1
mov iTmp1, R15
andi iTmp1, $DD ; 221d = DDh = 11011101b
eor iTmp0, iTmp1
mov S_2, iTmp0

mov iTmp0, R12
andi iTmp0, $77 ; 119d = 77h = 01110111b
mov iTmp1, R13
andi iTmp1, $BB ; 187d = BBh = 10111011b
eor iTmp0, iTmp1
mov iTmp1, R14
andi iTmp1, $DD ; 221d = DDh = 11011101b
eor iTmp0, iTmp1
mov iTmp1, R15
andi iTmp1, $EE ; 238d = EEh = 11101110b
eor iTmp0, iTmp1
mov S_3, iTmp0

mov R12, S_0
mov R13, S_1
mov R14, S_2
mov R15, S_3
ret //done: MixColumn
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
ShiftRow:

//Row 1
mov iTmp2, R9
mov iTmp3, R13
mov iTmp0, R9 //iTmp0 = S1_S13
mov iTmp1, R13 //iTmp1 = S5_S9
andi iTmp0, $0F //iTmp0 = 0_S13
andi iTmp1, $0F //iTmp1 = 0_S9
swap iTmp1 //S9_0
eor iTmp0, iTmp1 //iTmp0 = S9_S13
andi iTmp2, $F0 //R9 = S1_0
swap iTmp2 //R9 = 0_S1
andi iTmp3, $F0 //R13 = S5_0
eor iTmp3,iTmp2 //R13 = S5_S1
mov R9, iTmp3
mov R13, iTmp0 //R9 = S9_S13

//Row 2
swap R10
swap R14
eor R14, R10
eor R10, R14
eor R14, R10

//Row 3
mov iTmp2, R11
mov iTmp3, R15
mov iTmp0, R11 //iTmp0 = S3_S15
mov iTmp1, R15 //iTmp1 = S7_S11
andi iTmp0, $0F //iTmp0 = 0_S15
swap iTmp0 //iTmp0 = S15_0
andi iTmp1, $0F //iTmp1 = 0_S11
eor iTmp0, iTmp1 //iTmp0 = S15_S11
andi iTmp2, $F0 //R11 = S3_0
andi iTmp3, $F0 //R15 = S7_0
swap iTmp3 //R15 = 0_S7
eor iTmp3, iTmp2 //R15 = S3_S7
mov R15, iTmp3
mov R11, iTmp0
ret //done: ShiftRow

ShiftRow_1:

//Row 1
mov iTmp2, R9
mov iTmp3, R13
mov iTmp0, R9 //iTmp0 = S1_S13
mov iTmp1, R13 //iTmp1 = S5_S9
andi iTmp0, $0F //iTmp0 = 0_S13
swap iTmp0 //iTmp0 = S13_0
andi iTmp1, $0F //iTmp1 = 0_S9
eor iTmp0, iTmp1 //iTmp0 = S13_S9
andi iTmp2, $F0 //R9 = S1_0
andi iTmp3, $F0 //R13 = S5_0
swap iTmp3 //R13 = 0_S5
eor iTmp3, iTmp2 //R13 = S1_S5
mov R13, iTmp3
mov R9, iTmp0 //R9 = S13_S9

//Row 2
swap R10
swap R14
eor R14, R10
eor R10, R14
eor R14, R10

//Row 3
mov iTmp2, R11
mov iTmp3, R15
mov iTmp0, R11 //iTmp0 = S3_S15
mov iTmp1, R15 //iTmp1 = S7_S11
andi iTmp0, $0F //iTmp0 = 0_S15
andi iTmp1, $0F //iTmp1 = 0_S11
swap iTmp1 //S11_0
eor iTmp0, iTmp1 //S11_S15
andi iTmp2, $F0 //R11 = S3_0
swap iTmp2 //R15 = 0_S3
andi iTmp3, $F0 //R15 = S7_0
eor iTmp2, iTmp3 //R11 = S7_S3
mov R11, iTmp2
mov R15, iTmp0 //R15 = S11_S15
ret //done: ShiftRow_1
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
SBoxLayer:
mov ZL, R8 // Look up corresponding value
lpm R8, Z // write corresponding value
mov ZL, R9
lpm R9, Z
mov ZL, R10
lpm R10, Z
mov ZL, R11
lpm R11, Z
mov ZL, R12
lpm R12, Z
mov ZL, R13
lpm R13, Z
mov ZL, R14
lpm R14, Z
mov ZL, R15
lpm R15, Z
ret //done: sBoxLayer
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
keyexpansion:
movw Z, R26
adiw Z,8

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
ret //done: keyexpansion
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
keyload:
movw Z, R26
adiw Z,8

ld R0, Z+ // move key to R0:R7
ld R1, Z+
ld R2, Z+
ld R3, Z+
ld R4, Z+
ld R5, Z+
ld R6, Z+
ld R7, Z+
ret //done:keyload
//////////////////////////////////////////////////////////////
end:
nop
.EXIT
