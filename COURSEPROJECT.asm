.ORIG x3000

;  variables
NUM_STUDENTS .FILL x0000
TOTAL_SCORE  .FILL x0000
AVG_SCORE    .FILL x0000
SCORE_ARRAY  .BLKW 100

; program
MAIN
    ; ask number of students
    LEA R0, PROMPT1
    JSR PRINT_STRING

    ; # of student
    JSR READ_INT
    ST R0, NUM_STUDENTS

    ; set score to 0 
    AND R1, R1, #0
    ST R1, TOTAL_SCORE

    ; loop
    AND R4, R4, #0 ; Loop counter
SCORE_INPUT_LOOP
    ADD R2, R4, R3
    BRzp CALCULATE_AVERAGE

    ; ask student score
    LEA R0, PROMPT2
    JSR PRINT_STRING

    ; read score
    JSR READ_INT

    ; putting score into an array 
    ADD R5, R4, R4 ; R5 = R4 * 2 (array index)
    ADD R5, R5, R5 ; R5 = R5 * 2 (array index)
    ADD R5, R5, R5 ; R5 = R5 * 2 (array index)
    ADD R5, R5, R5 ; R5 = R5 * 2 (array index)
    LEA R6, SCORE_ARRAY
    ADD R6, R6, R5
    STR R0, R6, #0

    ; now add to variable total score
    LD R1, TOTAL_SCORE
    ADD R1, R1, R0
    ST R1, TOTAL_SCORE

    ; loop counter + 
    ADD R4, R4, #1
    BR SCORE_INPUT_LOOP

CALCULATE_AVERAGE
    ; Avg score
    LD R0, NUM_STUDENTS
    BRz DISPLAY_RESULTS
    LD R1, TOTAL_SCORE
    JSR DIV
    ST R0, AVG_SCORE

DISPLAY_RESULTS
    ; print score
    LEA R0, TOTAL_MSG
    JSR PRINT_STRING
    LD R0, TOTAL_SCORE
    JSR PRINT_INT

    ; avg score
    LEA R0, AVG_MSG
    JSR PRINT_STRING
    LD R0, AVG_SCORE
    JSR PRINT_INT

    ; Halt
    HALT

; subroutine
PRINT_STRING
    LDR R1, R0, #0
    BRz PRINT_STRING_DONE
    OUT
    ADD R0, R0, #1
    BRnzp PRINT_STRING

PRINT_STRING_DONE
    RET

; subroutine int 
READ_INT
    ; variables
    ADD R0, R0, #0     ; Clear R0 
    ADD R1, R1, #0     ; Clear R1 
    LEA R2, NEG_ASCII  ; Load address of -
    GETC               ; Read character
    BRz READ_INT_DONE  ; If character is null exit

    ; is input negative? 
    ADD R3, R0, R2     ; subtract input
    BRnp READ_INT_NEG  ; branch if -

    ; ASCII to int
    ADD R0, R0, #-16   ; Convert ASCII to int
    BRnzp READ_INT     ; read character

READ_INT_NEG
    ADD R1, R1, #1     ; neg flag
    BRnzp READ_INT     ; read characters

READ_INT_DONE
    ; - sign when necesary 
    BRzp READ_INT_SKIP_NEG  ; skip when + 
    NOT R0, R0          ; stop result
    ADD R0, R0, #1      ; add 1 to stop 2's complement
READ_INT_SKIP_NEG
    RET

; Subroutine
PRINT_INT
    ; put into place like before
    RET

; Subroutine 
DIV
    ; put into place like before
    RET

; Data 
PROMPT1 .STRINGZ "Enter number of students: "
PROMPT2 .STRINGZ "Enter score for student: "
TOTAL_MSG .STRINGZ "Total Score: "
AVG_MSG .STRINGZ "Average Score: "
NEG_ASCII .FILL xFFD0 ; ASCII value of '-'

.END