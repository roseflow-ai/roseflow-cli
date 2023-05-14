RSpec.describe "`roseflow-cli configure vectordb` command", type: :cli do
  it "executes `roseflow-cli configure help vectordb` command successfully" do
    output = `roseflow-cli configure help vectordb`
    expected_output = <<-OUT
Usage:
  roseflow-cli vectordb

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
