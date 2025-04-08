#include <stdlib.h>

#include <stdlib.h>

int is_space(char c) 
{
	if(c == ' ' || (c >= 9 && c <= 13))
		return(1);
	return(0);
}

int wordcount(char *s)
{
	int counter = 0;
	int inword = 0;
	while(*s)
	{
		if(!inword && !is_space(*s))
		{
			inword = 1;
			counter++;
		}
		else if(is_space(*s))
			inword = 0;
		s++;
	}
	return(counter);
}

char *word(char *s, char *new_s) 
{
    int i = 0;
	while(s[i] && !is_space(s[i]))
		i++;
	new_s = malloc(sizeof(char) * (i + 1));
	new_s[i + 1] = '\0';
	i = 0;
	while(s[i] && !is_space(s[i]))
	{
		new_s[i] = s[i];
		i++;
	}
	return(new_s);
}

char **ft_split(char *str) 
{
	if (!str)
		return NULL;
	char **new_s = (char **)malloc((wordcount(str) + 1) * sizeof(char *));
	if(!new_s)
		return NULL;
	int i = 0;
	int j = 0;
	while(str[i])
	{
		if(is_space(str[i]))
			i++;
		else
		{
			new_s[j] = word((char *)str + i, new_s[j]);
			j++;
			while(str[i] && !is_space(str[i]))
				i++;
		}
	}
	new_s[j] = NULL;
	return(new_s);
}









#include <stdio.h>
int main(void)
{
    char *s = "  Hello\tthere\nfriend  \t how  are you  ";
    char **words = ft_split(s);

    if (!words)
        return (1);

    int i = 0;
    while (words[i])
    {
        printf("Word %d: \"%s\"\n", i, words[i]);
        i++;
    }

    // (Optional) Free all the allocated strings afterwards to avoid memory leaks
}