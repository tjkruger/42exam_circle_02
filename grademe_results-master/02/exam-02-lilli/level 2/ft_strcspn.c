/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strcspn.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/21 21:15:38 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/21 21:27:37 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

size_t ft_strcspn(const char *s, const char *reject)
{
	int i = 0;
	size_t count = 0;

	while(s[count])
	{
		i = 0;
		while(reject[i])
		{
			if (s[count] == reject[i])
				return (count + 1);
			i++;
		}
		count++;
	}
	return(count);
}
int main(void)
{
	const char *s = "abcdhefg";
	const char *reject = "hfgzzz";
	size_t count = ft_strcspn(s, reject);
	printf("%zu\n", count);
	return (0);
}