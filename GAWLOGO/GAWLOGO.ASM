;* ------------------------------------------------------------------------- *
;* Name   : GAWLOGO
;* Author : Gerard Wassink
;* Date   : December 26, 2021
;* Purpose: Logo for my machine
;* Versions:
;*   0.1  : Initial code base
;*   0.2  : Adapted for Z80ASM assembler
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
BDOS        EQU     0005H           ; BDOS address
PRTSCR      EQU     009H            ; Print $ terminated string function
;
;* ------------------------------------------------------------------------- *
;*                                                       TERMINAL ATTRIBUTES
;* ------------------------------------------------------------------------- *
ESC         EQU     27
BRACKET     EQU     '['
CR          EQU     13
LF          EQU     10
EOS         EQU     '$'
;
;* ------------------------------------------------------------------------- *
;*                                                                 MAIN LINE *
;* ------------------------------------------------------------------------- *
GAWMANDL    PUSH    BC              ; Save
            PUSH    DE              ;  registers
            PUSH    HL              ;   on the stack
            ;
            ; Print header lines
            ;
            LD      C,PRTSCR        ; Print string function in reg C
            LD      DE,CYAN         ; Data address in DE
            CALL    BDOS            ; Call BDOS for print string function
            ;
            LD      C,PRTSCR        ; Print string function in reg C
            LD      DE,LOGO         ; Data address in DE
            CALL    BDOS            ; Call BDOS for print string function
            ;
            ; Reset screen attributes
            ;
            LD      C,PRTSCR        ; Print string function in reg C
            LD      DE,RESET        ; Data address in DE
            CALL    BDOS            ; Call BDOS for print string function
            ;
            ; Program end, restore registers and return
            ;
            POP     HL              ; Restore registers
            POP     DE              ;  from the
            POP     BC              ;   stack
            ;
            RET                     ; Go back to caller
            ;
;* ------------------------------------------------------------------------- *
;*                                                              DATA STORAGE *
;* ------------------------------------------------------------------------- *
;
; Text Strings
;
LOGO        DB      '                                                         ', CR, LF
            DB      '  __ __                                                  ', CR, LF
            DB      ' |  __ \                                                 ', CR, LF
            DB      ' | |  | | _____   _____  _ __ ___                        ', CR, LF
            DB      ' | |  | |/ _ \ \ / / _ \| /__/ _ \                       ', CR, LF
            DB      ' | |__| |  __/\ V / (_) | | |  __/                       ', CR, LF
            DB      ' |_____/ \___| \_/ \___/|_|  \___|                       ', CR, LF
            DB      '                                                         ', CR, LF
            DB      '    NCC-64088 - Akira class                              ', CR, LF
            DB      '                                                         ', CR, LF
            DB      '    RC2014 - Retro Computing 2014                        ', CR, LF
            DB      '    Home built Z80 computer                              ', CR, LF
            DB      '    Running Z-system CP/M                                ', CR, LF
            DB      '                                                         ', CR, LF
            DB      '                                                         ', CR, LF
            DB      EOS
;
;
BLACK       DB      ESC, BRACKET, '30m', EOS
RED         DB      ESC, BRACKET, '31m', EOS
GREEN       DB      ESC, BRACKET, '32m', EOS
YELLOW      DB      ESC, BRACKET, '33m', EOS
BLUE        DB      ESC, BRACKET, '34m', EOS
MAGENTA     DB      ESC, BRACKET, '35m', EOS
CYAN        DB      ESC, BRACKET, '36m', EOS
WHITE       DB      ESC, BRACKET, '37m', EOS
RESET       DB      ESC, BRACKET,  '0m', EOS
;
;
TOPLEFT     DB      ESC, BRACKET, '0;0H', EOS
;
ENDPROG     END                     ; assembly stops here