.PHONY: venv
venv:
	: # Create venv (One time only)
	: test -d venv || virtualenv -p --nostite-packages venv;
	test -d venv || python3 -m venv venv;
	@echo "To activate the virtual environment run following command:"
	@echo "source venv/bin/activate"

.PHONY: dependencies
dependencies:
	: # Install dependencies
	python3 -m pip install --upgrade pip
	pip install -r requirements.txt
.PHONY: database
database:
	: # Creates and fill the database
	docker-compose up
