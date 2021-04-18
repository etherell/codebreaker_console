# frozen_string_literal: true

class BaseConsole
  def initialize(*_args)
    raise NotImplementedError if instance_of? BaseConsole
  end

  def self.call(*args)
    new(*args).call
  end

  def call
    raise NotImplementedError
  end

  EXIT_INPUT = 'exit'

  def receive_input
    input = gets.chomp
    exit(true) if input == EXIT_INPUT
    input
  end
end
