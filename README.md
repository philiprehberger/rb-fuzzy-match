# philiprehberger-fuzzy_match

[![Tests](https://github.com/philiprehberger/rb-fuzzy-match/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-fuzzy-match/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-fuzzy_match.svg)](https://rubygems.org/gems/philiprehberger-fuzzy_match)
[![Last updated](https://img.shields.io/github/last-commit/philiprehberger/rb-fuzzy-match)](https://github.com/philiprehberger/rb-fuzzy-match/commits/main)

Fuzzy string matching with Levenshtein, Damerau-Levenshtein, Jaro-Winkler, Hamming, LCS, token-based, and phonetic algorithms

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem "philiprehberger-fuzzy_match"
```

Or install directly:

```bash
gem install philiprehberger-fuzzy_match
```

## Usage

```ruby
require "philiprehberger/fuzzy_match"

# Individual algorithms
Philiprehberger::FuzzyMatch.levenshtein('kitten', 'sitting')   # => 3
Philiprehberger::FuzzyMatch.jaro_winkler('martha', 'marhta')   # => ~0.96
Philiprehberger::FuzzyMatch.dice_coefficient('night', 'nacht') # => 0.25

# Normalized ratio (0.0 to 1.0)
Philiprehberger::FuzzyMatch.ratio('kitten', 'sitting')  # => ~0.57
```

### Damerau-Levenshtein (Transposition-Aware)

```ruby
# Counts adjacent transpositions as 1 edit (Levenshtein counts them as 2)
Philiprehberger::FuzzyMatch.damerau_levenshtein('teh', 'the')   # => 1
Philiprehberger::FuzzyMatch.damerau_ratio('teh', 'the')         # => ~0.667
```

### Longest Common Subsequence

```ruby
Philiprehberger::FuzzyMatch.lcs('kitten', 'sitting')       # => 4
Philiprehberger::FuzzyMatch.lcs_ratio('kitten', 'sitting')  # => ~0.615
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

### Phonetic Matching

```ruby
Philiprehberger::FuzzyMatch.soundex('Robert')    # => "R163"
Philiprehberger::FuzzyMatch.metaphone('Smith')    # => "SM0"
Philiprehberger::FuzzyMatch.phonetic_match?('Robert', 'Rupert')  # => true
```

### Deduplication

```ruby
Philiprehberger::FuzzyMatch.deduplicate(%w[hello helo world wrld], threshold: 0.8)
# => ["hello", "world"]
```

### Hamming Distance

```ruby
Philiprehberger::FuzzyMatch.hamming('karolin', 'kathrin')  # => 3
Philiprehberger::FuzzyMatch.hamming('abc', 'abc')          # => 0
# Raises Error for different-length strings
```

### Token-Based Matching

```ruby
# Token sort: reorder tokens alphabetically before comparing
Philiprehberger::FuzzyMatch.token_sort_ratio('john smith jr', 'jr john smith')  # => 1.0

# Token set: compare based on token set intersection/union
Philiprehberger::FuzzyMatch.token_set_ratio('new york mets', 'new york mets vs atlanta braves')
# => high score (shared tokens boost similarity)
```

### Weighted Scoring

```ruby
Philiprehberger::FuzzyMatch.weighted_score('kitten', 'sitting',
  weights: { jaro_winkler: 0.5, dice: 0.3, levenshtein_ratio: 0.2 })
# => weighted combination of algorithm scores
# Supported keys: :jaro_winkler, :dice, :levenshtein_ratio, :lcs_ratio, :damerau_ratio
# Weights must sum to 1.0
```

## API

### `Philiprehberger::FuzzyMatch`

| Method | Description |
|--------|-------------|
| `.levenshtein(a, b)` | Levenshtein edit distance (integer) |
| `.jaro_winkler(a, b)` | Jaro-Winkler similarity (0.0 to 1.0) |
| `.dice_coefficient(a, b)` | Dice coefficient from bigram overlap (0.0 to 1.0) |
| `.damerau_levenshtein(a, b)` | Damerau-Levenshtein distance with transpositions (integer) |
| `.damerau_ratio(a, b)` | Normalized Damerau-Levenshtein similarity (0.0 to 1.0) |
| `.lcs(a, b)` | Longest common subsequence length (integer) |
| `.lcs_ratio(a, b)` | Normalized LCS similarity (0.0 to 1.0) |
| `.ratio(a, b)` | Normalized Levenshtein ratio (0.0 to 1.0) |
| `.best(query, candidates, threshold: 0.0)` | Best match as `{ match:, score: }` |
| `.search(query, candidates, threshold: 0.3)` | Ranked array of `{ match:, score: }` |
| `.suggest(query, candidates, threshold: 0.6, max: 5)` | Array of match strings |
| `.soundex(string)` | Generate 4-character Soundex code |
| `.metaphone(string)` | Generate Metaphone phonetic code |
| `.phonetic_match?(a, b)` | Check if two strings match phonetically |
| `.hamming(a, b)` | Hamming distance for equal-length strings (integer) |
| `.token_sort_ratio(a, b)` | Token-sorted Jaro-Winkler similarity (0.0 to 1.0) |
| `.token_set_ratio(a, b)` | Token-set-based similarity (0.0 to 1.0) |
| `.weighted_score(a, b, weights:)` | Weighted multi-algorithm score (0.0 to 1.0) |
| `.deduplicate(array, threshold:, algorithm:)` | Group and deduplicate similar strings |

All methods are case-insensitive by default.

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## Support

If you find this project useful:

⭐ [Star the repo](https://github.com/philiprehberger/rb-fuzzy-match)

🐛 [Report issues](https://github.com/philiprehberger/rb-fuzzy-match/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

💡 [Suggest features](https://github.com/philiprehberger/rb-fuzzy-match/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)

❤️ [Sponsor development](https://github.com/sponsors/philiprehberger)

🌐 [All Open Source Projects](https://philiprehberger.com/open-source-packages)

💻 [GitHub Profile](https://github.com/philiprehberger)

🔗 [LinkedIn Profile](https://www.linkedin.com/in/philiprehberger)

## License

[MIT](LICENSE)
