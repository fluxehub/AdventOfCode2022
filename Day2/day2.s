// Reading an address is annoying in Mach-O so here's a macro to make it easier
.macro LOAD reg, addr
    adrp    \reg, \addr@PAGE
    add     \reg, \reg, \addr@PAGEOFF
.endm

// Writing this 100 times sure gets old!
.macro PUSHLR
    str     lr, [sp, -0x10]!
.endm

.macro POPLR
    ldr     lr, [sp], 0x10
.endm

.global _start             // Provide program starting address to linker
.align 2

// These registers store score constants
// Registers are used instead of immediates so that the csel opcode can be used
rock        .req x20
paper       .req x21
scissors    .req x22
win_bonus   .req x23
draw_bonus  .req x24

// Reads the file into the buffer
// x0: filename
read_file:
    // Open the file
    mov     x1, #0                  // Read
    mov     x2, #0                  // No flags
    mov     x16, #5                 // Open syscall
    svc     0                       // x0 now contains the fd

    // Read the file into our buffer
    mov     x19, x0                 // Save the fd to x19 temporarily
    LOAD    x1, buffer              // Load the buffer address
    mov     x2, #9999               // The buffer is 9999 bytes
    mov     x16, #3                 // Read syscall
    svc     0

    // Close the file
    mov     x0, x19                 // Retrieve the fd                
    mov     x16, 6                  // Close the file
    svc     0
    ret

// Converts a character to a move
// w0: Contains the move character, can be A,B,C or X,Y,Z
// Returns the move
get_move:
    sub     w0, w0, #65             // This allows ccmp to work, as the immediate must be [0, 31]
    
    cmp     w0, #0                  // 'A'
    ccmp    w0, #23, 0b0100, ne     // || 'X'
    csel    x0, rock, x0, eq        // Set x0 to rock if equal
    beq     get_move_end            // Return

    cmp     w0, #1                  // 'B'
    ccmp    w0, #24, 0b0100, ne     // || 'Y'
    csel    x0, paper, x0, eq
    beq     get_move_end

    cmp     w0, #2                  // 'C'
    ccmp    w0, #25, 0b0100, ne     // || 'Z'
    csel    x0, scissors, x0, eq

    get_move_end:
    ret

// Gets the move that beats x0
get_win:
    cmp     x0, rock
    csel    x0, paper, x0, eq       // Paper beats rock
    beq     get_win_end

    cmp     x0, paper
    csel    x0, scissors, x0, eq    // Scissors beats paper
    beq     get_win_end

    cmp     x0, scissors
    csel    x0, rock, x0, eq        // Rock beats scissors

    get_win_end:
    ret

// Get the move that loses to x0
get_loss:
    cmp     x0, rock
    csel    x0, scissors, x0, eq    // Rock beats scissors
    beq     get_loss_end

    cmp     x0, paper
    csel    x0, rock, x0, eq        // Paper beats rock
    beq     get_loss_end

    cmp     x0, scissors
    csel    x0, paper, x0, eq       // Scissors beats paper

    get_loss_end:
    ret

// Scores a round (part 1)
// w0: Opponent's move (char)
// w1: Our move (char)
// Returns the score
score_round:
    PUSHLR
    bl      get_move                // Get opponent's move
    mov     x2, x0                  // Save the opponent's move to x2
    mov     w0, w1                  // Get our move
    bl      get_move                // Our move is now in x0
    POPLR

    mov     x1, xzr                 // Clear x1 for storing the win/draw bonus

    // Handle wrapping cases (rock and scissors)
    cmp     x0, rock
    ccmp    x2, scissors, #0, eq
    csel    x1, win_bonus, x1, eq   // Rock beats scissors
    beq     score_round_end         

    cmp     x0, scissors
    ccmp    x2, rock, #0, eq
    beq     score_round_end         // We lost to rock

    // Otherwise it's a simple eq, lt, gt check
    cmp     x0, x2
    csel    x1, win_bonus, x1, gt   // If greater than, we won
    csel    x1, draw_bonus, x1, eq  // If equal, it's a draw
    b       score_round_end         // Otherwise it's a loss

    score_round_end:      
    add     x0, x0, x1              // Add bonus to x0
    ret     

// Scores the moves in the buffer and returns it
part1:
    PUSHLR
    mov     x7, #0                  // Sum in x7
    LOAD    x8, buffer              // Buffer address in x8

    part1_loop:
        ldrb    w0, [x8]            // Read the opponent's move
        cmp     w0, wzr             // Null byte, EOF
        beq     part1_end
        ldrb    w1, [x8, #2]        // Read our move
        bl      score_round
        
        add     x7, x7, x0          // Add score to sum
        add     x8, x8, #4          // Increment buffer to next move
        b       part1_loop          // Loop back

    part1_end:
    POPLR
    mov     x0, x7                  // Return score
    ret


// As above, so below
part2:
    PUSHLR
    mov     x7, #0                  // Sum in x7
    LOAD    x8, buffer              // Buffer address in x8

    part2_loop:
        ldrb    w0, [x8]            // Read the opponent's move
        cmp     w0, wzr             // Null byte, EOF
        beq     part2_end
        bl      get_move            // Get the move for the char in w0
        ldrb    w1, [x8, #2]        // Read our move

        cmp     w1, #88             // If 'X', we need to lose
        beq     part2_loss
        cmp     w1, #89             // If 'Y', we need to draw
        beq     part2_draw
        cmp     w1, #90             // If 'Z', we need to win
        beq     part2_win

        part2_loss:
        bl      get_loss    
        b       part2_add_move     // No extra score for loss

        part2_draw:
        add     x7, x7, #3          // x0 already contains our opponent's move so we can just add the bonus
        b       part2_add_move

        part2_win:
        bl      get_win
        add     x7, x7, #6          // Add the win bonus
        b       part2_add_move
        
        part2_add_move:
        add     x7, x7, x0          // Add move score to sum
        add     x8, x8, #4          // Increment buffer to next move
        b       part2_loop          // Loop back

    part2_end:
    POPLR
    mov     x0, x7                  // Return score
    ret

// Exits with code in x0
exit:
    mov     x16, #1                 // Exit syscall
    svc     0

// Exit the program if the arguments are wrong
bad_args:
    LOAD    x0, error
    bl      _printf
    mov     x0, 1                   // Return with error code 1
    b       exit                    // Exit

_start:
    // Get input file name from argc and argv
    cmp     x0, #2                  // Usage is day2 <file>, make sure there's 2 arguments
    bne     bad_args                // Exit if argc is wrong
    
    ldr     x0, [x1, #8]            // argv[1] has the filename
    bl      read_file

    // Initialize constants
    mov     rock, #1
    mov     paper, #2
    mov     scissors, #3
    mov     draw_bonus, #3
    mov     win_bonus, #6

    bl      part1
    str     x0, [sp]
    LOAD    x0, part1_out
    bl      _printf                 // I could spend hours of my ever shortening life 
                                    // writing an int -> string converter in assembly
                                    // or I could use printf

    bl      part2
    str     x0, [sp]
    LOAD    x0, part2_out
    bl      _printf

    mov     x0, #0                  // Exit with success code
    b       exit     

.data
    error:      .string "Invalid number of arguments\nUsage: day2 <input file>\n"
    part1_out:  .string "Part 1: Total score is %d\n"
    part2_out:  .string "Part 2: Total score is %d\n"
    
.bss
    buffer: .space 10000            // The input file is 9999 bytes at *most*
    