#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

/*
 * If I had access to hashsets this would be like 5 lines of code.
 * Oh well.
 */

bool inArray(const char* array, char c, int size) {
    for (int i = 0; i < size; i++) {
        if (array[i] == c) {
            return true;
        }
    }

    return false;
}

// Returns the common elements of a and b and the number of common elements
int intersect(const char* a, size_t a_size, const char* b, size_t b_size, char* intersections) {
    int count = 0;
    for (int i = 0; i < a_size; i++) {
        for (int j = 0; j < b_size; j++) {
            if (a[i] == b[j] && !inArray(intersections, a[i], count)) {
                intersections[count] = a[i];
                count++;
            }
        }
    }

    return count;
}

// a-z = 1-26, A-Z = 27-52
int get_priority(char item) {
    if (item <= 'a') {
        return item - 'A' + 27;
    } else {
        return item - 'a' + 1;
    }
}

int part1(FILE* input) {
    int sum = 0;
    char* rucksack = NULL;
    size_t buffer_size;
    ssize_t rucksack_size;

    while (rucksack_size = getline(&rucksack, &buffer_size, input), rucksack_size != -1) {
        size_t size = rucksack_size / 2; // Will always round down, -1 not needed

        char intersection; // Only one common item
        char* compartment_a = rucksack;
        char* compartment_b = rucksack + size;
        intersect(compartment_a, size, compartment_b, size, &intersection);
        sum += get_priority(intersection);
    }

    free(rucksack);
    return sum;
}

int part2(FILE* input) {
    int sum = 0;
    char* rucksack_a = NULL;
    char* rucksack_b = NULL;
    char* rucksack_c = NULL;
    size_t a_buffer_size;
    size_t b_buffer_size;
    size_t c_buffer_size;

    while (true) {
        char intersections[26 * 2]; // At most 26 * 2 common items
        char badge;

        ssize_t a_size = getline(&rucksack_a, &a_buffer_size, input) - 1;

        // EOF
        if (a_size == -2) {
            break;
        }

        ssize_t b_size = getline(&rucksack_b, &b_buffer_size, input) - 1;
        ssize_t c_size = getline(&rucksack_c, &c_buffer_size, input) - 1;

        // Intersect rucksack_a and rucksack_b
        int a_b_size = intersect(rucksack_a, a_size, rucksack_b, b_size, intersections);

        // Intersect the intersection with rucksack_c to get the badge
        intersect(intersections, a_b_size, rucksack_c, c_size, &badge);
        sum += get_priority(badge);
    }

    free(rucksack_a);
    free(rucksack_b);
    free(rucksack_c);

    return sum;
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Usage: day3 <input>");
    }

    char* input_path = argv[1];
    FILE* input = fopen(input_path, "r");

    printf("Part 1: %d\n", part1(input));
    fclose(input);

    input = fopen(input_path, "r");

    printf("Part 2: %d\n", part2(input));
    fclose(input);

    return 0;
}
