#include <stdio.h>
#include <math.h>
#define SIZE 5000
int main()
{
  int i, a=sqrt(SIZE)+1, s[SIZE+1]; 
  for (i=2;i<=SIZE;i++) s[i]=1; 
  s[1]=0;
  for (i=2;i<=a;i++){
    if (s[i]==1) {
          int j;
          for (j=2*i;j<=SIZE;j+=i)
            s[j]=0; 
    }
  }
  for (i=100;i<=SIZE;i++){ 
     if (s[i]==1){
     }
  }
  printf("work done");
  return 0;
}
