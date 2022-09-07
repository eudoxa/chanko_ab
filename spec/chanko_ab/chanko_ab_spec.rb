require 'spec_helper'

describe ChankoAb do
  let(:obj) do
    ChankoAdoptedClass.new
  end

  before do
    ChankoAbExperiment.class_eval do
      split_test.logic ChankoAb::Logic::NumberIdentifier
      split_test.add 'A', {}
      split_test.add 'B', {}
    end
  end

  describe 'Logging' do
    before do
      ChankoAb.set_logging do |name|
        ChankoAbExperiment::Logger.log(name)
      end
    end

    context 'pattern 0' do
      before do
        ChankoAbExperiment.split_test.identifier { '0' }
      end

      it 'returns A' do
        expect(ChankoAbExperiment::Logger).to receive(:log).with("my_log.A")
        obj.call(:log)
      end
    end
  end

  describe "Identifier" do
    context "Unit doesn't have non specified identifier proc" do
      before do
        # ignore default identifier
        ChankoAb.set_default_identifier { '0' }
        ChankoAbExperiment.class_eval do
          split_test.logic ChankoAb::Logic::HexIdentifier
        end
      end

      it 'returns A' do
        expect(obj.call(:name)).to eq 'A'
      end
    end

    context "The unit has specified identifier proc" do
      before do
        # ignore default identifier
        ChankoAb.set_default_identifier { '0' }
        ChankoAbExperiment.class_eval do
          split_test.logic ChankoAb::Logic::HexIdentifier
          split_test.identifier do
            "f"
          end
        end
      end

      it 'returns B' do
        expect(obj.call(:name)).to eq 'B'
      end
    end
  end
end
