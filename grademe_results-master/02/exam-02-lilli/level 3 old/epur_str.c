/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   epur_str.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/10 15:31:11 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/10 15:34:35 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int main(int argc, char **argv)
{
	if (argc == 2)
	{
		int i = 0;
		int space = 0;
		while(argv[1][i])
		{
			if (argv[1][i] == ' ')
				space = 1;
			else
			{
				if (space == 1)
					write(1, " ", 1);
				write(1, &argv[1][i], 1);
				space = 0;
			}
			i++;
		}
	}
	write(1, "\n", 1);
	return (0);
}