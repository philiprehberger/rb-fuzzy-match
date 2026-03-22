# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::FuzzyMatch::JaroWinkler do
  describe '.similarity' do
    it 'returns 1.0 for identical strings' do
      expect(described_class.similarity('abc', 'abc')).to eq(1.0)
    end

    it 'returns 0.0 for empty string vs non-empty' do
      expect(described_class.similarity('', 'abc')).to eq(0.0)
      expect(described_class.similarity('abc', '')).to eq(0.0)
    end

    it 'returns known similarity for martha/marhta' do
      score = described_class.similarity('martha', 'marhta')
      expect(score).to be_within(0.01).of(0.96)
    end

    it 'returns known similarity for dwayne/duane' do
      score = described_class.similarity('dwayne', 'duane')
      expect(score).to be_within(0.02).of(0.84)
    end

    it 'is case insensitive' do
      expect(described_class.similarity('Hello', 'hello')).to eq(1.0)
    end

    it 'returns value between 0 and 1' do
      score = described_class.similarity('abc', 'xyz')
      expect(score).to be_between(0.0, 1.0)
    end
  end
end
