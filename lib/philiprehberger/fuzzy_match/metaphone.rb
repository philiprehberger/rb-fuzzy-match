# frozen_string_literal: true

module Philiprehberger
  module FuzzyMatch
    module Metaphone
      def self.code(string)
        return '' if string.nil? || string.empty?

        word = string.upcase.gsub(/[^A-Z]/, '')
        return '' if word.empty?

        word = drop_initial_silent(word)
        result = +''
        i = 0

        while i < word.length
          char = word[i]
          next_char = word[i + 1]
          coded, skip = encode_char(word, i, char, next_char)
          result << coded if coded
          i += 1 + skip
        end

        result
      end

      def self.drop_initial_silent(word)
        case word[0, 2]
        when 'AE', 'GN', 'KN', 'PN', 'WR' then word[1..]
        else word
        end
      end

      SIMPLE = { 'F' => 'F', 'J' => 'J', 'L' => 'L', 'M' => 'M', 'N' => 'N',
                 'Q' => 'K', 'R' => 'R', 'V' => 'F', 'X' => 'KS', 'Z' => 'S' }.freeze

      def self.encode_char(word, i, char, next_char)
        return [SIMPLE[char], 0] if SIMPLE.key?(char)

        encode_complex(word, i, char, next_char)
      end

      def self.encode_complex(word, i, char, next_char)
        case char
        when 'B' then next_char == 'B' ? [nil, 1] : ['B', 0]
        when 'C' then encode_c(next_char)
        when 'D' then %w[G J].include?(next_char) ? ['J', 1] : ['T', 0]
        when 'G' then encode_g(word, i, next_char)
        when 'H' then encode_h(word, i)
        when 'K' then i.positive? && word[i - 1] == 'C' ? [nil, 0] : ['K', 0]
        when 'P' then next_char == 'H' ? ['F', 1] : ['P', 0]
        when 'S' then next_char == 'H' ? ['X', 1] : ['S', 0]
        when 'T' then next_char == 'H' ? ['0', 1] : ['T', 0]
        when 'W', 'Y' then vowel?(next_char) ? [char, 0] : [nil, 0]
        else [nil, 0]
        end
      end

      def self.encode_c(next_char)
        case next_char
        when 'I', 'E', 'Y' then ['S', 0]
        else ['K', 0]
        end
      end

      def self.encode_g(word, i, next_char)
        return [nil, 0] if next_char == 'H' && i + 2 < word.length && !vowel?(word[i + 2])

        next_char == 'H' ? ['F', 1] : ['K', 0]
      end

      def self.encode_h(word, i)
        return [nil, 0] if i.positive? && !vowel?(word[i - 1])

        vowel?(word[i + 1]) ? ['H', 0] : [nil, 0]
      end

      def self.vowel?(char)
        %w[A E I O U].include?(char)
      end

      private_class_method :drop_initial_silent, :encode_char, :encode_c, :encode_g, :encode_h, :vowel?
    end
  end
end
