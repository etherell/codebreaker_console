# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BaseConsole do
  describe '#call' do
    it 'creates new instance and sends call' do
      expect { described_class.new }.to raise_error(NotImplementedError)
    end
  end
end
