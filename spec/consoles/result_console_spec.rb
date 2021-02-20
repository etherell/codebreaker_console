# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResultConsole do
  subject(:result_console_call) { result_console.call }

  let(:result_console) { described_class.new(player, game_statistic) }
  let(:player) { Codebreaker::Player.new('a' * Validator::MIN_NAME_LENGTH) }
  let(:game_statistic) { Codebreaker::GameStatistic.new(I18n.t('difficulties.hell')) }
  let(:secret_number) { '1' * Validator::NUMBER_LENGTH }

  before do
    stub_const('StatsManager::DATA_PATH', './data/test_game_statistics.yaml')
    allow(result_console).to receive(:exit)
    game_statistic.instance_variable_set(:@secret_number, secret_number)
  end

  describe '#call' do
    context 'when player wins' do
      before { allow(result_console).to receive(:gets).and_return('yes', 'no') }

      it 'shows win message' do
        expect { result_console_call }.to output(/#{I18n.t('game.result.win_message')}/).to_stdout
      end

      it 'shows secret number' do
        expect do
          result_console_call
        end.to output(/#{I18n.t('game.result.secret_number', secret_number: secret_number)}/).to_stdout
      end

      it 'receives handle_win' do
        expect(result_console).to receive(:handle_win)
        result_console_call
      end

      it 'receives ask_if_save_result' do
        allow(result_console).to receive(:gets).and_return('no')
        expect(result_console).to receive(:ask_if_save_result)
        result_console_call
      end

      it 'receives ask_if_start_new_game' do
        expect(result_console).to receive(:ask_if_start_new_game)
        result_console_call
      end
    end

    context 'when player lose' do
      before do
        allow(result_console).to receive(:gets).and_return('no')
        allow(game_statistic).to receive(:attempts_left).and_return(0)
      end

      it 'shows lose message' do
        expect { result_console_call }.to output(/#{I18n.t('game.result.lose_message')}/).to_stdout
      end

      it 'shows secret number' do
        expect do
          result_console_call
        end.to output(/#{I18n.t('game.result.secret_number', secret_number: secret_number)}/).to_stdout
      end

      it 'receives handle_lose' do
        expect(result_console).to receive(:handle_lose)
        result_console_call
      end

      it 'receives ask_if_save_result' do
        expect(result_console).to receive(:ask_if_start_new_game)
        result_console_call
      end
    end
  end
end
