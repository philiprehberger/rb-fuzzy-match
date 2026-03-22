# frozen_string_literal: true
require 'spec_helper'
RSpec.describe Philiprehberger::FuzzyMatch::Levenshtein do
  describe '.distance' do
    it 'returns 0 for identical strings' do
      expect(described_class.distance('abc', 'abc')).to eq(0)
    end

    it 'returns length for empty string comparison' do
      expect(described_class.distance('', 'hello')).to eq(5)
      expect(described_class.distance('hello', '')).to eq(5)
    end

    it 'handles single character operations' do
      expect(described_class.distance('a', 'b')).to eq(1)
      expect(described_class.distance('a', 'ab')).to eq(1)
      expect(described_class.distance('ab', 'a')).to eq(1)
    end

    it 'computes known distances' do
      expect(described_class.distance('kitten', 'sitting')).to eq(3)
      expect(described_class.distance('saturday', 'sunday')).to eq(3)
      expect(described_class.distance('flaw', 'lawn')).to eq(2)
    end

    it 'is case insensitive' do
      expect(described_class.distance('ABC', 'abc')).to eq(0)
    end
  end
end
