/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strpbrk.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/21 21:34:42 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/22 16:24:09 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

char *ft_strpbrk(const char *s1, const char *s2)
{
	int i = 0;
	int j = 0;
	if (!s1[i] || !s2[j])
		return (NULL);
	while (s1[i])
	{
		j = 0;
		while (s2[j])
		{
			if (s1[i] == s2[i])
				return ((char *)s1[i]);
			j++;
		}
		i++;
	}
	return (NULL);
}
