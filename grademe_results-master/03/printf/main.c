int ft_printf(const char *format, ...);

int main()
{
    char *i = "Test";
	int temp = 16;
	unsigned int num = 0xdeadbe4f;
    ft_printf("%s\n%d\n%x\n", i, temp, num);
    return(0);
}