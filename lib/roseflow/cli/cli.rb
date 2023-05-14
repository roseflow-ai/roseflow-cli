# frozen_string_literal: true

require "thor"
require "pastel"
require "roseflow/cli/version"

module Roseflow
  module Cli
    # Handle the application command line parsing
    # and the dispatch to various command objects
    #
    # @api public
    class CLI < Thor
      # Error raised by this runner
      Error = Class.new(StandardError)

      def help(*args)
        pastel = Pastel.new(enabled: !options[:no_color])
        puts pastel.bright_red banner
        super
      end

      desc "version", "roseflow-cli version"

      def version
        require_relative "version"
        puts "v#{Roseflow::Cli::VERSION}"
      end

      map %w(--version -v) => :version

      require_relative "commands/configure"
      register Roseflow::Cli::Commands::Configure, "configure", "configure [SUBCOMMAND]", "Command description..."

      desc "configure", "Configure Roseflow CLI"
      method_option :help, aliases: "-h", type: :boolean,
                           desc: "Display usage information"

      def configure(*)
        if options[:help]
          invoke :help, ["configure"]
        else
          require_relative "commands/configure"
          Roseflow::Cli::Commands::Configure.new(options).execute
        end
      end

      require_relative "commands/configure"
      register Roseflow::Cli::Commands::Configure, "configure", "configure [SUBCOMMAND]", "Configure Roseflow CLI"

      private

      def banner
        <<-OUT

  @@@@@@@   @@@@@@   @@@@@@  @@@@@@@@ @@@@@@@@ @@@       @@@@@@  @@@  @@@  @@@ 
  @@!  @@@ @@!  @@@ !@@      @@!      @@!      @@!      @@!  @@@ @@!  @@!  @@! 
  @!@!!@!  @!@  !@!  !@@!!   @!!!:!   @!!!:!   @!!      @!@  !@! @!!  !!@  @!@ 
  !!: :!!  !!:  !!!     !:!  !!:      !!:      !!:      !!:  !!!  !:  !!:  !!  
  :    : :  : :. :  ::.: :   : :: ::   :       : ::.: :  : :. :    ::.:  :::  

  Interact with AI effortlessly in Ruby | https://roseflow.ai | Version #{Roseflow::Cli.gem_version}
        OUT
      end
    end
  end
end
