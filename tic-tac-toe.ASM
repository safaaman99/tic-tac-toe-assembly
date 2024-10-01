format PE console
include "win32ax.inc"

;=======================================
section '.code' code readable executable
;=======================================
start:
        cinvoke time, 0
        cinvoke srand, eax

        invoke GetStdHandle, -11                        ;get standard ouput handle
        mov [hStdOut], eax                              ;move standard output handle from eax to hStdOut
        invoke GetConsoleMode, [hStdOut], dwMode        ;get console mode
        or [dwMode], 4                                  ;change console mode to include ENABLE_VIRTUAL_TERMINAL_PROCESSING bit flag
        invoke SetConsoleMode, [hStdOut], [dwMode]      ;update console mode

        cinvoke printf, "%cWelcome to x86 Assembly Tic-Tac-toe!                  1 | 2 | 3%c", 10, 10
        cinvoke printf, "                                                     ---+---+---%c", 10
        cinvoke printf, "You will be X's and the computer wil be O's.          4 | 5 | 6%c", 10
        cinvoke printf, "The squares are number 1 - 9.                        ---+---+---%c", 10
        cinvoke printf, "Let's begin!                                          7 | 8 | 9%c%c", 10, 10

gameLoop:
        call printboard
        cinvoke printf, "Your move (1-9)? "
        cinvoke scanf, "%d", square
        call placeX
        call checkXWin
        call checkForDraw
        call computerMove
        call CheckOWin
        jmp gameLoop

printboard:
        cmp [isStart], 0        ;makes sure not to clear board on first print so that game information is not cleared
        je FirstPrint
        call printCLS
        jmp print
    FirstPrint:
        inc [isStart]
    print:
        cinvoke printf, "%c %1.1s | %1.1s | %1.1s%c",10, S1, S2, S3, 10
        cinvoke printf, "---+---+---%c", 10
        cinvoke printf, " %1.1s | %1.1s | %1.1s%c", S4, S5, S6, 10
        cinvoke printf, "---+---+---%c", 10
        cinvoke printf, " %1.1s | %1.1s | %1.1s%c%c", S7, S8, S9, 10, 10
        ret

placeX:
        mov eax, [square]

        cmp [S1+eax-1], 'X'     ;makes sure square is empty so player can't cheat and override a square
        je gameLoop
        cmp [S1+eax-1], 'O'
        je gameLoop

        mov [S1+eax-1], 'X'
        ret

checkXWin:
    Xrow1:
        cmp [S1], 'X'
        jne Xrow2
        cmp [S2], 'X'
        jne Xrow2
        cmp [S3], 'X'
        je playerWins

    Xrow2:
        cmp [S4], 'X'
        jne Xrow3
        cmp [S5], 'X'
        jne Xrow3
        cmp [S6], 'X'
        je playerWins

    Xrow3:
        cmp [S7], 'X'
        jne Xcol1
        cmp [S8], 'X'
        jne Xcol1
        cmp [S9], 'X'
        je playerWins

    Xcol1:
        cmp [S1], 'X'
        jne Xcol2
        cmp [S4], 'X'
        jne Xcol2
        cmp [S7], 'X'
        je playerWins

    Xcol2:
        cmp [S2], 'X'
        jne Xcol3
        cmp [S5], 'X'
        jne Xcol3
        cmp [S8], 'X'
        je playerWins

    Xcol3:
        cmp [S3], 'X'
        jne Xdiag1
        cmp [S6], 'X'
        jne Xdiag1
        cmp [S9], 'X'
        je playerWins

    Xdiag1:
        cmp [S1], 'X'
        jne Xdiag2
        cmp [S5], 'X'
        jne Xdiag2
        cmp [S9], 'X'
        je playerWins

    Xdiag2:
        cmp [S3], 'X'
        jne noXWin
        cmp [S5], 'X'
        jne noXWin
        cmp [S7], 'X'
        je playerWins

    noXWin:
        ret

