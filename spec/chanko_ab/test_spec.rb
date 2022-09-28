require 'spec_helper'

describe ChankoAb::Test do
  let(:obj) do
    ChankoAdoptedClass.new
  end

  before do
    ChankoAbExperiment.class_eval do
      split_test.identifier extractor: -> (ctx) { '0' }
      split_test.add_cohort name: 'A', attributes: {}
      split_test.add_cohort name: 'B', attributes: {}
    end
  end

  context "no overwrite" do
    it 'returns A' do
      expect(obj.call(:name)).to eq 'A'
    end
  end

  context "overwrite as pattern B" do
    before do
      ChankoAb::Test.overwrite(ChankoAbExperiment, 'B')
    end

    it 'returns B' do
      expect(obj.call(:name)).to eq 'B'
    end
  end
end
