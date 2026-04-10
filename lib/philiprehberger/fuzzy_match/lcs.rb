# frozen_string_literal: true

module Philiprehberger
  module FuzzyMatch
    # Longest Common Subsequence algorithm with O(min(n,m)) space
    module Lcs
      # Returns the length of the longest common subsequence
      #
      # @param str_a [String]
      # @param str_b [String]
      # @return [Integer]
      def self.length(str_a, str_b)
        a = str_a.to_s.downcase
        b = str_b.to_s.downcase

        return 0 if a.empty? || b.empty?

        # Ensure a is the shorter string for O(min(n,m)) space
        a, b = b, a if a.length > b.length

        prev = Array.new(a.length + 1, 0)
        curr = Array.new(a.length + 1, 0)

        b.each_char do |cb|
          a.each_char.with_index do |ca, j|
            curr[j + 1] = if ca == cb
                            prev[j] + 1
                          else
                            [curr[j], prev[j + 1]].max
                          end
          end
          prev, curr = curr, prev
          curr.fill(0)
        end

        prev[a.length]
      end

      # Returns normalized LCS similarity (0.0 to 1.0)
      #
      # @param str_a [String]
      # @param str_b [String]
      # @return [Float]
      def self.ratio(str_a, str_b)
        a = str_a.to_s.downcase
        b = str_b.to_s.downcase
        total = a.length + b.length

        return 1.0 if total.zero?

        lcs_len = length(a, b)
        (2.0 * lcs_len) / total
      end
    end
  end
end
