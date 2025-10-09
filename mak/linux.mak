# ***********************
# *** Important paths ***
# ***********************

OBJ_DIR := build/objects/linux
BIN_DIR := build/bin/linux

SRC_ZX0DIR	:= src/zx0
SRC_APUDIR	:= src/apultra
SRC_LZSADIR	:= src/lzsa

OBJ_ZX0DIR	:= $(OBJ_DIR)/zx0
OBJ_APUDIR	:= $(OBJ_DIR)/apultra
OBJ_LZSADIR	:= $(OBJ_DIR)/lzsa

# ***********************
# *** Important files ***
# ***********************

EXEC := $(BIN_DIR)/rasm

# ******************
# *** Find files ***
# ******************

SRC_APU := $(shell find $(SRC_APUDIR) -type f -name '*.c')
SRC_ZX0 := $(shell find $(SRC_ZX0DIR) -type f -name '*.c')
SRC_LZSA := $(shell find $(SRC_LZSADIR) -type f -name '*.c')

SRC_APU_OUT := $(filter-out $(SRC_APUDIR)/apultra.c,$(SRC_APU))
SRC_LZSA_OUT := $(filter-out $(SRC_LZSADIR)/lzsa.c,$(SRC_LZSA))

OBJ_APU := $(patsubst $(SRC_APUDIR)/%.c,$(OBJ_APUDIR)/%.o,$(SRC_APU_OUT))
OBJ_ZX0 := $(patsubst $(SRC_ZX0DIR)/%.c,$(OBJ_ZX0DIR)/%.o,$(SRC_ZX0))
OBJ_LZSA := $(patsubst $(SRC_LZSADIR)/%.c,$(OBJ_LZSADIR)/%.o,$(SRC_LZSA_OUT))

# *************
# *** Tools ***
# *************

CC := cc

# *************
# *** Flags ***
# *************

CFLAGS = -Iinclude -march=native -o $(EXEC)
CFLAGS_OPT = $(CFLAGS) -O2
CFLAGS_DBG = $(CFLAGS) -O0 -g -pthread
CFLAGS_3RD = $(CFLAGS) -g -pthread -DNO_3RD_PARTIES

# APU compilation flags
APU_FLAGS = -c -O3 -fomit-frame-pointer -I$(SRC_APUDIR) -Iinclude

# ZX0 compilation flags
ZX0_FLAGS = -c -O2 -I$(SRC_ZX0DIR) -Iinclude

# LZSA compilation flags
LZSA_FLAGS = -c -O3 -fomit-frame-pointer -I$(SRC_LZSADIR) -Iinclude

# ********************
# *** Object files ***
# ********************

# APU object files
APU_OBJ =   $(SRC_APUDIR)/expand.o \
			$(SRC_APUDIR)/matchfinder.o \
			$(SRC_APUDIR)/shrink.o \
			$(SRC_APUDIR)/libdivsufsort/lib/divsufsort.o \
			$(SRC_APUDIR)/libdivsufsort/lib/divsufsort_utils.o \
			$(SRC_APUDIR)/libdivsufsort/lib/sssort.o \
			$(SRC_APUDIR)/libdivsufsort/lib/trsort.o

# LZSA object files
LZSA_OBJ =  $(SRC_LZSADIR)/dictionary.o \
			$(SRC_LZSADIR)/expand_block_v1.o \
			$(SRC_LZSADIR)/expand_block_v2.o \
			$(SRC_LZSADIR)/expand_context.o \
			$(SRC_LZSADIR)/expand_inmem.o \
			$(SRC_LZSADIR)/frame.o \
			$(SRC_LZSADIR)/matchfinder.o \
			$(SRC_LZSADIR)/shrink_block_v1.o \
			$(SRC_LZSADIR)/shrink_block_v2.o \
			$(SRC_LZSADIR)/shrink_context.o \
			$(SRC_LZSADIR)/shrink_inmem.o \
			$(SRC_LZSADIR)/stream.o \

# ZX0 object files
ZX0_OBJ =   $(SRC_ZX0DIR)/optimize.o \
			$(SRC_ZX0DIR)/compress.o \
			$(SRC_ZX0DIR)/memory.o

# ********************
# *** .PHONY Rules ***
# ********************

.PHONY: prod third debug clean

all:
	make -j$(shell nproc) objects TARGET=linux
	make -j$(shell nproc) executable TARGET=linux

run: $(EXEC)
	@./$< test/main.asm

