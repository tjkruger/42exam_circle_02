/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   print_bits_new.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/23 11:58:05 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/23 12:00:39 by lkloters         ###   ########.fr       */
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

int main(void)
{
	unsigned char octet = 2;
	print_bits(octet);
	return (0);
}