/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   last_word.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/20 16:30:18 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/20 16:53:27 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int main(int argc, char **argv)
{
	if (argc == 2)
	{
		int end = 0;
		int flag = 0;
		while(argv[1][flag] != '\0')
			flag++;
		while(argv[1][flag] == ' ' || argv[1][flag] == '\t' || argv[1][flag] == '\0')
			flag--;
		end = flag + 1;
		while (argv[1][flag] != ' ' && argv[1][flag] != '\t')
			flag--;
		flag++;
		while(flag < end)
		{
			write(1, &argv[1][flag], 1);
			flag++;
		}
	}
	write(1, "\n", 1);
	return (0);
}