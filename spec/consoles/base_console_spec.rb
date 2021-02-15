require 'spec_helper'

RSpec.describe BaseConsole do
  describe '#call' do
    subject(:base_console_call) { described_class.call('test_data') }

    let(:base_console) { instance_double(described_class) }

    it 'creates new instance and sends call' do
      allow(described_class).to receive(:new).and_return(base_console)
      expect(base_console).to receive(:call)
      base_console_call
    end

    it 'returns not implemented error' do
      expect { base_console_call }.to raise_error(NotImplementedError)
    end
  end
end
