CONTENT_BUILD := content/build

fast: kactl

kactl: | $(CONTENT_BUILD)
	# Pre-process all C++ files (single Python invocation)
	python3 content/tex/preprocessor_typst.py --batch
	typst compile --root . content/kactl.typ kactl.pdf

test-session:
	typst compile --root . content/test-session/test-session.typ test-session.pdf

clean:
	rm -rf content/build/

veryclean: clean
	rm -f kactl.pdf test-session.pdf

.PHONY: help fast kactl test-session clean veryclean

$(CONTENT_BUILD):
	mkdir -p $(CONTENT_BUILD)/

