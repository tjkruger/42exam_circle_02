/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   rstr_capiatlizer.c                                 :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/10 17:42:46 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/10 18:00:22 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int main(int argc, char **argv)
{
	int i = 1;
	int j = 0;
	int flag = 0;
	if (argc > 1)
	{
		while(i < argc)
		{
			i = 0;
			while(argv[i][j])
			{
				if (argv[i][j + 1] == ' ' || argv[i][j + 1] == '\t' || argv[i][j + 1] == '\0')
					flag = 1;
				if (flag == 1 && (argv[i][j] >= 'a' && argv[i][j] <= 'z'))
					argv[i][j] = argv[i][j] - 32;
				else if (flag == 0 && (argv[i][j] >= 'A' && argv[i][j] <= 'Z'))
					argv[i][j] = argv[i][j] + 32;
				write(1, &argv[i][j], 1);
				j++;
				flag = 0;
			}
			write(1, "\n", 1);
			i++;
		}
	}
	else
		write(1, "\n", 1);
	return (0);
}