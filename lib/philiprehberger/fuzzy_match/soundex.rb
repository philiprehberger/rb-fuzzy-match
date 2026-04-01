# frozen_string_literal: true

module Philiprehberger
  module FuzzyMatch
    module Soundex
      CODES = {
        'B' => '1', 'F' => '1', 'P' => '1', 'V' => '1',
        'C' => '2', 'G' => '2', 'J' => '2', 'K' => '2', 'Q' => '2', 'S' => '2', 'X' => '2', 'Z' => '2',
        'D' => '3', 'T' => '3',
        'L' => '4',
        'M' => '5', 'N' => '5',
        'R' => '6'
      }.freeze

      def self.code(string)
        return '' if string.nil? || string.empty?

        upper = string.upcase.gsub(/[^A-Z]/, '')
        return '' if upper.empty?

        result = upper[0]
        prev_code = CODES[result]

        upper[1..].each_char do |char|
          char_code = CODES[char]
          next if char_code.nil? || char_code == prev_code

          result << char_code
          prev_code = char_code
          break if result.length == 4
        end

        result.ljust(4, '0')
      end
    end
  end
end
