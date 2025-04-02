#ifndef FT_LIST.H
#define FT_LIST.H

typedef struct    s_list
{
    struct s_list *next;
    void          *data;
} t_list;

#endif