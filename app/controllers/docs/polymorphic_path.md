http://api.rubyonrails.org/v4.1/classes/ActionDispatch/Routing/PolymorphicRoutes.html

polymorphic path http://api.rubyonrails.org/classes/ActionDispatch/Routing/PolymorphicRoutes.html


https://stackoverflow.com/questions/34572024/rails-4-delete-on-polymorphic-attribute


one-more-here - this looks like a more straightforward, get it
to work kind of thing.

# config/routes.rb
resources :photos, :albums do
   resources :comments, only: :create #-> url.com/photos/:photo_id/comments
end

# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
   def create
      @parent  = parent
      @comment = @parent.comments.new comment_params
      @comment.save
   end

   private

   def parent
      Album.find params[:album_id] if params[:album_id]
      Photo.find params[:photo_id] if params[:photo_id]
   end

   def comment_params
      params.require(:comment).permit(:body).merge(user_id: current_user.id)
   end
end

---------------------------

one more below------- https://stackoverflow.com/questions/35879272/polymorphic-association-controller-create-error

class CommentsController < ApplicationController
    before_action :find_comment, only: [:edit, :update, :destroy]
    before_action :logged_user

    def new
        if params[:movie_id]
            @movie = Movie.find(params[:movie_id])
        else
            @director = Director.find(params[:director_id])
        end
        @comment = Comment.new
    end

    def create
        if params[:movie_id]
            @commentable = Movie.find(params[:movie_id])
        else
            @commentable = Director.find(params[:director_id])
        end
        @comment = @commentable.comments.new(comment_params)
        @comment.user = current_user
        if @comment.save
            flash[:success] = 'Dodano komentarz.'
            redirect_to @commentable
        else
            flash[:danger] = 'Coś poszło nie tak, spróbuj ponownie.'
            render :new
        end
    end

    private
    def comment_params
        params.require(:comment).permit(:content, :grade)
    end

    def find_comment
        @comment = Comment.find(params[:id])
    end

end

class Movie < ActiveRecord::Base

    belongs_to :director
    has_many :comments, as: :commentable, dependent: :destroy
    has_many :users, through: :comments, source: :commentable, source_type: "User"
    accepts_nested_attributes_for :comments, :allow_destroy => true
end

class User < ActiveRecord::Base

    has_many :comments, dependent: :destroy
    has_many :movies, through: :comments, source: :commentable, source_type: "Movie"
    has_many :directors, through: :comments, source: :commentable, source_type: "Director"
    accepts_nested_attributes_for :comments, :allow_destroy => true
end

class Comment < ActiveRecord::Base
    belongs_to :commentable, polymorphic: true
    belongs_to :user

    validates_uniqueness_of :commentable, scope: :user
    validates :content, presence: true, length: { minimum: 40 }

end