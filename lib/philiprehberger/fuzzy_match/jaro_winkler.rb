# frozen_string_literal: true

module Philiprehberger
  module FuzzyMatch
    module JaroWinkler
      WINKLER_PREFIX_WEIGHT = 0.1
      MAX_PREFIX_LENGTH = 4

      def self.similarity(str_a, str_b)
        a = str_a.to_s.downcase
        b = str_b.to_s.downcase

        return 1.0 if a == b
        return 0.0 if a.empty? || b.empty?

        jaro = jaro_similarity(a, b)
        prefix_len = common_prefix_length(a, b)
        jaro + (prefix_len * WINKLER_PREFIX_WEIGHT * (1.0 - jaro))
      end

      def self.jaro_similarity(a, b)
        return 1.0 if a == b
        return 0.0 if a.empty? || b.empty?

        match_window = ([a.length, b.length].max / 2) - 1
        match_window = 0 if match_window.negative?

        a_matches = Array.new(a.length, false)
        b_matches = Array.new(b.length, false)
        matches = 0
        transpositions = 0

        a.each_char.with_index do |a_char, i|
          start = [0, i - match_window].max
          finish = [i + match_window, b.length - 1].min

          (start..finish).each do |j|
            next if b_matches[j] || a_char != b[j]

            a_matches[i] = true
            b_matches[j] = true
            matches += 1
            break
          end
        end

        return 0.0 if matches.zero?

        k = 0
        a.each_char.with_index do |_, i|
          next unless a_matches[i]

          k += 1 until b_matches[k]
          transpositions += 1 if a[i] != b[k]
          k += 1
        end

        ((matches.to_f / a.length) +
          (matches.to_f / b.length) +
          ((matches - (transpositions / 2.0)) / matches)) / 3.0
      end

      def self.common_prefix_length(a, b)
        limit = [a.length, b.length, MAX_PREFIX_LENGTH].min
        (0...limit).each do |i|
          return i if a[i] != b[i]
        end
        limit
      end

      private_class_method :jaro_similarity, :common_prefix_length
    end
  end
end
