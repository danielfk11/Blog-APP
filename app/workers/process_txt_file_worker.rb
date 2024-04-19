require 'sidekiq'

class ProcessTxtFileWorker
    include Sidekiq::Worker
  
    def perform(file_content, user_id)
      user = User.find(user_id)
      
      lines = file_content.split("\n")
      title = lines[0].strip
      content = lines[1..].join("\n").strip
      
      post = user.posts.build(title: title, content: content)
      
      if post.save
        post.assign_tags
      else
        Rails.logger.error "Failed to create post: #{post.errors.full_messages.to_sentence}"
      end
    end
end
