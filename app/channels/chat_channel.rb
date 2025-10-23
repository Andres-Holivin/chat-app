class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel"
  end

  def unsubscribed
  end

  def speak(data)
    message = Message.create(
      content: data['content'],
      username: data['username']
    )
    
    if message.persisted?
      ActionCable.server.broadcast(
        'chat_channel',
        {
          id: message.id,
          content: message.content,
          username: message.username,
          created_at: message.created_at
        }
      )
    end
  end
end
