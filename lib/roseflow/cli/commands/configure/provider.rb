# frozen_string_literal: true

require_relative "../../command"
require "tty-prompt"
require "tty-file"
require "perfect_toml"
require "yaml"

module Roseflow
  module Cli
    module Commands
      class Configure
        class Provider < Roseflow::Cli::Command
          def initialize(options)
            @options = options
            @prompt = TTY::Prompt.new
            @pastel = Pastel.new(enabled: !options[:no_color])
          end

          def execute(input: $stdin, output: $stdout)
            puts @pastel.bright_green "\n✨ ROSEFLOW: Configuring an AI provider ✨\n"
            @prompt.select("What AI provider would you like to configure?") do |menu|
              menu.choice "HuggingFace", -> { configure_huggingface }, disabled: "(coming soon)"
              menu.choice "MosaicML", -> { configure_mosaicml }, disabled: "(coming soon)"
              menu.choice "OpenAI", -> { configure_openai }
            end
          end

          def configure_openai
            scope = @prompt.select("\nAre you configuring OpenAI locally or globally?") do |menu|
              menu.choice "Local (configuration stored in current working directory)", -> { "local" }
              menu.choice "Global (system-wide configuration, stored in ~/.roseflow)", -> { "global" }
            end

            puts @pastel.bright_yellow "\nSetting default configuration for OpenAI"
            default_config = openai_environment_config({ organization_id: nil, api_key: nil })

            build_environments = @prompt.yes?("Do you want to create environment-specific configurations?")

            if build_environments
              environments = @prompt.multi_select("Which environments do you want to configure?") do |menu|
                menu.choice "Development", -> { "development" }
                menu.choice "Test", -> { "test" }
                menu.choice "Production", -> { "production" }
              end

              configs = environments.each_with_object({}) do |environment, hash|
                puts @pastel.bright_yellow "\nConfiguring [#{environment}] environment"
                hash[environment] = openai_environment_config(default_config)
              end

              configs[:default] = default_config
            else
              configs = { default: default_config }
            end

            # default = @prompt.yes?("Would you like to set this as the default provider?")

            puts @pastel.bright_yellow "\nSaving the configuration ..."

            tree = {
              "config" => [
                            ["openai.yml", yaml_from_config(configs)],
                          ],
            }

            case scope
            when "global"
              TTY::File.create_dir(tree, File.expand_path("~/.roseflow"))
            when "local"
              TTY::File.create_dir(tree)
            end

            puts @pastel.bright_green "\n✨ Configuration complete! ✨"
          end

          def openai_environment_config(default)
            api_key = @prompt.mask("Enter an OpenAI API key:") do |q|
              q.required true
            end

            organization_id = @prompt.ask("Enter an OpenAI organization ID:") do |q|
              q.required false
              q.default default[:organization_id]
            end

            { api_key: api_key, organization_id: organization_id }
          end

          def yaml_from_config(configs)
            default_yaml = <<-YAML
default: &default
  organization_id: #{configs.dig(:default, :organization_id)}
  api_key: #{configs.dig(:default, :api_key)}
YAML
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