checkForDraw:
        mov ecx, -1
    drawLoop:
        inc ecx
        cmp ecx, 9
        je draw
        cmp [S1+ecx], ' '
        jne drawLoop
        ret

computerMove:
;================== Comp Wins ==================

;============ Top Row ============
    compWinsTopRowS1: ; _ O O
        cmp [S1], ' '
        jne compWinsTopRowS2
        cmp [S2], 'O'
        jne compWinsTopRowS2
        cmp [S3], 'O'
        jne compWinsTopRowS2

        mov [S1], 'O'
        jmp computerWins

    compWinsTopRowS2: ; O _ O
        cmp [S1], 'O'
        jne compWinsTopRowS3
        cmp [S2], ' '
        jne compWinsTopRowS3
        cmp [S3], 'O'
        jne compWinsTopRowS3

        mov [S2], 'O'
        jmp computerWins

    compWinsTopRowS3: ; O O _
        cmp [S1], 'O'
        jne compWinsMidRowS4
        cmp [S2], 'O'
        jne compWinsMidRowS4
        cmp [S3], ' '
        jne compWinsMidRowS4

        mov [S3], 'O'
        jmp computerWins

;============ Mid Row ============
    compWinsMidRowS4: ; _ O O
        cmp [S4], ' '
        jne compWinsMidRowS5
        cmp [S5], 'O'
        jne compWinsMidRowS5
        cmp [S6], 'O'
        jne compWinsMidRowS5

        mov [S4], 'O'
        jmp computerWins

    compWinsMidRowS5: ; O _ O
        cmp [S4], 'O'
        jne compWinsMidRowS6
        cmp [S5], ' '
        jne compWinsMidRowS6
        cmp [S6], 'O'
        jne compWinsMidRowS6

        mov [S5], 'O'
        jmp computerWins

    compWinsMidRowS6: ; O O _
        cmp [S4], 'O'
        jne compWinsBotRowS7
        cmp [S5], 'O'
        jne compWinsBotRowS7
        cmp [S6], ' '
        jne compWinsBotRowS7

        mov [S6], 'O'
        jmp computerWins

;============ Bot Row ============
    compWinsBotRowS7: ; _ O O
        cmp [S7], ' '
        jne compWinsBotRowS8
        cmp [S8], 'O'
        jne compWinsBotRowS8
        cmp [S9], 'O'
        jne compWinsBotRowS8

        mov [S7], 'O'
        jmp computerWins

    compWinsBotRowS8: ; O _ O
        cmp [S7], 'O'
        jne compWinsBotRowS9
        cmp [S8], ' '
        jne compWinsBotRowS9
        cmp [S9], 'O'
        jne compWinsBotRowS9

        mov [S8], 'O'
        jmp computerWins

    compWinsBotRowS9: ; O O _
        cmp [S7], 'O'
        jne compWinsLeftColS1
        cmp [S8], 'O'
        jne compWinsLeftColS1
        cmp [S9], ' '
        jne compWinsLeftColS1

        mov [S9], 'O'
        jmp computerWins

;=========== Left Col ===========
    compWinsLeftColS1: ; _ O O
        cmp [S1], ' '
        jne compWinsLeftColS4
        cmp [S4], 'O'
        jne compWinsLeftColS4
        cmp [S7], 'O'
        jne compWinsLeftColS4

        mov [S1], 'O'
        jmp computerWins

    compWinsLeftColS4: ; O _ O
        cmp [S1], 'O'
        jne compWinsLeftColS7
        cmp [S4], ' '
        jne compWinsLeftColS7
        cmp [S7], 'O'
        jne compWinsLeftColS7

        mov [S4], 'O'
        jmp computerWins

    compWinsLeftColS7: ; O O _
        cmp [S1], 'O'
        jne compWinsMidColS2
        cmp [S4], 'O'
        jne compWinsMidColS2
        cmp [S7], ' '
        jne compWinsMidColS2

        mov [S7], 'O'
        jmp computerWins

