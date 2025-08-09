# No legacy

# *******************
# *** Directories ***
# *******************

SRC_ZX0DIR := ./src/zx0
SRC_LZSDIR := ./src/lzsa
SRC_APUDIR := ./src/apultra
SRC_RDDDIR := ./src/roudoudou
SRC_DFSDIR := ./src/divsufsort

OBJ_ZX0DIR := ./build/obj/zx0
OBJ_LZSDIR := ./build/obj/lzsa
OBJ_APUDIR := ./build/obj/apultra
OBJ_RDDDIR := ./build/obj/roudoudou
OBJ_DFSDIR := ./build/obj/divsufsorts

LIB_DIR := ./build/lib

BIN_DIR := ./build/bin
DBG_DIR := ./build/debug
RLS_DIR := ./build/release

# *************
# *** Files ***
# *************

LIB_ZX0 := $(LIB_DIR)/libzx0.a
LIB_LZS := $(LIB_DIR)/liblzsa.a
LIB_APU := $(LIB_DIR)/libapultra.a
LIB_RDD := $(LIB_DIR)/libroudoudou.a
LIB_DFS := $(LIB_DIR)/libdivsufsort.a

EXEC_BIN := $(BIN_DIR)/rasm
EXEC_DBG := $(DBG_DIR)/rasm
EXEC_RLS := $(RLS_DIR)/rasm

# ************
# *** Find ***
# ***********

FIND_ZX0 := $(shell find $(SRC_ZX0DIR) -type f -name '*.c')
FIND_LZS := $(shell find $(SRC_LZSDIR) -type f -name '*.c')
FIND_APU := $(shell find $(SRC_APUDIR) -type f -name '*.c')
FIND_RDD := $(shell find $(SRC_RDDDIR) -type f -name '*.c')
FIND_DFS := $(shell find $(SRC_DFSDIR) -type f -name '*.c')

# ***************
# *** Objects ***
# ***************

OBJECT_ZX0 := $(patsubst $(SRC_ZX0DIR)/%.c,$(OBJ_ZX0DIR)/%.o,$(FIND_ZX0))
OBJECT_LZS := $(patsubst $(SRC_LZSDIR)/%.c,$(OBJ_LZSDIR)/%.o,$(FIND_LZS))
OBJECT_APU := $(patsubst $(SRC_APUDIR)/%.c,$(OBJ_APUDIR)/%.o,$(FIND_APU))
OBJECT_RDD := $(patsubst $(SRC_RDDDIR)/%.c,$(OBJ_RDDDIR)/%.o,$(FIND_RDD))
OBJECT_DFS := $(patsubst $(SRC_DFSDIR)/%.c,$(OBJ_DFSDIR)/%.o,$(FIND_DFS))

# *************
# *** Tools ***
# *************

CC := cc
AR := ar

# *******************
# *** Tools flags ***
# *******************

CFLAGS  := -march=native -Iinclude -L$(LIB_DIR)
LDFLAGS := -lm -lzx0 -llzsa -lapultra -ldivsufsort
ARFLAGS := rcs

# ********************
# *** Extend flags ***
# ********************

CFLAGS_OPT := $(CFLAGS) -Os
CFLAGS_DBG := $(CFLAGS) -O0 -g -pthread
CFLAGS_3RD := $(CFLAGS) -g -pthread -DNO_3RD_PARTIES=1

ZX0FLAGS := $(CFLAGS) -Os
LZSFLAGS := $(CFLAGS) -O3 -fomit-frame-pointer
APUFLAGS := $(CFLAGS) -O3 -fomit-frame-pointer
RDDFLAGS := $(CFLAGS) -Os
DFSFLAGS := $(CFLAGS) -O3

# *************
# *** Rules ***
# *************

all:\
	$(OBJECT_ZX0) $(OBJECT_LZS) $(OBJECT_APU) $(OBJECT_RDD) $(OBJECT_DFS) \
	$(LIB_ZX0) $(LIB_LZS) $(LIB_APU) $(LIB_RDD) $(LIB_DFS) \
	$(EXEC_BIN) $(EXEC_DBG) $(EXEC_RLS)

run: $(EXEC_BIN)
	@./$<

debug: $(EXEC_DBG)
	@./$<

clean:
	$(RM) \
	$(OBJECT_ZX0) $(OBJECT_LZS) $(OBJECT_APU) $(OBJECT_RDD) $(OBJECT_DFS) \
	$(LIB_ZX0) $(LIB_LZS) $(LIB_APU) $(LIB_RDD) $(LIB_DFS) \
	$(EXEC_BIN) $(EXEC_DBG) $(EXEC_RLS)

