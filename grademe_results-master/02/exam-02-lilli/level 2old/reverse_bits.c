/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   reverse_bits.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/21 10:59:48 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/21 11:30:01 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

void print_bits(unsigned char octet)
{
	unsigned char bits;
	int i = 7;
	while(i >= 0)
	{
		bits = (octet>>i) & 1;
		if (bits == 0)
			write(1, "0", 1);
		else
			write(1, "1", 1);
		i--;
	}
}

unsigned char reverse_bits(unsigned char octet)
{
	int i = 0;
	unsigned char res;
	while(i < 8)
	{
		res 
			// 0000 0000
		res = res | octet; // 0000 0000 | 0011 0000 = 0011 0000
		i++;
	}
	return (res);
}

int main(void)
{
	unsigned char octet = 48;
	print_bits(octet);// 00010 0101
	write(1,"\n", 1);
	unsigned char x = reverse_bits(octet);
	print_bits(x); // 
	return (0);
}