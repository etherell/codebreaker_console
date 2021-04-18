# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Validator do
  let(:validator) { described_class }

  describe '#valid_player_name?' do
    subject(:valid_name?) { validator.valid_player_name?(name) }

    context 'with valid name' do
      let(:name) { Faker::String.random(length: Validator::MIN_NAME_LENGTH..Validator::MAX_NAME_LENGTH) }

      it 'returns true' do
        expect(valid_name?).to be_truthy
      end
    end

    context 'with short name' do
      let(:name) { Faker::String.random(length: Validator::MIN_NAME_LENGTH - 1) }

      it 'returns true' do
        expect(valid_name?).to be_falsey
      end
    end

    context 'with long name' do
      let(:name) { Faker::String.random(length: Validator::MAX_NAME_LENGTH + 1) }

      it 'returns true' do
        expect(valid_name?).to be_falsey
      end
    end
  end

  describe '#valid_difficulty?' do
    subject(:valid_difficulty?) { validator.valid_difficulty?(difficulty) }

    context 'with valid difficulty' do
      let(:difficulty) { Validator::DIFFICULTIES.sample }

      it 'returns true' do
        expect(valid_difficulty?).to be_truthy
      end
    end

    context 'with invalid difficulty' do
      let(:difficulty) { Faker::String.random }

      it 'returns false' do
        expect(valid_difficulty?).to be_falsey
      end
    end
  end
end
