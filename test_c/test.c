#include 	<stdio.h>
#include	<stdlib.h>

#define 	SAMPLING_RATE	512
#define		REPEAT_TIMES    4
int main()
{
	FILE 		*fp_in, *fp_out;
	unsigned int 	data_in = 0;
	long		result = 0;
	srand(12);

	fp_in 	= fopen("ref_c_input.txt","w");
	fp_out	= fopen("ref_c_result.txt","w");
	for(int j =0; j < REPEAT_TIMES; j++){
	for (int i = 0; i < SAMPLING_RATE; i++){
		result += data_in;
		data_in = rand()%4096;
		fprintf (fp_in, "%d\n",data_in); 
	}

	result = result / 512;
	fprintf (fp_out, "Average = %lu\n", result);
	}

	fclose(fp_in);
	fclose(fp_out);

	return 0;
}
