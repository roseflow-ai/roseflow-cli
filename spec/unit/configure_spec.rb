require 'roseflow/cli/commands/configure'

RSpec.describe Roseflow::Cli::Commands::Configure do
  it "executes `configure` command successfully" do
    output = StringIO.new
    options = {}
    command = Roseflow::Cli::Commands::Configure.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
