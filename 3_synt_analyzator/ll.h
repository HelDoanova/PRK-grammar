/* #define VERBOSE 1 */
#undef VERBOSE

#define _CPP_IOSTREAMS y

/* Define constants for patterns - used in process_pattern function */

#define PATT_NO 0 /* No pattern will be sent to parser */

#define PATT_INT 1 /* Integer number detected */
#define PATT_BIN 2 /* Binary number detected */
#define PATT_HEX 3 /* Hexadecimal number detected */
#define PATT_ARRAY_START 4 /* Array detected */
#define PATT_ARRAY_END 5 /* Array detected */
#define PATT_LOG_BASE 6 /* Logarithm base detected */
#define PATT_LOG_VAL 7 /* Logarithm value detected */
#define PATT_PLUS 8 /* Plus operator */
#define PATT_MPY 9  /* Multiplication operator */
#define PATT_L_BR 10 /* Left bracket */
#define PATT_R_BR 11 /* Close bracket */
#define PATT_COMMA 12 /* Comma detected */
#define PATT_PRUNIK 13 /* Prunik function detected */

#define PATT_ERR 100 /* Error in patterns: exit on errors! */


#define ERR_PATTERN 1 /* Lexer: an error pattern detected. */

char *ErrMsgMain = "Error detected with code:";

char Err_Messages[][255] = {"No Error","Lexer: Wrong character detected. Exiting."};





