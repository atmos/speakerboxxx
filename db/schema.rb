# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160613174641) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "commands", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "git_hub_organizations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name"
    t.string   "enc_webhook_secret"
    t.string   "default_room",       default: "#general"
    t.string   "webhook_id"
    t.uuid     "team_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "git_hub_repositories", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name"
    t.string   "default_room",    default: "#general"
    t.uuid     "organization_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "slack_teams", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "team_id",       null: false
    t.string   "team_domain"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "bot_user_id"
    t.string   "enc_bot_token"
  end

  create_table "slack_users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "slack_user_id",    null: false
    t.string   "slack_user_name",  null: false
    t.string   "github_id"
    t.string   "github_login"
    t.string   "enc_github_token"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.uuid     "team_id",          null: false
  end

end
