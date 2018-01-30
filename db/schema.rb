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

ActiveRecord::Schema.define(version: 20171210114507) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "awards", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "awards_winners", id: false, force: :cascade do |t|
    t.bigint "movie_cast_id", null: false
    t.bigint "award_id", null: false
    t.index ["award_id"], name: "index_awards_winners_on_award_id"
    t.index ["movie_cast_id"], name: "index_awards_winners_on_movie_cast_id"
  end

  create_table "cast_members", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "age"
    t.decimal "popularity"
    t.datetime "date_of_birth"
    t.datetime "date_of_death"
    t.text "biography"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "followings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "follower_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres", force: :cascade do |t|
    t.string "Name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres_movies", id: false, force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.bigint "genre_id", null: false
    t.index ["genre_id"], name: "index_genres_movies_on_genre_id"
    t.index ["movie_id"], name: "index_genres_movies_on_movie_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movie_casts", force: :cascade do |t|
    t.bigint "movie_id"
    t.bigint "cast_member_id"
    t.bigint "job_id"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cast_member_id"], name: "index_movie_casts_on_cast_member_id"
    t.index ["job_id"], name: "index_movie_casts_on_job_id"
    t.index ["movie_id"], name: "index_movie_casts_on_movie_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "imdbID"
    t.string "imdbVotes"
    t.decimal "imdbRating"
    t.string "Title"
    t.string "Awards"
    t.string "Language"
    t.string "TagLine"
    t.date "ReleaseDate"
    t.string "Poster"
    t.boolean "Adult"
    t.decimal "Popularity"
    t.string "Actors"
    t.string "BoxOffice"
    t.string "Country"
    t.string "Director"
    t.decimal "Metascore"
    t.text "Plot"
    t.string "Runtime"
    t.string "Website"
    t.string "Writer"
    t.integer "Year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imdbID"], name: "index_movies_on_imdbID", unique: true
  end

  create_table "movies_tags", id: false, force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.bigint "tag_id", null: false
    t.index ["movie_id"], name: "index_movies_tags_on_movie_id"
    t.index ["tag_id"], name: "index_movies_tags_on_tag_id"
  end

  create_table "production_companies", force: :cascade do |t|
    t.string "company_name"
    t.text "description"
    t.string "headquarters"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.decimal "Rating"
    t.text "Review"
    t.bigint "user_id"
    t.bigint "movie_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_ratings_on_movie_id"
    t.index ["user_id", "movie_id"], name: "index_ratings_on_user_id_and_movie_id", unique: true
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "recommendations", force: :cascade do |t|
    t.integer "from_user_id"
    t.integer "to_user_id"
    t.bigint "movie_id"
    t.decimal "ExpectedRating"
    t.decimal "UserRating"
    t.string "Message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_recommendations_on_movie_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "FirstName"
    t.string "LastName"
    t.date "DateOfBirth"
    t.string "UserName", null: false
    t.string "Email", null: false
    t.string "password_digest"
    t.date "JoiningDate", default: -> { "now()" }, null: false
    t.string "bio"
    t.string "profilePic_url", default: "data:image/png;base64,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"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["Email"], name: "index_users_on_Email", unique: true
    t.index ["UserName"], name: "index_users_on_UserName", unique: true
  end

  create_table "watchlists", force: :cascade do |t|
    t.bigint "movie_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_watchlists_on_movie_id"
    t.index ["user_id"], name: "index_watchlists_on_user_id"
  end

end