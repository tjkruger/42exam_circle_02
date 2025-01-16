typedef struct s_list	t_list;

struct					s_list
{
	int					data;
	t_list				*next;
};

int	ascending(int a, int b)
{
	return (a <= b);
}
