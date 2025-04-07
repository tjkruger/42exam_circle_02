/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   rstr_capitalizer.c                                 :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/21 15:50:44 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/21 16:00:50 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int main(int argc, char **argv)
{
	int i = 1;
	int j = 0;
	if (argc > 1)
	{
		while (argv[i])
		{
			j = 0;
			while (argv[i][j])
			{
				int flag = 0;
				if (argv[i][j + 1] == '\0' || argv[i][j + 1] == ' ' || argv[i][j + 1] == '\t')
					flag = 1;
				if (flag == 1 && argv[i][j] >= 'a' && argv[i][j] <= 'z')
					argv[i][j] = argv[i][j] - 32;
				else if (flag == 0 && argv[i][j] >= 'A' && argv[i][j] <= 'Z')
					argv[i][j] = argv[i][j] + 32;
				write(1, &argv[i][j], 1);
				j++;
			}
			write(1, "\n", 1);
			i++;
		}
	}
	else
		write(1, "\n", 1);
	return (0);
}