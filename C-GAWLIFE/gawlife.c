/* ------------------------------------------------------------------------- *
 * Name   : GAWLIFE
 * Author : Gerard Wassink
 * Date   : December 2022
 * Purpose: Coding the Game of Life, inspired by John Conway, ~1970
 * Versions:
 *   0.1  : Initial code base
 *   0.2  : re-setup arrays, no strings, just plain char's
 *          long arrays of char's, (MAXROW+1)*(MAXCOL+1) long
 *   
 * ------------------------------------------------------------------------- */
#define VERSION "0.2"
/* ------------------------------------------------------------------------- *
 *             GNU LICENSE CONDITIONS
 * ------------------------------------------------------------------------- *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * ------------------------------------------------------------------------- *
 *       Copyright (C) December 2022 Gerard Wassink
 * ------------------------------------------------------------------------- */

#include <stdio.h>
#include <strings.h>


/* ------------------------------------------------------------------------- *
 *                                                      CONSTANT definitions
 * ------------------------------------------------------------------------- */
#define MAXROW 15
#define MAXCOL 63


/* ------------------------------------------------------------------------- *
 *                                                      Function definitions
 * ------------------------------------------------------------------------- */
void    nextGeneration();
void    clearNextGen();
void    displayLifeGrid();
void    swapGrids();
void    Initialize();
int     inputCharacter();
void    Goodbye();
void    clearScreen();


/* ------------------------------------------------------------------------- *
 *                                                          Global variables
 * ------------------------------------------------------------------------- */

static char *template[MAXROW+1] = {
        "                                                                ",
        "                                                                ",
        "        ***   ***        **                                     ",
        "                         **      ***                            ",
        "      *    * *    *        **                                   ",
        "      *    * *    *        **                                   ",
        "      *    * *    *                                             ",
        "        ***   ***                                               ",
        "                                                                ",
        "        ***   ***            *                                  ",
        "      *    * *    *           *                                 ",
        "      *    * *    *         ***                                 ",
        "      *    * *    *                                             ",
        "                                                                ",
        "        ***   ***                                               ",
        "                                                                "
};
/*       ....+....1....+....2....+....3....+....4....+....5....+....6.... */

static char grid1[(MAXROW+1)*(MAXCOL+1)];       // grids are one continuous
static char grid2[(MAXROW+1)*(MAXCOL+1)];       //  'line' of characters

char *lifeGrid;
char *nextGrid;


/* ------------------------------------------------------------------------- *
 *                                                              Main routine
 * ------------------------------------------------------------------------- */
int main() {
    int done = (1==0);

    Initialize();                       // Initialize grids
    
    while (!done) {
        
        displayLifeGrid();              // Display current life Grid
        
        nextGeneration();               // Calculate next generation
        
        swapGrids();                    // Swap Grid pointers
        
    }
    return 0;
}


/* ------------------------------------------------------------------------- *
 *                                             Calculate the next generation
 * ------------------------------------------------------------------------- */
void nextGeneration() {
    int currentRow, currentCol;

    int Ncol, Nrow, NEcol, NErow, Ecol, Erow;
    int SEcol, SErow, Scol, Srow, SWcol, SWrow;
    int Wcol, Wrow, NWcol, NWrow;
    
    int lifeCount;

    clearNextGen();                     // Clear next generation grid
    
    // *** ---------------------------------------------------------------------------
    // *** go cell by cell trhough grid, determining positions of surrounding cells **
    // *** ---------------------------------------------------------------------------
    
    for (currentRow = 0; currentRow <= MAXROW; currentRow++) {
        
        for (currentCol = 0; currentCol <= MAXCOL; currentCol++) {
            
            Nrow = NWrow = NErow = currentRow - 1;  // fill in
            Srow = SWrow = SErow = currentRow + 1;  //   the default rows
            Erow = Wrow = currentRow;               //     first
            
            Ncol = Scol = currentCol;               // fill in
            Wcol = SWcol = NWcol = currentCol - 1;  //   the default cols
            Ecol = SEcol = NEcol = currentCol + 1;  //     first
            
            //
            // **** Now handle exceptions
            //
            
            if (currentRow == 0) {                  // At TOP row ================
                Nrow = NWrow = NErow = MAXROW;      //   then North is bottom row
                
                switch (currentCol) {
                
                case 0:                             // In top-left corner
                    Wcol = SWcol = NWcol = MAXCOL;  // then wrap around to right
                    break;
                    
                case (MAXCOL):                      // In top-right corner
                    Ecol = SEcol = NEcol = 0;       //   then wrap around to left
                    break;
                    
                default:
                    break;
                }
            
            } else if (currentRow == (MAXROW)) {    // At BOTTOM row =============
                Srow = SWrow = SErow = 0;           //   then South is top row
                
                switch (currentCol) {
                
                case 0:                             // In bottom-left corner
                    Wcol = NWcol = SWcol = MAXCOL;  //   then wrap around to right
                    break;
                
                case (MAXCOL):                      // In bottom-right corner
                    Ecol = SEcol = NEcol = 0;       //   then wrap around to left
                    break;
                    
                default:
                    break;
                }
            
            } else {                                // In some MIDDLE row ========
            
                switch (currentCol) {
                
                case 0:                             // At left side
                    Wcol = NWcol = SWcol = MAXCOL;  //   then wrap around to right
                    break;
                    
                case (MAXCOL):                      // At Right side
                    Ecol = SEcol = NEcol = 0;       //   then wrap around to left
                    break;
                    
                default:
                    break;
                }
            }
            
            // *** -------------------------------------------------------------------
            // Now count life cells surrounding currect cell
            // *** -------------------------------------------------------------------
            
            lifeCount = 0;
            
            if (lifeGrid[Nrow*(MAXCOL+1)+Ncol]   != ' ') lifeCount++;
            if (lifeGrid[Erow*(MAXCOL+1)+Ecol]   != ' ') lifeCount++;
            if (lifeGrid[Srow*(MAXCOL+1)+Scol]   != ' ') lifeCount++;
            if (lifeGrid[Wrow*(MAXCOL+1)+Wcol]   != ' ') lifeCount++;
            if (lifeGrid[NErow*(MAXCOL+1)+NEcol] != ' ') lifeCount++;
            if (lifeGrid[SErow*(MAXCOL+1)+SEcol] != ' ') lifeCount++;
            if (lifeGrid[SWrow*(MAXCOL+1)+SWcol] != ' ') lifeCount++;
            if (lifeGrid[NWrow*(MAXCOL+1)+NWcol] != ' ') lifeCount++;
            
            // *** -------------------------------------------------------------------
            // Calculate which cells live or die in the next generation
            // *** -------------------------------------------------------------------
            
            if (lifeGrid[currentRow*(MAXCOL+1)+currentCol] == ' ') {  // *** Dead cell
                if (lifeCount == 3) {                       //  comes alive when
                    nextGrid[currentRow*(MAXCOL+1)+currentCol] = '*'; //   3 neighbours alife
                }
            } else {                                        // *** Life cell =========
                if ((lifeCount == 2) || (lifeCount == 3)) { //  stays alive when 2 or 3
                    nextGrid[currentRow*(MAXCOL+1)+currentCol] = '*'; //  neighbours live
                }
            }
            
        } // for currentCol
        
    } // for currentRow
}


