---
name: py-unit-tests
description: Conventions for writing, organizing, and running unit tests. Use when writing new tests, adding tests for existing code, fixing failing tests, or setting up test infrastructure in a Python project. Not for integration or end-to-end tests.
---

# Python Unit Testing Conventions

## Isolation

- Unit tests must be deterministic and never touch real external systems. Replace system boundaries (network, database, filesystem, clock, randomness) with mocks or fakes, and share no state between tests.

## Structure

- Mirror the source tree: `src/pkg/foo.py` -> `tests/pkg/test_foo.py`.
- Put each function or method under test in its own class named `Test<Unit>`
  (e.g. `TestParseDate`, `TestOrderTotal`), with every test case for it as a method of that class.
  No module-level test functions.
- Name test methods `test_<scenario>_<expected result>`, since the class already names the unit,
  e.g. `TestParseDate.test_empty_string_raises_value_error`.
- Use Arrange / Act / Assert, separated by blank lines. No comments labeling them.
- Put imports at the top of the module. No imports inside unit tests definitions.

## Finishing

- Before finishing, run the whole suite and report the result.
- Don't weaken or delete an existing test to make it pass without telling me why.
