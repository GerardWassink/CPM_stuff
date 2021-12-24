;* ------------------------------------------------------------------------- *
;* Name   : GAWGETIM
;* Author : Gerard Wassink
;* Date   : December 24, 2021
;* Purpose: Get RTC time on the RC2014 CP/M computer
;* Versions:
;*   0.1  : Initial code base, and 1st ASM program on CP/M
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
; BIOS address and functions
;
BDOS        EQU     0005H           ; BDOS address
PRTSCR      EQU     009H            ; Print $ terminated string function
;
RTCGTTM     EQU     020H            ; Get HBIOS time
;
SAVEREGS    PUSH    A               ; SAVE
            PUSH    B               ;  REGISTERS
            PUSH    D               ;   ON THE STACK
            ;
            ; Get time from RTC (Real Time Clock)
            ;
            MVI     B,RTCGTTM       ; BIOS RTCGETTIM function
            LXI     H,TIMBUF        ; HL points to buffer for BIOS time
            RST     1               ; Call BIOS function 08H (8 times specified value)
            ;
            ; Convert date to Ascii
            ;
            LXI     B,TIMYR         ; BC points to value to convert
            LXI     D,DSPY1         ; DE points to receiving buffer
            CALL    BCD2DISP        ; Convert BCD to displayable
            ;
            LXI     B,TIMMT         ; BC points to value to convert
            LXI     D,DSPM1         ; DE points to receiving buffer
            CALL    BCD2DISP        ; Convert BCD to displayable
            ;
            LXI     B,TIMDY         ; BC points to value to convert
            LXI     D,DSPD1         ; DE points to receiving buffer
            CALL    BCD2DISP        ; Convert BCD to displayable
            ;
            ; Convert time to Ascii
            ;
            LXI     B,TIMHR         ; BC points to value to convert
            LXI     D,DSPH1         ; DE points to receiving buffer
            CALL    BCD2DISP        ; Convert BCD to displayable
            ;
            LXI     B,TIMMN         ; BC points to value to convert
            LXI     D,DSPI1         ; DE points to receiving buffer
            CALL    BCD2DISP        ; Convert BCD to displayable
            ;
            LXI     B,TIMSC         ; BC points to value to convert
            LXI     D,DSPS1         ; DE points to receiving buffer
            CALL    BCD2DISP        ; Convert BCD to displayable
            ;
            MVI     C,PRTSCR        ; Print string function in reg C
            LXI     D,DISPLTIM      ; data address in DE
            CALL    BDOS            ; call BDOS for print string function
            ;
RESTREGS    POP     D               ;  POP REGISTERS
            POP     B               ;   FROM THE
            POP     A               ;    STACK
            ;
            RET                     ; GO BACK
            ;
            ;
            ; Convert BCD value to two ascii bytes for display
            ;
BCD2DISP    EQU     $
            LDAX    B               ; load BCD value
            ANI     0F0H            ; Isolate first nibble
            RRC                     ; Rotate
            RRC                     ;  register
            RRC                     ;   A for
            RRC                     ;    four times
            ORI     030H            ; make Ascii number
            STAX    D               ; store printable value 1st part
            ;
            INX     D               ; Increment DE for next store
            ;
            LDAX    B               ; load value
            ANI     00FH            ; Isolate second nibble
            ORI     030H            ; make Ascii number
            STAX    D               ; store printable value 2nd part
            ;
            RET
            ;
            ; DATA STORAGE
            ;
TIMBUF      EQU     $               ; Reserve room for time buffer
TIMYR       DB      57H
TIMMT       DB      12H
TIMDY       DB      07H
TIMHR       DB      12H
TIMMN       DB      34H
TIMSC       DB      56H
;
DISPLTIM    EQU     $               ; Reserve room for displayable time
            DB      'Current date and time from the RTC: '
;
DSPY1       DB      0               ; YEAR
DSPY2       DB      0               ;
            DB      '-'             ;
DSPM1       DB      0               ; MONTH
DSPM2       DB      0               ;
            DB      '-'             ;
DSPD1       DB      0               ; DAY
DSPD2       DB      0               ;
;
            DB      ','             ;
            DB      ' '             ;
;
DSPH1       DB      0               ; HOURS
DSPH2       DB      0               ;
            DB      ':'             ;
DSPI1       DB      0               ; MINUTES
DSPI2       DB      0               ;
            DB      ':'             ;
DSPS1       DB      0               ; SECONDS
DSPS2       DB      0               ;
;
            DB      0DH
            DB      0AH
;
            DB      '$'             ; End of string character
;
ENDPROG     END
