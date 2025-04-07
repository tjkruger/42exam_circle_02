/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   lcm.c                                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/21 14:22:50 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/21 14:27:27 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

unsigned int lcm(unsigned int a, unsigned int b)
{
	unsigned int n = 0;
	if (a > b)
		n = a;
	else
		n = b;
	while(1)
	{
		if (n % a == 0 && n % b == 0)
			return (n);
		n++;
	}
}
int main(void)
{
	unsigned int a = 12;
	unsigned int b = 15;
	unsigned int n = lcm(a,b);
	printf("%i\n", n);
	return (0);
}