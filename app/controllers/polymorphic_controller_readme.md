
For these models....

class Picture < ActiveRecord::Base
  has_many :comments, as: commentable
end

class Post < ActiveRecord::Base
  has_many :comments, as: commentable
end

class Event < ActiveRecord::Base
  has_many :comments, as: commentable
end

class Article < ActiveRecord::Base
  has_many :comments, as: commentable
end

--------

DONT DO THIS

class CommentsController < ApplicationController
  def create
      if params[:picture_id]
          @commentable = Picture.find(params[:picture_id])
      elsif params[:post_id]
          @commentable = Post.find(params[:post_id])
      elsif params[:event_id]
          @commentable = Event.find(params[:event_id])
      elsif params[:article_id]
          @commentable = Article.find(params[:article_id])
      end

      @comment = @commentable.comments.build(comment_params)
  end
end

---------------------------------

DO THIS INSTEAD!!!!

class CommentsController < ApplicationController    
  def create
      @commentable = find_commentable
      @comment = @commentable.comments.build(comment_params)
  end

  private

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end