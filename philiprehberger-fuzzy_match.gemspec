# frozen_string_literal: true

require_relative 'lib/philiprehberger/fuzzy_match/version'

Gem::Specification.new do |spec|
  spec.name          = 'philiprehberger-fuzzy_match'
  spec.version       = Philiprehberger::FuzzyMatch::VERSION
  spec.authors       = ['Philip Rehberger']
  spec.email         = ['me@philiprehberger.com']

  spec.summary       = 'Fuzzy string matching with Levenshtein, Jaro-Winkler, and ranked search'
  spec.description   = 'Match strings approximately using multiple algorithms: Levenshtein edit distance, ' \
                        'Jaro-Winkler similarity, and Dice coefficient. Find best matches from candidate ' \
                        'lists and generate did-you-mean suggestions.'
  spec.homepage      = 'https://github.com/philiprehberger/rb-fuzzy-match'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri']          = spec.homepage
  spec.metadata['source_code_uri']       = spec.homepage
  spec.metadata['changelog_uri']         = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['bug_tracker_uri']       = "#{spec.homepage}/issues"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files         = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end
