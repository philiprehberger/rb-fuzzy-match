# philiprehberger-fuzzy_match

[![Gem Version](https://badge.fury.io/rb/philiprehberger-fuzzy_match.svg)](https://badge.fury.io/rb/philiprehberger-fuzzy_match)
$badge_line
[![CI](https://github.com/philiprehberger/rb-fuzzy-match/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-fuzzy-match/actions/workflows/ci.yml)

Fuzzy string matching with Levenshtein, Jaro-Winkler, and ranked search.

## Requirements

- Ruby >= 3.1

## Installation

```sh
gem install philiprehberger-fuzzy_match
```

Or add to your Gemfile:

```ruby
gem 'philiprehberger-fuzzy_match'
```

## Usage

```ruby
require 'philiprehberger/fuzzy_match'

# Individual algorithms
Philiprehberger::FuzzyMatch.levenshtein('kitten', 'sitting')   # => 3
Philiprehberger::FuzzyMatch.jaro_winkler('martha', 'marhta')   # => ~0.96
Philiprehberger::FuzzyMatch.dice_coefficient('night', 'nacht') # => 0.25

# Normalized ratio (0.0 to 1.0)
Philiprehberger::FuzzyMatch.ratio('kitten', 'sitting')  # => ~0.57
```

### Best Match

```ruby
candidates = %w[Ruby Python Rust JavaScript]
result = Philiprehberger::FuzzyMatch.best('rubyy', candidates)
result[:match]  # => "Ruby"
result[:score]  # => 0.8
```

### Ranked Search

```ruby
candidates = %w[commit comment command compare]
results = Philiprehberger::FuzzyMatch.search('comit', candidates, threshold: 0.5)
# => [{ match: "commit", score: 0.8333 }, { match: "comment", score: 0.7143 }, ...]
```

### Did-You-Mean Suggestions

```ruby
Philiprehberger::FuzzyMatch.suggest('comit', %w[commit comment zebra], threshold: 0.6, max: 3)
# => ["commit", "comment"]
```

## API

### `Philiprehberger::FuzzyMatch`

| Method | Description |
|--------|-------------|
| `.levenshtein(a, b)` | Levenshtein edit distance (integer) |
| `.jaro_winkler(a, b)` | Jaro-Winkler similarity (0.0 to 1.0) |
| `.dice_coefficient(a, b)` | Dice coefficient from bigram overlap (0.0 to 1.0) |
| `.ratio(a, b)` | Normalized Levenshtein ratio (0.0 to 1.0) |
| `.best(query, candidates, threshold: 0.0)` | Best match as `{ match:, score: }` |
| `.search(query, candidates, threshold: 0.3)` | Ranked array of `{ match:, score: }` |
| `.suggest(query, candidates, threshold: 0.6, max: 5)` | Array of match strings |

All methods are case-insensitive by default.

## Development

```sh
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT License. See [LICENSE](LICENSE) for details.
