#include "bsq.h"


void load_ele(FILE *f)
{
    
}

void mallocing_map(FILE *f)
{

}

void run_bsq(FILE *f)
{
    t_map *m;
    t_ele *ele;
    int i;
    load_ele(f);
    mallocing_map(f);
}

int main(int ac, char **av)
{
    if(ac == 1)
        run_bsq(stdin);
    else if(ac == 2)
    {
        FILE * f = fopen(av[1], "r");
        if(!f)
            return 1;
        run_bsq(f);
        close(f);
    }
    else 
        return 1;
    return 0;
}