;============ Mid Col ============
    compWinsMidColS2: ; _ O O
        cmp [S2], ' '
        jne compWinsMidColS5
        cmp [S5], 'O'
        jne compWinsMidColS5
        cmp [S8], 'O'
        jne compWinsMidColS5

        mov [S2], 'O'
        jmp computerWins

    compWinsMidColS5: ; O _ O
        cmp [S2], 'O'
        jne compWinsMidColS8
        cmp [S5], ' '
        jne compWinsMidColS8
        cmp [S8], 'O'
        jne compWinsMidColS8

        mov [S5], 'O'
        jmp computerWins

    compWinsMidColS8: ; O O _
        cmp [S2], 'O'
        jne compWinsRightColS3
        cmp [S5], 'O'
        jne compWinsRightColS3
        cmp [S8], ' '
        jne compWinsRightColS3

        mov [S8], 'O'
        jmp computerWins

;=========== Right Col ===========
    compWinsRightColS3: ; _ O O
        cmp [S3], ' '
        jne compWinsRightColS6
        cmp [S6], 'O'
        jne compWinsRightColS6
        cmp [S9], 'O'
        jne compWinsRightColS6

        mov [S3], 'O'
        jmp computerWins

    compWinsRightColS6: ; O _ O
        cmp [S3], 'O'
        jne compWinsRightColS9
        cmp [S6], ' '
        jne compWinsRightColS9
        cmp [S9], 'O'
        jne compWinsRightColS9

        mov [S6], 'O'
        jmp computerWins

    compWinsRightColS9: ; O O _
        cmp [S3], 'O'
        jne compWinsRightDiagS1
        cmp [S6], 'O'
        jne compWinsRightDiagS1
        cmp [S9], ' '
        jne compWinsRightDiagS1

        mov [S9], 'O'
        jmp computerWins

;=========== Right Diag ===========
    compWinsRightDiagS1: ; _ O O
        cmp [S1], ' '
        jne compWinsRightDiagS5
        cmp [S5], 'O'
        jne compWinsRightDiagS5
        cmp [S9], 'O'
        jne compWinsRightDiagS5

        mov [S1], 'O'
        jmp computerWins

    compWinsRightDiagS5: ; O _ O
        cmp [S1], 'O'
        jne compWinsRightDiagS9
        cmp [S5], ' '
        jne compWinsRightDiagS9
        cmp [S9], 'O'
        jne compWinsRightDiagS9

        mov [S5], 'O'
        jmp computerWins

    compWinsRightDiagS9: ; O O _
        cmp [S1], 'O'
        jne compWinsLeftDiagS3
        cmp [S5], 'O'
        jne compWinsLeftDiagS3
        cmp [S9], ' '
        jne compWinsLeftDiagS3

        mov [S9], 'O'
        jmp computerWins

;=========== Left Diag ===========
    compWinsLeftDiagS3: ; _ O O
        cmp [S3], ' '
        jne compWinsLeftDiagS5
        cmp [S5], 'O'
        jne compWinsLeftDiagS5
        cmp [S7], 'O'
        jne compWinsLeftDiagS5

        mov [S3], 'O'
        jmp computerWins

    compWinsLeftDiagS5: ; O _ O
        cmp [S3], 'O'
        jne compWinsLeftDiagS7
        cmp [S5], ' '
        jne compWinsLeftDiagS7
        cmp [S7], 'O'
        jne compWinsLeftDiagS7

        mov [S5], 'O'
        jmp computerWins

    compWinsLeftDiagS7: ; O O _
        cmp [S3], 'O'
        jne compBlockTopRowS1
        cmp [S5], 'O'
        jne compBlockTopRowS1
        cmp [S7], ' '
        jne compBlockTopRowS1

        mov [S7], 'O'
        jmp computerWins

;================= Comp Blocks =================

