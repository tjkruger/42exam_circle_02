#ifndef BUFFER_SIZE
#define BUFFER_SIZE 42
#endif

#include <unistd.h>
#include <stdlib.h>

char *ft_strdup(char *str)
{
	char *dup;
	char *start;
	int len = 0;

	while (str[len] != '\0')
		len++;
	dup = (char *)malloc(sizeof(char) * (len + 1));
	if (!dup)
		return NULL;
	start = dup;
	while (*str)
		*dup++ = *str++;
	*dup = '\0';
	return (start);
}

char *get_next_line(int fd)
{
	static int pos;
	static int rd;
	static char buf[BUFFER_SIZE];
	int i = 0;
	char line[70000];

	if (fd < 0 || BUFFER_SIZE <= 0)
		return NULL;
	while (1)
	{
		if (pos >= rd)
		{
			rd = read(fd, buf, BUFFER_SIZE);
			pos = 0;
			if (rd <= 0)
				break;
		}
		line[i] = buf[pos++];
		if (line[i] == '\n')
		{
			i++;
			break;
		}
		i++;
	}
	if (i == 0)
		return NULL;
	line[i] = '\0';
	return (ft_strdup(line));
}