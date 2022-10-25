bindir=$(HOME)/bin
install=install

all: eget-all.sh

install: all $(DESTDIR)$(bindir)
	$(install) -m 755 eget-all.sh $(DESTDIR)$(bindir)/eget-all

$(DESTDIR)$(bindir):
	install -m 755 -d $(DESTDIR)$(bindir)
