# Makefile to build the SDL Image library

INCLUDE = -I./
CFLAGS  = -g -O2 $(INCLUDE)
CC = xenon-gcc
AR	= xenon-ar
AS	= xenon-as
RANLIB	= xenon-ranlib
SRC_DIR = ./src

CFLAGS=$(INCLUDE) -O3 -DXENON -DBYTE_ORDER=1 -DBIG_ENDIAN=1 -DLITTLE_ENDIAN=0 -ffast-math -fomit-frame-pointer -funroll-loops -ffunction-sections -fdata-sections -fno-tree-vectorize -fno-tree-slp-vectorize -ftree-vectorizer-verbose=1 -flto -fuse-linker-plugin -maltivec -mabi=altivec -fno-pic -mpowerpc64 -mhard-float -Wall -mcpu=cell -mtune=cell -m32 -fno-pic -mpowerpc64 -u read -u _start -u exc_base -D_REENTRANT -DOGG_MUSIC -DOGG_USE_TREMOR -DWAV_MUSIC -DMOD_MUSIC -DMID_MUSIC -DUSE_TIMIDITY_MIDI -I$(DEVKITXENON)/usr/include/ -I$(DEVKITXENON)/usr/include/SDL/ -I$(SRC_DIR)/mikmod -I$(SRC_DIR)/timidity

TARGET  = libSDL_mixer.a
SOURCES = $(filter-out $(SRC_DIR)/playwave.c $(SRC_DIR)/playmus.c $(SRC_DIR)/music_cmd.c, $(wildcard $(SRC_DIR)/*.c)) $(wildcard $(SRC_DIR)/mikmod/*.c) $(wildcard $(SRC_DIR)/timidity/*.c) 

		

OBJECTS = $(shell echo $(SOURCES) | sed -e 's,\.c,\.o,g' -e 's,\.s,\.o,g')

all: $(TARGET)

$(TARGET): $(CONFIG_H) $(OBJECTS) 
	$(AR) crv $@ $^

%.o: %.c
	@echo [$(notdir $<)]
	@$(CC) -o $@ -c $< $(CFLAGS)
	
%.o: %.s
	@echo [$(notdir $<) $@ $*]
	$(CC) -MMD -MP -MF $*.d -x assembler-with-cpp $(ASFLAGS) -O3 -DXENON -ffast-math -fomit-frame-pointer -funroll-loops -ffunction-sections -fdata-sections -fno-tree-vectorize -fno-tree-slp-vectorize -ftree-vectorizer-verbose=1 -flto -fuse-linker-plugin -maltivec -mabi=altivec -fno-pic -mpowerpc64 -mhard-float -Wall -mcpu=cell -mtune=cell -m32 -fno-pic -mpowerpc64 -u read -u _start -u exc_base -c $< -o $@
	
clean:
	rm -f $(TARGET) $(OBJECTS)

install: all		
	cp -r $(SRC_DIR)/*.h $(DEVKITXENON)/usr/include/SDL/ 
	cp $(TARGET) $(DEVKITXENON)/usr/lib/$(TARGET)
