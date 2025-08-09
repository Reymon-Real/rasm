# *****************
# *** Main rule ***
# *****************

all: $(OBJECT_ZX0) $(OBJECT_LZS) $(OBJECT_APU) $(OBJECT_RDD) $(OBJECT_DFS) \
     $(LIB_ZX0) $(LIB_LZS) $(LIB_APU) $(LIB_DFS) \
     debug

# ***********************
# *** Roudoudou rules ***
# ***********************

debug: $(DBG_DIR)/$(RASM)

release: $(BIN_DIR)/$(RASM)

# ******************
# *** Clean rule ***
# ******************

clean:
	$(call RM,$(RASM))
	$(call RM,$(LIB_ZX0))
	$(call RM,$(LIB_LZS))
	$(call RM,$(LIB_APU))
	$(call RM,$(LIB_RDD))
	$(call RM,$(LIB_DFS))
	$(call RM,$(OBJECT_ZX0))
	$(call RM,$(OBJECT_LZS))
	$(call RM,$(OBJECT_APU))
	$(call RM,$(OBJECT_RDD))
	$(call RM,$(OBJECT_DFS))