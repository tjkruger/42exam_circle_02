/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   rostring.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/22 14:03:58 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/22 15:02:02 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

void last_word(int start, int end, char *str)
{
	while(start < end)
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
		int flag = 0;
		while(str[i] == ' ' || str[i] == '\t' || str[i] == '\0')
			i++;
		int start = i;
		while(str[i] != ' ' && str[i] != '\t' && str[i] != '\0')
			i++;
		int end = i;
		int x = 0;
		while(str[i])
		{
			while(str[i] == ' ' || str[i] == '\t')
			{
				i++;
				flag = 1;
			}
			if (flag == 1)
			{
				if (x == 0)
					x = 1;
				else
					write(1, " ", 1);
				flag = 0;
			}
			write(1, &str[i], 1);
			i++;
		}
		write(1, " ", 1);
		last_word(start, end, str);
	}
	write(1, "\n", 1);
	return (0);
}