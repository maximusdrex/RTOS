#ifndef task_queue_head
#define task_queue_head

// Store each task's priority and stack pointer
typedef struct task {
    int pid;
    int priority;
    int PC;
    int PS;
    int registers[2];
} Task;

Task current_task;

void queueTask(Task newTask);
Task getNextTask(void);


#endif