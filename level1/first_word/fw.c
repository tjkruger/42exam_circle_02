#include <unistd.h>

int main(int ac, char **str)
{
    int i = 0;
    if(ac == 2)
    {
        while(str[1][i] < 65 || (str[1][i] > 90 && str[1][i] < 97) || str[1][i] > 122)        
            i++;
        while((str[1][i] >= 65 && str[1][i] <= 90) || (str[1][i] >= 97 && str[1][i] <= 122))
        {
            write(1, &str[1][i], 1);
            i++;
        }
    }
    write(1, "\n", 1);
}