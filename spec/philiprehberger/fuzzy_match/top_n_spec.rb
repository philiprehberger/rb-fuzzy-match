# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::FuzzyMatch do
  describe '.top_n' do
    let(:candidates) { %w[commit comment command compare zebra] }

    it 'returns at most n results' do
      results = described_class.top_n('comit', candidates, n: 3)
      expect(results.length).to be <= 3
    end

    it 'returns the requested number when enough candidates qualify' do
      results = described_class.top_n('comit', candidates, n: 3)
      expect(results.length).to eq(3)
    end

    it 'returns hashes with :value and :similarity keys' do
      results = described_class.top_n('comit', candidates, n: 2)
      results.each do |entry|
        expect(entry).to be_a(Hash)
        expect(entry.keys).to contain_exactly(:value, :similarity)
      end
    end

    it 'sorts results descending by similarity' do
      results = described_class.top_n('comit', candidates, n: 5)
      similarities = results.map { |r| r[:similarity] }
      expect(similarities).to eq(similarities.sort.reverse)
    end

    it 'filters out entries below min_similarity' do
      results = described_class.top_n('comit', candidates, n: 10, min_similarity: 0.7)
      expect(results).not_to be_empty
      results.each do |entry|
        expect(entry[:similarity]).to be >= 0.7
      end
      values = results.map { |r| r[:value] }
      expect(values).not_to include('zebra')
    end

    it 'returns empty array when no candidate meets min_similarity' do
      results = described_class.top_n('comit', candidates, n: 3, min_similarity: 0.99)
      expect(results).to eq([])
    end

    it 'does not filter when min_similarity is the default 0.0' do
      results = described_class.top_n('comit', candidates, n: 100)
      expect(results.length).to eq(candidates.length)
    end

    it 'works with the :levenshtein algorithm' do
      results = described_class.top_n('comit', candidates, n: 2, algorithm: :levenshtein)
      expect(results.length).to eq(2)
      results.each do |entry|
        expect(entry[:similarity]).to be_between(0.0, 1.0)
      end
      similarities = results.map { |r| r[:similarity] }
      expect(similarities).to eq(similarities.sort.reverse)
    end

    it 'returns the best match first' do
      results = described_class.top_n('comit', candidates, n: 1)
      expect(results.length).to eq(1)
      expect(results.first[:value]).to eq('commit')
    end

    it 'returns empty array for empty candidates' do
      expect(described_class.top_n('anything', [], n: 3)).to eq([])
    end
  end
end
