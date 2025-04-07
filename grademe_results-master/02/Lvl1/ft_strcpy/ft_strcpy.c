char    *ft_strcpy(char *s1, char *s2)
{
	int	temp;

	temp = 0;
	while (*s1 && *s2)
	{
		s2[temp] = s1[temp];
		temp++;
	}
	return (s2);
}
