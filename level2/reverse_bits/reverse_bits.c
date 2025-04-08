

#include <unistd.h>

unsigned char	reverse_bits(unsigned char octed)
{
	int i = 0;
	unsigned char res = 0;
	while(i <= 7)
	{
		res <<= 1;
		res |= (octed & 1);
		octed >>= 1;
		i++;
	}
	return(res);
}

void print_bits(unsigned char c)
{
	int i = 7;
	while(i >= 0)
	{
		if((c >> i) & 1)
			write(1, "1", 1);
		else
			write(1, "0", 1);
		i--;
	}
	write(1, "\n", 1);
}



#include <stdio.h>


int main() {
    unsigned char num = 73;  // Example number in binary: 00000101
    printf("Original number: %d\n", num);
    printf("Original in binary: ");
    print_bits(num);  // Assuming print_bits is defined as in your previous code
    printf("\n");

    unsigned char reversed = reverse_bits(num);  // Reverse the bits
    printf("Reversed number: %d\n", reversed);
    printf("Reversed in binary: ");
    print_bits(reversed);  // Assuming print_bits is defined as in your previous code
    printf("\n");

    return 0;
}