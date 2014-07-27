# frozen_string_literal: true
require 'spec_helper'
RSpec.describe Philiprehberger::FuzzyMatch do
  describe '.levenshtein' do
    it 'returns 0 for identical strings' do
      expect(described_class.levenshtein('hello', 'hello')).to eq(0)
    end

    it 'returns correct distance for kitten/sitting' do
      expect(described_class.levenshtein('kitten', 'sitting')).to eq(3)
    end

    it 'handles empty strings' do
      expect(described_class.levenshtein('', 'abc')).to eq(3)
      expect(described_class.levenshtein('abc', '')).to eq(3)
    end

    it 'is case insensitive' do
      expect(described_class.levenshtein('Hello', 'hello')).to eq(0)
    end
  end

  describe '.jaro_winkler' do
    it 'returns 1.0 for identical strings' do
      expect(described_class.jaro_winkler('martha', 'martha')).to eq(1.0)
    end

    it 'returns high similarity for similar strings' do
      score = described_class.jaro_winkler('martha', 'marhta')
      expect(score).to be > 0.9
    end

    it 'returns 0.0 for completely different strings' do
      expect(described_class.jaro_winkler('', 'abc')).to eq(0.0)
    end

    it 'boosts score for common prefixes' do
      jw = described_class.jaro_winkler('prefix_abc', 'prefix_xyz')
      ratio = described_class.ratio('prefix_abc', 'prefix_xyz')
      expect(jw).to be > ratio
    end
  end

  describe '.ratio' do
    it 'returns 1.0 for identical strings' do
      expect(described_class.ratio('hello', 'hello')).to eq(1.0)
    end

    it 'returns 0.0 for completely different strings of equal length' do
      expect(described_class.ratio('abc', 'xyz')).to eq(0.0)
    end

    it 'returns a value between 0 and 1' do
      score = described_class.ratio('kitten', 'sitting')
      expect(score).to be_between(0.0, 1.0)
    end

    it 'handles empty strings' do
      expect(described_class.ratio('', '')).to eq(1.0)
    end
  end

  describe '.best_match' do
    let(:candidates) { ['Ruby', 'Python', 'Rust', 'JavaScript'] }

    it 'returns the best matching candidate' do
      result = described_class.best_match('rubyy', candidates)
      expect(result[:match]).to eq('Ruby')
    end

    it 'includes the score' do
      result = described_class.best_match('rubyy', candidates)
      expect(result[:score]).to be > 0.5
    end

    it 'returns nil for empty candidates' do
      expect(described_class.best_match('test', [])).to be_nil
    end

    it 'respects threshold' do
      result = described_class.best_match('zzzzz', candidates, threshold: 0.9)
      expect(result).to be_nil
    end
  end

  describe '.search' do
    let(:candidates) { ['commit', 'comment', 'command', 'compare', 'zebra'] }

    it 'returns ranked results' do
      results = described_class.search('comit', candidates)
      expect(results.first[:match]).to eq('commit')
    end

    it 'respects limit' do
      results = described_class.search('com', candidates, limit: 2)
      expect(results.length).to eq(2)
    end

    it 'respects threshold' do
      results = described_class.search('comit', candidates, threshold: 0.7)
      expect(results).to all(satisfy { |r| r[:score] >= 0.7 })
    end

    it 'supports key option for hash candidates' do
      items = [{ name: 'commit' }, { name: 'zebra' }]
      results = described_class.search('comit', items, key: :name)
      expect(results.first[:match]).to eq({ name: 'commit' })
    end
  end

  describe '.suggest' do
    it 'returns suggestions above threshold' do
      candidates = ['commit', 'comment', 'zebra']
      results = described_class.suggest('comit', candidates, threshold: 0.6)
      expect(results).to include('commit')
      expect(results).not_to include('zebra')
    end

    it 'returns empty array when nothing matches' do
      expect(described_class.suggest('zzzzz', ['abc'], threshold: 0.9)).to be_empty
    end
  end
end
