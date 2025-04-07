/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strcspn.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/20 14:22:15 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/20 14:31:54 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
size_t ft_strcspn(const char *s, const char *reject)
{
	size_t count = 0;
	int j = 0;
	while(s[count])
	{
		j = 0;
		while (reject[j])
		{
			if (s[count] == reject[j])
				return (count + 1);
			j++;
		}
		count++;
	}
	return (count);
}

int main(void)
{
	const char *s = "hello";
	const char *reject = "aeb";
	size_t count = ft_strcspn(s, reject);
	printf("%zu\n", count);
	return (0);
}