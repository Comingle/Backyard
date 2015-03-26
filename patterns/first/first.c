#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>

#define PI 3.1415926

#define random(min,max) myRandom(min,max)

struct {
  int step[4];
} Toy;

// First motor only
// Why have a 50ms timing on the step (Toy.step[3]) ? This lets you adjust the power of the pattern,
// so that instead of running [100, 0, 0, 50] the whole time, it might become [120, 0, 0, 50] after a button click
int pattern(int seq) {
  Toy.step[0] = 100;
  Toy.step[1] = 0;
  Toy.step[2] = 0;
  Toy.step[3] = 50;
  return 1;
}


int main(int argc, char *argv[]) {
  long startStep, endStep;
  if (argc > 2) {
    startStep = strtol(argv[1], (char **)NULL, 10);
    endStep = strtol(argv[2], (char **)NULL, 10);
  } else {
    startStep = 0;
    endStep = strtol(argv[1], (char **)NULL, 10);
  }

  if (startStep > endStep) {
    return -1;
  }
    
  printf("{ \"steps\": [\n");
  while (startStep < endStep-1) {
    pattern(startStep);
    printf("[ %d, %d, %d, %d ],\n", Toy.step[0], Toy.step[1], Toy.step[2], Toy.step[3]);
    startStep++;
  }
  pattern(startStep);  
  printf("[ %d, %d, %d, %d ]]}\n", Toy.step[0], Toy.step[1], Toy.step[2], Toy.step[3]);

  return 1;
}

int myRandom(int min, int max) {
  return rand()%(max-min)+min;
}
