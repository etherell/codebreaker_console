class RegistrationConsole < BaseConsole
  attr_accessor :player

  def initialize
    @player = Codebreaker::Player.new
    super
  end

  def call
    request_player_name
    set_player_name
    request_difficulty
    set_difficulty
    start_game
  end

  private

  def request_player_name
    puts I18n.t('game.registration.name')
    @name = gets.chomp
    request_name_again unless Codebreaker::Validator.valid_name?(@name)
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
    request_difficulty_again unless Codebreaker::Validator.valid_difficulty?(@difficulty)
  end

  def request_difficulty_again
    puts I18n.t('game.registration.wrong_difficulty')
    request_difficulty
  end

  def set_difficulty
    player.difficulty = @difficulty
  end

  def start_game
    GameConsole.call(player)
  end
end
