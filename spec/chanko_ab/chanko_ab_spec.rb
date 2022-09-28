require 'spec_helper'

describe ChankoAb do
  let(:obj) do
    ChankoAdoptedClass.new
  end

  before do
    ChankoAbExperiment.class_eval do
      split_test.add_cohort name: 'A', attributes: {}
      split_test.add_cohort name: 'B', attributes: {}
    end
  end

  context 'Allocation to fraction' do
    before do
      ChankoAbExperiment.class_eval do
        split_test.add_cohort name: 'C', attributes: {}
        split_test.identifier extractor: -> (ctx) { '9' }
      end
    end

    it 'does not run anything' do
      expect(obj.call(:name)).to eql nil
    end
  end

  context 'No identifier' do
    before do
      ChankoAbExperiment.class_eval do
        split_test.add_cohort name: 'C', attributes: {}
        split_test.identifier extractor: -> (ctx) { nil }
      end
    end

    it 'does not run anything' do
      expect(obj.call(:name)).to eql nil
    end
  end

  context 'Default identifier extractor' do
    before do
      ChankoAb.identifier extractor: -> (ctx) { '0' }
    end

    it "returns A" do
      expect(obj.call(:name)).to eql "A"
    end
  end


  describe 'Logging' do
    before do
      ChankoAb.logging do |name|
        ChankoAbExperiment::Logger.log(name)
      end
    end

    context 'pattern 0' do
      before do
        ChankoAbExperiment.split_test.identifier extractor: -> (ctx) { '0' }
      end

      it 'returns A' do
        expect(ChankoAbExperiment::Logger).to receive(:log).with("my_log.A")
        obj.call(:log)
      end
    end
  end

  describe "Identifier" do
    context "The unit doesn't have non specified identifier proc" do
      before do
        ChankoAb.identifier extractor: -> (ctx) { '0' }
        ChankoAbExperiment.split_test.identifier extractor: -> (ctx) { '0' }
      end

      it 'returns A' do
        expect(obj.call(:name)).to eq 'A'
      end
    end

    context "The unit has specified identifier proc" do
      before do
        ChankoAb.identifier extractor: -> (ctx) { '0' }
        ChankoAbExperiment.class_eval do
          split_test.identifier extractor: -> (ctx) { "1" }
        end
      end

      it 'ignores default identifier and returns B' do
        expect(obj.call(:name)).to eq 'B'
      end
    end

    context "The unit use tens place" do
      before do
        ChankoAbExperiment.class_eval do
          split_test.identifier extractor: -> (ctx) { "10"[0] }
        end
      end

      it 'returns A' do
        expect(obj.call(:name)).to eq 'B'
      end
    end
  end
end
