# frozen_string_literal: true

RSpec.describe "`roseflow configure` command", type: :cli do
  it "displays usage information" do
    command = "roseflow configure --help"

    out, err, status = Open3.capture3(command)

    puts out
    expect(err).to eq("")
    expect(status.exitstatus).to eq(0)
  end
end
