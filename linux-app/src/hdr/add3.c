/* add() is defined as a macro in add.h
 *
 * int add(int x, int y)
 * {
 * 	return x+y;
 * }
 */

#include "add.h"

int triple(int x)
{
	return add(x,add(x,x));
}

