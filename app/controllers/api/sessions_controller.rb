class Api::SessionsController < ApplicationController
  before_filter :set_user, only: [:show, :destroy]
  respond_to :json

  def show
    if @user
      render json: @user, serializer: SessionSerializer
    else
      render json: {}
    end
  end

  def create
    @user = User.find_by(username: params[:data][:attributes][:username])

    if @user && @user.authenticate(params[:data][:attributes][:password])
      render json: @user, serializer: SessionSerializer
    else
      render json: @user.errors
    end
  end

  def destroy
    @user.regenerate_token! if @user
    head :no_content
  end

  private

  def set_user
    @user = User.where(token: params[:id]).first
  end
end