# *******************
# *** PHONY rules ***
# *******************

.PHONY: all run debug clean

# **********************
# *** Generate files ***
# **********************

$(LIB_ZX0): $(OBJECT_ZX0)
	@mkdir -p $(dir $@)
	$(AR) $(ARFLAGS) -o $@ $^

$(LIB_LZS): $(OBJECT_LZS)
	@mkdir -p $(dir $@)
	$(AR) $(ARFLAGS) -o $@ $^

$(LIB_APU): $(OBJECT_APU)
	@mkdir -p $(dir $@)
	$(AR) $(ARFLAGS) -o $@ $^

$(LIB_RDD): $(OBJECT_RDD)
	@mkdir -p $(dir $@)
	$(AR) $(ARFLAGS) -o $@ $^

$(LIB_DFS): $(OBJECT_DFS)
	@mkdir -p $(dir $@)
	$(AR) $(ARFLAGS) -o $@ $^

$(EXEC_BIN): $(OBJ_RDDDIR)/rasm.o $(LIB_ZX0) $(LIB_LZS) $(LIB_APU) $(LIB_DFS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS_OPT) -o $@ $< $(LDFLAGS)
	strip $@

$(EXEC_DBG): $(OBJ_RDDDIR)/rasm.o $(LIB_ZX0) $(LIB_LZS) $(LIB_APU) $(LIB_DFS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS_DBG) -o $@ $< $(LDFLAGS)

$(EXEC_RLS): $(OBJ_RDDDIR)/rasm.o $(LIB_ZX0) $(LIB_LZS) $(LIB_APU) $(LIB_DFS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS_OPT) -o $@ $< $(LDFLAGS)
	strip -s $@
	strip --strip-all $@
	strip --strip-unneeded $@
	strip --remove-section=".note" $@
	strip --remove-section=".comment" $@
	strip --remove-section=".shstrtab" $@
	strip --remove-section=".eh_frame" $@
	strip --remove-section=".eh_frame_hdr" $@
	strip --remove-section=".note.ABI-tag" $@
	strip --remove-section=".note.gnu.build-id" $@
	strip --remove-section=".note.gnu.property" $@

# ****************
# *** Patterns ***
# ****************

