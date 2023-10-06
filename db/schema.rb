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

ActiveRecord::Schema[7.0].define(version: 2023_01_09_011933) do
  create_table "actions", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "user_id"
    t.string "request_type"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["request_type"], name: "index_actions_on_request_type"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "amendments", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "referral_id"
    t.text "text"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "sponsor_id"
    t.integer "number"
  end

  create_table "authorization_codes", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "chamber_id"
    t.string "chamber_role_type"
    t.string "code"
    t.boolean "active"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "ballots", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "preference"
    t.integer "vote_id"
    t.integer "chamber_role_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["chamber_role_id", "vote_id"], name: "chamber_role_id_and_vote_it", unique: true
  end

  create_table "calendar_referrals", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "calendar_id"
    t.integer "referral_id"
    t.integer "position"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "calendars", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "group_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "chamber_roles", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "chamber_id"
    t.integer "user_id"
    t.string "type"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "first_name"
    t.string "last_name"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at", precision: nil
  end

  create_table "chamber_settings", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "chamber_id"
    t.string "name"
    t.string "value"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "chambers", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.integer "course_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "scenerio", default: "us_house_of_representatives"
  end

  create_table "comments", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "discussion_id"
    t.integer "chamber_role_id"
    t.text "content"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "constituencies", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.string "map_url"
    t.integer "vote_weight"
    t.integer "chamber_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "contents", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "reference"
    t.text "copy"
    t.integer "chamber_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "altered", default: false
  end

  create_table "cosponsorships", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "legislation_id"
    t.integer "chamber_role_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "courses", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.integer "institution_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "start_at", precision: nil
    t.datetime "finish_at", precision: nil
    t.datetime "archive_at", precision: nil
    t.string "status"
    t.string "email"
    t.string "time_zone"
    t.string "payment_option", default: "prepaid"
  end

  create_table "discussions", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "group_id"
    t.string "name"
    t.boolean "open"
    t.boolean "private"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "creator_id"
    t.integer "referral_id"
    t.integer "last_comment_id"
    t.datetime "last_comment_at", precision: nil
    t.integer "comments_count"
  end

  create_table "examples", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "executive_profiles", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "executive_id"
    t.text "personal_statement"
    t.text "priorities"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "filibusters", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "motion_id"
    t.integer "chamber_role_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "group_leaders", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "chamber_role_id"
    t.integer "group_id"
    t.string "title"
    t.boolean "primary"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "group_membership_requests", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "group_id"
    t.integer "chamber_role_id"
    t.integer "rank"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "group_memberships", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "group_id"
    t.integer "chamber_role_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "group_settings", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "group_id"
    t.string "name"
    t.string "value"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "groups", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.string "type"
    t.text "jurisdiction_description"
    t.text "issue_description"
    t.integer "chamber_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "private_announcement"
    t.text "public_announcement"
  end

  create_table "holds", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "referral_id"
    t.integer "chamber_role_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "institutions", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "instructions", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "summary"
    t.integer "position"
    t.integer "chamber_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "leadership_nominations", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "chamber_id"
    t.integer "chamber_role_id"
    t.integer "endorsements"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "legislation", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.integer "number"
    t.integer "legislative_type_id"
    t.integer "submission_text_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "status"
    t.string "sponsor_id"
  end

  create_table "legislation_relationships", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "actor_id"
    t.integer "target_id"
    t.string "relation"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "legislative_texts", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.text "primary_text"
    t.text "secondary_text"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "legislative_types", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.integer "chamber_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "description"
  end

  create_table "letter_group_recipients", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "letter_id"
    t.integer "group_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "letter_meta_group_recipients", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "letter_id"
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "letter_user_recipients", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "letter_id"
    t.integer "chamber_role_id"
    t.integer "letter_group_recipient_id"
    t.integer "letter_meta_group_recipient_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "blind", default: false
  end

  create_table "letters", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "subject"
    t.text "message"
    t.integer "chamber_role_id"
    t.boolean "notified"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "chamber_id"
  end

  create_table "member_profiles", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "member_id"
    t.text "personal_statement"
    t.integer "constituency_id"
    t.text "constituency_description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "motions", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "action"
    t.text "text"
    t.integer "referral_id"
    t.integer "chamber_role_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "limited_debate", default: false
  end

  create_table "payments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "user_id"
    t.string "payment_type"
    t.integer "amount"
    t.datetime "processed_at", precision: nil
    t.string "transaction_id"
    t.string "approval_code"
    t.string "status"
    t.string "cc_number"
    t.boolean "test"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "details"
  end

  create_table "profiles", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "chamber_role_id"
    t.text "statement"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "referrals", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "legislation_id"
    t.integer "group_id"
    t.integer "referrer_id"
    t.integer "referred_text_id"
    t.string "status"
    t.integer "reading"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "priority"
  end

  create_table "reports", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "referral_id"
    t.integer "reported_text_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "status", default: "published"
  end

  create_table "survey_answers", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "chamber_role_id"
    t.integer "survey_question_id"
    t.integer "answer"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "survey_questions", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "chamber_id"
    t.text "question"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "system_users", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "legacy_login", limit: 40
    t.string "first_name", limit: 100, default: ""
    t.string "last_name", limit: 100, default: ""
    t.string "email", limit: 100
    t.string "legacy_crypted_password", limit: 40
    t.string "legacy_salt", limit: 40
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "legacy_remember_token", limit: 40
    t.datetime "legacy_remember_token_expires_at", precision: nil
    t.string "activation_code", limit: 40
    t.datetime "activated_at", precision: nil
    t.string "state", default: "passive"
    t.datetime "deleted_at", precision: nil
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_system_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_system_users_on_reset_password_token", unique: true
  end

  create_table "tutorials", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "summary"
    t.integer "position"
    t.integer "chamber_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "users", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "legacy_login", limit: 40
    t.string "first_name", limit: 100, default: ""
    t.string "last_name", limit: 100, default: ""
    t.string "email", limit: 100
    t.integer "course_id"
    t.integer "last_chamber_id"
    t.string "legacy_crypted_password", limit: 40
    t.string "legacy_salt", limit: 40
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "legacy_remember_token", limit: 40
    t.datetime "legacy_remember_token_expires_at", precision: nil
    t.string "activation_code", limit: 40
    t.datetime "activated_at", precision: nil
    t.string "state", default: "passive"
    t.datetime "deleted_at", precision: nil
    t.string "legacy_password_reset_code", limit: 40
    t.boolean "agreement", default: false
    t.string "payment_token"
    t.string "payment_ref"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email", "course_id"], name: "index_users_on_email_and_course_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "outcome"
    t.string "status"
    t.datetime "start_at", precision: nil
    t.datetime "finish_at", precision: nil
    t.integer "threshold"
    t.integer "motion_id"
    t.integer "yes_cache", default: 0
    t.integer "no_cache", default: 0
    t.integer "present_cache", default: 0
    t.boolean "absolute"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "record_type"
    t.datetime "held_at", precision: nil
    t.integer "group_id"
    t.integer "chamber_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
