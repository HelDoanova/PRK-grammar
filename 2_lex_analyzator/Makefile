# This is a general makefile used for the gitlab CI/CD.
ll_u2 := lenka_language/U2_lex_analyzator/flex
ll_u3 := lenka_language/U3_synt_analyzator/yacc
ll_u4 := lenka_language/U4_calculator/yacc 

ll_tasks := $(ll_u2) $(ll_u3) $(ll_u4)

.PHONY: all ll_all $(ll_tasks)

all: ll_all praxis_all

ll_all: $(ll_tasks)

$(ll_tasks):
	$(MAKE) --directory=$@ 
	

praxis_all:
	echo "No rules for praxis defined yet."