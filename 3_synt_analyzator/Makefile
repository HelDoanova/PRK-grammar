MAKE=make
GCC=gcc

FILENAME=ll
PRINT_OUTPUT="y"

PARSER_BIN="ll_parser"

ROOT_DIR=$(shell pwd)
INCDIR=$(ROOT_DIR)/inc
INCFILES=$(wildcard $(INCDIR)/*.c)
#LIBOBJS = $(wildcard $(LIBDIR)/*.o)
#LIBNAMES = $(shell basename -s ".o" $(LIBOBJS))
#LIBS = $(addprefix -l, $(LIBNAMES))

BINDIR="./bin"
TESTDIR="../testfiles"
TEST_OK_FILE="test_ok.txt"
TEST_NOOK_FILE="test_nook.txt"

.PHONY: parser test_ok test_nook subclean clean all

all: clean parser test_ok test_nook
	@if [ $(PRINT_OUTPUT) ]; then cat $(BINDIR)/$(TEST_OK_FILE).report; fi
	@if [ $(PRINT_OUTPUT) ]; then cat $(BINDIR)/$(TEST_NOOK_FILE).report; fi


test:
	echo $(ROOT_DIR)
	echo $(LIBOBJS)
	echo $(LIBNAMES)
	echo $(LIBS)

parser:
	yacc -d $(FILENAME).y
	flex $(FILENAME).lex
	$(GCC) -I$(INCDIR) $(INCFILES) lex.yy.c y.tab.c y.tab.h -o $(PARSER_BIN)
	@mv $(PARSER_BIN) $(BINDIR)/
#	@make -s subclean

test_ok:
	@./$(BINDIR)/$(PARSER_BIN) < $(TESTDIR)/$(TEST_OK_FILE) >$(BINDIR)/$(TEST_OK_FILE).report
test_nook:
	@./$(BINDIR)/$(PARSER_BIN) < $(TESTDIR)/$(TEST_NOOK_FILE) >$(BINDIR)/$(TEST_NOOK_FILE).report

subclean:
	@rm -rf lex.yy.c
	@rm -rf y.tab.h y.tab.c

clean: subclean
	@rm -rf $(BINDIR)/*

