/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   camel_to_snake.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: dalbano <dalbano@student.42heilbronn.de    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/10/29 16:36:11 by dalbano           #+#    #+#             */
/*   Updated: 2024/10/29 16:56:34 by dalbano          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>
#include <stdlib.h>
#include <ctype.h>

void	camel_to_snake(char *str)
{
	int i;

	i = 0;
	while (str[i]) {
		if (isupper(str[i])) {
			write(1, "_", 1);
			char lower = tolower(str[i]);
			write(1, &lower, 1);
		} else {
			write(1, &str[i], 1);
		}
		i++;
	}
}

int main(int argc, char **argv)
{
	if (argc == 2) {
		camel_to_snake(argv[1]);
	}
	write(1, "\n", 1);
	return 0;
}
