# frozen_string_literal: true

class ResultConsole < BaseConsole
  attr_reader :player, :game_statistic

  OPTIONS = %w[yes no].freeze

  def initialize(player, game_statistic)
    @player = player
    @game_statistic = game_statistic
    @player_input = ''
    super
  end

  def call
    game_statistic.attempts_left.positive? ? handle_win : handle_lose
  end

  private

  def handle_win
    puts I18n.t('game.result.win_message')
    show_secret_number
    ask_if_save_result
    ask_if_start_new_game
  end

  def handle_lose
    puts I18n.t('game.result.lose_message')
    show_secret_number
    ask_if_start_new_game
  end

  def ask_if_save_result
    puts I18n.t('game.result.ask_if_save_result')
    @player_input = receive_input
    ask_if_save_result unless OPTIONS.include?(@player_input)

    save_statistics if @player_input == I18n.t('answers.positive')
  end

  def ask_if_start_new_game
    puts I18n.t('game.result.ask_if_start_new_game')
    @player_input = receive_input
    ask_if_start_new_game unless OPTIONS.include?(@player_input)

    @player_input == I18n.t('answers.positive') ? restart_game : exit_game
  end

  def exit_game
    exit(true)
  end

  def restart_game
    OptionsConsole.call
  end

  def show_secret_number
    puts I18n.t('game.result.secret_number', secret_number: game_statistic.secret_number)
  end

  def save_statistics
    result_hash = game_statistic.to_h.merge(player.to_h)
    StatsManager.new.add(result_hash)
  end
end
