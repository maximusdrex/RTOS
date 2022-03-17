
.section .text
.global save_high_registers
save_high_registers:

    /*
    Have the current stack pointer for the task in register a1.
    First, add 4 bytes to the address of the stack pointer to make room for the registers
    */

    /* Allocate space for the registers 
    addi a1, a1, -56
    This is done before now */

    /* Need to add 16 to each offset */
    s32i a4, a1, 0
    s32i a5, a1, 4
    s32i a6, a1, 8
    s32i a7, a1, 12
    s32i a8, a1, 16
    s32i a9, a1, 20
    s32i a10, a1, 24
    s32i a11, a1, 28
    s32i a12, a1, 32
    s32i a13, a1, 36
    s32i a14, a1, 40
    s32i a15, a1, 44
    s32i a2, a1, 48
    s32i a3, a1, 52
    
    ret

.section .text
.literal_position
.global load_high_registers
load_high_registers:

    /*
    Have the stack pointer for the task in register a1. Need to add 16 to each offset
    */
    l32i a4, a1, 4
    l32i a5, a1, 0
    l32i a6, a1, 8
    l32i a7, a1, 12
    l32i a8, a1, 16
    l32i a9, a1, 20
    l32i a10, a1, 24
    l32i a11, a1, 28
    l32i a12, a1, 32
    l32i a13, a1, 36
    l32i a14, a1, 40
    l32i a15, a1, 44
    l32i a2, a1, 48
    l32i a3, a1, 52

    addi a1, a1, 56
    ret
    
.begin literal_prefix .restore_context
.section .text
.align 4
.global restore_context
.type restore_context, @function
restore_context:

    /* This is to be called as a C function: void restore_context(int pc, int ps, int a0, int a1)
    This puts pc in a2, ps in a3, a0 in a4, and a1 in a5 */
    wsr a2, EPC1
    wsr a3, PS
    //wsr a3, EPS1 this needs to change, the PS is only saved to EPS1 in processors with the high-level interrupt option
    mov a0, a4
    mov a1, a5
    call0 load_high_registers
    RFE

    .end literal_prefix

.begin literal_prefix .timer_interrupt_enter
.section .text
.align 4
.global timer_interrupt_enter
.type timer_interrupt_enter, @function
timer_interrupt_enter:
    .global enter_scheduler

    /*  save all registers except a0-a1*/

    /* restore the interrupt stack pointer */
    rsr a1, EXCSAVE1

    call0 save_high_registers
    l32i a2, a1, 8
    l32i a3, a1, 4
    l32i a4, a1, 12
    mov a5, a1

    //TODO setup stack frame here
    call0 enter_scheduler
    // call0 jumps to the scheduler and should never return

    .end literal_prefix