class RegistrationConsole < BaseConsole
  attr_accessor :player, :game_statistic

  def initialize
    @player = Codebreaker::Player.new
    @game_statistic = Codebreaker::GameStatistic.new
    super
  end

  def call
    request_player_name
    set_player_name
    request_difficulty
    set_game_difficulty
    start_game
  end

  private

  def request_player_name
    puts I18n.t('game.registration.name')
    @name = gets.chomp
    request_name_again unless Validator.valid_name?(@name)
  end

  def request_name_again
    puts I18n.t('game.registration.wrong_name')
    request_player_name
  end

  def set_player_name
    player.name = @name
  end

  def request_difficulty
    puts I18n.t('game.registration.difficulty')
    @difficulty = gets.chomp
    request_difficulty_again unless Validator.valid_difficulty?(@difficulty)
  end

  def request_difficulty_again
    puts I18n.t('game.registration.wrong_difficulty')
    request_difficulty
  end

  def set_game_difficulty
    game_statistic.difficulty = @difficulty
  end

  def start_game
    GameConsole.call(player, game_statistic)
  end
end
