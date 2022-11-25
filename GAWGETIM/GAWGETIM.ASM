;* ------------------------------------------------------------------------- *
;* Name   : GAWGETIM
;* Author : Gerard Wassink
;* Date   : December 25, 2021
;* Purpose: Get RTC time on the RC2014 CP/M computer
;* Versions:
;*   0.1  : Initial code base, and 1st ASM program on CP/M
;*   0.2  : Code cleanup and optimisation
;*   0.3  : Return to CP/M using Warm Reboot
;*   0.4  : Check return code from RTC
;*   0.5  : Changed to Z80ASM
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
GAWGETIM    PUSH    BC              ; Save
            PUSH    DE              ;  registers
            PUSH    HL              ;   on the stack
            ;
            ;       Display starter message
            ;
            LD      C,PRTSCR        ; Print string function in reg C
            LD      DE,MSG000       ; Data address in DE
            CALL    BDOS            ; Call BDOS for print string function
            ;
            ;       Get time from RTC (Real Time Clock)
            ;
            LD      B,RTCGTTM       ; BIOS RTCGETTIM function
            LD      HL,TIMBUF       ; HL points to buffer for BIOS time
            RST     08H             ; Call BIOS function 08H (8 times specified value)
            ;
            ;       Check return code
            ;
            JP      Z, RTC$OK       ; A=0: OKAY, else error
            ;
            ;       Display error message
            ;
            LD      C,PRTSCR        ; Print string function in reg C
            LD      DE,MSG001       ; Data address in DE
            CALL    BDOS            ; Call BDOS for print string function
            ;
            JP      ENDMAIN         ; Go back to CP/M
            ;
            ;       Convert date from BCD to Ascii
            ;
RTC$OK      EQU $
            LD      BC,BCDDATE      ; BC points to value to convert
            LD      DE,DSPDATE      ; DE points to receiving buffer
            CALL    BCD2ASCII       ; Convert BCD to displayable
            ;
            ;       Convert time from BCD to Ascii
            ;
            LD      BC,BCDTIME      ; BC points to value to convert
            LD      DE,DSPTIME      ; DE points to receiving buffer
            CALL    BCD2ASCII       ; Convert BCD to displayable
            ;
            ;       Print result string
            ;
            LD      C,PRTSCR        ; Print string function in reg C
            LD      DE,DISPLTIM     ; Data address in DE
            CALL    BDOS            ; Call BDOS for print string function
            ;
            ;       Program end, restore registers and return
            ;
ENDMAIN     EQU $
            POP     HL              ; Restore registers
            POP     DE              ;  from the
            POP     BC              ;   stack
            ;
            JP      WARMBOOT        ; Back to CP/M
            ;
;* ------------------------------------------------------------------------- *
;*                 Convert BCD values to ascii bytes for display (BCD2ASCII) *
;* ------------------------------------------------------------------------- *
BCD2ASCII    EQU     $
            ;
            ;       Initialize counter
            ;
            LD      A,03H           ; load counter for 3 times
            LD      (COUNT),A       ;  and store it
            ;
            ;       Loop start
            ;
BCDAGAIN:   LD      A,(BC)          ; load BCD value
            AND     0F0H            ;  Isolate first nibble
            RRCA                    ;   Rotate
            RRCA                    ;    register
            RRCA                    ;     A for
            RRCA                    ;     four times
            OR      030H            ;      make Ascii number
            LD      (DE),A          ; Store printable value 1st part
            ;
            INC     DE              ; Increment DE for next store
            ;
            LD      A,(BC)          ; load value again
            AND     00FH            ;  Isolate second nibble
            OR      030H            ;   Make Ascii number
            LD      (DE),A          ; Store printable value 2nd part
            ;
            ;       Increment pointers to next values
            ;
            INC     BC              ; Point to next BCD byte
            INC     DE              ; Point to 
            INC     DE              ;   next Ascii value
            ;
            ;       Check for loop end, go around if not
            ;
            LD      A,(COUNT)       ; Get counter value,
            DEC     A               ;  decrement it
            LD      (COUNT),A       ;   store counter back
            ;
            JP      NZ,BCDAGAIN     ; Not done? Again
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
MSG000      DB      'GAWGETIM version 0.5', 0DH, 0AH, '$'
MSG001      DB      'Error retrieving time, RTC present?', 0DH, 0AH, '$'
;
DISPLTIM    EQU     $               ; Reserve room for displayable time
            DB      'Current date and time from RTC: 20'
DSPDATE     DB      '00-00-00, '    ; YEAR, MONTH,DAY
DSPTIME     DB      '00:00:00'      ; HOURS, MINUTES,SECONDS
            DB      0DH, 0AH        ; CR/LF
            DB      '$'             ; End of string character
;
ENDPROG     END
