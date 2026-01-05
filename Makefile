NAME = libft.a
CC = cc
CXX = g++
AR = ar rcs

CFLAGS = -Wall -Wextra -Werror -Iinc -fno-builtin
CXXFLAGS = -Wall -Wextra -Werror -Iinc
ARCH ?= c 

OBJDIR = build/obj
LIBDIR = build/lib

SRC_C = src/c/ft_atoi.c
SRC_X86 = src/x86_64/ft_atoi.S
SRC_ARM = src/arm64/ft_atoi.S

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

main: main.cpp $(OBJ)
	$(CXX) $(CXXFLAGS) main.cpp $(OBJ) -o main

clean:
	rm -rf build main

re: clean all

.PHONY: all clean re
