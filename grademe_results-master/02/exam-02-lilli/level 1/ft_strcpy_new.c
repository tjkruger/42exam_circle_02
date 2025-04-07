/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strcpy_new.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/20 11:16:53 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/20 11:21:31 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

char *ft_strcpy(char *s1, char *s2)
{
	int i = 0;
	while(s1[i])
	{
		s2[i] = s1[i];
		i++;
	}
	return (s2);
}
int main (void)
{
	char *src = "hello";
	char *dest;
	ft_strcpy(src, dest);
	printf("%s\n", dest);
}