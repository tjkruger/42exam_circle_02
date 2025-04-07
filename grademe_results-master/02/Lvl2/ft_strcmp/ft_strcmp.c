#include <stdio.h>
#include <string.h>

int    ft_strcmp(char *s1, char *s2)
{
	int temp = 0;
	while (s1[temp] != '\0' || s2[temp] != '\0')
	{
		if (s1[temp] != s2[temp])
			return (s1[temp] - s2[temp]);
		temp++;
	}
	return (0);
}

// int main() {
//     char *str1 = "Hello";
//     char *str2 = "Hello";
//     char *str3 = "World";
//     char *str4 = "Hello, World!";

//     printf("ft_strcmp(str1, str2) = %d\n", ft_strcmp(str1, str2));
// 	printf("strcmp(str1, str2) = %d\n", strcmp(str1, str2));
//     printf("ft_strcmp(str1, str3) = %d\n", ft_strcmp(str1, str3));
//     printf("strcmp(str1, str3) = %d\n", strcmp(str1, str3));
//     printf("ft_strcmp(str1, str4) = %d\n", ft_strcmp(str1, str4));
//     printf("strcmp(str1, str4) = %d\n", strcmp(str1, str4));

//     return 0;
// }