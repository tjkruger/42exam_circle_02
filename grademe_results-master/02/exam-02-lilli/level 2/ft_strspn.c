/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strspn.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/21 21:52:45 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/21 21:58:31 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

size_t ft_strspn(const char *s, const char *accept)
{
	size_t count = 0;
	int i = 0;
	while(s[count])
	{
		int flag = 0;
		i = 0;
		while(accept[i])
		{
			if (s[count] == accept[i])
				flag = 1;
			i++;
		}
		if (flag != 1)
			return (count);
		count++;
	}
	return (count);
}

int main(void)
{
	const char *s = "hallo";
	const char *accept = "abfh";
	size_t count = ft_strspn(s, accept);
	printf("%zu\n", count);
	return (0);
}