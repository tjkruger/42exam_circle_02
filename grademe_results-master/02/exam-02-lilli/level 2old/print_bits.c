/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   print_bits.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/21 10:24:15 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/22 16:33:12 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

void print_bits(unsigned char octet)
{
	unsigned char bit;
	int i = 7;
	while(i >= 0)
	{
		//octet = octet>>i;
		bit = (octet>>i) & 1;
		if(bit == 0)
			write(1,"0",1);
		if(bit == 1)
			write(1,"1",1);
		i--;
	}
}

int main(void)
{
	unsigned char octet = 23;// 0101 0010/ 0000 0000 / 0000 0001 // 0000 0001
	print_bits(octet);
	return (0);
}