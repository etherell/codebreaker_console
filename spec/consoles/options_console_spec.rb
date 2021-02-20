# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OptionsConsole do
  subject(:options_console_call) { options_console.call }

  let(:options_console) { described_class.new }

  describe '#call' do
    before do
      allow(options_console).to receive(:receive_option_again)
    end

    context 'when console called' do
      before do
        allow(options_console).to receive(:gets).and_return(I18n.t('options.rules'))
      end

      it 'shows welcome message' do
        expect { options_console_call }.to output(/#{I18n.t('messages.welcome')}/).to_stdout
      end

      it 'shows options' do
        expect { options_console_call }.to output(/#{I18n.t('messages.options')}/).to_stdout
      end
    end

    context 'when rules chosen' do
      it 'receives show_rules' do
        allow(options_console).to receive(:gets).and_return(I18n.t('options.rules'))
        expect(options_console).to receive(:show_rules)
        options_console_call
      end
    end

    context 'when exit chosen' do
      before do
        allow(options_console).to receive(:gets).and_return(I18n.t('options.exit'))
        allow(options_console).to receive(:exit)
      end

      it 'receives exit_game' do
        expect(options_console).to receive(:exit_game)
        options_console_call
      end
    end

    context 'when stats chosen' do
      it 'shows stats' do
        allow(options_console).to receive(:gets).and_return(I18n.t('options.stats'))
        expect(options_console).to receive(:show_stats)
        options_console_call
      end
    end

    context 'when start chosen' do
      before do
        allow(options_console).to receive(:gets).and_return(I18n.t('options.start'))
        allow(RegistrationConsole).to receive(:call)
      end

      after { options_console_call }

      it 'starts registration' do
        expect(RegistrationConsole).to receive(:call)
      end

      it 'calls registration console' do
        expect(options_console).to receive(:start_registration)
      end
    end

    context 'when wrong input' do
      let(:not_valid_input) { 'blablabla' }

      before { allow(options_console).to receive(:gets).and_return(not_valid_input) }

      it 'receives show_error' do
        expect(options_console).to receive(:show_error)
        options_console_call
      end

      it 'shows error message' do
        expect { options_console_call }.to output(/#{I18n.t('messages.wrong_command')}/).to_stdout
      end
    end
  end
end
