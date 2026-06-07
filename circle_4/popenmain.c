#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int ft_popen(const char *file, char const *argv[], char type);

int main(void)
{
    int     fd;
    char    buf[256];
    ssize_t bytes_read;

    // Test 1: 'r' mode - read output of "ls"
    printf("=== Test 1: ls output ===\n");
    fd = ft_popen("ls", (char const *[]){"ls", NULL}, 'r');
    if (fd == -1)
        return (printf("ft_popen failed\n"), 1);
    while ((bytes_read = read(fd, buf, sizeof(buf) - 1)) > 0)
    {
        buf[bytes_read] = '\0';
        printf("%s", buf);
    }
    close(fd);

    // Test 2: 'w' mode - write to "cat"
    printf("\n=== Test 2: write to cat ===\n");
    fd = ft_popen("cat", (char const *[]){"cat", NULL}, 'w');
    if (fd == -1)
        return (printf("ft_popen failed\n"), 1);
    write(fd, "hello from ft_popen!\n", 21);
    close(fd);

    // Test 3: invalid type
    printf("\n=== Test 3: invalid type ===\n");
    fd = ft_popen("ls", (char const *[]){"ls", NULL}, 'x');
    printf("fd = %d (expected -1)\n", fd);

    // Test 4: NULL file
    printf("\n=== Test 4: NULL file ===\n");
    fd = ft_popen(NULL, (char const *[]){"ls", NULL}, 'r');
    printf("fd = %d (expected -1)\n", fd);

// Test 5: ls piped through grep
    printf("\n=== Test 5: ls | grep .c ===\n");
    int fd_ls = ft_popen("ls", (char const *[]){"ls", NULL}, 'r');
    if (fd_ls == -1)
        return (printf("ft_popen failed\n"), 1);
    while ((bytes_read = read(fd_ls, buf, sizeof(buf) - 1)) > 0)
    {
        buf[bytes_read] = '\0';
        // manually filter lines containing ".c"
        char *line = buf;
        char *newline;
        while ((newline = strchr(line, '\n')))
        {
            *newline = '\0';
            if (strstr(line, ".c"))
                printf("%s\n", line);
            line = newline + 1;
        }
    }
    close(fd_ls);

    return (0);
}