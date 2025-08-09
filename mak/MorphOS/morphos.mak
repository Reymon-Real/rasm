CC=gcc
STRIP=strip --strip-unneeded --remove-section .comment

EXEC=rasm
CFLAGS=-g -noixemul -Ofast -Wall -W

#
SRC_APUDIR=./apultra-master/src
SRC_LZSADIR=./lzsa-master/src
SRC_ZX0DIR=./ZX0-main/src

#
RASM_CFLAGS=$(CFLAGS) -lm

#
APU_FLAGS=$(CFLAGS) -fomit-frame-pointer -I$(SRC_LZSADIR)/libdivsufsort/include -I$(SRC_APUDIR)

APU_OBJ =$(SRC_APUDIR)/expand.o
APU_OBJ+=$(SRC_APUDIR)/matchfinder.o
APU_OBJ+=$(SRC_APUDIR)/shrink.o
APU_OBJ+=$(SRC_APUDIR)/libdivsufsort/lib/divsufsort.o
APU_OBJ+=$(SRC_APUDIR)/libdivsufsort/lib/divsufsort_utils.o
APU_OBJ+=$(SRC_APUDIR)/libdivsufsort/lib/sssort.o
APU_OBJ+=$(SRC_APUDIR)/libdivsufsort/lib/trsort.o

#
LZSA_FLAGS=$(CFLAGS) -fomit-frame-pointer -I$(SRC_LZSADIR)/libdivsufsort/include -I$(SRC_LZSADIR)

LZSA_OBJ =$(SRC_LZSADIR)/dictionary.o
LZSA_OBJ+=$(SRC_LZSADIR)/expand_block_v1.o
LZSA_OBJ+=$(SRC_LZSADIR)/expand_block_v2.o
LZSA_OBJ+=$(SRC_LZSADIR)/expand_context.o
LZSA_OBJ+=$(SRC_LZSADIR)/expand_inmem.o
LZSA_OBJ+=$(SRC_LZSADIR)/frame.o
LZSA_OBJ+=$(SRC_LZSADIR)/matchfinder.o
LZSA_OBJ+=$(SRC_LZSADIR)/shrink_block_v1.o
LZSA_OBJ+=$(SRC_LZSADIR)/shrink_block_v2.o
LZSA_OBJ+=$(SRC_LZSADIR)/shrink_context.o
LZSA_OBJ+=$(SRC_LZSADIR)/shrink_inmem.o
LZSA_OBJ+=$(SRC_LZSADIR)/stream.o

#
ZX0_FLAGS=$(CFLAGS) -I$(SRC_ZX0DIR)

ZX0_OBJ =$(SRC_ZX0DIR)/optimize.o
ZX0_OBJ+=$(SRC_ZX0DIR)/compress.o
ZX0_OBJ+=$(SRC_ZX0DIR)/memory.o

.PHONY: all clean

all: $(EXEC)

clean:
	@rm $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ) rasm.o

#
$(EXEC): rasm.o $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ)
	@echo "Linking $@..."
	@$(CC) -o $(EXEC).db rasm.o $(APU_OBJ) $(LZSA_OBJ) $(ZX0_OBJ)
	@$(STRIP) -o $(EXEC) $(EXEC).db
	@echo "Done $@"

# ZX0
$(SRC_ZX0DIR)/optimize.o: $(SRC_ZX0DIR)/optimize.c $(SRC_ZX0DIR)/zx0.h
	@echo "Compiling $@..."
	@$(CC) $(ZX0_FLAGS) -c -o $@ $<

$(SRC_ZX0DIR)/compress.o: $(SRC_ZX0DIR)/compress.c $(SRC_ZX0DIR)/zx0.h
	@echo "Compiling $@..."
	@$(CC) $(ZX0_FLAGS) -c -o $@ $<

$(SRC_ZX0DIR)/memory.o: $(SRC_ZX0DIR)/memory.c $(SRC_ZX0DIR)/zx0.h
	@echo "Compiling $@..."
	@$(CC) $(ZX0_FLAGS) -c -o $@ $<

#APU
$(SRC_APUDIR)/expand.o: $(SRC_APUDIR)/expand.c $(SRC_APUDIR)/expand.h $(SRC_APUDIR)/format.h $(SRC_APUDIR)/libapultra.h
	@echo "Compiling $@..."
	@$(CC) $(APU_FLAGS) -c -o $@ $<

$(SRC_APUDIR)/matchfinder.o: $(SRC_APUDIR)/matchfinder.c $(SRC_APUDIR)/matchfinder.h $(SRC_APUDIR)/format.h $(SRC_APUDIR)/libapultra.h
	@echo "Compiling $@..."
	@$(CC) $(APU_FLAGS) -c -o $@ $<

$(SRC_APUDIR)/shrink.o: $(SRC_APUDIR)/shrink.c $(SRC_APUDIR)/shrink.h $(SRC_APUDIR)/matchfinder.h $(SRC_APUDIR)/format.h $(SRC_APUDIR)/libapultra.h
	@echo "Compiling $@..."
	@$(CC) $(APU_FLAGS) -c -o $@ $<

$(SRC_APUDIR)/libdivsufsort/lib/divsufsort.o: $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort.c $(SRC_LZSADIR)/libdivsufsort/include/divsufsort_private.h
	@echo "Compiling $@..."
	@$(CC) $(APU_FLAGS) -c -o $@ $<

