TEMPLATE = app
QT = core
TARGET = qlalr
mac:CONFIG -= app_bundle
CONFIG += console

# Input
HEADERS += qlalr.h qlalr_lexer.h compress.h cppgenerator.h
SOURCES += qlalr_parser.cpp qlalr.cpp compress.cpp cppgenerator.cpp

OTHER_FILES = qlalr.qlalr qlalr_lexer.l

