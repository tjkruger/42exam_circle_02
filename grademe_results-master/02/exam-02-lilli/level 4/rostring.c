/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   rostring.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/22 18:55:15 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/22 19:03:11 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

void last_word(int start, int end, char *str)
{
	while (start < end)
	{
		write(1, &str[start], 1);
		start++;
	}
}
int main(int argc, char **argv)
{
	if (argc == 2)
	{
		char *str = argv[1];
		int i = 0;
		int start = 0;
		int end = 0;
		int flag = 0;
		int x = 0;
		while(str[i] == ' ' || str[i] == '\t' || str[i] == '\0')
			i++;
		start = i;
		while(str[i] != ' ' && str[i] != '\t' && str[i] != '\0')
			i++;
		end = i;
		while(str[i])
		{
			if (str[i] == ' ' || str[i] == '\t')
			{
				if (x == 0)
					x = 1;
				else
					flag = 1;
			}
			else
			{
				if (flag == 1)
				{
					write(1, " ", 1);
					flag = 0;
				}
				write(1, &str[i], 1);
			}
			i++;
		}
		write(1, " ", 1);
		last_word(start, end, str);
	}
	write(1, "\n", 1);
	return (0);
}