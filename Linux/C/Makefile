.POSIX:

TARGET        	= play
LIB			  	= playlib

LIBNAME		  	= libplay.a

SRCDIR 		  	= src
OBJDIR		  	= obj
BINDIR		  	= bin
LIBDIR        	= lib
INCLUDEDIR		= include

CC     			= cc
CFLAGS			= -Wall -Wextra -ansi -pedantic

all: $(BINDIR)/$(TARGET)
	@echo "Building executable completed. It is available at: $(BINDIR)/$(TARGET)"

lib: $(LIB)/$(LIBDIR)/$(LIBNAME)
	@echo "Building library completed. It is available at: $(LIB)/$(LIBDIR)/$(LIBNAME)"

$(BINDIR)/$(TARGET): $(OBJDIR)/main.o $(LIB)/$(LIBDIR)/$(LIBNAME)
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) $^ -o $@

$(LIB)/$(LIBDIR)/$(LIBNAME): $(LIB)/$(OBJDIR)/play.o $(LIB)/$(OBJDIR)/toot.o
	@mkdir -p $(@D)
	@ar -r $@ $^ >/dev/null 2>&1

$(LIB)/$(OBJDIR)/play.o: $(LIB)/$(SRCDIR)/play.c
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -I$(LIB)/$(INCLUDEDIR) -c $^ -o $@

$(LIB)/$(OBJDIR)/toot.o: $(LIB)/$(SRCDIR)/toot.c
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -c $^ -o $@

$(OBJDIR)/main.o: $(SRCDIR)/main.c
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -I$(LIB)/$(INCLUDEDIR) -c $^ -o $@

clean:
	@rm -rf $(BINDIR)
	@rm -rf $(OBJDIR)
	@rm -rf $(LIB)/$(LIBDIR)
	@rm -rf $(LIB)/$(OBJDIR)
	@echo 'Cleanup complete'