class GameConsole < BaseConsole
  attr_reader :player_input, :player, :game

  def initialize(player)
    @player = player
    @game = Codebreaker::Game.new
    @player_input = ''
  end

  def call
    player.attempts_total.times do
      request_player_input
      show_hint if player_input == 'hint'
      set_player_input
      show_result
      check_game_status
    end
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
    if player.has_hints?
      puts I18n.t('game.process.hint', number: game.give_hint(player))
    else
      puts I18n.t('game.process.no_hints')
    end
    request_player_input
  end

  def set_player_input
    game.player_number = player_input
    player.attempts_used += 1
  end

  def show_result
    puts I18n.t('game.process.result',
                result: game.result,
                hints_left: player.hints_left,
                attempts_left: player.attempts_left)
  end

  def check_game_status
    if game.win?
      puts I18n.t('game.process.win_message')
      exit(true)
    end

    puts I18n.t('game.process.lose_message') unless player.has_attempts?
    game.clear_result
  end
end
