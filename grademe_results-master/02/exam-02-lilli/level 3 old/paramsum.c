/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   paramsum.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/10 17:19:00 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/10 17:22:06 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

void ft_putnbr(int n)
{
	if (n >= 10)
		ft_putnbr(n / 10);
	char digit = n % 10 + '0';
	write(1, &digit, 1);
}

int main(int argc, char **argv)
{
	if (argc > 1)
		ft_putnbr(argc - 1);
	else
		ft_putnbr(0);
	write(1, "\n", 1);
	return (0);
}