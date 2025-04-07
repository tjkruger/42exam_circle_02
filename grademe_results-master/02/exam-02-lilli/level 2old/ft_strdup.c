/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strdup.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/20 14:34:28 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/20 14:46:57 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <stdlib.h>

char *ft_strdup(char *src)
{
	int i = 0;
	int length = 0;
	while (src[length])
		length++;
	char *copy = (char *)malloc(sizeof(char) * length + 1);
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
	char *src = "halo";
	printf("Src: %s\n", src);
	char *dup = ft_strdup(src);
	printf("Dup: %s\n", dup);
	return(0);
}