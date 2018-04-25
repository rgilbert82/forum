class Api::ConversationsController < ApplicationController
  before_filter :set_current_user, only: [:create, :update, :destroy]
  before_filter :set_conversation, only: [:show, :update, :destroy]

  respond_to :json

  def index
    render json: Conversation.all
  end

  def show
    render json: @conversation
  end

  def create
    if @user
      new_conversation = Conversation.new({
        title: conversation_params[:attributes][:title],
        recipient_id: conversation_params[:relationships][:recipient][:data][:id],
        sender_id: @user.id
      })

      if new_conversation.save!
        render json: new_conversation
      else
        render json: new_conversation.errors
      end
    else
      head 500
    end
  end

  def update
    if valid_user
      attrs = {
        sender_trash: conversation_params[:attributes]["sender-trash"],
        recipient_trash: conversation_params[:attributes]["recipient-trash"],
      }

      if @conversation.update(attrs)
        render json: @conversation
      else
        render json: @conversation.errors
      end
    else
      head 500
    end
  end

  def destroy
  end

  private

  def conversation_params
    params.require(:data).permit({ attributes: [:title, "sender-trash", "recipient-trash"], relationships: [recipient: [data: [:id]]] })
  end

  def valid_user
    @user && (@conversation.sender == @user || @conversation.recipient == @user)
  end

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def set_current_user
    @user = User.where(token: params[:data][:token]).first
  end
end
