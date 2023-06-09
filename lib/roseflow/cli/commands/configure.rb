# frozen_string_literal: true

require "thor"

module Roseflow
  module Cli
    module Commands
      class Configure < Thor
        namespace :configure

        desc "vectordb", "Configure a vector store for Roseflow"
        method_option :help, aliases: "-h", type: :boolean,
                             desc: "Display usage information"

        def vectordb(*)
          if options[:help]
            invoke :help, ["vectordb"]
          else
            require_relative "configure/vectordb"
            Roseflow::Cli::Commands::Configure::Vectordb.new(options).execute
          end
        end

        desc "provider", "Configure an AI provider for Roseflow"
        method_option :help, aliases: "-h", type: :boolean,
                             desc: "Display usage information"

        def provider(*)
          if options[:help]
            invoke :help, ["provider"]
          else
            require_relative "configure/provider"
            Roseflow::Cli::Commands::Configure::Provider.new(options).execute
          end
        end
      end
    end
  end
end