$(SRC_APUDIR)/libdivsufsort/lib/divsufsort_utils.o: $(SRC_LZSADIR)/libdivsufsort/lib/divsufsort_utils.c $(SRC_LZSADIR)/libdivsufsort/include/divsufsort_private.h
	@echo "Compiling $@..."
	@$(CC) $(APU_FLAGS) -c -o $@ $<

$(SRC_APUDIR)/libdivsufsort/lib/sssort.o: $(SRC_LZSADIR)/libdivsufsort/lib/sssort.c $(SRC_LZSADIR)/libdivsufsort/include/divsufsort_private.h
	@echo "Compiling $@..."
	@$(CC) $(APU_FLAGS) -c -o $@ $<

$(SRC_APUDIR)/libdivsufsort/lib/trsort.o: $(SRC_LZSADIR)/libdivsufsort/lib/trsort.c $(SRC_LZSADIR)/libdivsufsort/include/divsufsort_private.h
	@echo "Compiling $@..."
	@$(CC) $(APU_FLAGS) -c -o $@ $<

#LZSA
$(SRC_LZSADIR)/matchfinder.o: $(SRC_LZSADIR)/matchfinder.c $(SRC_LZSADIR)/matchfinder.h $(SRC_LZSADIR)/format.h $(SRC_LZSADIR)/lib.h
	@echo "Compiling $@..."
	@$(CC) $(LZSA_FLAGS) -c -o $@ $<

$(SRC_LZSADIR)/dictionary.o: $(SRC_LZSADIR)/dictionary.c $(SRC_LZSADIR)/format.h $(SRC_LZSADIR)/lib.h
	@echo "Compiling $@..."
	@$(CC) $(LZSA_FLAGS) -c -o $@ $<

$(SRC_LZSADIR)/expand_block_v1.o: $(SRC_LZSADIR)/expand_block_v1.c $(SRC_LZSADIR)/expand_block_v1.h $(SRC_LZSADIR)/format.h
	@echo "Compiling $@..."
	@$(CC) $(LZSA_FLAGS) -c -o $@ $<

$(SRC_LZSADIR)/expand_block_v2.o: $(SRC_LZSADIR)/expand_block_v2.c $(SRC_LZSADIR)/expand_block_v2.h $(SRC_LZSADIR)/format.h
	@echo "Compiling $@..."
	@$(CC) $(LZSA_FLAGS) -c -o $@ $<

$(SRC_LZSADIR)/expand_context.o: $(SRC_LZSADIR)/expand_context.c $(SRC_LZSADIR)/expand_context.h $(SRC_LZSADIR)/expand_block_v1.h $(SRC_LZSADIR)/expand_block_v2.h $(SRC_LZSADIR)/lib.h
	@echo "Compiling $@..."
	@$(CC) $(LZSA_FLAGS) -c -o $@ $<

$(SRC_LZSADIR)/expand_inmem.o: $(SRC_LZSADIR)/expand_inmem.c $(SRC_LZSADIR)/expand_context.h $(SRC_LZSADIR)/lib.h $(SRC_LZSADIR)/frame.h
	@echo "Compiling $@..."
	@$(CC) $(LZSA_FLAGS) -c -o $@ $<

$(SRC_LZSADIR)/frame.o: $(SRC_LZSADIR)/frame.c $(SRC_LZSADIR)/frame.h
	@echo "Compiling $@..."
	@$(CC) $(LZSA_FLAGS) -c -o $@ $<

$(SRC_LZSADIR)/shrink_block_v1.o: $(SRC_LZSADIR)/shrink_block_v1.c $(SRC_LZSADIR)/shrink_block_v1.h $(SRC_LZSADIR)/lib.h $(SRC_LZSADIR)/format.h
	@echo "Compiling $@..."
	@$(CC) $(LZSA_FLAGS) -c -o $@ $<

$(SRC_LZSADIR)/shrink_block_v2.o: $(SRC_LZSADIR)/shrink_block_v2.c $(SRC_LZSADIR)/shrink_block_v2.h $(SRC_LZSADIR)/lib.h $(SRC_LZSADIR)/format.h
	@echo "Compiling $@..."
	@$(CC) $(LZSA_FLAGS) -c -o $@ $<

$(SRC_LZSADIR)/shrink_context.o: $(SRC_LZSADIR)/shrink_context.c $(SRC_LZSADIR)/shrink_context.h $(SRC_LZSADIR)/shrink_block_v1.h $(SRC_LZSADIR)/shrink_block_v2.h $(SRC_LZSADIR)/format.h  $(SRC_LZSADIR)/matchfinder.h $(SRC_LZSADIR)/lib.h
	@echo "Compiling $@..."
	@$(CC) $(LZSA_FLAGS) -c -o $@ $<

$(SRC_LZSADIR)/shrink_inmem.o: $(SRC_LZSADIR)/shrink_inmem.c $(SRC_LZSADIR)/shrink_inmem.h $(SRC_LZSADIR)/shrink_context.h $(SRC_LZSADIR)/frame.h $(SRC_LZSADIR)/format.h $(SRC_LZSADIR)/lib.h
	@echo "Compiling $@..."
	@$(CC) $(LZSA_FLAGS) -c -o $@ $<

$(SRC_LZSADIR)/stream.o: $(SRC_LZSADIR)/stream.c $(SRC_LZSADIR)/stream.h
	@echo "Compiling $@..."
	@$(CC) $(LZSA_FLAGS) -c -o $@ $<

#rasm
rasm.o: rasm.c rasm.h
	@echo "Compiling $@..."
	@$(CC) $(RASM_FLAGS) -c -o $@ $<

