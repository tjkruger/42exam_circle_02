#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>

int ft_popen(const char *file, const char *argv[], char type)
{
    pid_t   pid;
    int     fd[2];

    if(!file || !argv || (type != 'r' && type != 'w'))
        return -1;
    if (pipe(fd) == -1)
        return(-1);
    pid = fork();
    if(pid == -1)
    {
        close(fd[0]);
        close(fd[1]);
        return(-1);
    }
    if(pid == 0)
    {
        if(type == 'r')
        {
            if(dup2(fd[1], STDOUT_FILENO) == -1)
                exit(EXIT_FAILURE);
        }
        else
        {
            if(dup2(fd[0], STDIN_FILENO) == -1)
                exit(EXIT_FAILURE);
        }
        close(fd[0]);
        close(fd[1]);
        execvp(file, (char * const *)argv);
        exit(EXIT_FAILURE);
    }
    if(type == 'r')
    {
        close(fd[1]);
        return(fd[0]);
    }
    else
    {
        close(fd[0]);
        return(fd[1]);
    }

}