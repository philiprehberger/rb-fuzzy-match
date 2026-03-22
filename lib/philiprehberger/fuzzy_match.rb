# frozen_string_literal: true

require_relative 'fuzzy_match/version'
require_relative 'fuzzy_match/levenshtein'
require_relative 'fuzzy_match/jaro_winkler'
require_relative 'fuzzy_match/dice'

module Philiprehberger
  module FuzzyMatch
    def self.levenshtein(str_a, str_b)
      Levenshtein.distance(str_a, str_b)
    end

    def self.jaro_winkler(str_a, str_b)
      JaroWinkler.similarity(str_a, str_b)
    end

    def self.ratio(str_a, str_b)
      a = str_a.to_s
      b = str_b.to_s
      max_len = [a.length, b.length].max
      return 1.0 if max_len.zero?

      distance = Levenshtein.distance(a, b)
      1.0 - (distance.to_f / max_len)
    end

    def self.best_match(query, candidates, threshold: 0.0)
      return nil if candidates.empty?

      best = nil
      best_score = -1.0

      candidates.each do |candidate|
        score = ratio(query, candidate.to_s)
        if score > best_score
          best = candidate
          best_score = score
        end
      end

      return nil if best_score < threshold

      { match: best, score: best_score.round(4) }
    end

    def self.search(query, candidates, key: nil, limit: nil, threshold: 0.0)
      scored = candidates.map do |candidate|
        text = key ? candidate[key].to_s : candidate.to_s
        score = ratio(query, text)
        { match: candidate, score: score.round(4) }
      end

      results = scored.select { |r| r[:score] >= threshold }
      results.sort_by! { |r| -r[:score] }
      results = results.first(limit) if limit
      results
    end

    def self.suggest(query, candidates, threshold: 0.6)
      results = search(query, candidates, threshold: threshold)
      results.map { |r| r[:match] }
    end
  end
end
