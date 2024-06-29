# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::FuzzyMatch::DamerauLevenshtein do
  describe '.distance' do
    it 'returns 0 for identical strings' do
      expect(described_class.distance('hello', 'hello')).to eq(0)
    end

    it 'returns 0 for empty/empty' do
      expect(described_class.distance('', '')).to eq(0)
    end

    it 'returns length for empty vs non-empty' do
      expect(described_class.distance('abc', '')).to eq(3)
      expect(described_class.distance('', 'abc')).to eq(3)
    end

    it 'counts transposition as 1 edit' do
      expect(described_class.distance('teh', 'the')).to eq(1)
    end

    it 'counts transposition as less than standard Levenshtein' do
      dl_dist = described_class.distance('teh', 'the')
      lev_dist = Philiprehberger::FuzzyMatch::Levenshtein.distance('teh', 'the')
      expect(dl_dist).to be < lev_dist
    end

    it 'returns known distance for ca/abc' do
      expect(described_class.distance('ca', 'abc')).to eq(3)
    end

    it 'handles substitution' do
      expect(described_class.distance('cat', 'car')).to eq(1)
    end

    it 'handles insertion' do
      expect(described_class.distance('cat', 'cats')).to eq(1)
    end

    it 'handles deletion' do
      expect(described_class.distance('cats', 'cat')).to eq(1)
    end

    it 'is case insensitive' do
      expect(described_class.distance('ABC', 'abc')).to eq(0)
    end
  end
end
