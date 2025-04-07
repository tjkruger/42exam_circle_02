/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   rev_wstr.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/22 18:42:40 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/22 18:54:37 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int main(int argc, char **argv)
{
	if (argc == 2)
	{
		int i = 0;
		int start = 0;
		int end = 0;
		char *str = argv[1];
		while(str[i])
			i++;
		while(i >= 0)
		{
			while (str[i] == ' ' || str[i] == '\t' || str[i] == '\0')
				i--;
			end = i;
			while(str[i] != ' ' && str[i] != '\t' && str[i] != '\0')
				i--;
			start = i + 1;
			while (start <= end)
			{
				write(1, &str[start], 1);
				start++;
			}
			if (i >= 0)
				write(1, " ", 1);
		}
	}
	write(1, "\n", 1);
	return (0);
}