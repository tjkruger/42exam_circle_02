

#include <stdlib.h>


int is_space(char c)
{
    if(c <= 32)
        return(1);
    return(0);
}

char *word(char *str)
{
    int i =  0;
    while(!is_space(str[i]) && str[i])
        i++;
    char *new_s = malloc(sizeof(char) * (i + 1));
    new_s[i] = '\0';
    i = 0;
    while(!is_space(str[i]) && str[i])
    {
        new_s[i] = str[i];
        i++;
    }
    return(new_s); 
}

int wordcount(char *s)
{
    int counter = 0;
    int flag = 0;
    while(*s)
    {
        if(!flag && !is_space(*s))
        {
            flag = 1;
            counter++;
        }
        else if(is_space(*s))
            flag = 0;
        s++;
    }
    return(counter);
}

char    **ft_split(char *str)
{
    if(!str)
        return NULL;
    char **new_s = (char **)malloc(sizeof(char *) * (wordcount(str) + 1));
    if (!new_s)
        return NULL;
    int i = 0;
    int j = 0;
    while(str[i])
    {
        if(is_space(str[i]))
            i++;
        else
        {
            new_s[j] = word((char *)str + i);
            j++;
            while(!is_space(str[i]))
                i++;
        }
    }
    new_s[j] = NULL;
    return(new_s);
}














#include <stdio.h>

int main() {
    char **result = ft_split("Hello   world  split  this  string!");
    
    // Print the result to check
    for (int i = 0; result[i] != NULL; i++) {
        printf("Word %d: %s\n", i, result[i]);
    }

    // Free memory
    for (int i = 0; result[i] != NULL; i++) {
        free(result[i]);
    }
    free(result);

    return 0;
}