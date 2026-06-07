#include <stdio.h>
#include <stdlib.h>

static char *s;

int parse_expression(void);

void    throw_error(char c)
{
    if(c == '\0')
        printf("something about the end of the line");
    else
        printf("unexpected token '%c'", c);
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
        {
            throw_error('\0');
        }
        val *= parse_factor();
    }
    return(val);
}

int parse_expression(void)
{
    int val;

    val = parse_term();
    while(*s =='+')
    {
        s++;
        if(*s == '\0')
            throw_error('\0');
        val += parse_term();
    }
    return(val);
}

int main(int c, char **v)
{
    if(c != 2)
        return(0);
    s = v[1];
    if(!s)
        throw_error('\0');
    int res;

    res = parse_expression();
    if(*s != '\0')
        throw_error(*s);
    printf("%i \n", res);

    return(1);
}