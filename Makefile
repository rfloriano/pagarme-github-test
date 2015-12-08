.PHONY: test run

setup:
	@npm install .

run:
	@grunt run

test:
	@PORT=3001 grunt test
