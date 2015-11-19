# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
