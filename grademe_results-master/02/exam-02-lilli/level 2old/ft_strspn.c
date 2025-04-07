/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strspn.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/20 15:01:45 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/20 16:05:49 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
size_t ft_strspn(const char *s, const char *accept)
{
	int j = 0;
	size_t count = 0;
	int seen = 0;
	while(s[count])
	{
		j = 0;
		while (accept[j])
		{
			if (s[count] == accept[j])
				seen = 1;
			j++;
		}
		if (seen != 1)
			return(count);
		count++;
		seen = 0;
	}
	return (count);
}