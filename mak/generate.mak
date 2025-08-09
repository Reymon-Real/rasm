# *****************************
# *** Generate binary files ***
# *****************************

$(DBG_DIR)/$(RASM): $(OBJECT_RDD) $(LIB_ZX0) $(LIB_LZS) $(LIB_APU) $(LIB_DFS)
	@$(call MKDIR,$(dir $@))
	$(CC) $(CFLAGS_DBG) -o $@ $< $(LDFLAGS)

$(BIN_DIR)/$(RASM): $(OBJECT_RDD) $(LIB_ZX0) $(LIB_LZS) $(LIB_APU) $(LIB_DFS)
	@$(call MKDIR,$(dir $@))
	$(CC) $(CFLAGS_OPT) -o $@ $< $(LDFLAGS)

# **************************
# *** Generate libraries ***
# **************************

$(LIB_ZX0): $(OBJECT_ZX0)
	@$(call MKDIR,$(dir $@))
	$(AR) $(ARFLAGS) -o $@ $^

$(LIB_LZS): $(OBJECT_LZS)
	@$(call MKDIR,$(dir $@))
	$(AR) $(ARFLAGS) -o $@ $^

$(LIB_APU): $(OBJECT_APU)
	@$(call MKDIR,$(dir $@))
	$(AR) $(ARFLAGS) -o $@ $^

$(LIB_DFS): $(OBJECT_DFS)
	@$(call MKDIR,$(dir $@))
	$(AR) $(ARFLAGS) -o $@ $^