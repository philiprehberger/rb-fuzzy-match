# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this gem adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.10.0] - 2026-05-09

### Added
- `FuzzyMatch.partial_ratio(a, b)` — substring-style similarity. Slides the shorter string across every same-length window of the longer one and returns the maximum Levenshtein-based ratio. Mirrors FuzzyWuzzy's `partial_ratio` — the canonical answer to "does string A appear approximately inside string B?".

## [0.9.0] - 2026-04-26

### Added
- `FuzzyMatch.top_n` — return top-N best matches for a query against candidates with a configurable similarity floor and algorithm

## [0.8.0] - 2026-04-16

### Added
- `FuzzyMatch.closest_n(query, candidates, n:, algorithm:)` returns the top N matches as `{ match:, score: }` hashes sorted by score descending

### Fixed
- Update gemspec `summary` to include "token-based," matching the README one-liner exactly

## [0.7.0] - 2026-04-15

### Added
- `FuzzyMatch.similarity_matrix(strings, algorithm:, threshold:)` returns hash-of-hashes with pairwise similarity scores for batch deduplication and clustering

## [0.6.0] - 2026-04-15

### Added
- `FuzzyMatch.rank(query, candidates, algorithm:)` returns all candidates sorted by similarity with `{ value:, score: }` entries (stable tie-break)

## [0.5.0] - 2026-04-14

### Added
- `FuzzyMatch.hamming(a, b)` for Hamming distance between equal-length strings
- `FuzzyMatch.token_sort_ratio(a, b)` for token-sorted Jaro-Winkler similarity
- `FuzzyMatch.token_set_ratio(a, b)` for token-set-based similarity comparison
- `FuzzyMatch.weighted_score(a, b, weights:)` for weighted multi-algorithm scoring

## [0.4.0] - 2026-04-10

### Added
- `FuzzyMatch.damerau_levenshtein(a, b)` for Damerau-Levenshtein edit distance with transpositions
- `FuzzyMatch.damerau_ratio(a, b)` for normalized Damerau-Levenshtein similarity (0.0 to 1.0)

### Fixed
- Make `Metaphone.encode_complex` private (was unintentionally public)

## [0.3.0] - 2026-04-10

### Added
- `FuzzyMatch.lcs(a, b)` for Longest Common Subsequence length
- `FuzzyMatch.lcs_ratio(a, b)` for normalized LCS similarity (0.0 to 1.0)

### Fixed
- Fix gemspec authors, email, and required Ruby version format to match guide
- Add gem version field to bug report template
- Add alternatives field to feature request template

## [0.2.0] - 2026-04-01

### Added
- `FuzzyMatch.soundex(string)` for Soundex phonetic code generation
- `FuzzyMatch.metaphone(string)` for Metaphone phonetic code generation
- `FuzzyMatch.phonetic_match?(a, b)` for phonetic similarity comparison
- `FuzzyMatch.deduplicate(array, threshold:, algorithm:)` for batch deduplication

## [0.1.11] - 2026-03-31

### Added
- Add GitHub issue templates, dependabot config, and PR template

## [0.1.10] - 2026-03-31

### Changed
- Standardize README badges, support section, and license format

## [0.1.9] - 2026-03-26

### Fixed
- Add Sponsor badge to README
- Fix license section link format

## [0.1.8] - 2026-03-24

### Fixed
- Fix stray character in CHANGELOG formatting

## [0.1.7] - 2026-03-24

### Fixed
- Standardize README code examples to use double-quote require statements

## [0.1.6] - 2026-03-24

### Fixed
- Fix Installation section quote style to double quotes

## [0.1.5] - 2026-03-23

### Fixed
- Standardize README to match template (installation order, code fences, license section, one-liner format)
- Update gemspec summary to match README description

## [0.1.4] - 2026-03-22

### Changed
- Fix README badges to match template (Tests, Gem Version, License)

## [0.1.3] - 2026-03-22

### Changed
- Add License badge to README

## [0.1.2] - 2026-03-22

### Fixed

- Fix CHANGELOG header wording
- Add bug_tracker_uri to gemspec

## [0.1.0] - 2026-03-22

### Added

- Levenshtein edit distance with O(min(n,m)) space optimization
- Jaro-Winkler similarity with prefix boost
- Dice coefficient for bigram-based similarity
- Normalized `ratio` method (0.0 to 1.0)
- `best` for finding the single best match from candidates
- `search` for ranked results sorted by score with threshold
- `suggest` for did-you-mean style suggestions with max limit
- Case-insensitive matching by default
