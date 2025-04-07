/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   is_power_of_2.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/20 16:20:11 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/20 16:26:46 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

int is_power_of_2(unsigned int n)
{
	if (n == 1)
		return(0);
	while(n % 2 == 0)
		n = n / 2;
	if (n != 1)
		return (0);
	return(1);
}
int main(void)
{
	unsigned int n = 1;
	int x = is_power_of_2(n);
	printf("%i\n", x);
	return (0);
}