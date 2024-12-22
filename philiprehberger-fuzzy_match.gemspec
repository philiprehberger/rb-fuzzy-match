# frozen_string_literal: true

require_relative 'lib/philiprehberger/fuzzy_match/version'

Gem::Specification.new do |spec|
  spec.name = 'philiprehberger-fuzzy_match'
  spec.version = Philiprehberger::FuzzyMatch::VERSION
  spec.authors = ['Philip Rehberger']
  spec.email = ['me@philiprehberger.com']

  spec.summary = 'Fuzzy string matching with Levenshtein, Damerau-Levenshtein, Jaro-Winkler, Hamming, LCS, and phonetic algorithms'
  spec.description = 'Match strings approximately using multiple algorithms: Levenshtein edit distance, ' \
                     'Damerau-Levenshtein with transpositions, Jaro-Winkler similarity, Dice coefficient, ' \
                     'Hamming distance, and Longest Common Subsequence. Includes token-based matching, ' \
                     'weighted scoring, Soundex and Metaphone phonetic matching, ranked search, and deduplication.'
  spec.homepage = 'https://philiprehberger.com/open-source-packages/ruby/philiprehberger-fuzzy_match'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/philiprehberger/rb-fuzzy-match'
  spec.metadata['changelog_uri'] = 'https://github.com/philiprehberger/rb-fuzzy-match/blob/main/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/philiprehberger/rb-fuzzy-match/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end
