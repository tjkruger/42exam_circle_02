/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   rot_13_nw.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/23 12:02:45 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/23 12:05:42 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int main(int argc, char **argv)
{
	if (argc == 2)
	{
		int i = 0;
		char *str = argv[1];
		while(str[i])
		{
			if (str[i] >= 'a' && str[i] <= 'z')
				str[i] = (str[i] + 13 - 'a') % 26 + 'a';
			else if (str[i] >= 'A' && str[i] <= 'Z')
				str[i] = (str[i] + 13 - 'A') % 26 + 'A';
			write(1, &str[i], 1);
			i++;
		}
		write(1, "\n", 1);
		return (0);
	}
}