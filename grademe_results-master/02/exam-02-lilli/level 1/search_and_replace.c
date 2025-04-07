/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   search_and_replace.c                               :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/06 11:39:08 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/06 13:20:27 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int main(int argc, char **argv)
{
	if (argc == 4 && !argv[2][1] && !argv[3][1])
	{
		char *str = argv[1];
		int i = 0;
		while (str[i])
		{
			if (str[i] == argv[2][0])
				str[i] = argv[3][0];
			write(1, &str[i], 1);
			i++;
		}
	}
	write(1, "\n", 1);
	return (0);
}