;============ Top Row ============
    compBlockTopRowS1: ; _ X X
        cmp [S1], ' '
        jne compBlockTopRowS2
        cmp [S2], 'X'
        jne compBlockTopRowS2
        cmp [S3], 'X'
        jne compBlockTopRowS2

        mov [S1], 'O'
        ret

    compBlockTopRowS2: ; X _ X
        cmp [S1], 'X'
        jne compBlockTopRowS3
        cmp [S2], ' '
        jne compBlockTopRowS3
        cmp [S3], 'X'
        jne compBlockTopRowS3

        mov [S2], 'O'
        ret

    compBlockTopRowS3: ; X X _
        cmp [S1], 'X'
        jne compBlockMidRowS4
        cmp [S2], 'X'
        jne compBlockMidRowS4
        cmp [S3], ' '
        jne compBlockMidRowS4

        mov [S3], 'O'
        ret

;============ Mid Row ============
    compBlockMidRowS4: ; _ X X
        cmp [S4], ' '
        jne compBlockMidRowS5
        cmp [S5], 'X'
        jne compBlockMidRowS5
        cmp [S6], 'X'
        jne compBlockMidRowS5

        mov [S4], 'O'
        ret

    compBlockMidRowS5: ; X _ X
        cmp [S4], 'X'
        jne compBlockMidRowS6
        cmp [S5], ' '
        jne compBlockMidRowS6
        cmp [S6], 'X'
        jne compBlockMidRowS6

        mov [S5], 'O'
        ret

    compBlockMidRowS6: ; X X _
        cmp [S4], 'X'
        jne compBlockBotRowS7
        cmp [S5], 'X'
        jne compBlockBotRowS7
        cmp [S6], ' '
        jne compBlockBotRowS7

        mov [S6], 'O'
        ret

;============ Bot Row ============
    compBlockBotRowS7: ; _ X X
        cmp [S7], ' '
        jne compBlockBotRowS8
        cmp [S8], 'X'
        jne compBlockBotRowS8
        cmp [S9], 'X'
        jne compBlockBotRowS8

        mov [S7], 'O'
        ret

    compBlockBotRowS8: ; X _ X
        cmp [S7], 'X'
        jne compBlockBotRowS9
        cmp [S8], ' '
        jne compBlockBotRowS9
        cmp [S9], 'X'
        jne compBlockBotRowS9

        mov [S8], 'O'
        ret

    compBlockBotRowS9: ; X X _
        cmp [S7], 'X'
        jne compBlockLeftColS1
        cmp [S8], 'X'
        jne compBlockLeftColS1
        cmp [S9], ' '
        jne compBlockLeftColS1

        mov [S9], 'O'
        ret

;=========== Left Col ===========
    compBlockLeftColS1: ; _ X X
        cmp [S1], ' '
        jne compBlockLeftColS4
        cmp [S4], 'X'
        jne compBlockLeftColS4
        cmp [S7], 'X'
        jne compBlockLeftColS4

        mov [S1], 'O'
        ret

    compBlockLeftColS4: ; X _ X
        cmp [S1], 'X'
        jne compBlockLeftColS7
        cmp [S4], ' '
        jne compBlockLeftColS7
        cmp [S7], 'X'
        jne compBlockLeftColS7

        mov [S4], 'O'
        ret

    compBlockLeftColS7: ; X X _
        cmp [S1], 'X'
        jne compBlockMidColS2
        cmp [S4], 'X'
        jne compBlockMidColS2
        cmp [S7], ' '
        jne compBlockMidColS2

        mov [S7], 'O'
        ret

;============ Mid Col ============
    compBlockMidColS2: ; _ X X
        cmp [S2], ' '
        jne compBlockMidColS5
        cmp [S5], 'X'
        jne compBlockMidColS5
        cmp [S8], 'X'
        jne compBlockMidColS5

        mov [S2], 'O'
        ret

    compBlockMidColS5: ; X _ X
        cmp [S2], 'X'
        jne compBlockMidColS8
        cmp [S5], ' '
        jne compBlockMidColS8
        cmp [S8], 'X'
        jne compBlockMidColS8

        mov [S5], 'O'
        ret

    compBlockMidColS8: ; X X _
        cmp [S2], 'X'
        jne compBlockRightColS3
        cmp [S5], 'X'
        jne compBlockRightColS3
        cmp [S8], ' '
        jne compBlockRightColS3

        mov [S8], 'O'
        ret

