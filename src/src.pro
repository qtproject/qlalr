TEMPLATE = app
QT = core
TARGET = qlalr
mac:CONFIG -= app_bundle
CONFIG += console

# Input
HEADERS += qlalr.h compress.h cppgenerator.h qlalr_lexer.h
SOURCES += qlalr.cpp compress.cpp cppgenerator.cpp qlalr_parser.cpp

PARSER_SOURCES = qlalr.qlalr
LEXER_SOURCES = qlalr_lexer.l

make_parser.name = Generate the front-end
make_parser.input = qlalr.qlalr qlalr_lexer.l
make_parser.output = qlalr_parser.cpp lalr_lexer.h
make_parser.commands = (qlalr qlalr.qlalr; flex -oqlalr_lexer.h qlalr_lexer.l)

QMAKE_EXTRA_TARGETS += make_parser
PRE_TARGETDEPS += make_parser


