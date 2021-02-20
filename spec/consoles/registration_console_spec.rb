# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RegistrationConsole do
  subject(:registration_console_call) { registration_console.call }

  let(:registration_console) { described_class.new }

  describe '#call' do
    before { allow(GameConsole).to receive(:call) }

    context 'with valid params' do
      let(:player_name) { 'a' * Validator::MIN_NAME_LENGTH }
      let(:difficulty) { I18n.t('difficulties.easy') }

      before { allow(registration_console).to receive(:gets).and_return(player_name, difficulty) }

      it 'receives request_player_name' do
        expect(registration_console).to receive(:request_player_name)
        registration_console_call
      end

      it 'requests player name' do
        expect { registration_console_call }.to output(/#{I18n.t('game.registration.player_name')}/).to_stdout
      end

      it 'receives set_player_name' do
        expect(registration_console).to receive(:set_player_name)
        registration_console_call
      end

      it 'sets player name' do
        registration_console_call
        expect(registration_console.player.name).to eq(player_name)
      end

      it 'requests difficulty' do
        expect { registration_console_call }.to output(/#{I18n.t('game.registration.difficulty')}/).to_stdout
      end

      it 'receives set_game_difficulty' do
        expect(registration_console).to receive(:set_game_difficulty)
        registration_console_call
      end

      it 'sets difficulty' do
        registration_console_call
        expect(registration_console.game_statistic.difficulty).to eq(difficulty)
      end

      it 'receives start_game' do
        expect(registration_console).to receive(:start_game)
        registration_console_call
      end

      it 'starts game' do
        expect(GameConsole).to receive(:call)
        registration_console_call
      end
    end

    context 'with invalid name' do
      let(:player_name) { 'a' * (Validator::MIN_NAME_LENGTH - 1) }
      let(:difficulty) { I18n.t('difficulties.easy') }

      before { allow(registration_console).to receive(:gets).and_return(player_name, difficulty) }

      it 'shows wrong name error' do
        expect { registration_console_call }.to output(/#{I18n.t('game.registration.wrong_player_name')}/).to_stdout
      end

      it 'requests player name again' do
        expect(registration_console).to receive(:request_player_name_again)
        registration_console_call
      end
    end
  end
end
