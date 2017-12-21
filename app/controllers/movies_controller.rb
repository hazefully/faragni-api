
class MoviesController < ApplicationController

  before_action :set_movie, only: [:show, :update, :destroy]
  before_action :set_single_user, only: :index
  skip_before_action :authenticate_user, only: [:index, :show]
  
  # GET /movies
  def index
    if @single_user.present?
      @movies = @single_user.watchlist
    else
      @movies = params[:genre].present?? Genre.where(Name: params[:genre]).first.movies.limit(100) : Movie.limit(100)
      if(params[:criteria].present?)
        @movies = @movies.order(params[:criteria].to_sym).limit(100)
      else
        @movies = @movies.limit(100).all
      end
    end
    render json: @movies.to_json(:except => :id, :methods => [:Poster, :Genre, :MovieID])
  end

  # GET /movies/1
  def show
    render json: @movie.to_json(:except => :id, :methods => [:Poster, :Genre, :MovieID])
  end

  # POST /movies
  def create
    @movie = Movie.new(create_movie_params)

    if @movie.save
      render json: @movie.to_json(:except => :id, :methods => [:Poster, :Genre, :MovieID])
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /movies/1
  def update
    if @movie.update(movie_params)
      render json: @movie.to_json(:except => :id, :methods => [:Poster, :Genre, :MovieID])
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  # DELETE /movies/1
  def destroy
    @movie.destroy
  end

  #GET /user/get_new_recommendations
  # not implemented yet, this should call the training model
  def get_new_recommendations
    user = current_user
    @recommended_movies = recommend(user)
    render json: @recommended_movies.to_json(:except => :id, :methods => [:Poster, :Genre, :MovieID])
  end



  #GET /user/rated_movies
  # not implemented yet, this should call the training model
  def get_rated_movies
    user = current_user
    @rated_movies = user.rated_movies
    render json: @rated_movies.to_json(:except => :id, :methods => [:Poster, :Genre, :MovieID])
  end
  # GET /movies/:movie_id/add_to_watchlist
  def add_to_watchlist
    if current_user.add_to_watchlist(params[:movie_id])
      render json: current_user.watchlist.to_json(:except => :id, :methods => [:Poster, :Genre, :MovieID])
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  # GET /movies/:movie_id/remove_from_watchlist
  def remove_from_watchlist
    if current_user.remove_from_watchlist(params[:movie_id])
      render json: current_user.watchlist.to_json(:methods => [:Poster, :Genre])
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    def recommend user
      rated_movies_ids = user.ratings.select{|rating| rating.Rating >= 3}.pluck(:id)
      rated_movies_imdb_ids = Movie.find(rated_movies_ids).pluck(:imdbID).join(" ")
      movies_ids = `cd lib/recommendation_engine && python final_rbm_model.py #{rated_movies_imdb_ids}`
      movies_ids = movies_ids.chomp("\n").split(" ").map{|id| "tt#{id.rjust(7,"0")}"}
      return Movie.where(imdbID: movies_ids)
    end

    def set_single_user
      if(request.url["watchlist"].present?)
        @single_user = current_user
      else
        @single_user = nil
      end
    end

    # Only allow a trusted parameter "white list" through.
    def create_movie_params
      p = movie_params
      p.delete :ProductionCompany
      return p
    end
    
    def movie_params
      p = params.permit(:imdbID, :imdbVotes, :imdbRating, :Title, :Language, :TagLine, :ReleaseDate, :Poster, :Popularity, :Actors, :BoxOffice, :Country, :Genre, :Director, :Metascore, :Plot, :Runtime, :Website, :Writer, :Year, :ProductionCompany, :criteria)
      p[:Genre] = Genre.get_genres_from_string(p[:Genre])
      p.delete :Genre
      p.delete :ProductionCompany
      return p
    end
end
