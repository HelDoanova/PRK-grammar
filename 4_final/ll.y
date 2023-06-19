%{
/* Original EBNF
HelcaLang ::= expr| array | "prunik(",obsahPruniku,")"| "log_", cislo, "-", cislo; 
expr ::= term, expr2 
expr2 ::= "+",term,expr2|;
term ::= factor, term2;
term2 ::= "*", factor, term2 |;
factor ::= "(", expr , ")" | cislo;
cislo ::= hexaCislo | intCislo | binCislo;
hexaCislo ::= "0x", hexa, {hexa};
binCislo ::= "b", bin, {bin};
intCislo ::= "0" | startInt, {int};
startInt ::= "1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9";
int ::= "1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"|"0";
bin ::= "0"|"1";
hexa ::= "1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"|"0"|"A"|"B"|"C"|"D"|"E"|"F";
//syntax=expr| array;
array ::= "[", obsahArray,"]";
//obsahArray ::= hexaCislo, {",", hexaCislo}|intCislo, {",", intCislo}|binCislo, {",", binCislo};
obsahArray ::= hexaArray|integerArray|binaryArray;
hexaArray ::= hexaArray, ",", hexa
integerArray ::= hntegerArray, ",", int
binaryArray ::= binaryArray, ",", bin
obsahPruniku = array, ",", array ;
//obsahPruniku = array, ",", array, ",", cislo;
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
//#include "prk-stack.h"
//#include "prints.h"

int yylex();
void yyerror(const char *s);
extern int yylineno;

char* int_to_bin(int number);
char* int_to_hexa(int number);
int* addNumberToArray(int number, int *numbers, int size);
void print_bin_array(int* array, int size);
void print_hexa_array(int* array, int size);
void print_int_array(int *numbers, int size);
int* intersection(int* array1, int size1, int* array2, int size2, int* resultSize);
int sum_array(int* array, int size);
double calculate_logarithm(int base, int value);
%}

// JDE TO TAKHLE ??? --- ODZKOUŠET !!!
%union {
	struct Array{
		char* type;
		int size;
		int *numbers;
	} array;
  int integer;
}

%token<integer> INTEGER 
%token<integer> BINARY 
%token<integer> HEXA 
%token ARRAY_START 
%token ARRAY_END 
%token LOG_BASE 
%token LOG_VALUE 
%token PLUS  
%token MPY 
%token L_BR
%token R_BR 
%token COMMA 
%token PRUNIK 
%token LINE_END

//%type <integer> HelcaLang expr expr2 term term2 factor cislo array obsahArray hexaArray integerArray binaryArray obsahPrunik

%type <integer> expr expr2 term term2 factor cislo
//%type <array> HelcaLang expr array obsahArray hexaArray integerArray binaryArray obsahPrunik
%type <array> array obsahArray hexaArray integerArray binaryArray 
%type <array> obsahPruniku


%%

HelcaLang:
    HelcaLang expr LINE_END { printf("Integer|bin|hexa: %d|%s|%s\n", $2, int_to_bin($2),int_to_hexa($2));int_to_bin($2);
    	printf("------------Syntax OK, Rule1------------\n");  //Rule1
    	printf("\n"); } 
    | expr LINE_END { printf("Integer|bin|hexa: %d|%s|%s\n", $1, int_to_bin($1),int_to_hexa($1));int_to_bin($1);
    	printf("------------Syntax OK, Rule2------------\n"); //Rule2 
    	printf("\n"); } 
    | HelcaLang array LINE_END{ printf("Rule0 - ARRAY\n");
    	print_int_array($2.numbers, $2.size);
    	printf("\n");
    	printf("------------Syntax OK, ArrayOk------------\n"); //Rule2 
    	} //Rule2 
    | HelcaLang PRUNIK obsahPruniku R_BR LINE_END{printf("Rule12 - PRUNIK\n");
    	//$$ = $2;
    	print_int_array($3.numbers, $3.size);
    	printf("\n");
    	int sum = sum_array($3.numbers, $3.size);
    	printf("%d\n", sum);
    	printf("------------Syntax OK, PrunikOk------------\n"); //Rule2 
    	} //Rule12
    | HelcaLang LOG_BASE cislo LOG_VALUE cislo LINE_END{printf("Rule11 - LOGARITMUS: \n"/* %f,(double)$$*/);
    	double log = calculate_logarithm($3,$5);
    	printf("%f\n", log);
    	printf("------------Syntax OK, LogOk------------\n"); //Rule2 
    	//$$ = result;
    	} //Rule11
    ;

