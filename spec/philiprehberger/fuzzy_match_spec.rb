# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::FuzzyMatch do
  describe '.levenshtein (via Levenshtein module)' do
    it 'returns 3 for kitten/sitting' do
      expect(described_class.levenshtein('kitten', 'sitting')).to eq(3)
    end

    it 'returns 0 for empty/empty' do
      expect(described_class.levenshtein('', '')).to eq(0)
    end

    it 'returns 0 for identical strings' do
      expect(described_class.levenshtein('abc', 'abc')).to eq(0)
    end

    it 'returns length for empty vs non-empty' do
      expect(described_class.levenshtein('abc', '')).to eq(3)
      expect(described_class.levenshtein('', 'abc')).to eq(3)
    end

    it 'is case insensitive' do
      expect(described_class.levenshtein('ABC', 'abc')).to eq(0)
    end
  end

  describe '.jaro_winkler (via JaroWinkler module)' do
    it 'returns approximately 0.96 for martha/marhta' do
      score = described_class.jaro_winkler('martha', 'marhta')
      expect(score).to be_within(0.01).of(0.96)
    end

    it 'returns 1.0 for identical strings' do
      expect(described_class.jaro_winkler('test', 'test')).to eq(1.0)
    end

    it 'returns approximately 0.0 for completely different strings' do
      expect(described_class.jaro_winkler('', 'abc')).to eq(0.0)
    end

    it 'is case insensitive' do
      expect(described_class.jaro_winkler('Hello', 'hello')).to eq(1.0)
    end
  end

  describe '.dice_coefficient (via Dice module)' do
    it 'returns 1.0 for identical strings' do
      expect(described_class.dice_coefficient('night', 'night')).to eq(1.0)
    end

    it 'returns 0.0 for completely different bigrams' do
      expect(described_class.dice_coefficient('ab', 'cd')).to eq(0.0)
    end

    it 'returns a known value for overlapping bigrams' do
      # "night" bigrams: ni, ig, gh, ht (4)
      # "nacht" bigrams: na, ac, ch, ht (4)
      # intersection: ht (1)
      # dice = 2*1 / (4+4) = 0.25
      expect(described_class.dice_coefficient('night', 'nacht')).to eq(0.25)
    end

    it 'handles single-character strings' do
      expect(described_class.dice_coefficient('a', 'b')).to eq(0.0)
    end
  end

  describe '.lcs' do
    it 'returns known LCS length' do
      expect(described_class.lcs('kitten', 'sitting')).to eq(4)
    end

    it 'returns 0 for empty strings' do
      expect(described_class.lcs('abc', '')).to eq(0)
    end

    it 'returns full length for identical strings' do
      expect(described_class.lcs('hello', 'hello')).to eq(5)
    end

    it 'is case insensitive' do
      expect(described_class.lcs('ABC', 'abc')).to eq(3)
    end
  end

  describe '.lcs_ratio' do
    it 'returns 1.0 for identical strings' do
      expect(described_class.lcs_ratio('hello', 'hello')).to eq(1.0)
    end

    it 'returns 0.0 for completely different strings' do
      expect(described_class.lcs_ratio('abc', 'xyz')).to eq(0.0)
    end

    it 'returns a value between 0.0 and 1.0' do
      ratio = described_class.lcs_ratio('kitten', 'sitting')
      expect(ratio).to be_between(0.0, 1.0)
    end

    it 'is case insensitive' do
      expect(described_class.lcs_ratio('Hello', 'hello')).to eq(1.0)
    end
  end

  describe '.ratio' do
    it 'returns 1.0 for identical strings' do
      expect(described_class.ratio('hello', 'hello')).to eq(1.0)
    end

    it 'returns approximately 0.0 for completely different strings' do
      expect(described_class.ratio('abc', 'xyz')).to be_within(0.01).of(0.0)
    end

    it 'returns 1.0 for empty/empty' do
      expect(described_class.ratio('', '')).to eq(1.0)
    end

    it 'is case insensitive' do
      expect(described_class.ratio('Hello', 'hello')).to eq(1.0)
    end
  end

  describe '.best' do
    let(:candidates) { %w[Ruby Python Rust JavaScript] }

    it 'returns highest match from list' do
      result = described_class.best('rubyy', candidates)
      expect(result[:match]).to eq('Ruby')
      expect(result[:score]).to be > 0.5
    end

    it 'returns nil for empty candidates' do
      expect(described_class.best('test', [])).to be_nil
    end

    it 'respects threshold' do
      result = described_class.best('zzzzz', candidates, threshold: 0.9)
      expect(result).to be_nil
    end
  end

  describe '.search' do
    let(:candidates) { %w[commit comment command compare zebra] }

    it 'returns ranked results sorted by score desc' do
      results = described_class.search('comit', candidates)
      expect(results.first[:match]).to eq('commit')
      scores = results.map { |r| r[:score] }
      expect(scores).to eq(scores.sort.reverse)
    end

    it 'respects threshold' do
      results = described_class.search('comit', candidates, threshold: 0.7)
      expect(results).to all(satisfy { |r| r[:score] >= 0.7 })
    end

    it 'returns empty when nothing matches threshold' do
      results = described_class.search('zzzzz', candidates, threshold: 0.99)
      expect(results).to be_empty
    end
  end

  describe '.suggest' do
    it 'returns reasonable suggestions for typos' do
      candidates = %w[commit comment zebra]
      results = described_class.suggest('comit', candidates, threshold: 0.6)
      expect(results).to include('commit')
      expect(results).not_to include('zebra')
    end

    it 'respects max parameter' do
      candidates = %w[commit comment command compare compete]
      results = described_class.suggest('com', candidates, threshold: 0.0, max: 2)
      expect(results.length).to be <= 2
    end

    it 'returns empty array when nothing matches' do
      expect(described_class.suggest('zzzzz', %w[abc], threshold: 0.9)).to be_empty
    end
  end

  describe '.soundex' do
    it 'generates Soundex code for Robert' do
      expect(described_class.soundex('Robert')).to eq('R163')
    end

    it 'generates same code for similar sounding names' do
      expect(described_class.soundex('Robert')).to eq(described_class.soundex('Rupert'))
    end

    it 'returns empty string for empty input' do
      expect(described_class.soundex('')).to eq('')
    end
  end

  describe '.metaphone' do
    it 'generates Metaphone code' do
      expect(described_class.metaphone('Smith')).to eq('SM0')
    end

    it 'handles silent letters' do
      expect(described_class.metaphone('Knight')).to eq('NT')
    end

    it 'returns empty string for empty input' do
      expect(described_class.metaphone('')).to eq('')
    end
  end

  describe '.phonetic_match?' do
    it 'returns true for phonetically similar names' do
      expect(described_class.phonetic_match?('Robert', 'Rupert')).to be true
    end

    it 'returns false for different names' do
      expect(described_class.phonetic_match?('Robert', 'Smith')).to be false
    end

    it 'returns false for empty strings' do
      expect(described_class.phonetic_match?('', '')).to be false
    end
  end

  describe '.deduplicate' do
    it 'removes similar strings' do
      result = described_class.deduplicate(%w[hello helo world wrld], threshold: 0.8)
      expect(result.length).to be < 4
    end

    it 'keeps unique strings' do
      result = described_class.deduplicate(%w[hello world foo], threshold: 0.9)
      expect(result.length).to eq(3)
    end

    it 'supports different algorithms' do
      result = described_class.deduplicate(%w[test testing], threshold: 0.7, algorithm: :dice)
      expect(result.length).to be >= 1
    end

    it 'returns empty array for empty input' do
      expect(described_class.deduplicate([])).to eq([])
    end
  end
end
