# *******************
# *** Executables ***
# *******************

ifeq ($(TARGET), Windows_NT)
RASM := rasm.exe
else
RASM := rasm
endif

# *****************
# *** Libraries ***
# *****************

LIB_ZX0 := $(LIB_DIR)/libzx0.a
LIB_LZS := $(LIB_DIR)/liblzsa.a
LIB_APU := $(LIB_DIR)/libapultra.a
LIB_RDD := $(LIB_DIR)/libroudoudou.a
LIB_DFS := $(LIB_DIR)/libdivsufsort.a