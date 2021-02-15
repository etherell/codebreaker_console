class GameConsole < BaseConsole
  attr_reader :player_input, :player, :game, :game_statistic

  HINT_INPUT = 'hint'.freeze

  def initialize(player, game_statistic)
    @player = player
    @game = Codebreaker::Game.new
    @game_statistic = game_statistic
    @player_input = ''
    super
  end

  def call
    prepare_hints
    game_statistic.attempts_total.times do
      request_player_input
      update_game_params
      show_result
      finish_game if game.win?
    end
    show_lose_message
  end

  private

  def prepare_hints
    game_statistic.secret_number = game.secret_number
  end

  def request_player_input
    puts I18n.t('game.process.player_input')
    @player_input = gets.chomp
    show_hint if @player_input == HINT_INPUT
    request_player_input_again unless Validator.valid_input?(player_input)
  end

  def request_player_input_again
    puts I18n.t('game.process.wrong_input')
    request_player_input
  end

  def show_hint
    if @game_statistic.hints?
      puts I18n.t('game.process.hint', number: @game_statistic.give_hint)
    else
      puts I18n.t('game.process.no_hints')
    end

    request_player_input
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
    StatsManager.new.add(result_hash)
    puts I18n.t('game.process.win_message')
    exit_game
  end

  def show_lose_message
    I18n.t('game.process.lose_message')
  end

  def result_hash
    game_statistic.to_h.merge(player.to_h)
  end

  def exit_game
    exit(true)
  end
end
