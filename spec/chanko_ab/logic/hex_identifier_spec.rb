require 'spec_helper'

describe ChankoAb::Logic::HexIdentifier do
  let(:obj) do
    ChankoAdoptedClass.new
  end

  before do
    ChankoAbTest.class_eval do
      split_test.logic ChankoAb::Logic::HexIdentifier
      split_test.add 'A', {}
      split_test.add 'B', {}
      split_test.add 'C', {}
    end
  end

  after do
    ChankoAbTest.split_test.reset_patterns
  end

  context 'pattern 0' do
    before do
      ChankoAb.set_identifier { '0' }
    end

    it 'returns A' do
      expect(obj.call(:name)).to eq 'A'
    end
  end

  context 'pattern e' do
    before do
      ChankoAb.set_identifier { 'e' }
    end

    it 'returns D' do
      expect(obj.call(:name)).to eq 'C'
    end
  end

  context 'pattern f which is non-assigned due to fraction' do
    before do
      ChankoAb.set_identifier { 'f' }
    end

    it 'returns nil' do
      expect(obj.call(:name)).to eq nil
    end
  end
end
