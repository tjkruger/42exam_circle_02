/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   do_op.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/20 13:56:30 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/20 14:01:21 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char **argv)
{
	if (argc == 4)
	{
		int num1 = atoi(argv[1]);
		int num2 = atoi(argv[3]);
		int result = 0;
		if (argv[2][0] == '+')
			result = num1 + num2;
		else if (argv[2][0] == '-')
			result = num1 - num2;
		else if (argv[2][0] == '*')
			result = num1 * num2;
		else if (argv[2][0] == '/')
			result = num1 / num2;
		printf("%i", result);
	}
	printf("\n");
	return (0);
}