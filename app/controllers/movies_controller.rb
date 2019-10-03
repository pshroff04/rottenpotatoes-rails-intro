class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort)
  end
  
  #movie_path(:id) -> hits here
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  #movies_path -> hit index
  def index
    #print params
    
    if !params.key?(:sort) and session.key?(:sort)
      params[:sort] = session[:sort]
    end
    if !params.key?(:ratings) and session.key?(:ratings)
      params[:ratings] = session[:ratings]
    end
    
    
    if params.key?(:sort) and params.key?(:ratings)
      selectRatingsWithSort(params[:sort], params[:ratings])
    
    elsif params.key?(:sort) 
      sortMovies(params[:sort])
    
    elsif params.key?(:ratings)
      selectRatings(params[:ratings])
    
    else
      @movies = Movie.all
    end
    #update the session
    if params.key?(:ratings); session[:ratings] = params[:ratings] end
    if params.key?(:sort); session[:sort] = params[:sort] end
    listRating
  end
  

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    flash.keep
    redirect_to movies_path, session[:sort]
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
    @movies = Movie.order(sortCol)
  end
  
  def selectRatings(ratingHash)
    @movies = Movie.with_ratings(ratingHash.keys)
  end
  
  def selectRatingsWithSort(sortCol, ratingHash)
    @movies = Movie.with_ratings(ratingHash.keys).order(sortCol)
  end
end
