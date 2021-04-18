# frozen_string_literal: true

class GameConsole < BaseConsole
  attr_reader :player_input, :player, :game, :game_statistic

  def initialize(player, game_statistic)
    @player = player
    @game = Codebreaker::Game.new(game_statistic)
    @game_statistic = game_statistic
    @player_input = ''
  end

  def call
    game_statistic.attempts_total.times do
      request_player_number
      update_game_params
      show_result
      break if game.win?
    end
    finish_game
  end

  private

  def request_player_number
    loop do
      puts I18n.t('game.process.player_number')
      @player_input = receive_input
      next show_hint if player_input == I18n.t('answers.hint')
      break if Validator.valid_input?(player_input)

      puts I18n.t('game.process.wrong_input')
    end
  end

  def show_hint
    return puts I18n.t('game.process.no_hints') unless game_statistic.hints?

    puts I18n.t('game.process.hint', number: game_statistic.give_hint)
  end

  def update_game_params
    game.player_number = player_input
    game_statistic.attempts_used += 1
  end

  def show_result
    puts I18n.t('game.process.result',
                result: game.result,
                hints_left: game_statistic.hints_left,
                attempts_left: game_statistic.attempts_left)
  end

  def finish_game
    ResultConsole.call(player, game_statistic, game)
  end
end
