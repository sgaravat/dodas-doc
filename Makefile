
.PHONY: install_deps test-docs publish-doc

all: help

help:
	@echo "Available commands:\n"
	@echo "- install deps: "
	@echo "- test-docs: "
	@echo "- publish-doc: "

install_deps:
	pip install --user mkdocs material-mkdocs 

test-docs:
	mkdocs serve

publish-doc: install_deps
	mkdocs gh-deploy 
