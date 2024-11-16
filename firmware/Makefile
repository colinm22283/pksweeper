FW_OBJS+=$(OBJ_DIR)/entry.o
FW_OBJS+=$(OBJ_DIR)/board.o
FW_OBJS+=$(OBJ_DIR)/random.o

$(BIN_DIR)/pksweeper: $(FW_OBJS) linker.ld
	mkdir -p $(BIN_DIR)
	$(LD) $(LDFLAGS) $(FW_OBJS) -o $@ -Map=$@.map

include $(MAKE_SCRIPTS)
