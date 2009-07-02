class SearchesController < ApplicationController

  def index
    raise(SecurityError) unless(current_user.admin?)
    @searches = Search.find(:all)
  end

  def show
    @search = Search.find_or_initialize_by_id(params[:id])
  end

  def edit; end

  def create
    # existing search-term; desperate attempt to limit inevitable table growth
    returning Search.find_by_body(params[:search][:body]) do |search|
      !search.nil? && redirect_to(search) and return
    end

    # TODO: scoping
    @search = Search.new(params[:search])
    @search.author = current_user.login
    if(@search.save)
      redirect_to(search_path(@search))
    else
      flash[:error] = t(:no_search_terms)
      redirect_to(root_path)
    end
  end

  def update; end
  def destroy; end
end
