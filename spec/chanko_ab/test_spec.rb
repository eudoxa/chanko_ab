require 'spec_helper'

describe ChankoAb::Test do
  let(:obj) do
    ChankoAdoptedClass.new
  end

  before do
    ChankoAbTest.class_eval do
      split_test.logic ChankoAb::Logic::NumberIdentifier
      split_test.add 'A', {}
      split_test.add 'B', {}
    end

    ChankoAb.set_identifier { '0' }
  end

  after do
    ChankoAbTest.split_test.reset_patterns
    ChankoAb::Test.reset!
  end

  context "no overwrite" do
    it 'returns A' do
      expect(obj.call(:name)).to eq 'A'
    end
  end

  context "overwrite as pattern B" do
    before do
      ChankoAb::Test.overwrite(ChankoAbTest, 'B')
    end

    it 'returns B' do
      expect(obj.call(:name)).to eq 'B'
    end
  end
end
