#include <stdio.h>
#include <stdlib.h>
#include <string.h>

main()
{
	char* Dictionary[65536];

	char prueba []	 = "42";
	char hello 	[]	 = "hello";
/*	
	Dictionary[1] = prueba;
	Dictionary[2] = hello;
	
	printf("%c\n",*(Dictionary[1]+1));
	printf("%c\n",*(Dictionary[2])); 
	 
*/
	int i;
	char* Temp_Asci;
	char Temporal;
	for(i = 0; i < 256; i++)
		{
				Temporal = i;
				Temp_Asci = &Temporal;
				Dictionary[i] = Temp_Asci;
				//printf("%c\n",*Dictionary[i]);
		}	
		
	char* P="b";	
	const char* c="a";
	char* InDictionary ;
	Dictionary[1] = strcat(P,c);
	printf("%c\n",*Dictionary[1]);
/*	
	
	FILE *file;
	file = fopen("wabba.txt", "r");
	if (file) {
    while ((c = getc(file)) != EOF)
    {
		
        printf("%c\n",c);
    }   
        
    fclose(file);
}	
*/		
	return 0;
}

