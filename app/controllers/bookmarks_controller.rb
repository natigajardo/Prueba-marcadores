class BookmarksController < ApplicationController
  before_action :set_bookmark, only: [:show, :edit, :update, :destroy]

  # GET /bookmarks
  # GET /bookmarks.json
  def index
    @bookmarks = Bookmark.all
    @bookmark = Bookmark.new
  end

  # GET /bookmarks/1
  # GET /bookmarks/1.json
  def show
  end

  # GET /bookmarks/new
  def new
    @bookmark = Bookmark.new
  end

  # GET /bookmarks/1/edit
  def edit
  end

  def getBookmarksByCategory
    current_category = Category.where(name: params[:category]).first

    json = { "bookmarks" => []}

    cat_parent = { current_category.name => []}
    json["bookmarks"].push(cat_parent)

    if current_category.bookmarks.count > 0 
      json["bookmarks"][0][current_category.name].push(current_category.bookmarks.pluck(:bookmark_url))
    end 

    current_category.children.each do |child|
      arr_bookmarks = child.bookmarks.pluck(:bookmark_url)
      json_bookmarks = {child.name => arr_bookmarks}
      json["bookmarks"][0][current_category.name].push(json_bookmarks)
    end 

    render json: json 
  end

  # POST /bookmarks
  # POST /bookmarks.json
  def create
    @bookmark = Bookmark.new(bookmark_params)

    respond_to do |format|
      if @bookmark.save
        @bookmarks = Bookmark.all
        format.html { redirect_to @bookmark, notice: 'Bookmark was successfully created.' }
        format.json { render :show, status: :created, location: @bookmark }
        format.js
      else
        format.html { render :new }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /bookmarks/1
  # PATCH/PUT /bookmarks/1.json
  def update
    respond_to do |format|
      if @bookmark.update(bookmark_params)
        format.html { redirect_to @bookmark, notice: 'Bookmark was successfully updated.' }
        format.json { render :show, status: :ok, location: @bookmark }
      else
        format.html { render :edit }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/1
  # DELETE /bookmarks/1.json
  def destroy
    @bookmark.destroy
    respond_to do |format|
      format.html { redirect_to bookmarks_url, notice: 'Bookmark was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bookmark_params
      params.require(:bookmark).permit(:name, :bookmark_url, :kind_id, :category_id)
    end
end
