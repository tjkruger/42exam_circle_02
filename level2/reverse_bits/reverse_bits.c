

#include <unistd.h>

unsigned char	reverse_bits(unsigned char octed)
{
	int				i;
	unsigned char	result;

	i = 7;
	result = 0;
	while (i >= 0)
	{
		result |= ((octed >> i) & 1) << (7 - i);
		i--;
	}
	return (result);
}
