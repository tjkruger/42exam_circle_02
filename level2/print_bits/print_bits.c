<<<<<<< HEAD

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
=======
// Write a function that takes a byte,
// 	and prints it in binary WITHOUT A NEWLINE AT THE END.

// 		Your function must be declared as follows :

// 	void
// 	print_bits(unsigned char octet);

// Example, if you pass 2 to print_bits, it will print "00000010"

#include <unistd.h>

void print_bits(unsigned char octet)
{
	int i = 7;
	while (i >= 0)
	{
		if((octet >> i) & 1)
			write(1, "1", 1);
		else
			write(1, "0", 1);
		i--;
	}
}

#include <stdio.h>


int	main(void)
{
	unsigned char n1 = 5;   // Binary: 00000101
	unsigned char n2 = 255; // Binary: 11111111
	unsigned char n3 = 73;  // Binary: 00101010
	unsigned char n4 = 0;   // Binary: 00000000

	printf("5   -> "); print_bits(n1); printf("\n");
	printf("255 -> "); print_bits(n2); printf("\n");
	printf("73  -> "); print_bits(n3); printf("\n");
	printf("0   -> "); print_bits(n4); printf("\n");

	return (0);
}
>>>>>>> origin/main
