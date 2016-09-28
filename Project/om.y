%{
#include <cstdio>
#include <iostream>
using namespace std;

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;

void yyerror(const char *s);
%}

%union {
    int ival;
    bool bval;
    char cval;
    char *sval;
}
// define the constant-string tokens:



%token <sval>INT
%token <sval>BOOL
%token CALLOUT
%token ASSIGNMENT_OPERATOR
%token <sval> IDENTIFIER
%token CLASS
%token PROGRAM
%token FOR
%token IF
%token ELSE
%token CONTINUE
%token BREAK
%token VOID
%token RETURN

%token <sval>HEX_LITERAL
%token <sval>DECIMAL_LITERAL
%token <sval>CHAR_LITERAL
%token <bval> BOOL_LITERAL
%token <sval>STRING_LITERAL

%left INT 
%left BOOL
%left OR
%left AND
%left EQUAL_EQUAL NOT_EQUAL
%left GREATER_EQUAL LESS_EQUAL '<' '>'
%left '+' '-' 
%left '*' '/' '%'
%left UMINUS
%nonassoc '!'

%%



program: 					CLASS PROGRAM  '{' field_decl_m method_decl_m '}' {cout<<"PROGRAM ENCOUNTERED"<<endl;};
																		
field_decl_m:			Empty			                
							|field_decl_m field_decl_s ';' 	;





field_decl_s:                     TYPE IDENTIFIER id_single                      { cout<<"INT DECLARATION FOUND"<<endl <<"Id="<<$2<< endl;}
                            |TYPE IDENTIFIER '[' DECIMAL_LITERAL ']' id_single     {cout<<"INT DECLARATION FOUND"<<endl<<"Id="<< $2 << endl<<"Size="<<$4<<endl;}
			|  TYPE IDENTIFIER '[' HEX_LITERAL ']' id_single     {cout<<" DECLARATION FOUND"<<endl<<"Id="<< $2 << endl<<"Size="<<$4<<endl;}
			  

				;


						;	
id_single: 					Empty								
							|',' IDENTIFIER id_single 			{ cout <<"Id="<<$2<< endl;}		
							|',' IDENTIFIER '[' DECIMAL_LITERAL ']' id_single	{ cout <<"Id="<<$2<< endl<<"Size="<<$4<<endl;}						|',' IDENTIFIER '[' HEX_LITERAL ']' id_single	{ cout <<"Id="<<$2<< endl<<"Size="<<$4<<endl;}	;					

						
method_decl_m:			Empty						
							|method_decl_s method_decl_m  ;

method_decl_s: 		TYPE IDENTIFIER argList block 	  	{cout<<$2<<"METHOD ENDED"<<endl;}
                            |VOID IDENTIFIER argList block 	{cout<<$2<<"METHOD ENDED"<<endl;};   

argList:               '(' ')'                                    {cout<<"METHOD ENCOUNTERED"<<endl;}
                            |'(' TYPE IDENTIFIER arg ')'              {cout<<"METHOD ENCOUNTERED"<<endl;};


arg:					     Empty								
							|',' TYPE IDENTIFIER arg 		;			

block:						'{' var_decl_multiple statement_multiple '}'   {cout<<"EXITING OUT OF BLOCK"<<endl;};

var_decl_multiple:				Empty							
							|var_decl_single ';' var_decl_multiple 	;	

var_decl_single:			INT IDENTIFIER variableList 	{cout<<"INT DECLARATION FOUND"<<endl<<"ID="<<$2<<endl;}
					|
					BOOL IDENTIFIER variableList 	{cout<<"BOOL DECLARATION FOUND"<<endl<<"ID="<<$2<<endl;};
;

TYPE:				INT|BOOL;
variableList:					Empty								
							|',' IDENTIFIER variableList		{cout<<"ID="<<$2<<endl;};		
							;
statement_multiple:			Empty									
							|statement_multiple statement_single		
							;
statement_single:			location ASSIGNMENT_OPERATOR expr ';'	 { cout <<"ASSIGNMENT OPERATION ENCOUNTERED"<<endl;}		
							|method_call ';'							
							|IF condition block else_block		{cout<<"IF CONDITION FOUND"<<endl;}		
							|FOR IDENTIFIER ASSIGNMENT_OPERATOR expr ',' expr block		{cout<<" FOR FOUND"<<endl;}
							|RETURN return_expr ';'	 {cout<<"RETURN OPERATION FOUND"<<endl;}				
							|BREAK ';'		{cout<<"BREAK FOUND"<<endl;}							
							|CONTINUE ';'		{cout<<"CONTINUE FOUND"<<endl;}						
							|block			{cout<<"BLOCK"<<endl;}
									
							;
