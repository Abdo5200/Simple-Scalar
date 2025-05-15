#include <stdio.h>

int main() {
    int i, j, k;
    int toggle = 0;
    int count = 0;

    for (i = 0; i < 100; i++) {
        if ((i % 5) == 0) {
            toggle = !toggle;  // Every 5 iterations, change behavior
        }

        // This branch depends on toggle, which depends on history
        if (toggle) {
            for (j = 0; j < 3; j++) {
                if ((j + i) % 2 == 0) {
                    count++;
                }
                printf("true %d\n",count);
            }
        } else {
            for (k = 0; k < 2; k++) {
                if ((k * i) % 3 == 1) {
                    count--;
                }
                printf("false %d\n",count);
            }
        }
    }

    printf("Final count: %d\n", count);
    return 0;
}
