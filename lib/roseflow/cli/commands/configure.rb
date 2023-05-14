# frozen_string_literal: true

require_relative "../command"

module Roseflow
  module Cli
    module Commands
      class Configure < Roseflow::Cli::Command
        def initialize(options)
          @options = options
        end

        def help(*args)
          output.puts <<-OUT

  @@@@@@@   @@@@@@   @@@@@@ @@@@@@@@ @@@@@@@@ @@@       @@@@@@  @@@  @@@  @@@ 
  @@!  @@@ @@!  @@@ !@@     @@!      @@!      @@!      @@!  @@@ @@!  @@!  @@! 
  @!@!!@!  @!@  !@!  !@@!!  @!!!:!   @!!!:!   @!!      @!@  !@! @!!  !!@  @!@ 
  !!: :!!  !!:  !!!     !:! !!:      !!:      !!:      !!:  !!!  !:  !!:  !!  
   :   : :  : :. :  ::.: :  : :: ::   :       : ::.: :  : :. :    ::.:  :::  

          OUT
        end

        def provider(*)
          if options[:help]
            invoke :help, ["provider"]
          else
            require_relative "configure/provider"
            Roseflow::Cli::Commands::Configure::Provider.new(options).execute
          end
        end

        def execute(input: $stdin, output: $stdout)
          # Command logic goes here ...
          output.puts "OK"
        end
      end
    end
  end
end
