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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100519110935) do

  create_table "card_images", :force => true do |t|
    t.integer "card_id"
    t.string  "file"
    t.string  "locale",  :default => "pl"
  end

  create_table "card_properties", :force => true do |t|
    t.integer "card_id"
    t.string  "name"
    t.string  "value"
  end

  add_index "card_properties", ["card_id", "name"], :name => "index_card_properties_on_card_id_and_name", :unique => true

  create_table "cards", :force => true do |t|
    t.string  "name"
    t.string  "type"
    t.integer "min_players", :default => 0
    t.integer "age"
    t.text    "description"
    t.integer "variant_id",  :default => 2
  end

  create_table "email_logs", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "email_template_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
  end

  create_table "email_queue", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "email_template_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "activate_at"
    t.datetime "created_at"
  end

  create_table "email_templates", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "email_templates", ["name"], :name => "index_email_templates_on_name", :unique => true

  create_table "game_cards", :force => true do |t|
    t.integer "game_id"
    t.integer "card_id"
    t.integer "player_id"
    t.string  "type"
    t.integer "yellow_tokens", :default => 0,     :null => false
    t.integer "blue_tokens",   :default => 0,     :null => false
    t.integer "position"
    t.boolean "active",        :default => false
  end

  add_index "game_cards", ["game_id", "card_id"], :name => "index_game_cards_on_game_id_and_card_id", :unique => true
  add_index "game_cards", ["player_id"], :name => "index_game_cards_on_player_id"
  add_index "game_cards", ["type"], :name => "index_game_cards_on_type"

  create_table "game_events", :force => true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.text     "description"
    t.datetime "created_at"
  end

  add_index "game_events", ["game_id"], :name => "index_game_events_on_game_id"
  add_index "game_events", ["user_id"], :name => "index_game_events_on_user_id"

  create_table "games", :force => true do |t|
    t.integer  "user_id"
    t.integer  "current_action_id"
    t.integer  "current_player_position"
    t.integer  "active_player_position"
    t.integer  "status",                  :default => 1
    t.integer  "round",                   :default => 0
    t.integer  "phase"
    t.integer  "age",                     :default => 0
    t.integer  "max_players",             :default => 4
    t.integer  "max_time",                :default => 0
    t.string   "type",                    :default => "Game::Civilization::Full"
    t.string   "description"
    t.string   "password"
    t.boolean  "ranking",                 :default => true
    t.integer  "lock_version",            :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["current_action_id"], :name => "index_games_on_current_player_id"
  add_index "games", ["user_id"], :name => "index_games_on_user_id"

  create_table "games_variants", :id => false, :force => true do |t|
    t.integer "game_id"
    t.integer "variant_id"
  end

  add_index "games_variants", ["game_id", "variant_id"], :name => "index_games_variants_on_game_id_and_variant_id", :unique => true

  create_table "group_privileges", :force => true do |t|
    t.integer "group_id"
    t.integer "privilege"
  end

  add_index "group_privileges", ["group_id", "privilege"], :name => "group_privilege", :unique => true

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "position",   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  add_index "groups_users", ["group_id", "user_id"], :name => "user_group", :unique => true

  create_table "player_actions", :force => true do |t|
    t.integer  "player_id"
    t.integer  "round"
    t.string   "type"
    t.integer  "actions"
    t.integer  "game_card_id"
    t.integer  "target_card_id"
    t.datetime "created_at"
  end

  add_index "player_actions", ["player_id", "round"], :name => "index_player_actions_on_player_id_and_round"

  create_table "players", :force => true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.integer  "position"
    t.integer  "color",          :default => 0
    t.integer  "free_workers",   :default => 1
    t.integer  "yellow_tokens",  :default => 25
    t.integer  "blue_tokens",    :default => 18
    t.integer  "points_culture", :default => 0
    t.integer  "points_science", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["game_id", "position"], :name => "game_position", :unique => true
  add_index "players", ["game_id", "user_id"], :name => "game_user", :unique => true

  create_table "profiles", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.text     "description"
    t.string   "remote_addr"
    t.string   "remote_host"
    t.integer  "updated_by"
    t.string   "locale",      :default => "pl"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_variables", :force => true do |t|
    t.string  "name"
    t.string  "label"
    t.integer "type"
    t.integer "report_id"
  end

  add_index "report_variables", ["report_id", "name"], :name => "index_report_variables_on_report_id_and_name", :unique => true

  create_table "reports", :force => true do |t|
    t.string   "name"
    t.string   "section"
    t.text     "description"
    t.text     "sql"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reports", ["name"], :name => "index_reports_on_name", :unique => true

  create_table "user_properties", :force => true do |t|
    t.integer "user_id"
    t.string  "name",    :limit => 20
    t.text    "value"
  end

  add_index "user_properties", ["user_id", "name"], :name => "index_user_properties_on_user_id_and_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "crypted_password", :limit => 40
    t.string   "salt",             :limit => 40
    t.integer  "profile_id"
    t.boolean  "active",                         :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["profile_id"], :name => "index_users_on_profile_id"

  create_table "variants", :force => true do |t|
    t.string "name"
  end

end
