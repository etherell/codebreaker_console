# frozen_string_literal: true

class OptionsConsole < BaseConsole
  attr_reader :game_statistic

  def initialize
    @game_statistic = StatsManager.new
    super
  end

  def call
    show_start_message
    loop do
      show_options
      receive_option
    end
  end

  private

  def show_start_message
    puts I18n.t('messages.welcome')
  end

  def show_options
    puts I18n.t('messages.options')
  end

  def receive_option
    option = receive_input
    process_option(option)
  end

  def process_option(option)
    case option
    when I18n.t('commands.exit') then exit_game
    when I18n.t('commands.rules') then show_rules
    when I18n.t('commands.stats') then show_stats
    when I18n.t('commands.start') then start_registration
    else show_error
    end
  end

  def exit_game
    exit(true)
  end

  def show_rules
    puts I18n.t('display.rules')
  end

  def show_stats
    game_statistic.game_statistics.each_with_index do |statistic, index|
      puts I18n.t('display.stats',
                  rating: index + 1,
                  player_name: statistic['player_name'],
                  difficulty: statistic['difficulty'],
                  attempts_total: statistic['attempts_total'],
                  attempts_used: statistic['attempts_used'],
                  hints_total: statistic['hints_total'],
                  hints_used: statistic['hints_used']).concat("\n")
    end
  end

  def start_registration
    RegistrationConsole.call
  end

  def show_error
    puts I18n.t('messages.wrong_command')
  end
end
