
%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
void yyerror(char* s);
extern int yylineno;
int numoferr = 0;
%}


%token BEGINSTMT
%token BOOLEANTYPE
%token DIGITTYPE
%token STRINGTYPE
%token CHARTYPE
%token SETTYPE
%token BOOLEAN
%token DIGIT
%token CHAR
%token STRING
%token LETTER
%token LP
%token RP
%token LPP
%token RPP
%token ASSIGNMENT
%token COMMENT
%token COMMA
%token ARRAYOPENER
%token ARRAYCLOSER
%token LOOPSTMT
%token RETURN
%token IFSTMT
%token ELSESTMT
%token WHITESPACE
%token INPUT


%token IN


%token OUTPUT


%token OUT


%token VAR_ID


%token STRINGARRAY


%token DIGITARRAY


%token CHARARRAY


%token SETARRAY


%nonassoc UNION


%nonassoc INTERSECTION


%left COMPLEMENT


%left DIFFERENCE


%left SUBSET


%left SUPERSET


%%

entry:


   BEGINSTMT LPP statements RPP    


	;

statements:   


   statement statements

   |statement


   ;

statement:


   declaration_statement
   
   |function_statement
   
   |comment_statement
   
   |input_statement
   
   |output_statement
   
   |loop_statement
   
   |return_statement

   |if_statement
   
   |COMMENT


   ;


declaration_statement:

	string_declaration
	
	|boolean_declaration
	
	|char_declaration
	
	|set_declaration
	
	|digit_declaration
	
	|array_declaration
	
	;
	

		


string_declaration:

	 STRINGTYPE VAR_ID ASSIGNMENT STRING


	;
	
	
boolean_declaration:

	 BOOLEANTYPE VAR_ID ASSIGNMENT BOOLEAN


	;
	
char_declaration:

	 CHARTYPE VAR_ID ASSIGNMENT CHAR


	;

	
set_declaration:

	 SETTYPE VAR_ID ASSIGNMENT set


	;
	
	
digit_declaration:

	 DIGITTYPE VAR_ID ASSIGNMENT DIGIT


	;


array_declaration:

	string_array
	
	|digit_array
	
	|char_array
	
	|set_array

	;

	
	
string_array:

	STRINGARRAY VAR_ID ASSIGNMENT ARRAYOPENER string_array_elements ARRAYCLOSER
	
	;
	
	
string_array_elements:

	STRING 
	| STRING COMMA string_array_elements
	
	;


digit_array:

	DIGITARRAY VAR_ID ASSIGNMENT ARRAYOPENER digit_array_elements ARRAYCLOSER
	
	;
	
	
digit_array_elements:

	DIGIT
	| DIGIT COMMA digit_array_elements
	
	;
	

char_array:

	CHARARRAY VAR_ID ASSIGNMENT ARRAYOPENER char_array_elements ARRAYCLOSER
	
	;
	
	
char_array_elements:

	CHAR
	| CHAR COMMA char_array_elements
	
	;
	
	
set_array:

	SETARRAY VAR_ID ASSIGNMENT ARRAYOPENER set_array_elements ARRAYCLOSER
	
	;
	
	
set_array_elements:

	set
	|set COMMA set_array_elements
	
	;


function_statement:

	function_call
	
	|function_declaration
	
	;
	
	
function_call:

	VAR_ID ASSIGNMENT function_name LP parameter_list RP
	
	;
	
function_name:

	STRING
	
	;
	
parameter_list:

	set
	|set COMMA parameter_list
	
	;


	
function_declaration:

	return_type function_name LP parameter_list RP LPP statements return_statement RPP
	

	;

	
comment_statement:

	COMMENT statements
	
	;
   
   
input_statement:
	
	
	IN INPUT 
	VAR_ID
	|set

	;
   
output_statement:
	
	OUT OUTPUT
	STRING 
	|set
	|BOOLEAN
	|VAR_ID
	
	;
   
loop_statement:
	
	LOOPSTMT LP BOOLEAN RP LPP statements RPP

	;
   
return_statement:

	RETURN return_type
	
	;

return_type:

	BOOLEAN
	|set
	|relations
	
	;

relations:

	subset
	|superset
	
	;
	
subset:

	set SUBSET set

	;
	
superset:
	
	set SUPERSET set
	
	;
	

if_statement:
	
	
	IFSTMT BOOLEAN statements 
	|IFSTMT BOOLEAN statements ELSESTMT statements


	;


operation:

	LP operation RP
	|LP oprt RP

	;
	
	
oprt:

	oprt UNION set
	|oprt INTERSECTION set
	|set UNION set
	|set INTERSECTION set
	|oprt COMPLEMENT set
	|oprt DIFFERENCE set
	|set DIFFERENCE set

	;
	
set:

	LPP set_elements RPP
	
	;
	
	
set_elements:

	element
	|element COMMA set_elements
	
	;
	
element:

	LETTER
	|DIGIT
	|CHAR
	|STRING
	|set

	;

%%

void yyerror(char* s) 
{
	numoferr++;
	fprintf(stdout, "%d-%s\n",yylineno,s);
}
int main()
{
	numoferr=0;
	yyparse();
	if(numoferr>0) {
		printf("Parsing could not be completed, there are errors in the code!");
		
	} else {
		printf("Successfully parsed");
	}
	return 0;
}


