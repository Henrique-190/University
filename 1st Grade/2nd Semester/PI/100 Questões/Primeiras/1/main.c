#include <stdio.h>

void escolheMaior(int x) {
	int y;
	y = 1;
	while(y!=0 && x!=0){
		scanf("%d",&y);
		if (x<y)
			x=y;
	}
	printf("%d",x);
}

int main(){
    int x;
    scanf("%d",&x);
	escolheMaior(x);
	return 0;
}
