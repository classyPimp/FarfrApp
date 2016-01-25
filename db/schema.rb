# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150422075245) do

  create_table "assignees", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "assignment_id"
    t.text     "text_report"
    t.text     "log"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "notified"
    t.datetime "visited"
    t.datetime "completed"
  end

  add_index "assignees", ["assignment_id"], name: "index_assignees_on_assignment_id"
  add_index "assignees", ["user_id"], name: "index_assignees_on_user_id"

  create_table "assignments", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "assignable_id"
    t.string   "assignable_type"
    t.string   "type"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.text     "assignment_details"
    t.string   "short_description"
    t.text     "log"
    t.datetime "deadline"
    t.datetime "completion_confirmed"
    t.string   "report_form"
  end

  add_index "assignments", ["assignable_id"], name: "index_assignments_on_assignable_id"
  add_index "assignments", ["assignable_type"], name: "index_assignments_on_assignable_type"
  add_index "assignments", ["parent_id"], name: "index_assignments_on_parent_id"
  add_index "assignments", ["user_id"], name: "index_assignments_on_user_id"

  create_table "attachments", force: :cascade do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "type"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.text     "description"
    t.text     "log"
  end

  add_index "attachments", ["attachable_id"], name: "index_attachments_on_attachable_id"
  add_index "attachments", ["attachable_type"], name: "index_attachments_on_attachable_type"
  add_index "attachments", ["type"], name: "index_attachments_on_type"

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.text     "log"
    t.string   "type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "parent_node"
    t.text     "body"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type"
  add_index "comments", ["parent_id"], name: "index_comments_on_parent_id"
  add_index "comments", ["type"], name: "index_comments_on_type"

  create_table "confirmation_statuses", force: :cascade do |t|
    t.integer  "confirmation_id"
    t.integer  "user_id"
    t.datetime "confirmed"
    t.datetime "notified"
    t.text     "log"
    t.string   "confirmators_note"
  end

  add_index "confirmation_statuses", ["confirmation_id"], name: "index_confirmation_statuses_on_confirmation_id"
  add_index "confirmation_statuses", ["user_id"], name: "index_confirmation_statuses_on_user_id"

  create_table "confirmations", force: :cascade do |t|
    t.integer  "confirmable_id"
    t.string   "confirmable_type"
    t.string   "type"
    t.integer  "initiator"
    t.string   "note"
    t.integer  "confirmed"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "subject"
  end

  add_index "confirmations", ["confirmable_type"], name: "index_confirmations_on_confirmable_type"
  add_index "confirmations", ["confirmed"], name: "index_confirmations_on_confirmed"
  add_index "confirmations", ["initiator"], name: "index_confirmations_on_initiator"
  add_index "confirmations", ["type"], name: "index_confirmations_on_type"

  create_table "contract_approvers", force: :cascade do |t|
    t.integer  "contract_id"
    t.integer  "user_id"
    t.datetime "approved"
    t.string   "notified"
    t.text     "log"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "approval_info"
    t.datetime "visited"
    t.boolean  "is_executor"
  end

  add_index "contract_approvers", ["contract_id"], name: "index_contract_approvers_on_contract_id"
  add_index "contract_approvers", ["user_id"], name: "index_contract_approvers_on_user_id"

  create_table "contract_attachments", force: :cascade do |t|
    t.integer  "contract_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "description"
    t.boolean  "is_final"
    t.boolean  "is_scan"
    t.boolean  "is_project"
  end

  add_index "contract_attachments", ["contract_id"], name: "index_contract_attachments_on_contract_id"

  create_table "contract_comments", force: :cascade do |t|
    t.integer  "contract_id"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.integer  "parent_node"
    t.string   "satisfied"
    t.string   "read"
    t.text     "log"
    t.text     "claims"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "body"
  end

  add_index "contract_comments", ["contract_id"], name: "index_contract_comments_on_contract_id"
  add_index "contract_comments", ["parent_id"], name: "index_contract_comments_on_parent_id"
  add_index "contract_comments", ["user_id"], name: "index_contract_comments_on_user_id"

  create_table "contract_contragents", force: :cascade do |t|
    t.integer  "contract_id"
    t.integer  "contragent_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "contract_contragents", ["contract_id"], name: "index_contract_contragents_on_contract_id"
  add_index "contract_contragents", ["contragent_id"], name: "index_contract_contragents_on_contragent_id"

  create_table "contracts", force: :cascade do |t|
    t.string   "number"
    t.string   "date"
    t.string   "subject"
    t.string   "short_description"
    t.integer  "parent_id"
    t.text     "log"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "approval_counter"
    t.datetime "approved"
    t.datetime "signed_by_company"
    t.datetime "sent_to_contragent"
    t.datetime "recieved_from_contragent"
    t.string   "kept_at"
  end

  add_index "contracts", ["parent_id"], name: "index_contracts_on_parent_id"

  create_table "contragent_profiles", force: :cascade do |t|
    t.string  "address"
    t.string  "director"
    t.string  "bank_account"
    t.string  "postal_address"
    t.string  "contacts"
    t.integer "contragent_id"
  end

  add_index "contragent_profiles", ["contragent_id"], name: "index_contragent_profiles_on_contragent_id"

  create_table "contragents", force: :cascade do |t|
    t.string   "corporate_form"
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "user_notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.string   "link"
    t.datetime "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_notifications", ["user_id"], name: "index_user_notifications_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "password_digest"
    t.string   "email"
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "remember_digest"
  end

end
