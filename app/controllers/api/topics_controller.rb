class Api::TopicsController < ApplicationController
  before_filter :set_current_user, only: [:create, :update, :destroy]
  before_filter :set_topic, only: [:show, :update, :destroy]

  respond_to :json

  def index
    render json: Topic.all
  end

  def show
    render json: @topic
  end

  def create
    if @user
      new_topic = Topic.new({
        title: topic_params[:attributes][:title],
        body: topic_params[:attributes][:body],
        forum_id: topic_params[:relationships][:forum][:data][:id],
        user_id: @user.id
      })

      if new_topic.save!
        render json: new_topic
      else
        render json: new_topic.errors
      end
    else
      head 500
    end
  end

  def update
    if valid_user
      attrs = {
        title: topic_params[:attributes][:title],
        body: topic_params[:attributes][:body],
      }

      if @topic.update(attrs)
        render json: @topic
      else
        render json: @topic.errors
      end
    else
      head 500
    end
  end

  def destroy
    if valid_user
      render json: @topic.destroy
    else
      head 500
    end
  end

  private

  def topic_params
    params.require(:data).permit({ attributes: [:title, :body], relationships: [forum: [data: [:id]]] })
  end

  def valid_user
    @user && (@topic.user == @user || @user.admin?)
  end

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def set_current_user
    @user = User.where(token: params[:data][:token]).first
  end
end
