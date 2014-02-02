# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-03-21

### Added
- Initial release
- Levenshtein edit distance calculation
- Jaro-Winkler similarity scoring with prefix boost
- Dice coefficient for bigram-based similarity
- Normalized ratio (0.0-1.0) for easy comparison
- Best-match search from candidate lists with threshold
- Ranked search with key, limit, and threshold options
- Did-you-mean style suggestions via `suggest`
- Case-insensitive matching by default
