# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StatsManager do
  let(:player_name) do
    Faker::String.random(length: Validator::MIN_NAME_LENGTH..Validator::MAX_NAME_LENGTH)
  end
  let(:player) { Codebreaker::Player.new(player_name) }
  let(:game_statistic) { Codebreaker::GameStatistic.new(Validator::DIFFICULTIES.sample) }
  let(:result_hash) { game_statistic.to_h.merge(player.to_h) }
  let(:stats_manager) { described_class.new }

  before do
    stub_const('StatsManager::DATA_PATH', './data/test_game_statistics.yaml')
  end

  after do
    data_path = File.expand_path('.', StatsManager::DATA_PATH)
    File.delete(data_path) if File.exist?(data_path)
  end

  describe '#add' do
    context 'when data added' do
      it 'adds newhash to results yml' do
        expect { stats_manager.add(result_hash) }.to(change { stats_manager.game_statistics.length })
      end
    end
  end
end
