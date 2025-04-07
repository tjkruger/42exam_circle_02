#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// Prototype of get_next_line (make sure to adjust the prototype as per your implementation)
char	*get_next_line(int fd);

int main(int argc, char **argv)
{
    int		fd;
    char	*line;

    if (argc != 2)
    {
        fprintf(stderr, "Usage: %s filename\n", argv[0]);
        return (1);
    }
    fd = open(argv[1], O_RDONLY);
    if (fd < 0)
    {
        perror("Error opening file");
        return (1);
    }
    while ((line = get_next_line(fd)) != NULL)
    {
        // Print the line read from the file
        printf("%s", line);
        free(line);
    }
    close(fd);
    return (0);
}
