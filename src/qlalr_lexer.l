%{

#define YY_DECL int Parser::yylex()

namespace {
QString text;
}

%}

%option noyywrap
%x DECL
%x IMPL
%x C_COMMENT
%%

"/*" BEGIN(C_COMMENT);
<C_COMMENT>{
"*/"      BEGIN(INITIAL);
[\n]+     yylineno += yyleng;
.
}

"/."                        text = lineInfo(); BEGIN(IMPL);
<IMPL>{
"./"[ \t\r]*$               flags->impl_text.append(text); BEGIN(INITIAL);
[\n]+                       text += QString::fromUtf8(yytext, yyleng); yylineno += yyleng;
"$$"                        text += '$';
"$"[a-zA-Z][a-zA-Z0-9_]+    text += expand(QString::fromUtf8(yytext + 1, yyleng - 1));
.                           text += QLatin1Char(yytext[0]);
}

"/:"                        text = lineInfo(); BEGIN(DECL);
<DECL>{
":/"[ \t\r]*$               flags->decl_text.append(text); BEGIN(INITIAL);
[\n]+                       text += QString::fromUtf8(yytext, yyleng); yylineno += yyleng;
"$$"                        text += '$';
"$"[a-zA-Z][a-zA-Z0-9_]+    text += expand(QString::fromUtf8(yytext + 1, yyleng - 1));
.                           text += QLatin1Char(yytext[0]);
}

[\n]+ yylineno += yyleng;
[ \t\r]+
"--".*
"//".*
"%%"
"%token_prefix"             return T_TOKEN_PREFIX;
"%merged_output"            return T_MERGED_OUTPUT;
"%token"                    return T_TOKEN;
"%start"                    return T_START;
"%parser"                   return T_PARSER;
"%decl"                     return T_DECL_FILE;
"%impl"                     return T_IMPL_FILE;
"%expect"                   return T_EXPECT;
"%expect-rr"                return T_EXPECT_RR;
"%left"                     return T_LEFT;
"%right"                    return T_RIGHT;
"%nonassoc"                 return T_NONASSOC;
"%prec"                     return T_PREC;

":"                         return T_COLON;
"::="                       return T_COLON_COLON_EQUAL;
";"                         return T_SEMICOLON;
"|"                         return T_BAR;
"%"[\-._a-zA-Z0-9]+         fprintf(stderr, "ignored directive %s\n", yytext);
["]([^"]|\\\")*["]                 yylval = QString::fromUtf8(yytext + 1, yyleng - 2); return T_STRING_LITERAL;
[\-._a-zA-Z0-9]+            yylval = QString::fromUtf8(yytext, yyleng); return T_IDENTIFIER;
.                           return T_ERROR;
