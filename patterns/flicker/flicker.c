#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>

#define PI 3.1415926

#define random(min,max) myRandom(min,max)

struct {
  int step[4];
} Toy;

// Turn on all outputs slightly offset from each other.
int pattern(int seq) {
  // set all motors initally to -1, ie "leave it alone"
  Toy.step[0] = Toy.step[1] = Toy.step[2] = -1;

  if (seq > 2) {
    Toy.step[3] = 200;
  } else {
    Toy.step[3] = 20;
  }

  seq %= 3;
  Toy.step[seq] = 80;

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
