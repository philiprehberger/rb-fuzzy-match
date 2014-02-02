# frozen_string_literal: true

module Philiprehberger
  module FuzzyMatch
    module Levenshtein
      def self.distance(str_a, str_b)
        a = str_a.downcase
        b = str_b.downcase

        return b.length if a.empty?
        return a.length if b.empty?

        if a.length > b.length
          a, b = b, a
        end

        prev_row = (0..a.length).to_a

        b.each_char do |b_char|
          curr_row = [prev_row[0] + 1]

          a.each_char.with_index do |a_char, j|
            cost = a_char == b_char ? 0 : 1
            curr_row << [
              curr_row[j] + 1,
              prev_row[j + 1] + 1,
              prev_row[j] + cost
            ].min
          end

          prev_row = curr_row
        end

        prev_row[a.length]
      end
    end
  end
end
