require 'spec_helper'

describe ChankoAb do
  let(:obj) do
    ChankoAdoptedClass.new
  end

  before do
    ChankoAbTest.class_eval do
      split_test.logic ChankoAb::Logic::NumberIdentifier
      split_test.add 'A', {}
      split_test.add 'B', {}
      split_test.add 'C', {}
    end
  end

  after do
    ChankoAbTest.split_test.reset_patterns
  end

  describe 'Item' do
    context 'pattern 0' do
      before do
        ChankoAb.set_identifier { '0' }
      end

      it 'returns A' do
        expect(obj.call(:name)).to eq 'A'
      end
    end

    context 'pattern 1' do
      before do
        ChankoAb.set_identifier { '1' }
      end

      it 'returns B' do
        expect(obj.call(:name)).to eq 'B'
      end
    end

    context 'pattern 2' do
      before do
        ChankoAb.set_identifier { '2' }
      end

      it 'returns C' do
        expect(obj.call(:name)).to eq 'C'
      end
    end

    context 'pattern 3 which is non-assigned due to fraction' do
      before do
        ChankoAb.set_identifier { '3' }
      end

      it 'returns nil' do
        expect(obj.call(:name)).to eq nil
      end
    end

    context 'pattern 4 which is non-assigned due to fraction' do
      before do
        ChankoAb.set_identifier { '4' }
      end

      it 'returns nil' do
        expect(obj.call(:name)).to eq nil
      end
    end

    context 'pattern 5' do
      before do
        ChankoAb.set_identifier { '5' }
      end

      it 'returns nil' do
        expect(obj.call(:name)).to eq 'A'
      end
    end
  end
end
