namespace :db do
  desc "Reset the database to a fresh state"
  task delete_all_records: :environment do
    Command.destroy_all
    GitHub::Organization.destroy_all
    GitHub::Repository.destroy_all
    SlackHQ::Team.destroy_all
    SlackHQ::User.destroy_all
  end
end
