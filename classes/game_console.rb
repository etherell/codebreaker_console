class GameConsole < BaseConsole
  attr_reader :player_input, :player, :game, :stats, :hints_manager

  HINT_INPUT = 'hint'.freeze

  def initialize(player)
    @player = player
    @game = Codebreaker::Game.new
    @hints_manager = Codebreaker::HintsManager.new(player.hints_total, game.secret_number)
    @stats = Stats.new
    @player_input = ''
  end

  def call
    player.attempts_total.times do
      request_player_input
      show_hint if player_input == HINT_INPUT
      set_player_params
      show_result
      finish_game if game.win?
    end
    show_lose_message
  end

  private

  def request_player_input
    puts I18n.t('game.process.player_input')
    @player_input = gets.chomp
    request_player_input_again unless Codebreaker::Validator.valid_input?(player_input)
  end

  def request_player_input_again
    puts I18n.t('game.process.wrong_input')
    request_player_input
  end

  def show_hint
    puts if hints_manager.has_hints?
  I18n.t('game.process.hint',
                                           number: hints_manager.give_hint)
else
  I18n.t('game.process.no_hints')
end
    request_player_input
  end

  def set_player_params
    game.player_number = player_input
    player.attempts_total += 1
    player.hints_used = hints_manager.hints_used
  end

  def show_result
    puts I18n.t('game.process.result',
                result: game.result,
                hints_left: hints_manager.hints_left,
                attempts_left: player.attempts_left)
  end

  def finish_game
    stats.add(player)
    puts I18n.t('game.process.win_message')
    exit_game
  end

  def show_lose_message
    I18n.t('game.process.lose_message')
  end

  def exit_game
    exit(true)
  end
end
