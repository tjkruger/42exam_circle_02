#include <unistd.h>

void repeat_alpha(char *str)
{
    int counter = 0;
    int i = 0;

    while(str[i] != '\0')
    {
        counter = 0;
        while(counter <= str[i] - 'a')
        {
            write(1, &str[i], 1);
            counter++;
        }
        i++;
    }
}


int main()
{
    char str[] = "";
    repeat_alpha(str);
}