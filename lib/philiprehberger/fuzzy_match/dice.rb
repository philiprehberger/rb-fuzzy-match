# frozen_string_literal: true

module Philiprehberger
  module FuzzyMatch
    module Dice
      def self.coefficient(str_a, str_b)
        a = str_a.to_s.downcase
        b = str_b.to_s.downcase

        return 1.0 if a == b
        return 0.0 if a.length < 2 || b.length < 2

        bigrams_a = bigrams(a)
        bigrams_b = bigrams(b)

        intersection = 0
        b_copy = bigrams_b.dup

        bigrams_a.each do |bg|
          idx = b_copy.index(bg)
          if idx
            intersection += 1
            b_copy.delete_at(idx)
          end
        end

        (2.0 * intersection) / (bigrams_a.length + bigrams_b.length)
      end

      def self.bigrams(str)
        (0...(str.length - 1)).map { |i| str[i, 2] }
      end

      private_class_method :bigrams
    end
  end
end
