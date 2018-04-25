class Api::ForumsController < ApplicationController
  before_filter :set_current_user, only: [:create, :update, :destroy]
  before_filter :set_forum, only: [:show, :update, :destroy]

  respond_to :json

  def index
    render json: Forum.all
  end

  def show
    render json: @forum
  end

  def create
    if @user && @user.admin?
      new_forum = Forum.new({
        name: forum_params[:attributes][:name],
        user_id: @user.id
      })

      if new_forum.save!
        render json: new_forum
      else
        render json: new_forum.errors
      end
    else
      head 500
    end
  end

  def update
    if @user && @user.admin?
      attrs = {
        name: forum_params[:attributes][:name]
      }

      if @forum.update(attrs)
        render json: @forum
      else
        render json: @forum.errors
      end
    else
      head 500
    end
  end

  def destroy
    if @user && @user.admin?
      render json: @forum.destroy
    else
      head 500
    end
  end

  private

  def set_forum
    @forum = Forum.find(params[:id])
  end

  def set_current_user
    @user = User.where(token: params[:data][:token]).first
  end

  def forum_params
    params.require(:data).permit({ attributes: [:name] })
  end
end
