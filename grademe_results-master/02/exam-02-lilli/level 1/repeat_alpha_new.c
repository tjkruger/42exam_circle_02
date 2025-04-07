/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   repeat_alpha_new.c                                 :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/20 11:28:10 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/20 12:01:18 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int main(int argc, char **argv)
{
	if(argc == 2)
	{
		int alpha_count = 0;
		int i = 0;
		while(argv[1][i])
		{
			alpha_count = argv[1][i] - 'a';
			while(alpha_count >= 0)
			{
				write(1, &argv[1][i], 1);
				alpha_count--;
			}
			i++;
		}
	}
	write(1, "\n", 1);
	return (0);
}