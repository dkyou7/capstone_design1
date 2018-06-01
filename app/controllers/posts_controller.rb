class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index, :show]
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.order(created_at: :desc)
  end

  # def action
  #     target_string = params[:스트링]
  #     result = Digest::SHA256.hexdigest target_string
  #     #이렇게 되면 타겟 스트링이 암호화됨
  # end


  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    authorize_action_for @post
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    require 'digest'
    @post.hashstring = Digest::SHA256.hexdigest @post.content
    @post.user = current_user 
    @post.save
    if @post.save
       
    else
       render "new"
    end

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
            
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    authorize_action_for @post
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    authorize_action_for @post
    @post = Post.find(params[:id])
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:name, :attachment,:title, :content, :user_id,:image,:hashstring)
    end
end
