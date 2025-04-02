
#include <unistd.h>

void manno(unsigned char byte)
{
   int i = 7;
   while(i >= 0)
   {
    if((byte >> i) & 1)
        write(1, "1", 1);
    else
        write(1, "0", 1);
    i--;
   }
}

int main(int ac, char  **av)
{
    unsigned char byte = *av[1];
    manno(byte);
    return(0);
}