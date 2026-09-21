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

ActiveRecord::Schema[8.1].define(version: 2026_09_21_022208) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activity_logs", force: :cascade do |t|
    t.string "action", null: false
    t.integer "actor_id", null: false
    t.datetime "created_at", null: false
    t.integer "project_id", null: false
    t.integer "trackable_id"
    t.string "trackable_type"
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_activity_logs_on_actor_id"
    t.index ["project_id", "created_at"], name: "index_activity_logs_on_project_id_and_created_at"
    t.index ["project_id"], name: "index_activity_logs_on_project_id"
    t.index ["trackable_type", "trackable_id"], name: "index_activity_logs_on_trackable_type_and_trackable_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "author_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.integer "task_id", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_comments_on_author_id"
    t.index ["task_id"], name: "index_comments_on_task_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "action", null: false
    t.integer "actor_id"
    t.datetime "created_at", null: false
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.datetime "read_at"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["actor_id"], name: "index_notifications_on_actor_id"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["user_id", "read_at"], name: "index_notifications_on_user_id_and_read_at"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.integer "owner_id"
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_projects_on_owner_id"
  end

  create_table "projects_users", id: false, force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "user_id", null: false
    t.index ["project_id", "user_id"], name: "index_projects_users_unique", unique: true
  end

  create_table "requirements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "priority"
    t.integer "project_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_requirements_on_project_id"
  end

  create_table "subtasks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "done", default: false, null: false
    t.integer "position", default: 0, null: false
    t.integer "task_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id", "position"], name: "index_subtasks_on_task_id_and_position"
    t.index ["task_id"], name: "index_subtasks_on_task_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "color", default: "#0d6efd", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "project_id", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "name"], name: "index_tags_on_project_id_and_name", unique: true
    t.index ["project_id"], name: "index_tags_on_project_id"
  end

  create_table "task_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "tag_id", null: false
    t.integer "task_id", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_task_tags_on_tag_id"
    t.index ["task_id", "tag_id"], name: "index_task_tags_on_task_id_and_tag_id", unique: true
    t.index ["task_id"], name: "index_task_tags_on_task_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "assigned_to_id", null: false
    t.integer "author_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.date "due_date"
    t.integer "priority"
    t.integer "project_id", null: false
    t.integer "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_tasks_on_assigned_to_id"
    t.index ["author_id"], name: "index_tasks_on_author_id"
    t.index ["due_date"], name: "index_tasks_on_due_date"
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "api_token"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.index ["api_token"], name: "index_users_on_api_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activity_logs", "projects"
  add_foreign_key "activity_logs", "users", column: "actor_id"
  add_foreign_key "comments", "tasks"
  add_foreign_key "comments", "users", column: "author_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "notifications", "users", column: "actor_id"
  add_foreign_key "projects", "users", column: "owner_id"
  add_foreign_key "projects_users", "projects"
  add_foreign_key "projects_users", "users"
  add_foreign_key "requirements", "projects"
  add_foreign_key "subtasks", "tasks"
  add_foreign_key "tags", "projects"
  add_foreign_key "task_tags", "tags"
  add_foreign_key "task_tags", "tasks"
  add_foreign_key "tasks", "projects"
  add_foreign_key "tasks", "users", column: "assigned_to_id"
  add_foreign_key "tasks", "users", column: "author_id"
end
