/*

*/

#include "task_queue.h"

// Number of tasks in the queue
int tasks = 0;

// Array holding the queue
Task queue[100];

//Track the currently running task;
Task current_task;

// Add a task to the back of the queue
void queueTask(Task newTask)  {
    queue[tasks] = newTask;
    tasks++;
}

// Pop the next task with the highest priority
Task getNextTask(void) {
    int ind = 0;
    int priority = 0;

    // Find the highest priority task
    int i;
    for (i = 0; i < tasks; i++) {
        if(queue[i].priority > priority) {
            ind = i;
            priority = queue[i].priority;
        }
    }
    Task nextTask = queue[ind];

    // Shift all tasks after ind up the queue
    for(i = ind; i < tasks; i++) {
        queue[i] = queue[i+1];
    }

    tasks--;
    return nextTask;
}

void dequeueTask(Task t) {
    int i;
    int ind;
    for (i = 0; i < tasks; i++) {
        if(queue[i].pid == t.pid) {
            ind = i;
            break;
        }
    }
    // Shift all tasks starting at ind up the queue
    for(i = ind; i < tasks; i++) {
        queue[i] = queue[i+1];
    }

    tasks--;
}