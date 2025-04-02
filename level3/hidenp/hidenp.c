#include <unistd.h>


int is_instr(char *str, char *in)
{
    int i = 0;
    int j = 0;
    int temp = 0;
    while(in[i] != '\0')
    {
        if(str[j] == in[i])
            j++;
        i++;
    }
    if(str[j] == '\0')
        return(1);
    else
        return(0);
}

int main(int ac, char **av)
{
    if (ac == 3)
    {
        int erg;
        erg = is_instr(av[1], av[2]);
        if (erg == 1)
            write(1, "1", 1);
        else
            write(1, "0", 1);
    }
    write(1, "\n", 1);
}