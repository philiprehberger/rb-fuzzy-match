# frozen_string_literal: true

require_relative 'fuzzy_match/version'
require_relative 'fuzzy_match/levenshtein'
require_relative 'fuzzy_match/jaro_winkler'
require_relative 'fuzzy_match/dice'
require_relative 'fuzzy_match/soundex'
require_relative 'fuzzy_match/metaphone'
require_relative 'fuzzy_match/lcs'

module Philiprehberger
  module FuzzyMatch
    def self.levenshtein(str_a, str_b)
      Levenshtein.distance(str_a, str_b)
    end

    def self.jaro_winkler(str_a, str_b)
      JaroWinkler.similarity(str_a, str_b)
    end

    def self.dice_coefficient(str_a, str_b)
      Dice.coefficient(str_a, str_b)
    end

    # Length of the longest common subsequence
    #
    # @param str_a [String]
    # @param str_b [String]
    # @return [Integer]
    def self.lcs(str_a, str_b)
      Lcs.length(str_a, str_b)
    end

    # Normalized LCS similarity (0.0 to 1.0)
    #
    # @param str_a [String]
    # @param str_b [String]
    # @return [Float]
    def self.lcs_ratio(str_a, str_b)
      Lcs.ratio(str_a, str_b)
    end

    def self.ratio(str_a, str_b)
      a = str_a.to_s.downcase
      b = str_b.to_s.downcase
      max_len = [a.length, b.length].max
      return 1.0 if max_len.zero?

      distance = Levenshtein.distance(a, b)
      1.0 - (distance.to_f / max_len)
    end

    def self.best(query, candidates, threshold: 0.0)
      return nil if candidates.empty?

      best_result = nil
      best_score = -1.0

      candidates.each do |candidate|
        score = ratio(query, candidate.to_s)
        if score > best_score
          best_result = candidate
          best_score = score
        end
      end

      return nil if best_score < threshold

      { match: best_result, score: best_score.round(4) }
    end

    def self.search(query, candidates, threshold: 0.3)
      scored = candidates.map do |candidate|
        score = ratio(query, candidate.to_s)
        { match: candidate, score: score.round(4) }
      end

      results = scored.select { |r| r[:score] >= threshold }
      results.sort_by { |r| -r[:score] }
    end

    def self.suggest(query, candidates, threshold: 0.6, max: 5)
      results = search(query, candidates, threshold: threshold)
      results.first(max).map { |r| r[:match] }
    end

    # Generate a Soundex code for a string
    #
    # @param string [String]
    # @return [String] 4-character Soundex code
    def self.soundex(string)
      Soundex.code(string)
    end

    # Generate a Metaphone code for a string
    #
    # @param string [String]
    # @return [String] Metaphone phonetic code
    def self.metaphone(string)
      Metaphone.code(string)
    end

    # Check if two strings match phonetically (same Soundex code)
    #
    # @param a [String]
    # @param b [String]
    # @return [Boolean]
    def self.phonetic_match?(a, b)
      sa = Soundex.code(a)
      sb = Soundex.code(b)
      !sa.empty? && sa == sb
    end

    # Group and deduplicate similar strings
    #
    # @param array [Array<String>] strings to deduplicate
    # @param threshold [Float] similarity threshold (0.0 to 1.0)
    # @param algorithm [Symbol] :jaro_winkler (default), :dice, or :levenshtein
    # @return [Array<String>] unique representatives
    def self.deduplicate(array, threshold: 0.8, algorithm: :jaro_winkler)
      representatives = []
      array.each do |item|
        duplicate = representatives.any? do |rep|
          score = case algorithm
                  when :jaro_winkler then jaro_winkler(rep, item)
                  when :dice then dice_coefficient(rep, item)
                  when :levenshtein then ratio(rep, item)
                  else raise Error, "Unknown algorithm: #{algorithm}"
                  end
          score >= threshold
        end
        representatives << item unless duplicate
      end
      representatives
    end
  end
end
