/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   flood_fill.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lkloters <lkloters@student.42heilbronn.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/01/22 10:46:25 by lkloters          #+#    #+#             */
/*   Updated: 2025/01/22 10:56:01 by lkloters         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

typedef struct  s_point
{
	int			x;
	int			y;
}				t_point;
  
fill(char **tab, t_point size, t_point cur, char to_fill)
{
	if (cur.x < 0 || cur.y < 0 || cur.x >= size.x || cur.y >= size.y)
		return ;
	tab[cur.y][cur.x] = 'F';
	fill(tab, size, (t_point){cur.y - 1, cur.x}, to_fill);
	fill(tab, size, (t_point){cur.y + 1, cur.x}, to_fill);
	fill(tab, size, (t_point){cur.y, cur.x - 1}, to_fill);
	fill(tab, size, (t_point){cur.y, cur.x + 1}, to_fill);
}

void flood_fill(char **tab, t_point size, t_point begin)
{
	fill(tab, size, begin, tab[begin.y][begin.x]);
}