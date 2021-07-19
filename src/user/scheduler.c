
#include "task_queue.h"

extern void return_context(int pc, int ps, int a0, int a1);

void runTask(Task t) {
    return_context(t.PC, t.PS, t.registers[0], t.registers[1]);
}

// Called at the beginning of each quanta to run the next task
void scheduleTask() {
    queueTask(current_task);
    Task t = getNextTask();
    current_task = t;
    runTask(t);
}

// Same as the scheduler but don't put the finished task back into the queue
void exitTask() {
    Task t = getNextTask();
    current_task = t;
    runTask(t);
}

void enter_scheduler(int pc, int ps, int a0, int a1) {
    current_task = (Task) {current_task.pid, current_task.priority, pc, ps, {a0, a1}};
    scheduleTask();
}

// Add a new task to the scheduler with given priority
void runNewTask(void (*taskFunction)(), int priority) {
    int pid = 0; // TODO: Make increasing
    //int pc = taskFunction; Instead of calling the function with call0, we will just set the program counter to the beginning and set the other relavent registers.
    int ps = 0x00000000; // Initialize the ps to what it should be
    void (* a0)() = &exitTask; // if the spawned task returns, set the return adress to the scheduler, this should be changed to 
    int a1 = 0x00000000; // A new stack frame needs to be initialized, not too sure what to do for that though
    queueTask((Task) {pid, priority, taskFunction, ps, {a0, a1}});
}
