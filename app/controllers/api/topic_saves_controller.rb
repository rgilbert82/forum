class Api::TopicSavesController < ApplicationController
  before_filter :set_current_user, only: [:create, :update, :destroy]
  before_filter :set_topic_saves, only: [:show, :update, :destroy]

  respond_to :json

  def index
    render json: TopicSave.all
  end

  def show
    render json: @topic_save
  end

  def create
    if @user
      new_save = TopicSave.new({
        topic_id: topic_save_params[:relationships][:topic][:data][:id],
        user_id: @user.id
      })

      if new_save.save!
        render json: new_save
      else
        render json: new_save.errors
      end
    else
      head 500
    end
  end

  def update
  end

  def destroy
    if valid_user
      render json: @topic_save.destroy
    else
      head 500
    end
  end

  private

  def topic_save_params
    params.require(:data).permit({ attributes: [], relationships: [topic: [data: [:id]]] })
  end

  def set_current_user
    @user = User.where(token: params[:data][:token]).first
  end

  def set_topic_saves
    @topic_save = TopicSave.find(params[:id])
  end

  def valid_user
    @user && (@topic_save.user == @user)
  end
end
