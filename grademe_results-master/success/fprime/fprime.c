#include <stdio.h>
#include <stdlib.h>

void print_prime_factors(int n) {
    int i = 2;
    int first = 1;

    while (n > 1) {
        while (n % i == 0) {
            if (!first) {
                printf("*");
            }
            printf("%d", i);
            n /= i;
            first = 0;
        }
        i++;
    }
    printf("\n");
}

int main(int argc, char **argv) {
    if (argc != 2) {
        printf("\n");
        return 1;
    }

    int n = atoi(argv[1]);
    if (n > 0) {
        print_prime_factors(n);
    } else {
        printf("\n");
    }

    return 0;
}
