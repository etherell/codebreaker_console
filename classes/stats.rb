class Stats
  DIR_NAME = 'data'.freeze
  DATA_PATH = './data/players.yaml'.freeze
  DIFFICULTIES = %w[hell medium easy].freeze

  attr_accessor :players

  def initialize
    @players = load_players || []
  end

  def add(player)
    @players << player
    save
  end

  def sorted_players
    DIFFICULTIES.flat_map do |difficulty|
      current_difficulty_players = players.select { |player| difficulty == player.difficulty }
      current_difficulty_players.sort_by { |player| [player.attempts_used, player.hints_used] }
    end
  end

  def load_players
    return [] unless File.exist?(DATA_PATH)

    stats = YAML.safe_load(File.read(DATA_PATH), permitted_classes: [Stats, Codebreaker::Player], aliases: true)
    stats&.players
  end

  private

  def save
    Dir.mkdir(DIR_NAME) unless Dir.exist?(DIR_NAME)
    File.open(DATA_PATH, 'w+') { |file| file.write(Psych.dump(self)) }
  end

  # def add_random_player
  #   player = Player.new
  #   player.difficulty = DIFFICULTIES.sample
  #   player.attempts_used = rand(1...player.attempts_total)
  #   player.hints_used = rand(1..player.hints_total)
  #   player.name = Faker::Name.name
  #   add(player)
  # end
end
