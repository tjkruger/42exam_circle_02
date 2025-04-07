/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strcmp.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/20 14:09:21 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/20 14:21:40 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

int ft_strcmp(char *s1, char *s2)
{
	int i = 0;
	while(s1[i] == s2[i] && s1[i] != '\0' && s2[i] != '\0')
		i++;
	return(s1[i] - s2[i]);
}
int main(void)
{
	char *s1 = "ha";
	char *s2 = "";
	int dif = ft_strcmp(s1, s2);
	printf("%i\n", dif);
	return (0);
}