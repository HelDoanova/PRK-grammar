%{
/* Original EBNF
HelcaLang=expr; 
expr=term, expr2;
expr2="+",term,expr2|;
term=factor, term2;
term2="*", factor, term2 |;
factor="(", expr , ")" | cislo | "log_", cislo, "-", cislo | "prunik(",obsahPruniku,")";
cislo = hexaCislo | intCislo | binCislo;
hexaCislo = "0x", hexa, {hexa};
binCislo = "b", bin, {bin};
intCislo = "0" | startInt, {int};
startInt = "1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9";
int = "1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"|"0";
bin = "0"|"1";
hexa = "1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"|"0"|"A"|"B"|"C"|"D"|"E"|"F";
//syntax=expr| array;
array = "[", obsahArray,"]";
obsahArray = hexaCislo, {",", hexaCislo}|intCislo, {",", intCislo}|binCislo, {",", binCislo};
obsahPruniku = array, ",", array, ",", cislo;
*/

#include <stdio.h>
//#include "prk-stack.h"
//#include "prints.h"

int yylex();
void yyerror(const char *s);
extern int yylineno;

%}

// yylval - možnost uložení int i stringu
%union {
  int int_value;
  char* str_value;
}

%token INTEGER 
%token BINARY 
%token HEXA 
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

%%

HelcaLang:
    HelcaLang expr LINE_END { printf("Syntax OK, Rule1------------\n"); } //Rule1
    | expr LINE_END { printf("Syntax OK, Rule2---------------\n");} //Rule2 
    ;

expr:
    term expr2 {printf("Rule3\n");} //Rule3
    | array { printf("Rule0 - ARRAY\n");} //Rule2 
    ;

expr2:
    PLUS term expr2 {printf("Rule4 - +\n");} //Rule4
    | {printf("Rule5\n");} //Rule5
    ;

term:
    factor term2 {printf("Rule6\n");}; //Rule6
    ;

term2:
    MPY factor term2  {printf("Rule7 - *\n");} //Rule7
    | {printf("Rule8\n");} //Rule8
    ;

factor:
    L_BR expr R_BR {printf("Rule9\n");} //Rule9
    | cislo {printf("Rule10\n");} //Rule10
    | LOG_BASE cislo LOG_VALUE cislo {printf("Rule11 - LOGARITMUS\n");} //Rule11
    | PRUNIK obsahPruniku R_BR {printf("Rule12 - PRUNIK\n");} //Rule12
    ;
   
cislo:
    HEXA {printf("Rule13 - HEXA\n");} //Rule13  
    | INTEGER {printf("Rule14 - INTEGER\n");} //Rule14
    | BINARY {printf("Rule15 - BINARY\n");} //Rule15
    ;
    
array:
    | ARRAY_START obsahArray ARRAY_END {printf("Rule16\n");}; //Rule16
    ;

obsahArray:
    hexaArray {printf("Rule17 - hexa array\n");} //Rule17 
    | integerArray {printf("Rule18 - integer array\n");} //Rule18
    | binaryArray {printf("Rule19 - binary array\n");} //Rule19
    ;
    
hexaArray:
    HEXA {printf("Rule26\n");} //Rule26
    | hexaArray COMMA HEXA {printf("Rule27\n");} //Rule27
    ;

integerArray:
    INTEGER {printf("Rule22\n");} //Rule22
    | integerArray COMMA INTEGER {printf("Rule23\n");} //Rule23
    ;
    
binaryArray:
    BINARY {printf("Rule24\n");} //Rule24
    | binaryArray COMMA BINARY {printf("Rule25\n");} //Rule25
    ;
   
obsahPruniku:
    array COMMA array COMMA cislo {printf("Rule20\n");} //Rule20
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

