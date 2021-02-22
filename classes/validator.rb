# frozen_string_literal: true

class Validator
  DIFFICULTIES = %w[hell medium easy].freeze
  MIN_NAME_LENGTH = 3
  MAX_NAME_LENGTH = 20
  NUMBER_LENGTH = 4

  class << self
    def valid_player_name?(name)
      name.length.between?(MIN_NAME_LENGTH, MAX_NAME_LENGTH)
    end

    def valid_difficulty?(difficulty)
      DIFFICULTIES.include?(difficulty)
    end

    def valid_input?(input)
      input.match?(/^[1-6]{#{NUMBER_LENGTH}}$/o)
    end
  end
end
