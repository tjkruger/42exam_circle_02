/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_range.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: dalbano <dalbano@student.42heilbronn.de    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/10/29 16:57:16 by dalbano           #+#    #+#             */
/*   Updated: 2024/10/29 17:23:29 by dalbano          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>

int     *output(int start, int end, int range);
// void    neg_conv(int *start, int *end, int start_neg, int end_neg);

int     *ft_range(int start, int end)
{
    int range;

    // if (start < 0) {
    //     start_neg = 1;
    //     start *= -1;
    // }
    // if (end < 0) {
    //     end_neg = 1;
    //     end *= -1;
    // }
    
    if (start < end)
        range = end - start + 1;
    else
        range = start - end + 1;
    return output(start, end, range);
}

// void    neg_conv(int *start, int *end, int start_neg, int end_neg)
// {
//     if (start_neg == 1)
//         *start *= -1;
//     if (end_neg == 1)
//         *end *= -1;
// }

int     *output(int start, int end, int range)
{
    int *ptr;
    int temp = 0;

    ptr = malloc(range * sizeof(int));
    if (!ptr)
        return NULL;
    // neg_conv(&start, &end, start_neg, end_neg);
    if (start <= end) {
        while (temp < range) {
            ptr[temp] = start;
            start++;
            temp++;
        }
    } else {
        while (temp < range) {
            ptr[temp] = start;
            start--;
            temp++;
        }
    }
    return ptr;
}

// int main(void)
// {
//     int start = -3;
//     int end = 3;
//     int *range_array = ft_range(start, end);

//     if (range_array) {
//         int size = (start < end) ? (end - start + 1) : (start - end + 1);
//         for (int i = 0; i < size; i++) {
//             printf("%d ", range_array[i]);
//         }
//         printf("\n");
//         free(range_array);
//     }

//     return 0;
// }
