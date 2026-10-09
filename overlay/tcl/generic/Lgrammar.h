/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Skeleton interface for Bison GLR parsers in C

   Copyright (C) 2002-2015, 2018-2021 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_L_LGRAMMAR_H_INCLUDED
# define YY_L_LGRAMMAR_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int L_debug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    END = 0,                       /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    T_ANDAND = 258,                /* "&&"  */
    T_ARROW = 259,                 /* "=>"  */
    T_ATTRIBUTE = 260,             /* "_attribute"  */
    T_BANG = 261,                  /* "!"  */
    T_BANGTWID = 262,              /* "!~"  */
    T_BITAND = 263,                /* "&"  */
    T_BITOR = 264,                 /* "|"  */
    T_BITNOT = 265,                /* "~"  */
    T_BITXOR = 266,                /* "^"  */
    T_BREAK = 267,                 /* "break"  */
    T_CLASS = 268,                 /* "class"  */
    T_COLON = 269,                 /* ":"  */
    T_COMMA = 270,                 /* ","  */
    T_CONSTRUCTOR = 271,           /* "constructor"  */
    T_CONTINUE = 272,              /* "continue"  */
    T_DEFINED = 273,               /* "defined"  */
    T_DESTRUCTOR = 274,            /* "destructor"  */
    T_DO = 275,                    /* "do"  */
    T_DOT = 276,                   /* "."  */
    T_DOTDOT = 277,                /* ".."  */
    T_ELLIPSIS = 278,              /* "..."  */
    T_ELSE = 279,                  /* "else"  */
    T_EQ = 280,                    /* "eq"  */
    T_EQBITAND = 281,              /* "&="  */
    T_EQBITOR = 282,               /* "|="  */
    T_EQBITXOR = 283,              /* "^="  */
    T_EQDOT = 284,                 /* ".="  */
    T_EQLSHIFT = 285,              /* "<<="  */
    T_EQMINUS = 286,               /* "-="  */
    T_EQPERC = 287,                /* "%="  */
    T_EQPLUS = 288,                /* "+="  */
    T_EQRSHIFT = 289,              /* ">>="  */
    T_EQSTAR = 290,                /* "*="  */
    T_EQSLASH = 291,               /* "/="  */
    T_EQTWID = 292,                /* "=~"  */
    T_EQUALS = 293,                /* "="  */
    T_EQUALEQUAL = 294,            /* "=="  */
    T_EXPAND = 295,                /* "(expand)"  */
    T_EXTERN = 296,                /* "extern"  */
    T_FLOAT = 297,                 /* "float"  */
    T_FLOAT_LITERAL = 298,         /* "float constant"  */
    T_FOR = 299,                   /* "for"  */
    T_FOREACH = 300,               /* "foreach"  */
    T_GOTO = 301,                  /* "goto"  */
    T_GE = 302,                    /* "ge"  */
    T_GREATER = 303,               /* ">"  */
    T_GREATEREQ = 304,             /* ">="  */
    T_GT = 305,                    /* "gt"  */
    T_HTML = 306,                  /* T_HTML  */
    T_ID = 307,                    /* "id"  */
    T_IF = 308,                    /* "if"  */
    T_INSTANCE = 309,              /* "instance"  */
    T_INT = 310,                   /* "int"  */
    T_INT_LITERAL = 311,           /* "integer constant"  */
    T_LHTML_EXPR_START = 312,      /* "<?="  */
    T_LHTML_EXPR_END = 313,        /* "?>"  */
    T_LBRACE = 314,                /* "{"  */
    T_LBRACKET = 315,              /* "["  */
    T_LE = 316,                    /* "le"  */
    T_LEFT_INTERPOL = 317,         /* "${"  */
    T_LEFT_INTERPOL_RE = 318,      /* "${ (in re)"  */
    T_LESSTHAN = 319,              /* "<"  */
    T_LESSTHANEQ = 320,            /* "<="  */
    T_LPAREN = 321,                /* "("  */
    T_LSHIFT = 322,                /* "<<"  */
    T_LT = 323,                    /* "lt"  */
    T_MINUS = 324,                 /* "-"  */
    T_MINUSMINUS = 325,            /* "--"  */
    T_NE = 326,                    /* "ne"  */
    T_NOTEQUAL = 327,              /* "!="  */
    T_OROR = 328,                  /* "||"  */
    T_PATTERN = 329,               /* "pattern function"  */
    T_PERC = 330,                  /* "%"  */
    T_PLUS = 331,                  /* "+"  */
    T_PLUSPLUS = 332,              /* "++"  */
    T_POINTS = 333,                /* "->"  */
    T_POLY = 334,                  /* "poly"  */
    T_PRIVATE = 335,               /* "private"  */
    T_PUBLIC = 336,                /* "public"  */
    T_QUESTION = 337,              /* "?"  */
    T_RBRACE = 338,                /* "}"  */
    T_RBRACKET = 339,              /* "]"  */
    T_RE = 340,                    /* "regular expression"  */
    T_RE_MODIFIER = 341,           /* "regexp modifier"  */
    T_RETURN = 342,                /* "return"  */
    T_RIGHT_INTERPOL = 343,        /* "} (end of interpolation)"  */
    T_RIGHT_INTERPOL_RE = 344,     /* "} (end of interpolation in re)"  */
    T_RPAREN = 345,                /* ")"  */
    T_RSHIFT = 346,                /* ">>"  */
    T_TRY = 347,                   /* "try"  */
    T_SEMI = 348,                  /* ";"  */
    T_SLASH = 349,                 /* "/"  */
    T_SPLIT = 350,                 /* "split"  */
    T_STAR = 351,                  /* "*"  */
    T_START_BACKTICK = 352,        /* "backtick"  */
    T_STR_BACKTICK = 353,          /* "`"  */
    T_STR_LITERAL = 354,           /* "string constant"  */
    T_STRCAT = 355,                /* " . "  */
    T_STRING = 356,                /* "string"  */
    T_STRUCT = 357,                /* "struct"  */
    T_SUBST = 358,                 /* "=~ s/a/b/"  */
    T_TYPE = 359,                  /* "type name"  */
    T_TYPEDEF = 360,               /* "typedef"  */
    T_UNLESS = 361,                /* "unless"  */
    T_ARGUSED = 362,               /* "_argused"  */
    T_OPTIONAL = 363,              /* "_optional"  */
    T_MUSTBETYPE = 364,            /* "_mustbetype"  */
    T_VOID = 365,                  /* "void"  */
    T_WIDGET = 366,                /* "widget"  */
    T_WHILE = 367,                 /* "while"  */
    T_PRAGMA = 368,                /* "#pragma"  */
    T_SWITCH = 369,                /* "switch"  */
    T_CASE = 370,                  /* "case"  */
    T_DEFAULT = 371,               /* "default"  */
    LOWEST = 372,                  /* LOWEST  */
    PREFIX_INCDEC = 373,           /* PREFIX_INCDEC  */
    UPLUS = 374,                   /* UPLUS  */
    UMINUS = 375,                  /* UMINUS  */
    ADDRESS = 376,                 /* ADDRESS  */
    HIGHEST = 377                  /* HIGHEST  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 53 "Lgrammar.y"

	long	i;
	char	*s;
	Tcl_Obj	*obj;
	Type	*Type;
	Expr	*Expr;
	Block	*Block;
	ForEach	*ForEach;
	Switch	*Switch;
	Case	*Case;
	FnDecl	*FnDecl;
	Cond	*Cond;
	Loop	*Loop;
	Stmt	*Stmt;
	TopLev	*TopLev;
	VarDecl	*VarDecl;
	ClsDecl	*ClsDecl;
	struct {
		Type	*t;
		char	*s;
	} Typename;

#line 204 "Lgrammar.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE L_lval;
extern YYLTYPE L_lloc;
int L_parse (void);

#endif /* !YY_L_LGRAMMAR_H_INCLUDED  */
