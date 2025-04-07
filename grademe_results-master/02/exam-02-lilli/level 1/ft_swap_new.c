/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_swap_new.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/20 11:22:17 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/20 11:27:47 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

void ft_swap(int *a, int *b)
{
	int temp = *a;
	*a = *b;
	*b = temp;
}
int main(void)
{
	int x = 1;
	int y = 5;
	int *a = &x;
	int *b = &y;
	printf("%i", *a);
	printf("%i\n", *b);
	ft_swap(a, b);
	printf("%i", *a);
	printf("%i\n", *b);
}