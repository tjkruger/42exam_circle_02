/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   print_bits_new.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/21 10:54:18 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/21 10:58:49 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

void print_bits(unsigned char octet)
{
	int i = 7;
	unsigned char bits;
	while(i >= 0)
	{
		bits = (octet>>i) & 1;
		if (bits == 0)
			write(1, "0", 1);
		else if (bits == 1)
			write(1, "1" ,1);
		i--;
	}
}

int main (void)
{
	unsigned char octet = 6;
	print_bits(octet);
	return (0);
}