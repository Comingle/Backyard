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
  // neat exponential sequence inspired by github/jgeisler0303
  const uint8_t fadeTable[32] = {0, 1, 1, 2, 2, 2, 3, 3, 4, 5, 6, 7, 9, 10, 12, 15, 17, 21, 25, 30, 36, 43, 51, 61, 73, 87, 104, 125, 149, 178, 213, 255};
  seq %= 32;
  Toy.step[0] = Toy.step[1] = Toy.step[2] = fadeTable[seq];
  Toy.step[3] = 12 ;
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
    
  printf("{ \"steps\": [");
  while (startStep < endStep-1) {
    pattern(startStep);
    printf("[ %d, %d, %d, %d ],", Toy.step[0], Toy.step[1], Toy.step[2], Toy.step[3]);
    startStep++;
  }
  pattern(startStep);  
  printf("[ %d, %d, %d, %d ]]}\n", Toy.step[0], Toy.step[1], Toy.step[2], Toy.step[3]);

  return 1;
}

int myRandom(int min, int max) {
  return rand()%(max-min)+min;
}
