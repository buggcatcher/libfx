NAME = libft.a
CC = cc
CXX = g++
AR = ar rcs

CFLAGS = -Wall -Wextra -Werror -Iinc -fno-builtin
CXXFLAGS = -Wall -Wextra -Werror -Iinc
ARCH ?= c 

OBJDIR = build/obj
LIBDIR = build/lib

SRC_C = src/c/fx_atoi.c \
         src/c/fx_bzero.c \
         src/c/fx_calloc.c \
         src/c/fx_lcpy.c \
         src/c/fx_memcpy.c \
         src/c/fx_memmove.c \
         src/c/fx_memset.c \
         src/c/fx_strdup.c \
         src/c/fx_strlcpy.c \
         src/c/fx_strmapi.c \
         src/c/fx_strulen.c
SRC_X86 = src/x86_64/fx_atoi.S
SRC_ARM = src/arm64/fx_atoi.S

OBJ = \
    $(OBJDIR)/fx_atoi.o \
    $(OBJDIR)/fx_bzero.o \
    $(OBJDIR)/fx_calloc.o \
    $(OBJDIR)/fx_lcpy.o \
    $(OBJDIR)/fx_memcpy.o \
    $(OBJDIR)/fx_memmove.o \
    $(OBJDIR)/fx_memset.o \
    $(OBJDIR)/fx_strdup.o \
    $(OBJDIR)/fx_strlcpy.o \
    $(OBJDIR)/fx_strmapi.o \
    $(OBJDIR)/fx_strulen.o

all: $(LIBDIR)/$(NAME)

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(LIBDIR):
	mkdir -p $(LIBDIR)

$(OBJDIR)/%.o: src/c/%.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(LIBDIR)/$(NAME): $(OBJ) | $(LIBDIR)
	$(AR) $@ $(OBJ)

main: main.cpp $(OBJ)
	$(CXX) $(CXXFLAGS) main.cpp $(OBJ) -o main

c: $(OBJDIR) $(LIBDIR) $(OBJ)
	@echo "\033[1;35mMakefile: compilazione main.c e implementazione $(ARCH)\033[0m"
	$(CC) $(CFLAGS) main.c $(OBJ) -o main_c

cpp: $(OBJDIR) $(LIBDIR) $(OBJ)
	@echo "\033[1;33mCompilazione con main.cpp e implementazione $(ARCH)\033[0m"
	$(CXX) $(CXXFLAGS) main.cpp $(OBJ) -o main_cpp

clean:
	@echo "\033[38;5;208mPulizia build ed eseguibili\033[0m"
	rm -rf build main main_c main_cpp

re: clean all

.PHONY: all clean re
