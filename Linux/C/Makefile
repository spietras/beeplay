TARGET        = play

TOOTDIR       = toot

CFLAGS        += -I$(TOOTDIR)

OBJECTS       = play.o $(TOOTDIR)/toot.o 

$(TARGET): $(OBJECTS)
	$(CC) $^ -o $@

play.o: $(TOOTDIR)/toot.h 
$(TOOTDIR)/toot.o: $(TOOTDIR)/toot.h 

.PHONY: clean
clean:
	rm -f $(OBJECTS)
	rm -f $(TARGET)