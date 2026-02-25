# Contributing to toktrack

Thanks for your interest in contributing! Here's how to get started.

## Getting Started

### Prerequisites

- [Rust](https://rustup.rs/) (stable)
- Git

### Setup

```bash
git clone https://github.com/mag123c/toktrack.git
cd toktrack
make setup   # configure git hooks
cargo build
```

## Development Workflow

1. Fork and create a feature branch from `main`
2. Make your changes
3. Run checks before submitting:

```bash
make check   # fmt + clippy + test
```

4. Open a Pull Request against `main`

### Commit Messages

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
{type}({scope}): {description}
```

**Types:** `feat` | `fix` | `refactor` | `docs` | `test` | `chore` | `perf`

**Scopes:** `parser` | `tui` | `services` | `cache` | `cli`

Examples:
- `feat(parser): add OpenCode session parsing`
- `fix(cache): handle version mismatch on warm path`
- `perf(parser): parallelize JSONL file scanning`

## Project Structure

```
src/
├── main.rs            # Entry point
├── cli/               # CLI argument parsing
├── parser/            # JSONL parsers (claude, codex, gemini, opencode)
├── services/          # Aggregation, caching, pricing
└── tui/               # Terminal UI (ratatui)
```

## Running Tests

```bash
cargo test             # all tests
cargo test -- --nocapture  # with stdout
cargo bench            # benchmarks
```

## CI

Pull requests run CI on **Ubuntu, macOS, and Windows** with:
- `cargo fmt --check`
- `cargo clippy -- -D warnings`
- `cargo build`
- `cargo test`

All checks must pass before merge.

## Reporting Issues

- **Bugs:** Use the [Bug Report](https://github.com/mag123c/toktrack/issues/new?template=bug_report.md) template
- **Features:** Use the [Feature Request](https://github.com/mag123c/toktrack/issues/new?template=feature_request.md) template
- **Questions:** Open a [Discussion](https://github.com/mag123c/toktrack/issues/new?template=discussion.md)

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).
