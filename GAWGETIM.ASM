;* ------------------------------------------------------------------------- *
;* Name   : GAWGETIM
;* Author : Gerard Wassink
;* Date   : December 25, 2021
;* Purpose: Get RTC time on the RC2014 CP/M computer
;* Versions:
;*   0.1  : Initial code base, and 1st ASM program on CP/M
;*   0.2  : Code cleanup and optimisation
;*   0.3  : Return to CP/M using Warm Reboot
;*   
;* ------------------------------------------------------------------------- *
;
;* ------------------------------------------------------------------------- *
;*             GNU LICENSE CONDITIONS
;* ------------------------------------------------------------------------- *
;* This program is free software; you can redistribute it and/or modify
;* it under the terms of the GNU General Public License as published by
;* the Free Software Foundation; either version 2 of the License, or
;* (at your option) any later version.
;*
;* This program is distributed in the hope that it will be useful,
;* but WITHOUT ANY WARRANTY; without even the implied warranty of
;* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;* GNU General Public License for more details.
;*
;* You should have received a copy of the GNU General Public License along
;* with this program; if not, write to the Free Software Foundation, Inc.,
;* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
;*
;* ------------------------------------------------------------------------- *
;*       Copyright (C) December 2021 Gerard Wassink
;* ------------------------------------------------------------------------- *
;
START       ORG     0100H
;
; BDOS and BIOS addresses and functions
;
WARMBOOT    EQU     0000H           ; Warm Reboot
BDOS        EQU     0005H           ; BDOS address
PRTSCR      EQU     009H            ; Print $ terminated string function
;
RTCGTTM     EQU     020H            ; Get HBIOS time
;
;* ------------------------------------------------------------------------- *
;*                                                                 MAIN LINE *
;* ------------------------------------------------------------------------- *
GAWGETIM    PUSH    B               ; Save
            PUSH    D               ;  registers
            PUSH    H               ;   on the stack
            ;
            ; Get time from RTC (Real Time Clock)
            ;
            MVI     B,RTCGTTM       ; BIOS RTCGETTIM function
            LXI     H,TIMBUF        ; HL points to buffer for BIOS time
            RST     1               ; Call BIOS function 08H (8 times specified value)
            ;
            ; Convert date from BCD to Ascii
            ;
            LXI     B,BCDDATE       ; BC points to value to convert
            LXI     D,DSPDATE       ; DE points to receiving buffer
            CALL    BCD2ASCII       ; Convert BCD to displayable
            ;
            ; Convert time from BCD to Ascii
            ;
            LXI     B,BCDTIME       ; BC points to value to convert
            LXI     D,DSPTIME       ; DE points to receiving buffer
            CALL    BCD2ASCII       ; Convert BCD to displayable
            ;
            ; Print result string
            ;
            MVI     C,PRTSCR        ; Print string function in reg C
            LXI     D,DISPLTIM      ; Data address in DE
            CALL    BDOS            ; Call BDOS for print string function
            ;
            ; Program end, restore registers and return
            ;
            POP     H               ; Restore registers
            POP     D               ;  from the
            POP     B               ;   stack
            ;
            JMP     WARMBOOT        ; Back to CP/M
            ;
;* ------------------------------------------------------------------------- *
;*                 Convert BCD values to ascii bytes for display (BCD2ASCII) *
;* ------------------------------------------------------------------------- *
BCD2ASCII    EQU     $
            ;
            ; Initialize counter
            ;
            MVI     A,03H           ; load counter for 3 times
            STA     COUNT           ;  and store it
            ;
            ; Loop start
            ;
BCDAGAIN:   LDAX    B               ; load BCD value
            ANI     0F0H            ; Isolate first nibble
            RRC                     ; Rotate
            RRC                     ;  register
            RRC                     ;   A for
            RRC                     ;    four times
            ORI     030H            ; Make Ascii number
            STAX    D               ; Store printable value 1st part
            ;
            INX     D               ; Increment DE for next store
            ;
            LDAX    B               ; load value again
            ANI     00FH            ; Isolate second nibble
            ORI     030H            ; Make Ascii number
            STAX    D               ; Store printable value 2nd part
            ;
            ; Increment pointers to next values
            ;
            INX     B               ; Point to next BCD byte
            INX     D               ; Point to 
            INX     D               ;   next Ascii value
            ;
            ; Check for loop end, go around if not
            ;
            LDA     COUNT           ; Get counter value
            DCR     A               ; Decrement
            STA     COUNT           ; Store counter back
            JNZ     BCDAGAIN        ; Not done, again
            ;
            RET
            ;
;* ------------------------------------------------------------------------- *
;*                                                              DATA STORAGE *
;* ------------------------------------------------------------------------- *
COUNT       DB      03H             ; Counter storage
            ;
TIMBUF      EQU     $               ; Reserve room for date / time buffer
BCDDATE     DB      00H, 00H, 00H
BCDTIME     DB      00H, 00H, 00H
;
DISPLTIM    EQU     $               ; Reserve room for displayable time
            DB      'Current date and time from the RTC: '
DSPDATE     DB      '00-00-00, '    ; YEAR, MONTH,DAY
DSPTIME     DB      '00:00:00'      ; HOURS, MINUTES,SECONDS
            DB      0DH, 0AH        ; CR/LF
            DB      '$'             ; End of string character
;
ENDPROG     END
