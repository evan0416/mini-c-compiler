%{
#include <stdio.h>
#include <stdarg.h>

extern int yylex();
extern int yylineno;
extern char* yytext;

void yyerror(const char* s);
void yyprintf(const char* format, ...);
void yyscanf(const char* format, ...);

%}

%union {
    int intval;
    float floatval;
}

%token <intval> INTEGER
%token <floatval> FLOAT
%token PRINTF SCANF

%type <intval> int_expr
%type <floatval> float_expr

%start program

%%

program: /* empty */
        | program statement
        ;

statement: int_expr ';'   { printf("\nResult: %d\n", $1); }
         | float_expr ';' { printf("\nResult: %f\n", $1); }
         | PRINTF int_expr  { yyprintf($2); }
         | PRINTF float_expr { yyprintf($2); }
         | SCANF int_expr   { yyscanf($2); }
         | SCANF float_expr { yyscanf($2); }
         ;

int_expr: INTEGER   { $$ = $1; }
        | int_expr '+' int_expr   { $$ = $1 + $3; }
        | int_expr '-' int_expr   { $$ = $1 - $3; }
        | int_expr '*' int_expr   { $$ = $1 * $3; }
        | int_expr '/' int_expr   { $$ = $1 / $3; }
        | '(' int_expr ')'   { $$ = $2; }
        ;

float_expr: FLOAT   { $$ = $1; }
           | float_expr '+' float_expr   { $$ = $1 + $3; }
           | float_expr '-' float_expr   { $$ = $1 - $3; }
           | float_expr '*' float_expr   { $$ = $1 * $3; }
           | float_expr '/' float_expr   { $$ = $1 / $3; }
           | '(' float_expr ')'   { $$ = $2; }
           ;

%%

void yyerror(const char* s) {
    fprintf(stderr, "error: %s at line %d\n", s, yylineno);
}

void yyprintf(const char* format, ...) {
    va_list args;
    va_start(args, format);
    vprintf(format, args);
    va_end(args);
}

void yyscanf(const char* format, ...) {
    va_list args;
    va_start(args, format);
    vscanf(format, args);
    va_end(args);
}

int main() {
    yyparse();
    return 0;
}
