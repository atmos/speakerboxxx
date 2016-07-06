class CreateCommands < ActiveRecord::Migration[5.0]
  def change
    create_table :commands, id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
      t.string   "args"
      t.string   "application"
      t.string   "channel_id",    null: false
      t.string   "channel_name",  null: false
      t.string   "command",       null: false
      t.string   "command_text"
      t.string   "response_url",  null: false
      t.string   "subtask"
      t.string   "slack_user_id"
      t.string   "task"
      t.string   "team_id",       null: false
      t.string   "team_domain",   null: false
      t.uuid     "user_id"
      t.datetime "processed_at"
      t.timestamps
    end
  end
end
