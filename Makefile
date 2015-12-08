.PHONY: test run

run:
	@grunt run

test:
	@PORT=3001 grunt test
