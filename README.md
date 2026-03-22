# philiprehberger-fuzzy_match

[![Tests](https://github.com/philiprehberger/rb-fuzzy-match/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-fuzzy-match/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-fuzzy_match.svg)](https://rubygems.org/gems/philiprehberger-fuzzy_match)
[![License](https://img.shields.io/github/license/philiprehberger/rb-fuzzy-match)](LICENSE)

Fuzzy string matching with Levenshtein, Jaro-Winkler, and ranked search

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem 'philiprehberger-fuzzy_match'
```

Or install directly:

```bash
gem install philiprehberger-fuzzy_match
```

## Usage

```ruby
require 'philiprehberger/fuzzy_match'

Philiprehberger::FuzzyMatch.levenshtein('kitten', 'sitting')  # => 3
Philiprehberger::FuzzyMatch.jaro_winkler('martha', 'marhta')  # => 0.96
Philiprehberger::FuzzyMatch.ratio('kitten', 'sitting')        # => 0.5714
```

### Best Match

```ruby
candidates = ['Ruby', 'Python', 'Rust', 'JavaScript']
result = Philiprehberger::FuzzyMatch.best_match('rubyy', candidates)
result[:match]  # => "Ruby"
result[:score]  # => 0.8
```

### Ranked Search

```ruby
candidates = ['commit', 'comment', 'command', 'compare']
results = Philiprehberger::FuzzyMatch.search('comit', candidates, limit: 3)
# => [{ match: "commit", score: 0.8333 }, ...]
```

### Search with Key

```ruby
items = [{ name: 'commit' }, { name: 'comment' }]
results = Philiprehberger::FuzzyMatch.search('comit', items, key: :name)
```

### Suggestions

```ruby
Philiprehberger::FuzzyMatch.suggest('comit', ['commit', 'comment', 'zebra'])
# => ["commit", "comment"]
```

## API

### `Philiprehberger::FuzzyMatch`

| Method | Description |
|--------|-------------|
| `.levenshtein(a, b)` | Levenshtein edit distance between two strings |
| `.jaro_winkler(a, b)` | Jaro-Winkler similarity (0.0 to 1.0) |
| `.ratio(a, b)` | Normalized similarity ratio (0.0 to 1.0) |
| `.best_match(query, candidates, threshold:)` | Find the single best match from candidates |
| `.search(query, candidates, key:, limit:, threshold:)` | Ranked search across candidates |
| `.suggest(query, candidates, threshold:)` | Return matches above threshold |

## Development

```bash
bundle install
bundle exec rspec      # Run tests
bundle exec rubocop    # Check code style
```

## License

MIT