executable: $(EXEC)

objects: $(OBJ_ZX0) $(OBJ_APU) $(OBJ_LZSA)

$(EXEC): src/rasm.o $(OBJ_ZX0) $(OBJ_APU) $(OBJ_LZSA)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS_OPT) $^ -lm
	strip $(EXEC)

$(OBJ_DIR)/rasm.o: src/rasm.c
	@mkdir -p $(dir $@)
	$(CC) -Iinclude -march=native -O2 -o $@ $< 

$(OBJ_ZX0DIR)/%.o: $(SRC_ZX0DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(ZX0_FLAGS) -o $@ $<

$(OBJ_APUDIR)/%.o: $(SRC_APUDIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(APU_FLAGS) -o $@ $<

$(OBJ_LZSADIR)/%.o: $(SRC_LZSADIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(LZSA_FLAGS) -o $@ $<

# Default target
#default: prod

# Third-party libraries compilation
third:
	$(CC) src/rasm.c $(CFLAGS_3RD)

# Debug compilation
debug:
	$(CC) $(SRC_ZX0DIR)/optimize.c $(ZX0_FLAGS) -o $(SRC_ZX0DIR)/optimize.o
	$(CC) $(SRC_ZX0DIR)/compress.c $(ZX0_FLAGS) -o $(SRC_ZX0DIR)/compress.o
	$(CC) $(SRC_ZX0DIR)/memory.c $(ZX0_FLAGS) -o $(SRC_ZX0DIR)/memory.o

	$(CC) $(SRC_APUDIR)/expand.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/expand.o
	$(CC) $(SRC_APUDIR)/matchfinder.c $(APU_FLAGS)                           -o $(SRC_APUDIR)/matchfinder.o
	$(CC) $(SRC_APUDIR)/shrink.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/shrink.o

	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort.c $(APU_FLAGS)         -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort_utils.c $(APU_FLAGS)   -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort_utils.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/sssort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/sssort.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/trsort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/trsort.o

	$(CC) $(SRC_LZSADIR)/matchfinder.c $(LZSA_FLAGS)       -o $(SRC_LZSADIR)/matchfinder.o
	$(CC) $(SRC_LZSADIR)/dictionary.c $(LZSA_FLAGS)        -o $(SRC_LZSADIR)/dictionary.o
	$(CC) $(SRC_LZSADIR)/expand_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v1.o
	$(CC) $(SRC_LZSADIR)/expand_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v2.o
	$(CC) $(SRC_LZSADIR)/expand_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/expand_context.o
	$(CC) $(SRC_LZSADIR)/expand_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/expand_inmem.o
	$(CC) $(SRC_LZSADIR)/frame.c $(LZSA_FLAGS)             -o $(SRC_LZSADIR)/frame.o
	$(CC) $(SRC_LZSADIR)/shrink_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v1.o
	$(CC) $(SRC_LZSADIR)/shrink_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v2.o
	$(CC) $(SRC_LZSADIR)/shrink_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/shrink_context.o
	$(CC) $(SRC_LZSADIR)/shrink_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/shrink_inmem.o
	$(CC) $(SRC_LZSADIR)/stream.c $(LZSA_FLAGS)            -o $(SRC_LZSADIR)/stream.o

	$(CC) src/rasm.c $(CFLAGS_DBG) $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ)

# Production compilation
prod:
	$(CC) $(SRC_ZX0DIR)/optimize.c $(ZX0_FLAGS)           -o $(SRC_ZX0DIR)/optimize.o
	$(CC) $(SRC_ZX0DIR)/compress.c $(ZX0_FLAGS)           -o $(SRC_ZX0DIR)/compress.o
	$(CC) $(SRC_ZX0DIR)/memory.c $(ZX0_FLAGS)             -o $(SRC_ZX0DIR)/memory.o

	$(CC) $(SRC_APUDIR)/expand.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/expand.o
	$(CC) $(SRC_APUDIR)/matchfinder.c $(APU_FLAGS)                           -o $(SRC_APUDIR)/matchfinder.o
	$(CC) $(SRC_APUDIR)/shrink.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/shrink.o

	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort.c $(APU_FLAGS)         -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort_utils.c $(APU_FLAGS)   -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort_utils.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/sssort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/sssort.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/trsort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/trsort.o

	$(CC) $(SRC_LZSADIR)/matchfinder.c $(LZSA_FLAGS)       -o $(SRC_LZSADIR)/matchfinder.o
	$(CC) $(SRC_LZSADIR)/dictionary.c $(LZSA_FLAGS)        -o $(SRC_LZSADIR)/dictionary.o
	$(CC) $(SRC_LZSADIR)/expand_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v1.o
	$(CC) $(SRC_LZSADIR)/expand_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v2.o
	$(CC) $(SRC_LZSADIR)/expand_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/expand_context.o
	$(CC) $(SRC_LZSADIR)/expand_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/expand_inmem.o
	$(CC) $(SRC_LZSADIR)/frame.c $(LZSA_FLAGS)             -o $(SRC_LZSADIR)/frame.o
	$(CC) $(SRC_LZSADIR)/shrink_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v1.o
	$(CC) $(SRC_LZSADIR)/shrink_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v2.o
	$(CC) $(SRC_LZSADIR)/shrink_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/shrink_context.o
	$(CC) $(SRC_LZSADIR)/shrink_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/shrink_inmem.o
	$(CC) $(SRC_LZSADIR)/stream.c $(LZSA_FLAGS)            -o $(SRC_LZSADIR)/stream.o

	$(CC) src/rasm.c $(CFLAGS_OPT) $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ)
	strip $(EXEC)

reloadd:
	$(CC) src/rasm.c $(CFLAGS_DBG) $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ)

