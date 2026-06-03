SHELL:=/bin/bash
SGBD=psql
DB_NAME=compras_publicas
TABLES_FOLDER=tables
QUERIES_FOLDER=queries
SQL_FILES = $(shell find $(TABLES_FOLDER) -name '*.sql' | sort)
QUERIES_FILES = $(shell find $(QUERIES_FOLDER) -name '*.sql' | sort)
POPULATE_SCRIPT=./scripts/injection_populate.py
DUMP_FILE=./scripts/data_base_dump.sql

all: setup

USER := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

setup: 
	@if $(SGBD) -lqt | cut -d \| -f 1 | grep -wq $(DB_NAME); then \
		echo "Data Base '$(DB_NAME)' already exists!"; \
	else \
		echo "Data Base '$(DB_NAME)' does not exist! Creating data base..."; \
		createdb -U $(USER) $(DB_NAME); \
	fi
	@echo "Initializing files insertion..."
	@for file in $(SQL_FILES); do \
		no_prefix=$${file#*_}; \
		final_name=$${no_prefix%.*}; \
		echo "Tyring to create TABLE: $$final_name"; \
		if $(SGBD) -U $(USER) -d $(DB_NAME) -c '\dt' | cut -d \| -f 2 | grep -wqi $$final_name; then \
			echo " Schema '$$final_name' already exists."; \
		else \
			echo "executing $$file"; \
			$(SGBD) -U $(USER) -d $(DB_NAME) -f $$file || exit 1; \
		fi; \
	done
	@echo "Processing completed successfully."

ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

populate:
	@if [ "$(ARGS)" = "help" ]; then \
		echo -e "Program Usage: \nmake populate <data_base_name> <user_name> <password>"; \
	else \
		echo "Populating Data Base $(DB_NAME)"; \
		python3 $(POPULATE_SCRIPT) $(ARGS); \
	fi

%::
	@true

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
		echo "999. Clear Terminal"; \
		echo "0. Exit"; \
		echo "-------------------------------"; \
	}; \
	while true; do \
		menu; \
		read -p "Select a query (or 0 to exit): " opt; \
		if [[ $$opt -eq 0 ]]; then \
			echo "Exiting..."; \
			break; \
		fi; \
		if [[ $$opt = 999 ]]; then \
			clear; \
			continue; \
		fi; \
		if [[ $$opt -lt 1 || $$opt -gt $${#queries[@]} ]]; then \
			echo "Invalid Option Try again."; \
			continue; \
		fi; \
		index=$$((opt -1)); \
		target_file=$${queries[$$index]}; \
		echo "Executing $${target_file#$(QUERIES_FOLDER)/}..."; \
		echo "-------------------------------"; \
		$(SGBD) -U $(USER) -d $(DB_NAME) -f $$target_file; \
		echo "-------------------------------"; \
	done

generate_dump_file:
	@echo "Generating dump file..."
	@pg_dump -U $(USER) -d $(DB_NAME) -O -f $(DUMP_FILE)

clean: 
	@psql -U $(USER) -d $(DB_NAME) -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
	@echo "Schema cleaned."

.PHONY: all setup populate clean execute_query generate_dump_file
