class Api::VotesController < ApplicationController
  before_filter :set_current_user, only: [:create, :update, :destroy]
  before_filter :set_vote, only: [:show, :update, :destroy]

  respond_to :json

  def index
    render json: Vote.all
  end

  def show
    render json: @vote
  end

  def create
    if @user
      new_vote = Vote.new({
        vote: vote_params[:attributes][:vote],
        topic_id: vote_params[:relationships][:topic][:data][:id],
        user_id: @user.id
      })

      if new_vote.save!
        render json: new_vote
      else
        render json: new_vote.errors
      end
    else
      head 500
    end
  end

  def update
    if valid_user
      attrs = {
        vote: vote_params[:attributes][:vote]
      }

      if @vote.update(attrs)
        render json: @vote
      else
        render json: @vote.errors
      end
    else
      head 500
    end
  end

  def destroy
    if valid_user
      render json: @vote.destroy
    else
      head 500
    end
  end

  private

  def vote_params
    params.require(:data).permit({ attributes: [:vote], relationships: [topic: [data: [:id]]] })
  end

  def set_current_user
    @user = User.where(token: params[:data][:token]).first
  end

  def set_vote
    @vote = Vote.find(params[:id])
  end

  def valid_user
    @user && (@vote.user == @user)
  end
end
