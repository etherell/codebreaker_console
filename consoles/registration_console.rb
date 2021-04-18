# frozen_string_literal: true

class RegistrationConsole < BaseConsole
  attr_accessor :player, :game_statistic

  def call
    request_player_name
    set_player_name
    request_difficulty
    set_game_difficulty
    start_game
  end

  private

  def request_player_name
    loop do
      puts I18n.t('game.registration.player_name')
      @player_name = receive_input
      break if Validator.valid_player_name?(@player_name)

      puts I18n.t('game.registration.wrong_player_name')
    end
  end

  def set_player_name
    @player = Codebreaker::Player.new(@player_name)
  end

  def request_difficulty
    loop do
      puts I18n.t('game.registration.difficulty')
      @difficulty = receive_input
      break if Validator.valid_difficulty?(@difficulty)

      puts I18n.t('game.registration.wrong_difficulty')
    end
  end

  def set_game_difficulty
    @game_statistic = Codebreaker::GameStatistic.new(@difficulty)
  end

  def start_game
    GameConsole.call(player, game_statistic)
  end
end
