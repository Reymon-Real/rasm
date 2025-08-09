# ****************
# *** Patterns ***
# ****************

$(OBJ_ZX0_DIR)/%.obj: $(SRC_ZX0_DIR)/%.c
	@$(call MKDIR,$(dir $@))
	$(CC) $(ZX0FLAGS) -c -o $@ $<

$(OBJ_LZS_DIR)/%.obj: $(SRC_LZS_DIR)/%.c
	@$(call MKDIR,$(dir $@))
	$(CC) $(LZSFLAGS) -c -o $@ $<

$(OBJ_APU_DIR)/%.obj: $(SRC_APU_DIR)/%.c
	@$(call MKDIR,$(dir $@))
	$(CC) $(APUFLAGS) -c -o $@ $<

$(OBJ_RDD_DIR)/%.obj: $(SRC_RDD_DIR)/%.c
	@$(call MKDIR,$(dir $@))
	$(CC) $(RDDFLAGS) -c -o $@ $<

$(OBJ_DFS_DIR)/%.obj: $(SRC_DFS_DIR)/%.c
	@$(call MKDIR,$(dir $@))
	$(CC) $(DFSFLAGS) -c -o $@ $<