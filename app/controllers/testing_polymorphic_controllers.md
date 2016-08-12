https://stackoverflow.com/questions/37254534/railsrspec-controller-spec-with-polymorphic-association

I'm trying to test the actions in controller spec but for some reason I get the no routes matches error. What should I do to make the route work?

ActionController::UrlGenerationError:
   No route matches {:action=>"create", :comment=>{:body=>"Consectetur quo accusamus ea.", 
   :commentable=>"4"}, :controller=>"comments", :post_id=>"4"}
model

class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true, touch: true 

class Post < ActiveRecord::Base
  has_many :comments, as: :commentable, dependent: :destroy
routes

resources :posts do
  resources :comments, only: [:create, :update, :destroy], module: :posts
end
controller_spec

describe "POST create" do
  let!(:user) { create(:user) }
  let!(:profile) { create(:profile, user: @user) }
  let!(:commentable) { create(:post, user: @user) }

  context "with valid attributes" do
    subject(:create_action) { xhr :post, :create, post_id: commentable, comment: attributes_for(:comment, commentable: commentable, user: @user) }

    it "saves the new task in the db" do
      expect{ create_action }.to change{ Comment.count }.by(1)
    end
    ...
EDIT

The controller_spec from above can be found in spec/controllers/comments_controller_spec.rb

controllers/comments_controller.rb

class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = @commentable.comments.new(comment_params)
    authorize @comment
    @comment.user = current_user
    if @comment.save
      @comment.send_comment_creation_notification(@commentable)
      respond_to :js
    end
  end
controllers/posts/comments_controller.rb

  class Posts::CommentsController < CommentsController
    before_action :set_commentable

    private

    def set_commentable
      @commentable = Post.find(params[:post_id])
    end
ruby-on-rails rspec controller polymorphic-associations

Using the module: :posts will route to Posts::CommentsController#create.

If that is not what you intended than remove the module option. 

Otherwise you need to ensure that you have the correct class name for both your controller and spec.

class Posts::CommentsController
  def create

  end
end

RSpec.describe Posts::CommentsController do
  # ...
end
Also note that if often does not make sense to nest the "individual actions" for a resource.

Instead you may want to declare the routes like so:

resources :comments, only: [:update, :destroy] # show, edit ...

resources :posts do
  resources :comments, only: [:create], module: :posts # new, index
end
Which gives you:

class CommentsController < ApplicationController

  before_action :set_posts

  # DELETE /comments/:id
  def destroy
     # ...
  end

  # PUT|PATCH /comments/:id
  def update
  end
end 

class Posts::CommentsController < ApplicationController
  # POST /posts/:post_id/comments
  def create
     # ...
  end
end 
See Avoid Deeply Nested Routes in Rails for a deeper explaination of why.

Setting the up the controller to use inheritance in this case is a good idea - however you cannot test the create method through the parent CommentsController class in a controller spec since RSpec will always look at described_class when trying to resolve the route.

Instead you may want to use shared examples:

# /spec/support/shared_examples/comments.rb
RSpec.shared_examples "nested comments controller" do |parameter|
  describe "POST create" do
    let!(:user) { create(:user) }

    context "with valid attributes" do
      subject(:create_action) { xhr :post, :create, post_id: commentable, comment: attributes_for(:comment, commentable: commentable, user: @user) }

      it "saves the new task in the db" do
        expect{ create_action }.to change{ Comment.count }.by(1)
      end
    end
  end
end
require 'rails_helper'
require 'shared_examples/comments'
RSpec.describe Posts::CommentsController
  # ...
  include_examples "nested comments controller" do
    let(:commentable) { create(:post, ...) }
  end
end
require 'rails_helper'
require 'shared_examples/comments'
RSpec.describe Products::CommentsController
  # ...
  include_examples "nested comments controller" do
    let(:commentable) { create(:product, ...) }
  end
end
The other alternative which I prefer is to use request specs instead:

require 'rails_helper'
RSpec.describe "Comments", type: :request do

  RSpec.shared_example "has nested comments" do
    let(:path) { polymorphic_path(commentable) + "/comments" } 
    let(:params) { attributes_for(:comment) }

    describe "POST create" do
      expect do
        xhr :post, path, params
      end.to change(commentable.comments, :count).by(1)
    end
  end


  context "Posts" do
     include_examples "has nested comments" do
       let(:commentable) { create(:post) }
     end
  end

  context "Products" do
     include_examples "has nested comments" do
       let(:commentable) { create(:product) }
     end
  end
end
Since you are really sending a HTTP request instead of faking it they cover more of the application stack. This does however come with a small price in terms of test speed. Both shared_context and shared_examples are two of the things which make RSpec really awesome.

