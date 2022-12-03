#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

int **parse_inventories(char *filename);
void print_inventories(int **invs);

int part_one(int **inventories);
int part_two(int **inventories);

int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(stderr, "usage: ./day1 <inputfile>\n");
    exit(1);
  }

  char *filename = argv[1];

  int **inventories = parse_inventories(filename);

  print_inventories(inventories);

  return 0;
}

int **parse_inventories(char *filename) {
  FILE *infile = fopen(filename, "r");

  if (infile == NULL) {
    fprintf(stderr, "Error opening file!\n");
    exit(1);
  }

  char *line = NULL;
  size_t line_length = 0;

  // parsed input (null terminated)
  int **inventories = calloc(sizeof(int **), 1);
  int invs_size = 1;
  int current_inv_size = 0;

  while (getline(&line, &line_length, infile) != -1) {
    int value = atoi(line);

    // expand input array if new elf
    if (value == 0) {
      inventories = realloc(inventories, ++invs_size * sizeof(int *));
      current_inv_size = 0;
      continue;
    }

    // expand per-elf inventory
    inventories[invs_size - 1] = realloc(inventories[invs_size - 1], ++current_inv_size * sizeof(int));
    inventories[invs_size - 1][current_inv_size - 1] = value;
  }

  // make sure null terminator at end
  inventories = realloc(inventories, ++invs_size * sizeof(int *));
  inventories[invs_size - 1] = NULL;

  return inventories;
}

void print_inventories(int **invs) {
  // for each elf
  for (int i = 0; invs[i] != NULL; i++) {
    printf("Elf %i:\n", i + 1);

    // for each item in their inv
    for (int j = 0; invs[i][j] != 0; j++) {
      printf("%i ", invs[i][j]);
    }

    printf("\n\n");
  }
}

int sum(int* arr) {
  // arr is null terminated
  int sum = 0;

  for (int i = 0; arr[i] != 0; i++) {
    sum += arr[i];
  }

  return sum;
}

// PART 1
// How many calories is the elf with the maximum number of calories carrying ?
int part_one(int **inventories) {
  int largest = 0;
}

// PART 2
// What is the sum of the top three elves calories?
int part_two(int **inventories) {}
