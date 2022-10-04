require "spec_helper"

describe ChankoAb::IdentifierAllocator do
  let(:obj) do
    ChankoAdoptedClass.new
  end

  before do
    ChankoAbExperiment.class_eval do
      split_test.add_cohort name: 'A', attributes: {}
      split_test.add_cohort name: 'B', attributes: {}
      split_test.add_cohort name: 'C', attributes: {}
    end
  end

  describe "digit option" do
    context 'digit 1 and identifier is 9' do
      before do
        ChankoAbExperiment.split_test.identifier digit: 1, radix: 10, extractor: -> (ctx) { '9' }
      end

      it 'returns nil because 9 is leftover' do
        expect(obj.call(:name)).to eq nil
      end
    end

    context 'digit 2 and identifier is 9' do
      before do
        ChankoAbExperiment.split_test.identifier digit: 2, radix: 10, extractor: -> (ctx) { '9' }
      end

      it 'returns A because 9 is target of allocation' do
        expect(obj.call(:name)).to eq "A"
      end
    end

    context 'digit 2 and identifier is 99' do
      before do
        ChankoAbExperiment.split_test.identifier digit: 2, radix: 10, extractor: -> (ctx) { '99' }
      end

      it 'returns nil because 99 is leftover' do
        expect(obj.call(:name)).to eq nil
      end
    end
  end

  describe 'Decimal' do
    context 'pattern 0' do
      before do
        ChankoAbExperiment.split_test.identifier digit: 1, radix: 10, extractor: -> (ctx) { '0' }
      end

      it 'returns A' do
        expect(obj.call(:name)).to eq 'A'
      end
    end

    context 'pattern 1' do
      before do
        ChankoAbExperiment.split_test.identifier digit: 1, radix: 10, extractor: -> (ctx) { '1' }
      end

      it 'returns B' do
        expect(obj.call(:name)).to eq 'B'
      end
    end

    context 'pattern 2' do
      before do
        ChankoAbExperiment.split_test.identifier digit: 1, radix: 10, extractor: -> (ctx) { '2' }
      end

      it 'returns C' do
        expect(obj.call(:name)).to eq 'C'
      end
    end

    context 'pattern 3' do
      before do
        ChankoAbExperiment.split_test.identifier digit: 1, radix: 10, extractor: -> (ctx) { '3' }
      end

      it 'returns A' do
        expect(obj.call(:name)).to eq 'A'
      end
    end

    context 'pattern 8' do
      before do
        ChankoAbExperiment.split_test.identifier digit: 1, radix: 10, extractor: -> (ctx) { '8' }
      end

      it 'returns C' do
        expect(obj.call(:name)).to eq 'C'
      end
    end

    context 'pattern 9 which is non-assigned due to fraction' do
      before do
        ChankoAbExperiment.split_test.identifier digit: 1, radix: 10, extractor: -> (ctx) { '9' }
      end

      it 'returns nil' do
        expect(obj.call(:name)).to eq nil
      end
    end
  end

  describe 'Hex' do
    context 'pattern 0' do
      before do
        ChankoAbExperiment.split_test.identifier digit: 1, radix: 16, extractor: -> (ctx) { '0' }
      end

      it 'returns A' do
        expect(obj.call(:name)).to eq 'A'
      end
    end

    context 'pattern e' do
      before do
        ChankoAbExperiment.split_test.identifier digit: 1, radix: 16, extractor: -> (ctx) { 'e' }
      end

      it 'returns C' do
        expect(obj.call(:name)).to eq 'C'
      end
    end

    context 'pattern f which is non-assigned due to fraction' do
      before do
        ChankoAbExperiment.split_test.identifier digit: 1, radix: 16, extractor: -> (ctx) { 'f' }
      end

      it 'returns nil' do
        expect(obj.call(:name)).to eq nil
      end
    end
  end
end
