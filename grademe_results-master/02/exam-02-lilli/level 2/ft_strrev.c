/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strrev.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/21 21:40:43 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/21 21:52:20 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

char *ft_strrev(char *str)
{
	int temp = 0;
	int start = 0;
	int end = 0;
	while(str[end])
		end++;
	end--;
	while(start < end)
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
	char str[] = "abcde";
	ft_strrev(str);
	printf("%s\n", str);
	return (0);
}