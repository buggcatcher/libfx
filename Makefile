NAME = libft.a
CC = cc
AR = ar rcs

CFLAGS = -Wall -Wextra -Werror -Iincludes -fno-builtin
ARCH ?= c 

OBJDIR = build/obj
LIBDIR = build/lib

SRC_C = src/converter/ft_atoi.c
SRC_X86 = asm/x86_64/converter/ft_atoi.S
SRC_ARM = asm/arm64/converter/ft_atoi.S

OBJ = $(OBJDIR)/ft_atoi.o

all: $(LIBDIR)/$(NAME)

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(LIBDIR):
	mkdir -p $(LIBDIR)

$(OBJ): | $(OBJDIR)
ifeq ($(ARCH),x86_64)
	$(CC) $(CFLAGS) -c $(SRC_X86) -o $@
else ifeq ($(ARCH),arm64)
	$(CC) $(CFLAGS) -c $(SRC_ARM) -o $@
else
	$(CC) $(CFLAGS) -c $(SRC_C) -o $@
endif

$(LIBDIR)/$(NAME): $(OBJ) | $(LIBDIR)
	$(AR) $@ $(OBJ)

clean:
	rm -rf build

re: clean all

.PHONY: all clean re
