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

  describe '.damerau_levenshtein' do
    it 'counts transposition as 1 edit' do
      expect(described_class.damerau_levenshtein('teh', 'the')).to eq(1)
    end

    it 'returns 0 for identical strings' do
      expect(described_class.damerau_levenshtein('abc', 'abc')).to eq(0)
    end

    it 'is case insensitive' do
      expect(described_class.damerau_levenshtein('ABC', 'abc')).to eq(0)
    end
  end

  describe '.damerau_ratio' do
    it 'returns 1.0 for identical strings' do
      expect(described_class.damerau_ratio('hello', 'hello')).to eq(1.0)
    end

    it 'returns higher score than ratio for transpositions' do
      dr = described_class.damerau_ratio('teh', 'the')
      r = described_class.ratio('teh', 'the')
      expect(dr).to be > r
    end

    it 'returns 1.0 for empty/empty' do
      expect(described_class.damerau_ratio('', '')).to eq(1.0)
    end

    it 'is case insensitive' do
      expect(described_class.damerau_ratio('Hello', 'hello')).to eq(1.0)
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

  describe '.rank' do
    let(:candidates) { %w[commit comment command compare zebra] }

    it 'returns all candidates sorted descending by score' do
      results = described_class.rank('comit', candidates)
      expect(results.length).to eq(candidates.length)
      scores = results.map { |r| r[:score] }
      expect(scores).to eq(scores.sort.reverse)
    end

    it 'returns empty array for empty candidates' do
      expect(described_class.rank('anything', [])).to eq([])
    end

    it 'preserves original input order for ties (stable sort)' do
      # Two identical candidates must retain input order
      tied = %w[apple apple]
      results = described_class.rank('apple', tied)
      expect(results.map { |r| r[:score] }.uniq).to eq([1.0])
      expect(results.map { |r| r[:value] }).to eq(%w[apple apple])
    end

    it 'defaults to jaro_winkler' do
      default_result = described_class.rank('martha', %w[marhta])
      jw_result = described_class.rank('martha', %w[marhta], algorithm: :jaro_winkler)
      expect(default_result.first[:score]).to eq(jw_result.first[:score])
      # Distinguish jaro_winkler from levenshtein for this pair
      lev_result = described_class.rank('martha', %w[marhta], algorithm: :levenshtein)
      expect(default_result.first[:score]).not_to eq(lev_result.first[:score])
    end

    it 'supports explicit algorithm: :levenshtein' do
      results = described_class.rank('kitten', %w[sitting kitten mitten], algorithm: :levenshtein)
      expect(results.first[:value]).to eq('kitten')
      expect(results.first[:score]).to eq(1.0)
    end

    it 'returns hashes with :value and :score keys' do
      results = described_class.rank('abc', %w[abc abd])
      results.each do |entry|
        expect(entry).to be_a(Hash)
        expect(entry.keys).to contain_exactly(:value, :score)
      end
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

  describe '.hamming' do
    it 'returns 0 for identical strings' do
      expect(described_class.hamming('abc', 'abc')).to eq(0)
    end

    it 'returns 1 for a single character difference' do
      expect(described_class.hamming('abc', 'adc')).to eq(1)
    end

    it 'returns length when all characters differ' do
      expect(described_class.hamming('abc', 'xyz')).to eq(3)
    end

    it 'raises Error for different-length strings' do
      expect { described_class.hamming('abc', 'ab') }.to raise_error(Philiprehberger::FuzzyMatch::Error)
    end

    it 'raises Error for empty vs non-empty' do
      expect { described_class.hamming('', 'a') }.to raise_error(Philiprehberger::FuzzyMatch::Error)
    end

    it 'returns 0 for two empty strings' do
      expect(described_class.hamming('', '')).to eq(0)
    end

    it 'is case insensitive' do
      expect(described_class.hamming('ABC', 'abc')).to eq(0)
    end
  end

  describe '.token_sort_ratio' do
    it 'returns 1.0 for identical strings' do
      expect(described_class.token_sort_ratio('hello world', 'hello world')).to eq(1.0)
    end

    it 'returns 1.0 for reordered words' do
      expect(described_class.token_sort_ratio('hello world', 'world hello')).to eq(1.0)
    end

    it 'scores higher for reordered words than plain jaro_winkler' do
      a = 'john smith jr'
      b = 'jr john smith'
      token_score = described_class.token_sort_ratio(a, b)
      plain_score = described_class.jaro_winkler(a, b)
      expect(token_score).to be >= plain_score
    end

    it 'handles extra whitespace via split' do
      expect(described_class.token_sort_ratio('hello  world', 'world hello')).to eq(1.0)
    end

    it 'is case insensitive' do
      expect(described_class.token_sort_ratio('Hello World', 'world hello')).to eq(1.0)
    end
  end

  describe '.token_set_ratio' do
    it 'returns 1.0 for identical token sets' do
      expect(described_class.token_set_ratio('hello world', 'hello world')).to eq(1.0)
    end

    it 'returns 1.0 when one side has duplicate tokens' do
      expect(described_class.token_set_ratio('hello hello world', 'hello world')).to eq(1.0)
    end

    it 'scores high for subset relationships' do
      score = described_class.token_set_ratio('new york mets', 'new york mets vs atlanta braves')
      expect(score).to be > 0.8
    end

    it 'is case insensitive' do
      expect(described_class.token_set_ratio('Hello World', 'hello world')).to eq(1.0)
    end

    it 'handles reordered tokens' do
      expect(described_class.token_set_ratio('world hello', 'hello world')).to eq(1.0)
    end
  end

  describe '.weighted_score' do
    it 'computes weighted combination of algorithms' do
      score = described_class.weighted_score('kitten', 'sitting', weights: { jaro_winkler: 0.5, dice: 0.3, levenshtein_ratio: 0.2 })
      expect(score).to be_between(0.0, 1.0)
    end

    it 'returns 1.0 for identical strings regardless of weights' do
      score = described_class.weighted_score('hello', 'hello', weights: { jaro_winkler: 0.5, dice: 0.5 })
      expect(score).to eq(1.0)
    end

    it 'raises Error when weights do not sum to 1.0' do
      expect do
        described_class.weighted_score('a', 'b', weights: { jaro_winkler: 0.5, dice: 0.3 })
      end.to raise_error(Philiprehberger::FuzzyMatch::Error, /Weights must sum to 1.0/)
    end

    it 'raises Error for unknown algorithm' do
      expect do
        described_class.weighted_score('a', 'b', weights: { unknown_algo: 1.0 })
      end.to raise_error(Philiprehberger::FuzzyMatch::Error, /Unknown algorithm/)
    end

    it 'supports lcs_ratio as a weight key' do
      score = described_class.weighted_score('kitten', 'sitting', weights: { lcs_ratio: 0.5, damerau_ratio: 0.5 })
      expect(score).to be_between(0.0, 1.0)
    end

    it 'returns higher score when higher-scoring algorithms are weighted more' do
      jw_heavy = described_class.weighted_score('martha', 'marhta', weights: { jaro_winkler: 0.9, levenshtein_ratio: 0.1 })
      lev_heavy = described_class.weighted_score('martha', 'marhta', weights: { jaro_winkler: 0.1, levenshtein_ratio: 0.9 })
      # jaro_winkler scores higher for transpositions than levenshtein ratio
      expect(jw_heavy).to be > lev_heavy
    end

    it 'accepts weights that sum to 1.0 with floating point' do
      score = described_class.weighted_score('abc', 'abc', weights: { jaro_winkler: 0.3, dice: 0.3, levenshtein_ratio: 0.4 })
      expect(score).to be_within(0.001).of(1.0)
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