$(OBJ_ZX0DIR)/%.o: $(SRC_ZX0DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(ZX0FLAGS) -c -o $@ $<

$(OBJ_LZSDIR)/%.o: $(SRC_LZSDIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(LZSFLAGS) -c -o $@ $<

$(OBJ_APUDIR)/%.o: $(SRC_APUDIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(APUFLAGS) -c -o $@ $<

$(OBJ_RDDDIR)/%.o: $(SRC_RDDDIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(RDDFLAGS) -c -o $@ $<

$(OBJ_DFSDIR)/%.o: $(SRC_DFSDIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(DFSFLAGS) -c -o $@ $<


## ************
#
## Legacy
#
#CC   := cc
#EXEC := rasm
#
#CFLAGS := -lm -march=native -o $(EXEC)
#CFLAGS_OPT = $(CFLAGS) -O2
#CFLAGS_DBG = $(CFLAGS) -O0 -g -pthread
#CFLAGS_3RD = $(CFLAGS) -g -pthread -DNO_3RD_PARTIES
#
#SRC_APUDIR  :=./apultra-master/src
#SRC_LZSADIR :=./lzsa-master/src
#SRC_ZX0DIR  :=./ZX0-main/src
#
#APU_FLAGS=-c -O3 -fomit-frame-pointer -I$(SRC_LZSADIR)/libdivsufsort/include -I$(SRC_APUDIR)
#
#APU_OBJ =$(SRC_APUDIR)/expand.o
#APU_OBJ+=$(SRC_APUDIR)/matchfinder.o
#APU_OBJ+=$(SRC_APUDIR)/shrink.o
#APU_OBJ+=$(SRC_APUDIR)/libdivsufsort/lib/divsufsort.o
#APU_OBJ+=$(SRC_APUDIR)/libdivsufsort/lib/divsufsort_utils.o
#APU_OBJ+=$(SRC_APUDIR)/libdivsufsort/lib/sssort.o
#APU_OBJ+=$(SRC_APUDIR)/libdivsufsort/lib/trsort.o
#
#LZSA_FLAGS=-c -O3 -fomit-frame-pointer -I$(SRC_LZSADIR)/libdivsufsort/include -I$(SRC_LZSADIR)
#
#LZSA_OBJ =$(SRC_LZSADIR)/dictionary.o
#LZSA_OBJ+=$(SRC_LZSADIR)/expand_block_v1.o
#LZSA_OBJ+=$(SRC_LZSADIR)/expand_block_v2.o
#LZSA_OBJ+=$(SRC_LZSADIR)/expand_context.o
#LZSA_OBJ+=$(SRC_LZSADIR)/expand_inmem.o
#LZSA_OBJ+=$(SRC_LZSADIR)/frame.o
#LZSA_OBJ+=$(SRC_LZSADIR)/matchfinder.o
#LZSA_OBJ+=$(SRC_LZSADIR)/shrink_block_v1.o
#LZSA_OBJ+=$(SRC_LZSADIR)/shrink_block_v2.o
#LZSA_OBJ+=$(SRC_LZSADIR)/shrink_context.o
#LZSA_OBJ+=$(SRC_LZSADIR)/shrink_inmem.o
#LZSA_OBJ+=$(SRC_LZSADIR)/stream.o
#
#ZX0_FLAGS=-c -O2 -I$(SRC_ZX0DIR)
#ZX0_OBJ =$(SRC_ZX0DIR)/optimize.o
#ZX0_OBJ+=$(SRC_ZX0DIR)/compress.o
#ZX0_OBJ+=$(SRC_ZX0DIR)/memory.o
#
#.PHONY: prod third debug clean
#
#default: prod
#
#third:
#	$(CC) rasm.c $(CFLAGS_3RD)
#
#debug:
#	$(CC) $(SRC_ZX0DIR)/optimize.c $(ZX0_FLAGS)           -o $(SRC_ZX0DIR)/optimize.o
#	$(CC) $(SRC_ZX0DIR)/compress.c $(ZX0_FLAGS)           -o $(SRC_ZX0DIR)/compress.o
#	$(CC) $(SRC_ZX0DIR)/memory.c $(ZX0_FLAGS)             -o $(SRC_ZX0DIR)/memory.o
#
#	$(CC) $(SRC_APUDIR)/expand.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/expand.o
#	$(CC) $(SRC_APUDIR)/matchfinder.c $(APU_FLAGS)                           -o $(SRC_APUDIR)/matchfinder.o
#	$(CC) $(SRC_APUDIR)/shrink.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/shrink.o
#
#	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort.c $(APU_FLAGS)         -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort.o
#	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort_utils.c $(APU_FLAGS)   -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort_utils.o
#	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/sssort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/sssort.o
#	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/trsort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/trsort.o
#
#	$(CC) $(SRC_LZSADIR)/matchfinder.c $(LZSA_FLAGS)       -o $(SRC_LZSADIR)/matchfinder.o
#	$(CC) $(SRC_LZSADIR)/dictionary.c $(LZSA_FLAGS)        -o $(SRC_LZSADIR)/dictionary.o
#	$(CC) $(SRC_LZSADIR)/expand_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v1.o
#	$(CC) $(SRC_LZSADIR)/expand_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v2.o
#	$(CC) $(SRC_LZSADIR)/expand_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/expand_context.o
#	$(CC) $(SRC_LZSADIR)/expand_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/expand_inmem.o
#	$(CC) $(SRC_LZSADIR)/frame.c $(LZSA_FLAGS)             -o $(SRC_LZSADIR)/frame.o
#	$(CC) $(SRC_LZSADIR)/shrink_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v1.o
#	$(CC) $(SRC_LZSADIR)/shrink_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v2.o
#	$(CC) $(SRC_LZSADIR)/shrink_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/shrink_context.o
#	$(CC) $(SRC_LZSADIR)/shrink_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/shrink_inmem.o
#	$(CC) $(SRC_LZSADIR)/stream.c $(LZSA_FLAGS)            -o $(SRC_LZSADIR)/stream.o
#
#	$(CC) rasm.c $(CFLAGS_DBG) $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ)
#
#prod:
#	$(CC) $(SRC_ZX0DIR)/optimize.c $(ZX0_FLAGS)           -o $(SRC_ZX0DIR)/optimize.o
#	$(CC) $(SRC_ZX0DIR)/compress.c $(ZX0_FLAGS)           -o $(SRC_ZX0DIR)/compress.o
#	$(CC) $(SRC_ZX0DIR)/memory.c $(ZX0_FLAGS)             -o $(SRC_ZX0DIR)/memory.o
#
#	$(CC) $(SRC_APUDIR)/expand.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/expand.o
#	$(CC) $(SRC_APUDIR)/matchfinder.c $(APU_FLAGS)                           -o $(SRC_APUDIR)/matchfinder.o
#	$(CC) $(SRC_APUDIR)/shrink.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/shrink.o
#
#	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort.c $(APU_FLAGS)         -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort.o
#	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort_utils.c $(APU_FLAGS)   -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort_utils.o
#	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/sssort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/sssort.o
#	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/trsort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/trsort.o
#
#	$(CC) $(SRC_LZSADIR)/matchfinder.c $(LZSA_FLAGS)       -o $(SRC_LZSADIR)/matchfinder.o
#	$(CC) $(SRC_LZSADIR)/dictionary.c $(LZSA_FLAGS)        -o $(SRC_LZSADIR)/dictionary.o
#	$(CC) $(SRC_LZSADIR)/expand_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v1.o
#	$(CC) $(SRC_LZSADIR)/expand_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v2.o
#	$(CC) $(SRC_LZSADIR)/expand_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/expand_context.o
#	$(CC) $(SRC_LZSADIR)/expand_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/expand_inmem.o
#	$(CC) $(SRC_LZSADIR)/frame.c $(LZSA_FLAGS)             -o $(SRC_LZSADIR)/frame.o
#	$(CC) $(SRC_LZSADIR)/shrink_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v1.o
#	$(CC) $(SRC_LZSADIR)/shrink_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v2.o
#	$(CC) $(SRC_LZSADIR)/shrink_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/shrink_context.o
#	$(CC) $(SRC_LZSADIR)/shrink_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/shrink_inmem.o
#	$(CC) $(SRC_LZSADIR)/stream.c $(LZSA_FLAGS)            -o $(SRC_LZSADIR)/stream.o
#
#	$(CC) rasm.c $(CFLAGS_OPT) $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ)
#	strip $(EXEC)
#
#reloadd:
#	$(CC) rasm.c $(CFLAGS_DBG) $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ)
#
#reload:
#	$(CC) rasm.c $(CFLAGS_OPT) $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ)
#	strip $(EXEC)
#
#release:
#	$(CC) $(SRC_ZX0DIR)/optimize.c $(ZX0_FLAGS)           -o $(SRC_ZX0DIR)/optimize.o
#	$(CC) $(SRC_ZX0DIR)/compress.c $(ZX0_FLAGS)           -o $(SRC_ZX0DIR)/compress.o
#	$(CC) $(SRC_ZX0DIR)/memory.c $(ZX0_FLAGS)             -o $(SRC_ZX0DIR)/memory.o
#
#	$(CC) $(SRC_APUDIR)/expand.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/expand.o
#	$(CC) $(SRC_APUDIR)/matchfinder.c $(APU_FLAGS)                           -o $(SRC_APUDIR)/matchfinder.o
#	$(CC) $(SRC_APUDIR)/shrink.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/shrink.o
#
#	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort.c $(APU_FLAGS)         -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort.o
#	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort_utils.c $(APU_FLAGS)   -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort_utils.o
#	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/sssort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/sssort.o
#	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/trsort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/trsort.o
#
#	$(CC) $(SRC_LZSADIR)/matchfinder.c $(LZSA_FLAGS)       -o $(SRC_LZSADIR)/matchfinder.o
#	$(CC) $(SRC_LZSADIR)/dictionary.c $(LZSA_FLAGS)        -o $(SRC_LZSADIR)/dictionary.o
#	$(CC) $(SRC_LZSADIR)/expand_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v1.o
#	$(CC) $(SRC_LZSADIR)/expand_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v2.o
#	$(CC) $(SRC_LZSADIR)/expand_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/expand_context.o
#	$(CC) $(SRC_LZSADIR)/expand_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/expand_inmem.o
#	$(CC) $(SRC_LZSADIR)/frame.c $(LZSA_FLAGS)             -o $(SRC_LZSADIR)/frame.o
#	$(CC) $(SRC_LZSADIR)/shrink_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v1.o
#	$(CC) $(SRC_LZSADIR)/shrink_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v2.o
#	$(CC) $(SRC_LZSADIR)/shrink_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/shrink_context.o
#	$(CC) $(SRC_LZSADIR)/shrink_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/shrink_inmem.o
#	$(CC) $(SRC_LZSADIR)/stream.c $(LZSA_FLAGS)            -o $(SRC_LZSADIR)/stream.o
#	$(CC) rasm.c $(CFLAGS_OPT) $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ)
#	strip $(EXEC)
#
#clean:
#	rm -rf *.o
#
#