;=========== Right Col ===========
    compBlockRightColS3: ; _ X X
        cmp [S3], ' '
        jne compBlockRightColS6
        cmp [S6], 'X'
        jne compBlockRightColS6
        cmp [S9], 'X'
        jne compBlockRightColS6

        mov [S3], 'O'
        ret

    compBlockRightColS6: ; X _ X
        cmp [S3], 'X'
        jne compBlockRightColS9
        cmp [S6], ' '
        jne compBlockRightColS9
        cmp [S9], 'X'
        jne compBlockRightColS9

        mov [S6], 'O'
        ret

    compBlockRightColS9: ; X X _
        cmp [S3], 'X'
        jne compBlockRightDiagS1
        cmp [S6], 'X'
        jne compBlockRightDiagS1
        cmp [S9], ' '
        jne compBlockRightDiagS1

        mov [S9], 'O'
        ret

;=========== Right Diag ===========
    compBlockRightDiagS1: ; _ X X
        cmp [S1], ' '
        jne compBlockRightDiagS5
        cmp [S5], 'X'
        jne compBlockRightDiagS5
        cmp [S9], 'X'
        jne compBlockRightDiagS5

        mov [S1], 'O'
        ret

    compBlockRightDiagS5: ; X _ X
        cmp [S1], 'X'
        jne compBlockRightDiagS9
        cmp [S5], ' '
        jne compBlockRightDiagS9
        cmp [S9], 'X'
        jne compBlockRightDiagS9

        mov [S5], 'O'
        ret

    compBlockRightDiagS9: ; X X _
        cmp [S1], 'X'
        jne compBlockLeftDiagS3
        cmp [S5], 'X'
        jne compBlockLeftDiagS3
        cmp [S9], ' '
        jne compBlockLeftDiagS3

        mov [S9], 'O'
        ret

;=========== Left Diag ===========
    compBlockLeftDiagS3: ; _ X X
        cmp [S3], ' '
        jne compBlockLeftDiagS5
        cmp [S5], 'X'
        jne compBlockLeftDiagS5
        cmp [S7], 'X'
        jne compBlockLeftDiagS5

        mov [S3], 'O'
        ret

    compBlockLeftDiagS5: ; X _ X
        cmp [S3], 'X'
        jne compBlockLeftDiagS7
        cmp [S5], ' '
        jne compBlockLeftDiagS7
        cmp [S7], 'X'
        jne compBlockLeftDiagS7

        mov [S5], 'O'
        ret

    compBlockLeftDiagS7: ; X X _
        cmp [S3], 'X'
        jne randomMove
        cmp [S5], 'X'
        jne randomMove
        cmp [S7], ' '
        jne randomMove

        mov [S7], 'O'
        ret

;================= Random Move =================
    randomMove:
        cinvoke rand
        cdq
        mov ebx, 9
        idiv ebx
        cmp [S1+edx], 'O'
        je randomMove
        cmp [S1+edx], 'X'
        je randomMove

        mov [S1+edx], 'O'
        ret

CheckOWin:
    Orow1:
        cmp [S1], 'O'
        jne Orow2
        cmp [S2], 'O'
        jne Orow2
        cmp [S3], 'O'
        je computerWins

    Orow2:
        cmp [S4], 'O'
        jne Orow3
        cmp [S5], 'O'
        jne Orow3
        cmp [S6], 'O'
        je computerWins

    Orow3:
        cmp [S7], 'O'
        jne Ocol1
        cmp [S8], 'O'
        jne Ocol1
        cmp [S9], 'O'
        je computerWins

    Ocol1:
        cmp [S1], 'O'
        jne Ocol2
        cmp [S4], 'O'
        jne Ocol2
        cmp [S7], 'O'
        je computerWins

    Ocol2:
        cmp [S2], 'O'
        jne Ocol3
        cmp [S5], 'O'
        jne Ocol3
        cmp [S8], 'O'
        je computerWins

    Ocol3:
        cmp [S3], 'O'
        jne Odiag1
        cmp [S6], 'O'
        jne Odiag1
        cmp [S9], 'O'
        je computerWins

    Odiag1:
        cmp [S1], 'O'
        jne Odiag2
        cmp [S5], 'O'
        jne Odiag2
        cmp [S9], 'O'
        je computerWins

    Odiag2:
        cmp [S3], 'O'
        jne noOWin
        cmp [S5], 'O'
        jne noOWin
        cmp [S7], 'O'
        je computerWins

    noOWin:
        ret


