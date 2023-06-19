%{
/* Variable declaration */
int lines_done=0;
int void_lines_done=0;
int lines_comment=0;

int add_ops=0;
int mpy_ops=0;
int br_left=0;
int br_right=0;
int int_values=0;
int bin_values=0;
int hexa_values=0;
int array_start=0;
int array_end=0;
int logarithm_base = 0;
int logarithm_value = 0;
int prunik_function = 0;
int comma = 0;

int errors_detected=0;

#include "ll.h"
#include "y.tab.h"

/* Function prototypes */

int process_pattern(int number, char *Message, int Pattern);
void print_error(int ERRNO);
void print_msg(char *msg);
int bin_to_int(char* binary);
int hexa_to_int(char* hexa);

%}
%%
^#.*\n {lines_comment=process_pattern(lines_comment,"Comment deleted.\n",PATT_NO);}
\+     {
        add_ops=process_pattern(add_ops,"Add operator detected.",PATT_PLUS);        
        return PLUS; 
        }
\*     {
        mpy_ops=process_pattern(mpy_ops,"Multiplication operator detected.",PATT_MPY);
        return MPY;
        }
\(     {
        br_left=process_pattern(br_left,"Opening bracket detected.",PATT_L_BR);
        return L_BR;
        }
\)     {
        br_right=process_pattern(br_right,"Closing bracket detected.", PATT_R_BR);
        return R_BR;
        }
 
(?:0|[1-9][0-9]*)  {
        int_values=process_pattern(int_values,"Integer number detected.", PATT_INT);   
        yylval.integer = atoi(yytext);              
        return INTEGER;
        }
b[0-1]+ {
        bin_values=process_pattern(bin_values,"Binary number detected.", PATT_BIN);   
        yylval.integer = bin_to_int(yytext);            
        return BINARY;
        }
0x[0-9A-F]+ 	{
        hexa_values=process_pattern(hexa_values,"Hexadecimal number detected.", PATT_HEX);   
        yylval.integer = hexa_to_int(yytext);        
        return HEXA;
        }
\[      {
        array_start=process_pattern(array_start,"Start of array detected.", PATT_ARRAY_START);                 
        return ARRAY_START;
        }
\]      {
        array_end=process_pattern(array_end,"End of array detected.", PATT_ARRAY_END);                 
        return ARRAY_END;
        }
log_ 	{
	logarithm_base=process_pattern(logarithm_base,"Logarithm base detected.", PATT_LOG_BASE);
	return LOG_BASE;
	}    
\- 	{
	logarithm_value=process_pattern(logarithm_value,"Logarithm value detected.", PATT_LOG_VAL);
	return LOG_VALUE;}
prunik\(	{
		prunik_function=process_pattern(prunik_function,"Prunik function detected.", PATT_PRUNIK);
		return PRUNIK;
		}
,   	{
	comma=process_pattern(comma,"Comma detected.",PATT_COMMA);
            return COMMA;
        }
^\n     {void_lines_done++;        
            print_msg("Void line detected.\n");
        }       
\n      {lines_done++;
            print_msg("Line detected.\n");
            return LINE_END;
        }

[ \t]+ ; /*Skip whitespace*/

.      {errors_detected=process_pattern(errors_detected,"An error detected.\n",PATT_ERR);} /* What is not from alphabet: lexer error  */

%%
/* Main part */
/*
int main()
    {
        yylex();
        printf("%d of total errors detected in input file.\n",errors_detected);
        printf("%d of int numbers detected.\n",int_values);
        printf("%d of bin numbers detected.\n",bin_values);
        printf("%d of hexa numbers detected.\n",hexa_values);
        printf("%d of comment lines canceled.\n",lines_comment);
        printf("%d of add operators detected.\n",add_ops);
        printf("%d of multiplication operators detected.\n",mpy_ops);
        printf("%d of opening brackets detected.\n",br_left);
        printf("%d of closing brackets detected.\n",br_right);
        printf("%d of start of array detected.\n",array_start);
        printf("%d of end of array detected.\n",array_end);
        printf("%d of logarithm base detected.\n",logarithm_base);
        printf("%d of logarithm value detected.\n",logarithm_value);
        printf("%d of prunik function detected.\n",prunik_function);
        printf("%d of comma detected.\n",comma);
        printf("%d of void lines ignored.\nFile processed sucessfully.\n",void_lines_done);
        printf("Totally %d of valid code lines in file processed.\nFile processed sucessfully.\n",lines_done);
        
    }*/

/* Function declaration */

int yywrap(void) {
return 1;
}

void print_msg(char *msg){
    #ifdef VERBOSE
        printf("%s",msg);
    #endif
}

void print_error(int ERRNO){
    #ifdef VERBOSE
    char *message = Err_Messages[ERRNO];
    printf("%s - %d - %s\n",ErrMsgMain,ERR_PATTERN,message);
    #endif
}

int process_pattern(int number,char* Message, int Pattern) {
    if (Pattern == PATT_ERR) {       
        print_error(ERR_PATTERN);        
        exit(ERR_PATTERN);
    }    

    print_msg(Message);
    
    number++;
    return number;
}


/* Funkce pro převod binárního čísla na integer(celé číslo)*/
int bin_to_int(char* binary) {
    return strtol(binary + 1, NULL, 2);
}

/* Funkce pro převod hexadecimálního čísla na celé číslo */
int hexa_to_int(char* hexa) {
    return strtol(hexa, NULL, 16);
}



