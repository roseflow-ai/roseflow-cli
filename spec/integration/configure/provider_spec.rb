RSpec.describe "`roseflow configure provider` command", type: :cli do
  it "executes `roseflow configure help provider` command successfully" do
    output = `roseflow configure help provider`
    expected_output = <<-OUT
Usage:
  roseflow configure provider

Options:
  -h, [--help], [--no-help]  # Display usage information

Configure an AI provider for Roseflow
    OUT

    expect(output).to eq(expected_output)
  end
end
