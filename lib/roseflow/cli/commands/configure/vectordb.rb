# frozen_string_literal: true

require_relative "./base_command"
require "tty-prompt"
require "tty-file"
require "yaml"

module Roseflow
  module Cli
    module Commands
      class Configure
        class Vectordb < BaseCommand
          def execute(input: $stdin, output: $stdout)
            puts @pastel.bright_green "\n✨ ROSEFLOW: Configuring a vector store ✨\n"
            @prompt.select("What vector store provider would you like to configure?") do |menu|
              menu.choice "pgvector", -> { configure_pgvector }, disabled: "(coming soon)"
              menu.choice "Pinecone", -> { configure_pinecone }
            end
          end

          def configure_pinecone
            scope = @prompt.select("\nAre you configuring Pinecone locally or globally?") do |menu|
              menu.choice "Local (configuration stored in current working directory)", -> { "local" }
              menu.choice "Global (system-wide configuration, stored in ~/.roseflow)", -> { "global" }
            end

            puts @pastel.bright_yellow "\nSetting default configuration for Pinecone"
            default_config = pinecone_environment_config({ environment: nil, api_key: nil })

            build_environments = @prompt.yes?("Do you want to create environment-specific configurations?")

            if build_environments
              environments = @prompt.multi_select("Which environments do you want to configure?") do |menu|
                menu.choice "Development", -> { "development" }
                menu.choice "Test", -> { "test" }
                menu.choice "Production", -> { "production" }
              end

              configs = environments.each_with_object({}) do |environment, hash|
                puts @pastel.bright_yellow "\nConfiguring [#{environment}] environment"
                hash[environment] = pinecone_environment_config(default_config)
              end

              configs[:default] = default_config
            else
              configs = { default: default_config }
            end

            # default = @prompt.yes?("Would you like to set this as the default provider?")

            puts @pastel.bright_yellow "\nSaving the configuration ..."

            tree = {
              "config" => [
                            ["pinecone.yml", yaml_from_config(configs)],
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

          def pinecone_environment_config(default)
            api_key = @prompt.mask("Enter a Pinecone API key:") do |q|
              q.required true
            end

            environment_id = @prompt.ask("Enter a Pinecone environment ID:") do |q|
              q.required false
              q.default default[:environment]
            end

            { api_key: api_key, environment: environment_id }
          end

          def default_yaml_config(configs)
            <<-YAML
default: &default
  environment: #{configs.dig(:default, :environment)}
  api_key: #{configs.dig(:default, :api_key)}
YAML
          end
        end
      end
    end
  end
end
