;* ------------------------------------------------------------------------- *
;* Name   : CLS
;* Author : Gerard Wassink
;* Date   : December 28, 2021
;* Purpose: Just clear the screen and reset the terminal
;* Versions:
;*   0.1  : Initial code base
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
REBOOT      EQU     0000H           ; Warm reboot CP/M
BDOS        EQU     0005H           ; BDOS address
PRTSCR      EQU     009H            ; Print $ terminated string function
;
;* ------------------------------------------------------------------------- *
;*                                                        Terminal ESC codes
;* ------------------------------------------------------------------------- *
ESC         EQU     27
BRACKET     EQU     '['
EOS         EQU     '$'
;
;* ------------------------------------------------------------------------- *
;*                                                                 Main line *
;* ------------------------------------------------------------------------- *
            PUSH    B               ; Save
            PUSH    D               ;  registers
            PUSH    H               ;   on the stack
            ;
            ;       Reset Screen
            ;
            MVI     C,PRTSCR        ; Print string function in reg C
            LXI     D,RESET         ; Data address in DE
            CALL    BDOS            ; Call BDOS for print string function
            ;
            ;       Clear Screen
            ;
            MVI     C,PRTSCR        ; Print string function in reg C
            LXI     D,CLS           ; Data address in DE
            CALL    BDOS            ; Call BDOS for print string function
            ;
            ;       Cursor home
            ;
            MVI     C,PRTSCR        ; Print string function in reg C
            LXI     D,HOME          ; Data address in DE
            CALL    BDOS            ; Call BDOS for print string function
            ;
            ;
            ; Program end, restore registers and return
            ;
            POP     H               ; Restore registers
            POP     D               ;  from the
            POP     B               ;   stack
            ;
            RET                     ; Back to CP/M
;
;
;* ------------------------------------------------------------------------- *
;*                                                              DATA STORAGE *
;* ------------------------------------------------------------------------- *
;
; Text Strings
;
CLS         DB      ESC, BRACKET,  '2J', EOS
RESET       DB      ESC, BRACKET,  '0m', EOS
HOME        DB      ESC, BRACKET,  '2;2H', EOS
;
ENDPROG     END                     ; assembly stops here
;

