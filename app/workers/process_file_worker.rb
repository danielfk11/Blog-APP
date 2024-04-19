class ProcessFileWorker
  include Sidekiq::Worker

  def perform(file_path, user_id)
    user = User.find_by(id: user_id)

    return unless user

    file_content = File.read(file_path).force_encoding('UTF-8')

    lines = file_content.split("\n").map(&:chomp)
    posts_data = []

    (0..lines.size - 1).step(4) do |i|
      title = lines[i].to_s.chomp
      content = lines[i + 1].to_s.chomp
      tag_names = lines[i + 2].to_s.chomp

      posts_data << { title: title, content: content, tag_names: tag_names }
    end

    posts_data.each do |post_data|
      post = user.posts.build(
        title: post_data[:title],
        content: post_data[:content],
        tag_names: post_data[:tag_names]
      )

      unless post.save
        Rails.logger.error "Failed to save post with errors: #{post.errors.full_messages.to_sentence}"
      end
    end
  end
end