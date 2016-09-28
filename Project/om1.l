%option noyywrap


%{
#include <iostream>
using namespace std;
#define YY_DECL extern "C" int yylex()
#include "om.tab.h"

%}
Identifier 	[_a-zA-Z]+[_a-zA-Z0-9]*	
Digits		[0-9]+
Hexadec		0x[0-9a-fA-F]+	
AssignOp	"="|"+="|"-="	
StringL		\"(\\.|[^\\"])*\"	
Whitespace	[ \t\n]*
CharL		'(\\.|[^\\'])+'
%%


(true|false)								{yylval.bval = yytext; 
										return BOOL_LITERAL;}


(for)								{return FOR;}

(if)									{return IF;}

(class)								{return CLASS;}

(Program)								{return PROGRAM;}

(int)								{yylval.sval = strdup(yytext);return INT;}

(boolean)							{yylval.sval = strdup(yytext);return BOOL;}

(void)								{return VOID;}

(else)									{return ELSE;}

(break)									{return BREAK;}

(continue)							{return CONTINUE;}

(return)								{return RETURN;}

(callout)								{return CALLOUT;}

{Identifier}					{yylval.sval = strdup(yytext);
											return IDENTIFIER;}

{Digits}						    {yylval.sval = strdup(yytext);
											return DECIMAL_LITERAL;}

{Hexadec}						{yylval.sval = strdup(yytext);
													return HEX_LITERAL;}

{AssignOp}						{return ASSIGNMENT_OPERATOR;}

{CharL}							{yylval.sval = strdup(yytext);
											return CHAR_LITERAL;}

"=="									{return EQUAL_EQUAL;}

"<="									{return LESS_EQUAL;}

">="									{return GREATER_EQUAL;}

"!="									{return NOT_EQUAL;}

"||"									{return OR;}

"&&"									{return AND;}

\/\/.*$															

{Whitespace}		

{StringL}					{yylval.sval = strdup(yytext);
												return STRING_LITERAL;}

		
.										{return *yytext;}

%%

/*int main(){
	//int a = yyparse();
    //if(!a)
     //   cout<<"Valid code"<<endl;
    //else
      //  cout<<"Not valid code"<<endl;
return 0;
}*/
