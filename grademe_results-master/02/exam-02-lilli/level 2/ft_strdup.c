/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strdup.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/21 21:28:06 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/21 21:34:14 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <stdio.h>

char *ft_strdup(char *src)
{
	int length = 0;
	while(src[length])
		length++;
	char *copy = (char *)malloc(sizeof (char) * length + 1);
	int i = 0;
	while (i < length)
	{
		copy[i] = src[i];
		i++;
	}
	copy[i] = '\0';
	return (copy);
}
int main(void)
{
	char *src = "hall   sdfsdff   53453 o";
	char *copy = ft_strdup(src);
	printf("%s\n", copy);
	return (0);
}