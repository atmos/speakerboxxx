class FixSlackTeamId < ActiveRecord::Migration[5.0]
  def change
    remove_column :slack_users, :slack_team_id

    add_column :slack_users, :team_id, :uuid, null: false
  end
end