playerWins:
        call printboard
        call printRed
        cinvoke printf, " __     __                    _       %c", 10
        cinvoke printf, " \ \   / /                   (_)      %c", 10
        cinvoke printf, "  \ \_/ /__  _   _  __      ___ _ __  %c", 10
        cinvoke printf, "   \   / _ \| | | | \ \ /\ / / | '_ \ %c", 10
        cinvoke printf, "    | | (_) | |_| |  \ V  V /| | | | |%c", 10
        cinvoke printf, "    |_|\___/ \__,_|   \_/\_/ |_|_| |_|%c", 10
        jmp finish

computerWins:
        call printboard
        call printRed
        cinvoke printf, "   _____                            _             __          ___           %c", 10
        cinvoke printf, "  / ____|                          | |            \ \        / (_)          %c", 10
        cinvoke printf, " | |     ___  _ __ ___  _ __  _   _| |_ ___ _ __   \ \  /\  / / _ _ __  ___ %c", 10
        cinvoke printf, " | |    / _ \| '_ ` _ \| '_ \| | | | __/ _ \ '__|   \ \/  \/ / | | '_ \/ __|%c", 10
        cinvoke printf, " | |___| (_) | | | | | | |_) | |_| | ||  __/ |       \  /\  /  | | | | \__ \%c", 10
        cinvoke printf, "  \_____\___/|_| |_| |_| .__/ \__,_|\__\___|_|        \/  \/   |_|_| |_|___/%c", 10
        cinvoke printf, "                       | |                                                  %c", 10
        cinvoke printf, "                       |_|                                                  %c", 10
        jmp finish

draw:
        call printboard
        call printRed
        cinvoke printf, "  _____ _    _               _____                     %c", 10
        cinvoke printf, " |_   _| |  ( )             |  __ \                    %c", 10
        cinvoke printf, "   | | | |_ |/ ___    __ _  | |  | |_ __ __ ___      __%c", 10
        cinvoke printf, "   | | | __|  / __|  / _` | | |  | | '__/ _` \ \ /\ / /%c", 10
        cinvoke printf, "  _| |_| |_   \__ \ | (_| | | |__| | | | (_| |\ V  V / %c", 10
        cinvoke printf, " |_____|\__|  |___/  \__,_| |_____/|_|  \__,_| \_/\_/  %c", 10
        jmp finish

printCLS:
        cinvoke printf, "%c[1J%c[H", 27, 27
        ret

printRed:
        cinvoke printf, "%c[31;1m", 27
        ret

finish:
        invoke getch

;=====================================
section '.bss' data readable writeable
;=====================================
square          rd 1
hStdOut         rd 1    ;Standard output handle
dwMode          rd 1    ;Console mode

;======================================
section '.data' data readable writeable
;======================================
S1              db ' '
S2              db ' '
S3              db ' '
S4              db ' '
S5              db ' '
S6              db ' '
S7              db ' '
S8              db ' '
S9              db ' '
isStart         dd 0

;=========================================
section '.idata' import readable writeable
;=========================================
library msvcrt, 'msvcrt.dll', kernel32, 'kernel32.dll'
import msvcrt, printf, 'printf', scanf, 'scanf', getch, '_getch', rand, 'rand', srand, 'srand', time, 'time'
import kernel32, GetStdHandle,  'GetStdHandle', GetConsoleMode, 'GetConsoleMode', SetConsoleMode, 'SetConsoleMode'