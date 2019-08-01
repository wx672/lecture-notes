switch (operator) {
 case '+':
     result += value;
     break;
 case '-':
     result -= value;
     break;
 case '*':
     result *= value;
     break;
 case '/':
     if (value == 0) {
         printf("Error:Divide by zero\n");
         printf("   operation ignored\n");
     } else
         result /= value;
     break;
 default:
     printf("Unknown operator %c\n", operator);
     break;
 }
