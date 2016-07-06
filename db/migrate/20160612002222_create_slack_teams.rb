class CreateSlackTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :slack_teams, id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
      t.string "enc_bot_token", null: false
      t.string "team_id",       null: false
      t.string "team_domain"
      t.timestamps
    end

    create_table :slack_users, id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
      t.string   "slack_user_id",   null: false
      t.string   "slack_user_name", null: false
      t.string   "slack_team_id",   null: false
      t.string   "github_id"
      t.string   "github_login"
      t.string   "enc_github_token"
      t.timestamps
    end
  end
end
