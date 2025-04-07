/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   repeat_alpha.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/06 10:51:05 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/06 11:06:07 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int main(int argc, char **argv)
{
	if (argc == 2)
	{
		char *str = argv[1];
		int i = 0;
		int count = 0;
		while (str[i])
		{
			if (str[i] >= 'a' && str[i] <= 'z')
			{
				count = str[i] - 'a';
				while (count >= 0)
				{
					write(1, &str[i], 1);
					count--;
				}
			}
			else if (str[i] >= 'A' && str[i] <= 'Z')
			{
				count = str[i] - 'A';
				while (count >= 0)
				{
					write(1, &str[i], 1);
					count--;
				}
			}
			else
				write(1, &str[i], 1);
			i++;
		}
	}
	write(1,"\n", 1);
	return (0);
}