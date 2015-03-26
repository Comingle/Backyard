#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>

#define PI 3.1415926

#define random(min,max) myRandom(min,max)

struct {
  int step[4];
} Toy;

int pattern(int seq) {
  // cos sequence takes 158 steps to run. start motor 1 a third of the way in (53 steps), start motor 2 2/3 (106 steps) of the way in.
  Toy.step[0] = round(127 * cos((seq / (8*PI))-PI) + 127);
  if (seq >= 58) {
    Toy.step[1] = round(127 * cos(((seq-58) / (8*PI))-PI) + 127);
  }
  if (seq >= 106) {
    Toy.step[2] = round(127 * cos(((seq-106) / (8*PI))-PI) + 127);
  }
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
