
    .begin      literal_prefix .MaxDebugExceptionVector
    .section    .MaxDebugExceptionVector.text
    .global     _MaxDebugExceptionVector
    .type _MaxDebugExceptionVector, @function
_MaxDebugExceptionVector:
    //break   1, 2
    //wsr a0, EXCSAVE1
    .extern _DebugExceptionVector
    j   _DebugExceptionVector

    .end literal_prefix

    .begin      literal_prefix .MaxNMIExceptionVector
    .section    .MaxNMIExceptionVector.text
    .global     _MaxNMIExceptionVector
    .type _MaxNMIExceptionVector, @function
_MaxNMIExceptionVector:
    .extern _NMIExceptionVector
    j           _NMIExceptionVector
    /* TODO */
    //.literal_position
    //call0 _NMIExceptionVector

    .end literal_prefix

    .begin      literal_prefix .MaxKernelExceptionVector
    .section    .MaxKernelExceptionVector.text
    .global     _MaxKernelExceptionVector
    .type _MaxKernelExceptionVector, @function
_MaxKernelExceptionVector:
    /*save a0 for now */
    /*wsr     a0, EXCSAVE1
    .literal_position
    call0 MaxKernelExceptionHandler */
    .extern _KernelExceptionVector
    j _KernelExceptionVector

    .end literal_prefix


    .begin      literal_prefix .MaxUserExceptionVector
    .section    .MaxUserExceptionVector.text
    .global     _MaxUserExceptionVector
    .type _MaxUserExceptionVector, @function
_MaxUserExceptionVector:
    /*save a0 for now */
    wsr     a0, EXCSAVE1
    //.literal_position
    j UserExceptionHandler

    .end literal_prefix


    .begin      literal_prefix .MaxDoubleExceptionVector
    .section    .MaxDoubleExceptionVector.text
    .global     _MaxDoubleExceptionVector
    .type _MaxDoubleExceptionVector, @function
_MaxDoubleExceptionVector:
    //break       1, 4
    .extern _DoubleExceptionVector
    j           _DoubleExceptionVector
    /* TODO */
    //.literal_position
    //call0 _DoubleExceptionVector

    .end literal_prefix



#define EXCCAUSE_LEVEL1INTERRUPT 0x10000


    .section    .entry.text
    .global     UserExceptionHandler
    .type UserExceptionHandler, @function
    .literal_position
UserExceptionHandler:
    break   1, 3

    mov     a0, a1                  
    addi    a1, a1, -72   /* allocate interrupt stack frame, 72 is currently the stack size in bytes needed to store the general registers + PC and PS */
    s32i    a0, a1, 0               /* save pre-interrupt a1 */
    rsr     a0, PS                  /* save interruptee's PS */
    s32i    a0, a1, 4
    rsr     a0, EPC1               /* save interruptee's PC */
    s32i    a0, a1, 8
    rsr     a0, EXCSAVE1           /* save interruptee's a0 */
    s32i    a0, a1, 12

    /* If level1 interrupt call l1int */
    rsr     a0, EXCCAUSE
    wsr     a1, EXCSAVE1
    movi    a1, 0x4
    beq    a0, a1, l1int

    /* Add handlers for other interrupt levels if necessary */
    .extern _UserExceptionVector
    j       _UserExceptionVector

    .section    .entry.text
    .global     MaxKernelExceptionHandler
    .type MaxKernelExceptionHandler, @function
MaxKernelExceptionHandler:

    mov     a0, a1                  
    addi    a1, a1, -72   /* allocate interrupt stack frame, 72 is currently the stack size in bytes needed to store the general registers + PC and PS */
    s32i    a0, a1, 0               /* save pre-interrupt a1 */
    rsr     a0, PS                  /* save interruptee's PS */
    s32i    a0, a1, 4
    rsr     a0, EPC1               /* save interruptee's PC */
    s32i    a0, a1, 8
    rsr     a0, EXCSAVE1           /* save interruptee's a0 */
    s32i    a0, a1, 12

    /* If level1 interrupt call l1int */
    rsr     a0, EXCCAUSE
    wsr     a1, EXCSAVE1
    movi    a1, 0x10000
    beq    a0, a1, l1int

    /* Add handlers for other interrupt levels if necessary */





/* From xtensa hal for esp-32, 
Timer 0 interrupt: 6
Timer 1 interrupt: 15
Timer NMI interrupt: 14
*/

#define TIMER_MASK 0x1000000
    .section .entry.text
    .global l1int
    .type l1int, @function
l1int:

    /* Check to see if timer interrupt */
    rsr a0, INTERRUPT
    movi a1, TIMER_MASK
    and a1, a0, a1

    .extern timer_interrupt_enter
    bnez a1, timer_interrupt_enter

    .extern _UserExceptionVector
    j       _UserExceptionVector
