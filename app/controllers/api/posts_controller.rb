class Api::PostsController < ApplicationController
  before_filter :set_current_user, only: [:create, :update]
  before_filter :set_post, only: [:show, :update]

  respond_to :json

  def index
    render json: Post.all
  end

  def show
    render json: @post
  end

  def create
    topic_id = post_params[:relationships][:topic] ? post_params[:relationships][:topic][:data][:id] : nil
    parent_id = post_params[:relationships][:parent] ? post_params[:relationships][:parent][:data][:id] : nil

    if @user
      new_post = Post.new({
        body: post_params[:attributes][:body],
        topic_id: topic_id,
        parent_id: parent_id,
        user_id: @user.id
      })

      if new_post.save!
        render json: new_post
      else
        render json: new_post.errors
      end
    else
      head 500
    end
  end

  def update
    if valid_user
      attrs = {
        body: post_params[:attributes][:body],
        editable: post_params[:attributes][:editable],
      }

      if @post.update(attrs)
        render json: @post
      else
        render json: @post.errors
      end
    else
      head 500
    end
  end

  def destroy
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def set_current_user
    @user = User.where(token: params[:data][:token]).first
  end

  def valid_user
    @user && (@post.user == @user || @user.admin?)
  end

  def post_params
    params.require(:data).permit({ attributes: [:body, :editable], relationships: [topic: [data: [:id]], parent: [data: [:id]]]})
  end
end
