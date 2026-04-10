# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::FuzzyMatch::Lcs do
  describe '.length' do
    it 'returns 0 for empty strings' do
      expect(described_class.length('', '')).to eq(0)
    end

    it 'returns 0 for empty vs non-empty' do
      expect(described_class.length('abc', '')).to eq(0)
      expect(described_class.length('', 'abc')).to eq(0)
    end

    it 'returns full length for identical strings' do
      expect(described_class.length('abc', 'abc')).to eq(3)
    end

    it 'returns known LCS length for kitten/sitting' do
      # LCS of kitten/sitting is "ittn" = 4
      expect(described_class.length('kitten', 'sitting')).to eq(4)
    end

    it 'returns known LCS length for ABCBDAB/BDCAB' do
      # Classic example: LCS is "BCAB" = 4
      expect(described_class.length('ABCBDAB', 'BDCAB')).to eq(4)
    end

    it 'is case insensitive' do
      expect(described_class.length('ABC', 'abc')).to eq(3)
    end

    it 'handles single character strings' do
      expect(described_class.length('a', 'a')).to eq(1)
      expect(described_class.length('a', 'b')).to eq(0)
    end
  end

  describe '.ratio' do
    it 'returns 1.0 for identical strings' do
      expect(described_class.ratio('hello', 'hello')).to eq(1.0)
    end

    it 'returns 1.0 for empty/empty' do
      expect(described_class.ratio('', '')).to eq(1.0)
    end

    it 'returns 0.0 for completely different strings' do
      expect(described_class.ratio('abc', 'xyz')).to eq(0.0)
    end

    it 'returns a value between 0.0 and 1.0' do
      ratio = described_class.ratio('kitten', 'sitting')
      expect(ratio).to be_between(0.0, 1.0)
    end

    it 'is case insensitive' do
      expect(described_class.ratio('Hello', 'hello')).to eq(1.0)
    end
  end
end
