install:
	install -m 0755 tag /usr/local/bin
	install tag.1 /usr/local/man/man1

README.md: tag.1
	mandoc -T markdown tag.1 | sed 's/^#/###/' > README.md
