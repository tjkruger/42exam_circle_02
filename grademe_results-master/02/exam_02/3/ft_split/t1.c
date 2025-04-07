#include <stdlib.h>

int wrdlen(char *str)
{
	int i = 0;
	while (str[i] != ' ' && str[i] != '\t' && str[i] != '\n' && str[i] != '\0')
		i++;
	return (i);
}
char *word_dupe(char *str)
{
	int i = 0;
	int len = wrdlen(str);
	char *word = malloc(sizeof(char) * (len + 1));
	word[len] = '\0';
	while (i < len)
	{
		word[i] = str[i];
		i++;
	}
	return (word);
}

void fill_words(char **array, char *str)
{
	int idx = 0;
	while (*str == ' ' || *str == '\t' || *str == '\n')
		str++;
	while (*str != '\0')
	{
		array[idx] = word_dupe(str);
		idx++;
		while (*str != ' ' && *str != '\t' && *str != '\n' && *str != '\0')
			str++;
		while (*str == ' ' || *str == '\t' || *str == '\n')
			str++;
	}
}

int count_words(char *str)
{
	int count = 0;
	while (*str == ' ' || *str == '\t' || *str == '\n')
		str++;
	while (*str != '\0')
	{
		count++;
		while (*str != ' ' && *str != '\t' && *str != '\n' && *str != '\0')
			str++;
		while (*str == ' ' || *str == '\t' || *str == '\n')
			str++;
	}
	return (count);
}

char **ft_split(char *str)
{
	int num_words = 0;
	char **array;

	num_words = count_words(str);
	array = malloc(sizeof(char *) * (num_words + 1));
	array[num_words] = 0;
	fill_words(array, str);
	return (array);
}
