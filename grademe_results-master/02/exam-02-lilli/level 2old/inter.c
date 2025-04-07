/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   inter.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/20 16:06:14 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/21 22:06:34 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int main(int argc, char **argv)
{
	if (argc == 3)
	{
		int i = 0;
		int j = 0;
		char seen[256] = {0};
		while (argv[1][i])
		{
			if (argv[1][i] == argv[2][j])
			{
				if (!seen[(unsigned char)argv[2][j]])
				{
					write(1, &argv[2][j], 1);
					seen[(unsigned char)argv[2][j]] = 1;
					break;
				}
				j++;
			}
			i++;
		}
	}
	write(1, "\n", 1);
	return (0);
}