expr:
    term expr2 {printf("Rule3 - vysledek: %d\n",$1 + $2);
    	$$ = $1 + $2;} //Rule3
    ;

expr2:
    PLUS term expr2 {printf("Rule4 - + : %d\n",$2+$3);
    	$$ = $2 + $3;} //Rule4
    | {printf("Rule5\n");
    	$$=0;} //Rule5
    ;

term:
    factor term2 {printf("Rule6\n");
   	$$ = $1*$2;}; //Rule6
    ;

term2:
    MPY factor term2  {printf("Rule7 - *\n");
    	$$ = $2*$3;} //Rule7
    | {printf("Rule8\n");
    	$$=1;} //Rule8
    ;

factor:
    L_BR expr R_BR {printf("Rule9 - (-)\n");
    	$$ = $2;} //Rule9
    | cislo {printf("Rule10\n");
    	$$ = $1;} //Rule10
    ;
   
cislo:
    HEXA {printf("Rule13 - HEXA: "); int_to_hexa($1); printf(" -> int %d\n", $1);
    	$$ = $1;}
    | INTEGER {printf("Rule14 - INTEGER: %d\n", $1);
    	$$ = $1;} //Rule14
    | BINARY {printf("Rule15 - BINARY: "); int_to_bin($1); printf(" -> int %d\n", $1);
    	$$ = $1;} //Rule15
    ;
    
array:
    ARRAY_START obsahArray ARRAY_END {printf("Rule16\n");
    $$ = $2;
    }; //Rule16
    ;

obsahArray:
    hexaArray {printf("Rule17 - hexa array: ");
        print_hexa_array($1.numbers, $1.size);
        printf("\n");
        $$ = $1;} //Rule19} //Rule17 
    | integerArray {printf("Rule18 - integer array: ");
        print_int_array($1.numbers, $1.size);
        printf("\n");
        $$ = $1;} //Rule18
    | binaryArray {printf("Rule19 - binary array: ");
        print_bin_array($1.numbers, $1.size);
        printf("\n");
        $$ = $1;} //Rule19
    ;
    
hexaArray:
    HEXA {printf("Rule20\n");
    	if($$.size == 0){
		$$.type = "hexa";
		$$.size = 1;
		int* array = malloc(1 * sizeof(int));
		array[0] = $1;
		$$.numbers = array;
	    }else{
	    	$$.type = "hexa";
		int lastSize = $$.size;
		$$.size = lastSize + 1;
		$$.numbers = addNumberToArray($1, $$.numbers, lastSize);	
	    	}} //Rule26
    | hexaArray COMMA HEXA {printf("Rule21\n");
    	$$.type = "hexa";
        int lastSize = $$.size;
        $$.size = lastSize + 1;
        $$.numbers = addNumberToArray($3, $$.numbers, lastSize);} //Rule27
    ;

integerArray:
    INTEGER {printf("Rule22\n");
    	if($$.size == 0){
		$$.type = "int";
		$$.size = 1;
		int* array = malloc(1 * sizeof(int));
		array[0] = $1;
		$$.numbers = array;
	    }else{
	    	$$.type = "int";
		int lastSize = $$.size;
		$$.size = lastSize + 1;
		$$.numbers = addNumberToArray($1, $$.numbers, lastSize);	
	    	}
		}  //Rule22
    | integerArray COMMA INTEGER {printf("Rule23\n");
    	$$.type = "int";
        int lastSize = $$.size;
        $$.size = lastSize + 1;
        $$.numbers = addNumberToArray($3, $$.numbers, lastSize);} //Rule23
    ;
    