/* ------------------------------------------------------------------------- *
 *                                                Clear next generation grid
 * ------------------------------------------------------------------------- */
void clearNextGen() {
    int row, col;
    for (row=0; row <= MAXROW; row++) {
        for (col=0; col <= MAXCOL; col++) {
            nextGrid[row*(MAXCOL+1)+col] = ' ';
        }
    }
}


/* ------------------------------------------------------------------------- *
 *                                                            Swap the grids
 * ------------------------------------------------------------------------- */
void swapGrids() {
    char *tempGrid = NULL;
    tempGrid = lifeGrid;
    lifeGrid = nextGrid;
    nextGrid = tempGrid;
}


/* ------------------------------------------------------------------------- *
 *                                                   Display the active grid
 * ------------------------------------------------------------------------- */
void displayLifeGrid() {
    printf("%c%s", 27, "[03;00H");
    for (int gridLine=0; gridLine <= MAXROW; gridLine++) {
        for (int gridCol=0; gridCol <= MAXCOL; gridCol++) {
            printf("%c", lifeGrid[gridLine*(MAXCOL+1)+gridCol]);
        }
        printf("\n");
    }
}


void Initialize() {
/* ------------------------------------------------------------------------- *
 *                                                           Welcome message
 * It's a bit garbeled because every backslash has to be doubled...
 * ------------------------------------------------------------------------- */
    clearScreen();
    printf("%s", "GawLife version ");
    printf("%s", VERSION);
    printf("%s\n", " - inspired by 'game of life' by John Conway");
    printf("%s\n", "|....+....1....+....2....+....3....+....4....+....5....+....6....");
    printf("%s\n", "   _____                _      _  __      ");
    printf("%s\n", "  / ____|              | |    (_)/ _|     ");
    printf("%s\n", " | |  __  __ ___      _| |     _| |_ ___  ");
    printf("%s\n", " | | |_ |/ _` \\ \\ /\\ / / |    | |  _/ _ \\ ");
    printf("%s\n", " | |__| | (_| |\\ V  V /| |____| | ||  __/ ");
    printf("%s\n", "  \\_____|\\__,_| \\_/\\_/ |______|_|_| \\___| ");
    printf("%s\n", "                                          ");
    printf("%s\n", "Press any key to start");

    inputCharacter();
    
    lifeGrid = grid1;
    nextGrid = grid2;
    
                                        // ===== Initialize lifeGrid with the
                                        // =====   contents of the template
    for (int row=0; row<=MAXROW; row++) {
        for (int col=0; col<=MAXCOL; col++) {
            lifeGrid[row*(MAXCOL+1)+col] = template[row][col];
        }
    }
    
    clearNextGen();                     // ===== Initialize nextGrid with spaces
}


/* ------------------------------------------------------------------------- *
 *                                                       Input one character
 * ------------------------------------------------------------------------- */
int inputCharacter() {    
    int i;
    scanf("%c", &i);
    return i;
}


/* ------------------------------------------------------------------------- *
 *                                                           Goodbye message
 * ------------------------------------------------------------------------- */
void Goodbye() {
    printf("%s", "GAWLIFE - program ended");
}


/* ------------------------------------------------------------------------- *
 *                                                           Clear Screen
 * ------------------------------------------------------------------------- */
void clearScreen() {
    printf("%c%s%c%s%c%s", 27, "[2J", 27, "[0m", 27, "[00;00H");
}