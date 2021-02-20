# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GameConsole do
  subject(:game_console_call) { game_console.call }

  let(:game_console) { described_class.new(player, game_statistic) }
  let(:player) { Codebreaker::Player.new('a' * Validator::MIN_NAME_LENGTH) }
  let(:game_statistic) { Codebreaker::GameStatistic.new(I18n.t('difficulties.hell')) }
  let(:input) { '1' * Validator::NUMBER_LENGTH }

  before do
    stub_const('StatsManager::DATA_PATH', './data/test_game_statistics.yaml')
    game_statistic.instance_variable_set(:@attempts_total, 1)
    allow(game_console).to receive(:finish_game)
  end

  after do
    data_path = File.expand_path('.', StatsManager::DATA_PATH)
    File.delete(data_path) if File.exist?(data_path)
  end

  describe '#call' do
    describe '#when game started' do
      before do
        allow(game_console).to receive(:gets).and_return(input)
      end

      it 'sets statistic secret number' do
        game_console_call
        expect(game_statistic.instance_variable_get(:@secret_number).length).to eq(4)
      end

      it 'sets statistic hints' do
        game_console_call
        expect(game_console.game_statistic).to be_hints
      end

      it 'receives request_player_number' do
        expect(game_console).to receive(:request_player_number)
        game_console_call
      end

      it 'requests player input' do
        expect { game_console_call }.to output(/Please, input your number or take a hint/).to_stdout
      end
    end

    context 'when player inputs valid number' do
      before { allow(game_console).to receive(:gets).and_return(input) }

      it 'updates game params' do
        expect(game_console).to receive(:update_game_params)
        game_console_call
      end

      it 'increases statistic attempts_used' do
        expect { game_console_call }.to change(game_statistic, :attempts_used)
      end
    end

    context 'when player requests hints' do
      let(:hint_input) { I18n.t('answers.hint') }

      before do
        allow(game_console).to receive(:gets).and_return(hint_input, hint_input, input)
      end

      it 'receives show_hint' do
        expect(game_console).to receive(:show_hint).twice
        game_console_call
      end

      it 'shows hint' do
        expect { game_console_call }.to output(/Number from secret code/).to_stdout
      end

      it 'shows no hints message' do
        expect { game_console_call }.to output(/You have used all hints/).to_stdout
      end
    end

    context 'when player inputs wrong number' do
      let(:not_valid_input) { '1' * (Validator::NUMBER_LENGTH + 1) }

      before do
        allow(game_console).to receive(:gets).and_return(not_valid_input, input)
      end

      it 'receives request_player_number_again' do
        expect(game_console).to receive(:request_player_number_again)
        game_console_call
      end

      it 'shows error message' do
        expect { game_console_call }.to output(/Wrong input fomat, please try again/).to_stdout
      end
    end

    context 'when game finishes' do
      let(:result_console) { ResultConsole }

      before do
        game_console.game.instance_variable_set(:@secret_number, input)
        allow(game_console).to receive(:exit)
        allow(game_console).to receive(:gets).and_return(input)
      end

      it 'receives request_player_number_again' do
        expect(game_console).to receive(:finish_game).once
        game_console_call
      end
    end
  end
end
