#include <stdio.h>
#include <stdlib.h>

static char *s;

int	parse_expression(void);

void	throw_error(char c)
{
	if(c == '\0')
		printf("someting about not beeing the end of the string or so\n");
	else
		printf("unexpected token %c\n", c);
	exit(1);
}

int parse_factor(void)
{
	int val;
	if(*s == '(')
	{
		s++;
		val = parse_expression();
		if(*s != ')')
			throw_error(*s);
		s++;
		return(val);
	}
	if(*s >= '0' && *s <= '9')
		return(*s++ - '0');
	throw_error(*s);
	return(0);
}

int parse_term(void)
{
	int val;

	val = parse_factor();
	while(*s == '*')
	{
		s++;
		if(*s == '\0')
			throw_error('\0');
		val *= parse_factor();
	}
	return(val);
}


int	parse_expression(void)
{
	int val;

	val = parse_term();
	while(*s == '+')
	{
		s++;
		if(*s == '\0')
			throw_error('\0');
		val += parse_term();
	}
	return(val);
}


int main(int ac, char **av)
{
	int res;
	s = av[1];
	if(ac != 2)
		return(1);
	if(!s)
	{
		throw_error(*s);
		return(1);
	}
	res = parse_expression();
	if(*s != '\0')
		throw_error(*s);
	printf("%i\n", res);
	return(0);
}