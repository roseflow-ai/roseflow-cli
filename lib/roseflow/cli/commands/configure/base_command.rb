# frozen_string_literal: true

require_relative "../../command"
require "tty-prompt"
require "tty-file"
require "yaml"

module Roseflow
  module Cli
    module Commands
      class Configure
        class BaseCommand < Roseflow::Cli::Command
          def initialize(options)
            @options = options
            @prompt = TTY::Prompt.new(interrupt: interrupt_proc)
            @pastel = Pastel.new(enabled: !options[:no_color])
          end

          private

          def interrupt_proc
            Proc.new do
              puts @pastel.bright_red "\n\n🚨 ROSEFLOW: Configuration aborted 🚨\n"
              exit
            end
          end

          def yaml_from_config(configs)
            default_yaml = default_yaml_config(configs)
            default_yaml + configs.reject { |env, cfg| env == :default }.map do |environment, config|
              yaml_for_environment(environment, config)
            end.join("")
          end

          def yaml_for_environment(environment, config)
            yaml = "\n#{environment}:\n  <<: *default\n"
            config.each do |key, value|
              yaml += "  #{key}: #{value}\n"
            end
            yaml
          end
        end
      end
    end
  end
end
