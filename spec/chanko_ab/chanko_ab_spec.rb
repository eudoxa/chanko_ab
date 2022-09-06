require 'spec_helper'
require 'chanko'
require 'chanko_ab'

describe ChankoAb do
  let(:obj) do
    ChankoAdoptedClass.new
  end

  before do
    ChankoAbTest.class_eval do
      split_test.logic ChankoAb::Logic::NumberIdentifier
      split_test.add 'A', {}
    end
  end

  after do
    ChankoAbTest.split_test.reset_patterns
  end

  describe 'Logging' do
    before do
      ChankoAb.set_logging do |name|
        ChankoAbTest::Logger.log(name)
      end
    end

    context 'pattern 0' do
      before do
        ChankoAb.set_identifier { '0' }
      end

      it 'returns A' do
        expect(ChankoAbTest::Logger).to receive(:log).with("my_log.A")
        obj.call(:log)
      end
    end
  end
end
