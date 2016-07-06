class CreateGitHubOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :git_hub_organizations, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string   "name"
      t.string   "enc_webhook_secret"
      t.string   "default_room", default: "#general"
      t.string   "webhook_id"
      t.uuid     "team_id"
      t.timestamps
    end

    create_table :git_hub_repositories, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string   "name"
      t.string   "default_room", default: "#general"
      t.uuid     "organization_id"
      t.timestamps
    end
  end
end