else_block:                 Empty        
                            |ELSE block            {cout<<"ELSE BLOCK"<<endl;}                    
							;
condition:                  '(' expr ')'                                
							;
return_expr:                Empty                           
                            |expr                                       
							;
expr:						location							
							|method_call		 					
							|literal				
							|arith_expr								
							|rel_expr		{cout<<"RELATION OPERATION ENCOUNTERED" <<endl;}							              
							|equal_expr							       
							|condition_expr		{cout<<"CONDITION EXPRESSION ENCOUNTERED" <<endl;}								
							|'-' expr								
							|'!' expr								
							|'(' expr ')'	
														
							;
location:					IDENTIFIER		 { cout <<"LOCATION ENCOUNTERED="<< $1<<endl;}				
							|IDENTIFIER '[' expr ']'		 { cout <<"LOCATION ENCOUNTERED="<< $1<<endl;}			
							;
method_call:			    method_name '('parameterList')'				
						    |CALLOUT '(' STRING_LITERAL  callout_arg ')'
							;
method_name:                IDENTIFIER                                
							;
parameterList:              Empty                               
                            | expr parameter                            
							;	
parameter:					Empty								
							|',' expr parameter 							
							;
literal:                    int_literal									
						    |CHAR_LITERAL		{cout<<"CHAR ENCOUNTERED=" << $1<<endl;}					
						    |BOOL_LITERAL		{cout<<"BOOLEAN ENCOUNTERED=" << boolalpha<<$1<<endl;}				
							;	
int_literal:				DECIMAL_LITERAL								
						    |HEX_LITERAL				

						;


arith_expr:					expr '*' expr	{cout<<"MULTIPLICATION ENCOUNTERED"<<endl;}							
							|expr '/' expr	{cout<<"DIVISION ENCOUNTERED"<<endl;}											|expr '%' expr								{cout<<"MOD ENCOUTERED"<<endl;}
							|expr '+' expr			{cout<<"ADDITION ENCOUNTERED"<<endl;}				
							|expr '-' expr	{cout<<"SUBTRACTION ENCOUNTERED"<<endl;}							
							;
rel_expr:					expr '<' expr	{cout<<"LESS THAN ENCOUNTERED"<<endl;}							
							|expr '>' expr			{cout<<"GREATER THAN ENCOUNTERED" <<endl;}				
							|expr LESS_EQUAL expr		{cout<<"LESSTHANEQUALTO ENCOUNTERED" <<endl;}								
							|expr GREATER_EQUAL expr {cout<<"GREATERTHANEQUALTO ENCOUNTERED" <<endl;}					
							;
equal_expr:					expr EQUAL_EQUAL expr		{cout<<"==COMPARISON ENCOUNTERED" <<endl;}								
							|expr NOT_EQUAL expr		{cout<<"!=COMPARISON ENCOUNTERED" <<endl;}								
							;
condition_expr:				expr AND expr			{cout<<"AND ENCOUNTERED" <<endl;}									
							|expr OR expr	{cout<<"OR ENCOUNTERED" <<endl;}								
							;
callout_arg:			    Empty								
						    |callout_arg ',' expr
													
|callout_arg ',' STRING_LITERAL  { cout <<"CALLOUT TO"<< $3<<"ENCOUNTERED"<<endl;}	
								; 

Empty:
		;
%%
int main(int, char**) {
    // open a file handle to a particular file:
    FILE *myfile = fopen("decaf.txt", "r");
    // make sure it's valid:
    if (!myfile) {
        cout << "I can't open test_program!" << endl;
        return -1;
    }
    // set flex to read from it instead of defaulting to STDIN:
    yyin = myfile;

    // parse through the input until there is no more:
    do {
       cout<< yyparse();
    } while (!feof(yyin));

}

void yyerror(const char *s) {
    cout << "EEK, parse error!  Message: " << s << endl;
    // might as well halt now:
    exit(-1);
}

