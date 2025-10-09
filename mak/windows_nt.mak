# ***********************
# *** Important paths ***
# ***********************

BAT_DIR := script\bat

OBJ_DIR := build\objects\windows
BIN_DIR := build\bin\windows

SRC_ZX0DIR	:= src\zx0
SRC_APUDIR	:= src\apultra
SRC_LZSADIR	:= src\lzsa

OBJ_ZX0DIR	:= $(OBJ_DIR)\zx0
OBJ_APUDIR	:= $(OBJ_DIR)\apultra
OBJ_LZSADIR	:= $(OBJ_DIR)\lzsa

# ***********************
# *** Important files ***
# ***********************

EXEC := $(BIN_DIR)\rasm.exe

# ******************
# *** Find files ***
# ******************

SRC_APU := $(wildcard $(SRC_APUDIR)\*.c)
SRC_ZX0 := $(wildcard $(SRC_ZX0DIR)\*.c)
SRC_LZSA := $(wildcard $(SRC_LZSADIR)\*.c)

SRC_APU_OUT := $(filter-out $(SRC_APUDIR)\apultra.c,$(SRC_APU))
SRC_LZSA_OUT := $(filter-out $(SRC_LZSADIR)\lzsa.c,$(SRC_LZSA))

OBJ_APU := $(patsubst $(SRC_APUDIR)\%.c,$(OBJ_APUDIR)\%.obj,$(SRC_APU_OUT))
OBJ_ZX0 := $(patsubst $(SRC_ZX0DIR)\%.c,$(OBJ_ZX0DIR)\%.obj,$(SRC_ZX0))
OBJ_LZSA := $(patsubst $(SRC_LZSADIR)\%.c,$(OBJ_LZSADIR)\%.obj,$(SRC_LZSA_OUT))

# *************
# *** Tools ***
# *************

CC := cl.exe

# *************
# *** Flags ***
# *************

CFLAGS = /O2 /Qpar /Ob3 /c -I include

# ********************
# *** Object files ***
# ********************

# ********************
# *** .PHONY Rules ***
# ********************

.PHONY: prod third debug clean

all:
	make -j$(shell nproc) objects TARGET=windows
	make -j$(shell nproc) executable TARGET=windows

executable: $(EXEC)

objects: $(OBJ_ZX0) $(OBJ_APU) $(OBJ_LZSA)

$(EXEC): $(OBJ_DIR)\rasm.obj $(OBJ_ZX0) $(OBJ_APU) $(OBJ_LZSA)
	@.\$(BAT_DIR)\create_dir.bat
	$(CC) /O2 $^ /Fe$(dir $@)
	upx.exe --ultra-brute $@

$(OBJ_DIR)\rasm.obj: src\rasm.c
	@.\$(BAT_DIR)\create_dir.bat
	$(CC) $< $(CFLAGS) /Fo$@ 

$(OBJ_ZX0DIR)\%.obj: $(SRC_ZX0DIR)\%.c
	@.\$(BAT_DIR)\create_dir.bat
	$(CC) $< $(CFLAGS) /Fo$@

$(OBJ_APUDIR)\%.obj: $(SRC_APUDIR)\%.c
	@.\$(BAT_DIR)\create_dir.bat
	$(CC) $< $(CFLAGS) /Fo$@

$(OBJ_LZSADIR)\%.obj: $(SRC_LZSADIR)\%.c
	@.\$(BAT_DIR)\create_dir.bat
	$(CC) $< $(CFLAGS) /Fo$@

run: $(EXEC)
	@.\$< test/main.asm

# Clean target
clean:
	rm -rf build