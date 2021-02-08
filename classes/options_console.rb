class OptionsConsole < BaseConsole
  def call
    show_start_message
    show_options
    get_option
  end

  private

  def show_start_message
    puts I18n.t('messages.welcome')
  end

  def show_options
    puts I18n.t('messages.options')
  end

  def get_option
    option = gets.chomp
    process_option(option)
    get_option_again
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

  def get_option_again
    show_options
    get_option
  end

  def exit_game
    exit(true)
  end

  def show_rules
    puts I18n.t('display.rules')
  end

  def show_stats
    Stats.new.sorted_players.each_with_index do |player, index|
      puts I18n.t('display.stats',
                  rating: index + 1,
                  name: player.name,
                  difficulty: player.difficulty,
                  attempts_total: player.attempts_total,
                  attempts_used: player.attempts_used,
                  hints_total: player.hints_total,
                  hints_used: player.hints_used) + "\n"
    end
  end

  def start_registration
    RegistrationConsole.call
  end

  def show_error
    puts I18n.t('messages.wrong_command')
  end
end
