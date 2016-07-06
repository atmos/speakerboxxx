class FixBotTokens < ActiveRecord::Migration[5.0]
  def change
    remove_column :slack_teams, :enc_bot_token

    add_column :slack_teams, :bot_user_id, :string, null: true
    add_column :slack_teams, :enc_bot_token, :string, null: true
  end
end
