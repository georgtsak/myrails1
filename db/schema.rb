# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_22_090200) do
  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer "creator_id", null: false
    t.integer "recepient_id", null: false
    t.string "value"
    t.datetime "createdon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_messages_on_creator_id"
    t.index ["recepient_id"], name: "index_messages_on_recepient_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.datetime "createdon"
    t.integer "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_posts_on_creator_id"
  end

  create_table "posts_categories", force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_posts_categories_on_category_id"
    t.index ["post_id"], name: "index_posts_categories_on_post_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_friends", force: :cascade do |t|
    t.integer "initiator_id", null: false
    t.integer "recepient_id", null: false
    t.datetime "createdon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["initiator_id"], name: "index_users_friends_on_initiator_id"
    t.index ["recepient_id"], name: "index_users_friends_on_recepient_id"
  end

  create_table "users_requests", force: :cascade do |t|
    t.integer "initiator_id", null: false
    t.integer "recepient_id", null: false
    t.datetime "createdon"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["initiator_id"], name: "index_users_requests_on_initiator_id"
    t.index ["recepient_id"], name: "index_users_requests_on_recepient_id"
  end

  add_foreign_key "messages", "creators"
  add_foreign_key "messages", "recepients"
  add_foreign_key "posts", "creators"
  add_foreign_key "posts_categories", "categories"
  add_foreign_key "posts_categories", "posts"
  add_foreign_key "users_friends", "initiators"
  add_foreign_key "users_friends", "recepients"
  add_foreign_key "users_requests", "initiators"
  add_foreign_key "users_requests", "recepients"
end
