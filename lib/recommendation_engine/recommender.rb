module RecommendationEngine
  class Recommender
    # Machine learning magic!
    def self.recommend user
      rated_movies_ids = user.ratings.select{|rating| rating.Rating >= 3}.pluck(:id)
      rated_movies_imdb_ids = Movie.find(rated_movies_ids).pluck(:imdbID).join(" ")
      movies_ids = `cd lib/recommendation_engine && python final_rbm_model.py #{rated_movies_imdb_ids}`
      byebug
      movies_ids = movies_ids.chomp("\n").split(" ").map{|id| "tt#{id.rjust(7,"0")}"}
      return Movie.where(imdbID: movies_ids)
    end
  end
end