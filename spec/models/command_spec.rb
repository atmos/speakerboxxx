require "rails_helper"

RSpec.describe Command, type: :model do
  let(:user) { create_atmos }
  it "creates a command" do
    expect do
      command = user.create_command_for(command_params_for("help"))

      expect(command.task).to eql("help")
      expect(command.subtask).to eql("default")
      expect(command.application).to eql(nil)
    end.to change { Command.count }.from(0).to(1)
  end
end
