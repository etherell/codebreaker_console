# frozen_string_literal: true

require 'bundler/setup'
require 'pry'
require 'codebreaker'
require 'date'
require 'yaml'
require 'i18n'
require 'faker'

require_relative 'config'
require './classes/stats_manager'
require './classes/validator'
require './consoles/base_console'
require './consoles/options_console'
require './consoles/registration_console'
require './consoles/game_console'
require './consoles/result_console'
