ActiveRecord::Schema[8.1].define(version: 2025_10_22_132932) do
  enable_extension "pg_catalog.plpgsql"

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
  end
end
