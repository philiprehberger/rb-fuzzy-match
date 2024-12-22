# frozen_string_literal: true

module Philiprehberger
  module FuzzyMatch
    # Hamming distance for equal-length strings
    #
    # Counts the number of positions where corresponding characters differ.
    # Both strings must have the same length.
    module Hamming
      def self.distance(str_a, str_b)
        a = str_a.to_s.downcase
        b = str_b.to_s.downcase

        raise Error, "Strings must be the same length (got #{a.length} and #{b.length})" unless a.length == b.length

        a.chars.zip(b.chars).count { |c_a, c_b| c_a != c_b }
      end
    end
  end
end
