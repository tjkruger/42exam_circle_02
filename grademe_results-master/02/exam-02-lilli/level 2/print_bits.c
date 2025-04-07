/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   print_bits.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/22 19:11:29 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/22 19:16:13 by lkloters         ###   ########.fr       */
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
		if (bits == 1)
			write(1, "1", 1);
		else
			write(1, "0", 1);
		i--;
	}
}

int main(int argc, char **argv)
{
	unsigned char octet = 3;
	print_bits(octet);
	return (0);
}