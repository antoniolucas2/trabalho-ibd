SHELL := /bin/bash
SGBD=psql
USER=gduarte
DB_NAME=compras_publicas
TABLES_FOLDER=tables
QUERIES_FOLDER=queries
POPULATE_FOLDER=populate
SQL_FILES = $(shell find $(TABLES_FOLDER) -name '*.sql' | sort)
QUERIES_FILES = $(shell find $(QUERIES_FOLDER) -name '*.sql' | sort)
POPULATE_FILES = $(shell find $(POPULATE_FOLDER) -name '*.sql' | sort)

all: setup

setup: 
	@if $(SGBD) -lqt | cut -d \| -f 1 | grep -wq $(DB_NAME); then \
		echo "Data Base '$(DB_NAME)' exists!"; \
	else \
		echo "Data Base '$(DB_NAME)' does not exists! Creating..."; \
		createdb -U $(USER) $(DB_NAME); \
	fi
	@echo "Initializing files insertion..."
	@for file in $(SQL_FILES); do \
		echo "executing $$file"; \
		$(SGBD) -U $(USER) -d $(DB_NAME) -f $$file || exit 1; \
	done
	@echo "Processing completed successfully."

populate:
	@echo "Populating Data Base $(DB_NAME)"
	@for file in $(POPULATE_FILES); do \
		echo "executing $$file"; \
		$(SGBD) -U $(USER) -d $(DB_NAME) -f $$file || exit 1; \
	done
	@echo "Populating completed successfully."

execute_query:
	@echo "Execute Query:"
	@queries=($(QUERIES_FILES)); \
	function menu { \
		local counter=1; \
		echo "-------------------------------"; \
		for query in "$${queries[@]}"; do \
			echo "$$counter. $${query#$(QUERIES_FOLDER)/}"; \
			((counter++)); \
		done; \
		echo "0. Sair"; \
		echo "-------------------------------"; \
	}; \
	while true; do \
		menu; \
		read -p "Select a query (or 0 to exit): " opt; \
		if [[ $$opt -eq 0 ]]; then \
			echo "Exiting..."; \
			break; \
		fi; \
		if [[ $$opt -lt 1 || $$opt -gt $${#queries[@]} ]]; then \
			echo "Invalid Option Try again."; \
			continue; \
		fi; \
		index=$$((opt -1)); \
		target_file=$${queries[$$index]}; \
		echo "Executing $${target_file#$(QUERIES_FOLDER)/}..."; \
		echo "--------------------------------------------------"; \
		$(SGBD) -U $(USER) -d $(DB_NAME) -f $$target_file; \
		echo "--------------------------------------------------"; \
		read -p "Continue? (y/n) " confirm; \
		if [[ ! $$confirm =~ ^[Yy]$$ ]]; then \
			break; \
		fi; \
	done 

clean: 
	@psql -U $(USER) -d $(DB_NAME) -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
	@echo "Schema cleaned."

.PHONY: all setup populate clean execute_query
