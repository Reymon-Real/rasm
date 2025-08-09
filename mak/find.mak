# ********************
# *** Source files ***
# ********************

SOURCE_ZX0 := $(call FIND,$(SRC_ZX0_DIR),c)
SOURCE_LZS := $(call FIND,$(SRC_LZS_DIR),c)
SOURCE_APU := $(call FIND,$(SRC_APU_DIR),c)
SOURCE_RDD := $(call FIND,$(SRC_RDD_DIR),c)
SOURCE_DFS := $(call FIND,$(SRC_DFS_DIR),c)

# ********************
# *** Object files ***
# ********************

OBJECT_ZX0 := $(patsubst $(SRC_ZX0_DIR)/%.c,$(OBJ_ZX0_DIR)/%.obj,$(SOURCE_ZX0))
OBJECT_LZS := $(patsubst $(SRC_LZS_DIR)/%.c,$(OBJ_LZS_DIR)/%.obj,$(SOURCE_LZS))
OBJECT_APU := $(patsubst $(SRC_APU_DIR)/%.c,$(OBJ_APU_DIR)/%.obj,$(SOURCE_APU))
OBJECT_RDD := $(patsubst $(SRC_RDD_DIR)/%.c,$(OBJ_RDD_DIR)/%.obj,$(SOURCE_RDD))
OBJECT_DFS := $(patsubst $(SRC_DFS_DIR)/%.c,$(OBJ_DFS_DIR)/%.obj,$(SOURCE_DFS))