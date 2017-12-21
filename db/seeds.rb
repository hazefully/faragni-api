# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'
require 'rest-client'

CSV.foreach("lib/movies.csv", :headers => true, :col_sep => "\t") do |row|
  imdb_id = row.to_hash["imdbId"]
  
  imdb_id = imdb_id.rjust(7, "0")
  next if Movie.where(imdbID: "tt#{imdb_id}").present?
  begin
    imdb_movie = {}
    begin
      imdb_movie = RestClient::Request.execute(:method => :get, :url => "https://www.omdbapi.com/?i=tt#{imdb_id}&apikey=f51215f6", :timeout => 5) 
    rescue RestClient::Unauthorized
      imdb_movie = RestClient::Request.execute(:method => :get, :url => "https://www.omdbapi.com/?i=tt#{imdb_id}&apikey=76dc84ae", :timeout => 5)     
    else
      begin
        imdb_movie = RestClient::Request.execute(:method => :get, :url => "https://www.omdbapi.com/?i=tt#{imdb_id}&apikey=76dc84ae", :timeout => 8)     
      rescue => exception
        imdb_movie = RestClient::Request.execute(:method => :get, :url => "https://www.omdbapi.com/?i=tt#{imdb_id}&apikey=1fff86fb", :timeout => 12)             
      end
    end
    movie_json = JSON.parse(imdb_movie.body)
    movie_json =  Hash[movie_json.map{|(k,v)| [k.to_sym,v]}]
    [:Response, :DVD, :Production, :Type, :Rated, :Ratings].each do |key|
      movie_json.delete key
    end
    movie_json[:genres] = Genre.get_genres_from_string(movie_json[:Genre])
    movie_json.delete :Genre
    movie_json[:ReleaseDate] = Time.parse(movie_json[:Released])
    # image = RestClient.get(movie_json[:Poster])
    # movie_json[:poster_base] = "data:#{image.headers[:content_type]};base64,#{Base64.strict_encode64(image.body)}"
    movie_json.delete :Released
    new_movie = Movie.new(movie_json)
    new_movie.Poster = movie_json[:Poster];
    new_movie.save
    puts "saved movie #{imdb_id}"
  rescue => exception
    puts "skipping movie #{imdb_id}"
  end

end