binaryArray:
    BINARY {printf("Rule24\n");
    	if($$.size == 0){
    		$$.type = "bin";
		$$.size = 1;
		int* array = malloc(1 * sizeof(int));
        	array[0] = $1;
        	$$.numbers = array;
    	}else{
    		$$.type = "bin";
            	int lastSize = $$.size;
            	$$.size = lastSize + 1;
            	$$.numbers = addNumberToArray($1, $$.numbers, lastSize);	
    	}
	} //Rule24
    | binaryArray COMMA BINARY {printf("Rule25\n");
    	$$.type = "bin";
        int lastSize = $$.size;
        $$.size = lastSize + 1;
        $$.numbers = addNumberToArray($3, $$.numbers, lastSize);} //Rule25
    ;
   
obsahPruniku:
    //array COMMA array COMMA cislo {printf("Rule26\n");} //Rule20
    array COMMA array  {printf("Rule26 \n");
    	//print_int_array($1.numbers,$1.size);
	int resultSize;
        int* result = intersection($1.numbers, $1.size, $3.numbers, $3.size, &resultSize);
        $$ = (struct Array){ .type = $1.type, .size = resultSize, .numbers = result };
    	}
 	 //Rule20
    ;
   
%%



void yyerror(const char* s) {   
    printf("%s\n",s);
}

void main(){
    // yydebug = 1;
    //debug_print("Entering the main");
    printf("Entering the main\n");
    yyparse();  
}

// Převod integeru na binární číslo 
char* int_to_bin(int number) {
    int size = sizeof(int) * 8; 
    int bitCount = 0;
    int temp = number;

    while (temp != 0) {
        bitCount++;
        temp >>= 1;
    }

    char* binary = (char*)malloc((bitCount + 2) * sizeof(char)); 
    binary[0] = 'b'; 
    binary[bitCount + 1] = '\0'; 

    if (number == 0) {
        binary[1] = '0';
    } else {
        for (int i = bitCount - 1; i >= 0; i--) {
            binary[i + 1] = (number & 1) ? '1' : '0'; 
            number >>= 1; 
        }
    }

    return binary;
}


// Převod integeru na hexadecimální číslo 
char* int_to_hexa(int number) {
    char* hexa;
    int length = snprintf(NULL, 0, "0x%X", number); 
    hexa = (char*)malloc((length + 1) * sizeof(char)); 
    snprintf(hexa, length + 1, "0x%X", number); 
    return hexa;
}

// Přidání čílsa do pole
int* addNumberToArray(int number, int *numbers, int size) {
    numbers = (int*) realloc(numbers, (size + 1) * sizeof(int));
    numbers[size] = number;
    return numbers;
}

//Vypíše pole v bin
void print_bin_array(int* array, int size) {
    printf("[");
    for (int i = 0; i < size; i++) {
    	printf("%s", int_to_bin(array[i]));
        //int_to_bin(array[i]);
        if (i < size - 1) {
            printf(", ");
        }
    }
    printf("]");
}

//Vypíše pole v hexa
void print_hexa_array(int* array, int size) {
    printf("[");
    for (int i = 0; i < size; i++) {
    	printf("%s", int_to_hexa(array[i]));
        //int_to_bin(array[i]);
        if (i < size - 1) {
            printf(", ");
        }
    }
    printf("]");
}

//Vypíše pole v integer
void print_int_array(int *numbers, int size) {
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d", numbers[i]);
        if (i != size - 1) {
            printf(", ");
        }
    }
    printf("]");
}

//Funkce pro průnik - vrátí pole se s hodnotami, které jsou v array1 i array2
int* intersection(int* array1, int size1, int* array2, int size2, int* resultSize) {
    int maxSize = (size1 < size2) ? size1 : size2; 
    int* result = (int*)malloc(maxSize * sizeof(int));
    int count = 0;

    for (int i = 0; i < size1; i++) {
        int element = array1[i];

        for (int j = 0; j < size2; j++) {
            if (array2[j] == element) {
                result[count++] = element; 
                break;
            }
        }
    }

    *resultSize = count; 
    return result;
}

int sum_array(int* array, int size) {
   int sum = 0;
    for (int i = 0; i < size; i++) {
        sum = sum + array[i];
    }
    return sum;
}


double calculate_logarithm(int base, int value) {
    return log(value) / log(base);
}


