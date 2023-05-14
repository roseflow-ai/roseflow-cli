require 'roseflow/cli/commands/configure/provider'

RSpec.describe Roseflow::Cli::Commands::Configure::Provider do
  it "executes `configure provider` command successfully" do
    output = StringIO.new
    options = {}
    command = Roseflow::Cli::Commands::Configure::Provider.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
