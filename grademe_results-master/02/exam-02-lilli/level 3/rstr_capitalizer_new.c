/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   rstr_capitalizer_new.c                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/23 10:30:06 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/23 10:56:57 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int main(int argc, char **argv)
{
	if (argc > 0)
	{
		int i = 1;
		char c;
		while(argv[i])
		{
			int j = 0;
			while (argv[i][j])
			{
				c = argv[i][j];
				if (argv[i][j] >= 'a' && argv[i][j] <= 'z')
				{
					if (argv[i][j + 1] == ' ' || argv[i][j + 1] == '\t' || argv[i][j + 1] == '\0')
						c = c - 32;
					write(1, &c, 1);
					
				}
				else if (argv[i][j] >= 'A' && argv[i][j] <= 'Z')
				{
					if (argv[i][j + 1] != ' ' && argv[i][j + 1] != '\t')
						c = c + 32;
					write(1, &c, 1);
				}
				else
					write(1, &c, 1);
				j++;
			}
			i++;
		}
	}
	write(1, "\n", 1);
	return (0);
}