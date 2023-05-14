require 'roseflow/cli/commands/configure/vectordb'

RSpec.describe Roseflow::Cli::Commands::Configure::Vectordb do
  it "executes `configure vectordb` command successfully" do
    output = StringIO.new
    options = {}
    command = Roseflow::Cli::Commands::Configure::Vectordb.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
