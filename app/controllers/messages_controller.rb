class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @messages = Message.order(created_at: :asc).limit(100)
    render json: @messages
  end

  def create
    @message = Message.new(message_params)
    
    if @message.save
      ActionCable.server.broadcast(
        'chat_channel',
        {
          id: @message.id,
          content: @message.content,
          username: @message.username,
          created_at: @message.created_at
        }
      )
      
      render json: @message, status: :created
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :username)
  end
end
