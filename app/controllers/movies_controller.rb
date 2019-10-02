class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params.key?(:sort)
      sortMovies(params[:sort])
    elsif params.key?(:ratings)
      selectRatings(params[:ratings])
    else
      @movies = Movie.all
    end
    listRating
  end
  

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def listRating
    @all_ratings = Movie.uniq.pluck(:rating)
  end
  
  def sortMovies(sortCol)
    if sortCol == "title" 
      @movies = Movie.order(:title)
    elsif sortCol == "date"
      @movies = Movie.order(:release_date)
    end
  end
  
  def selectRatings(ratingHash)
    @movies = Movie.with_ratings(ratingHash.keys)
  end
end
