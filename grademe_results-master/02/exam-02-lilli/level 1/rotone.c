/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   rotone.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/06 11:26:13 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/06 11:38:29 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int main (int argc, char **argv)
{
	if (argc == 2)
	{
		int i = 0;
		char *str = argv[1];
		while (str[i])
		{
			if (str[i] >= 'a' && str[i] <= 'z')
				str[i] = (str[i] - 'a' + 1) % 26 + 'a';
			else if (str[i] >= 'A' && str[i] <= 'Z')
				str[i] = (str[i] - 'A' + 1) % 26 + 'A';
			write (1, &str[i], 1);
			i++;
		}
	}
	write (1, "\n", 1);
	return (0);
}