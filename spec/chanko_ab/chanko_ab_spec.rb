require 'spec_helper'
require 'chanko'
require 'chanko_ab'

class Chanko::Loader 
  def add_autoload_path
    # Ignored
  end
end

class ChankoAdoptedClass
  include Chanko::Invoker

  def hello
    invoke(:chanko_ab_test, :name)
  end

  def request
    { }
  end
end

module ChankoAbTest
  include Chanko::Unit
  include ChankoAb
  active_if { true }

  split_test.add 'A', {}
  split_test.add 'B', {}
  split_test.add 'C', {}

  split_test.define(:name, scope: ChankoAdoptedClass) do
    ab.name
  end
end


describe ChankoAb do

  let(:process) do
    ChankoAb::Process::NumberIdentifier.new
  end

  let(:obj) do 
    ChankoAdoptedClass.new
  end

  describe 'Item' do
    context 'pattern 0' do
      before do
        ChankoAb.set_identifier { '0' }
      end

      it 'returns A' do
        expect(obj.hello).to eq 'A'
      end
    end

    context 'pattern 1' do
      before do
        ChankoAb.set_identifier { '1' }
      end

      it 'returns B' do
        expect(obj.hello).to eq 'B'
      end
    end

    context 'pattern 2' do
      before do
        ChankoAb.set_identifier { '2' }
      end

      it 'returns C' do
        expect(obj.hello).to eq 'C'
      end
    end

    context 'pattern 3' do
      before do
        ChankoAb.set_identifier { '3' }
      end

      it 'returns nil' do
        expect(obj.hello).to eq nil
      end
    end

    context 'pattern 4' do
      before do
        ChankoAb.set_identifier { '4' }
      end

      it 'returns nil' do
        expect(obj.hello).to eq nil
      end
    end

    context 'pattern 5' do
      before do
        ChankoAb.set_identifier { '5' }
      end

      it 'returns nil' do
        expect(obj.hello).to eq 'A'
      end
    end
  end
end
