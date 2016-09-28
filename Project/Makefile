a.out: lex.yy.c om.tab.c om.tab.h
	g++ om.tab.c lex.yy.c -lfl 
	
om.tab.c om.tab.h: om.y
	bison -d om.y

lex.yy.c: om1.l om.tab.h
	flex om1.l

