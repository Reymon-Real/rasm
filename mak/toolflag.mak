# *******************************
# *** Linker search libraries ***
# *******************************

LDDIR := -L$(LIB_DIR)

# ************************
# *** Linker libraries *** 
# ************************

ifeq ($(OS), Windows_NT)
LDDYM := 
else
LDDYM := -Bdynamic -lc -lm
endif

LDSTC := -Bstatic -lzx0 -llzsa -lapultra -ldivsufsort

# ********************
# *** Common flags ***
# ********************

CFLAGS  := -march=native -I$(INC_DIR)
LDFLAGS := $(LDDIR) $(LDDYM) $(LDSTC)
ARFLAGS := rcs

# **********************
# *** Specific flags ***
# **********************

CFLAGS_OPT := $(CFLAGS) -Os
CFLAGS_DBG := $(CFLAGS) -O0 -g -pthread
CFLAGS_3RD := $(CFLAGS) -g -pthread -DNO_3RD_PARTIES=1

ZX0FLAGS := $(CFLAGS) -Os
LZSFLAGS := $(CFLAGS) -O3 -fomit-frame-pointer
APUFLAGS := $(CFLAGS) -O3 -fomit-frame-pointer
RDDFLAGS := $(CFLAGS) -Os
DFSFLAGS := $(CFLAGS) -O3