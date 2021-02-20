# frozen_string_literal: true

class StatsManager
  DIR_NAME = 'data'
  DATA_PATH = './data/game_statistics.yaml'
  DIFFICULTIES = %w[hell medium easy].freeze

  attr_reader :game_statistics

  def initialize
    @game_statistics = sorted_statistics
  end

  def add(result_hash)
    @game_statistics << result_hash
    save
  end

  private

  def sorted_statistics
    DIFFICULTIES.flat_map do |difficulty|
      difficulty_statistics = load_statistics.select { |statistic| difficulty == statistic['difficulty'] }
      difficulty_statistics.sort_by { |statistic| [statistic['attempts_used'], statistic['hints_used']] }
    end
  end

  def load_statistics
    return [] unless File.exist?(DATA_PATH)

    stats_manager = YAML.safe_load(File.read(DATA_PATH),
                                   permitted_classes: [StatsManager, Hash, Symbol],
                                   aliases: true)
    stats_manager&.game_statistics || []
  end

  def save
    Dir.mkdir(DIR_NAME) unless Dir.exist?(DIR_NAME)
    File.open(DATA_PATH, 'w+') { |file| file.write(Psych.dump(self)) }
  end
end
