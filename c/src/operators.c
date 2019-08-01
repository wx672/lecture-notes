int term1, term2; /* 2 terms */
int sum;          /* sum of first and second term */
int diff;         /* difference of the two terms */
int modulo;       /* term1 modulus term2 */
int product;      /* term1 * term2 */
int ratio ;       /* term1 / term2 */                        

int main()
{
  term1 = 1 + 2 * 4;       /* 2*4=8, 8+1=9 */
  term2 = (1 + 2) * 4;     /* 1+2=3, 3*4=12 */
  sum = term1 + term2;     /* 9+12=21 */
  diff = term1 - term2;    /* 9-12=-3 */
  modulo = term1 % term2;  /* 9/12=0, remainder is 9 */
  product = term1 * term2; /* 9*12=108  */
  ratio = 9/12;            /* 9/12=0  */
  return(sum);
}
