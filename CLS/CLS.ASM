;* ------------------------------------------------------------------------- *
;* Name   : CLS
;* Author : Gerard Wassink
;* Date   : December 29, 2021
;* Purpose: Just clear the screen and reset the terminal
;* Versions:
;*   0.1  : Stripped unnessecary code
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
            ;       Reset and clear Screen, cursor home
            ;
            LD      C,09H           ; Print string function in reg C
            LD      DE,RESET        ; Data address in DE
            CALL    0005H           ; Call BDOS for print string function
            ;
            ;       Return to CP/M
            ;
            RET                     ; Back to CP/M
;
;           Terminal ESC codes
;
RESET       DB      27, '[2J', 27, '[0m', 27, '[1;1H$'
;
ENDPROG     END                     ; assembly stops here
;

