/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strrev.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/20 14:54:16 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/20 15:01:18 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
char *ft_strrev(char *str)
{
	int temp = 0;
	int start = 0;
	int end = 0;
	while (str[end])
		end++;
	end--;
	while (start < end)
	{
		temp = str[start];
		str[start] = str[end];
		str[end] = temp;
		start++;
		end--;
	}
	return(str);
}
int main(void)
{
	char str[] = "abcdefgh";
	ft_strrev(str);
	printf("%s\n", str);
	return (0);
}