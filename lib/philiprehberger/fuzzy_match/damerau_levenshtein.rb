# frozen_string_literal: true

module Philiprehberger
  module FuzzyMatch
    # Damerau-Levenshtein distance (optimal string alignment variant)
    #
    # Extends Levenshtein by counting adjacent transpositions as a single edit.
    # Operations: insertion, deletion, substitution, and adjacent transposition.
    module DamerauLevenshtein
      def self.distance(str_a, str_b)
        a = str_a.to_s.downcase
        b = str_b.to_s.downcase

        return b.length if a.empty?
        return a.length if b.empty?
        return 0 if a == b

        n = a.length
        m = b.length

        # Build full matrix (need 2 previous rows for transpositions)
        d = Array.new(n + 1) { Array.new(m + 1, 0) }

        (0..n).each { |i| d[i][0] = i }
        (0..m).each { |j| d[0][j] = j }

        (1..n).each do |i|
          (1..m).each do |j|
            cost = a[i - 1] == b[j - 1] ? 0 : 1

            d[i][j] = [
              d[i - 1][j] + 1,
              d[i][j - 1] + 1,
              d[i - 1][j - 1] + cost
            ].min

            if i > 1 && j > 1 && a[i - 1] == b[j - 2] && a[i - 2] == b[j - 1]
              d[i][j] = [d[i][j], d[i - 2][j - 2] + 1].min
            end
          end
        end

        d[n][m]
      end
    end
  end
end