reload:
	$(CC) src/rasm.c $(CFLAGS_OPT) $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ)
	strip $(EXEC)

release:
	$(CC) $(SRC_ZX0DIR)/optimize.c $(ZX0_FLAGS)           -o $(SRC_ZX0DIR)/optimize.o
	$(CC) $(SRC_ZX0DIR)/compress.c $(ZX0_FLAGS)           -o $(SRC_ZX0DIR)/compress.o
	$(CC) $(SRC_ZX0DIR)/memory.c $(ZX0_FLAGS)             -o $(SRC_ZX0DIR)/memory.o

	$(CC) $(SRC_APUDIR)/expand.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/expand.o
	$(CC) $(SRC_APUDIR)/matchfinder.c $(APU_FLAGS)                           -o $(SRC_APUDIR)/matchfinder.o
	$(CC) $(SRC_APUDIR)/shrink.c $(APU_FLAGS)                                -o $(SRC_APUDIR)/shrink.o

	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort.c $(APU_FLAGS)         -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort_utils.c $(APU_FLAGS)   -o $(SRC_APUDIR)/libdivsufsort/lib/divsufsort_utils.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/sssort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/sssort.o
	$(CC) $(SRC_LZSADIR)/libdivsufsort/lib/trsort.c $(APU_FLAGS)             -o $(SRC_APUDIR)/libdivsufsort/lib/trsort.o

	$(CC) $(SRC_LZSADIR)/matchfinder.c $(LZSA_FLAGS)       -o $(SRC_LZSADIR)/matchfinder.o
	$(CC) $(SRC_LZSADIR)/dictionary.c $(LZSA_FLAGS)        -o $(SRC_LZSADIR)/dictionary.o
	$(CC) $(SRC_LZSADIR)/expand_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v1.o
	$(CC) $(SRC_LZSADIR)/expand_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/expand_block_v2.o
	$(CC) $(SRC_LZSADIR)/expand_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/expand_context.o
	$(CC) $(SRC_LZSADIR)/expand_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/expand_inmem.o
	$(CC) $(SRC_LZSADIR)/frame.c $(LZSA_FLAGS)             -o $(SRC_LZSADIR)/frame.o
	$(CC) $(SRC_LZSADIR)/shrink_block_v1.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v1.o
	$(CC) $(SRC_LZSADIR)/shrink_block_v2.c $(LZSA_FLAGS)   -o $(SRC_LZSADIR)/shrink_block_v2.o
	$(CC) $(SRC_LZSADIR)/shrink_context.c $(LZSA_FLAGS)    -o $(SRC_LZSADIR)/shrink_context.o
	$(CC) $(SRC_LZSADIR)/shrink_inmem.c $(LZSA_FLAGS)      -o $(SRC_LZSADIR)/shrink_inmem.o
	$(CC) $(SRC_LZSADIR)/stream.c $(LZSA_FLAGS)            -o $(SRC_LZSADIR)/stream.o
	$(CC) src/rasm.c $(CFLAGS_OPT) $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ)
	strip $(EXEC)

# Clean target
clean:
	rm -rf build