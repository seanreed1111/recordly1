Polymorphic Association in Rails 5
by Bala Paranj on May 01, 2016
https://rubyplus.com/articles/3901-Polymorphic-Association-in-Rails-5
https://github.com/bparanj/polym.or

You can download the source code for this article from polym.or. This article uses Ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-darwin11.0] and Rails 5.0.0.beta4.

Starter Rails 5 App
Create a new Rails 5 project and the article, event and photo models.

rails new polym.or
rails g model article name content:text
rails g model event name starts_at:datetime ends_at:datetime description:text
rails g model photos name filename 
Create the controllers.

rails g controller articles
rails g controller events
rails g controller photos
The controllers have the standard RESTful actions. Copy the images to app/assets/images folder. Create and populate the tables.

rails db:migrate
rails db:seed
Define the resources in routes.rb

Rails.application.routes.draw do
  resources :photos
  resources :events
  resources :articles

  root to: 'articles#index'
end
Start the server, you will be able to see all the articles in the home page. You can click on the links to photos and events in the navigation.

Polymorphic Association
Create a comments model.

rails g model comment content:text commentable_id:integer commentable_type
The generated migration file looks like this:

class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :commentable_id
      t.string :commentable_type

      t.timestamps
    end
  end
end
Add index to this file.

class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :commentable_id
      t.string :commentable_type

      t.timestamps
    end
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
You can simplify the migration by using:

t.belongs_to :commentable, polymorphic: true
The migration file now looks like this:

class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.belongs_to :commentable, polymorphic: true

      t.timestamps
    end
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
Run the migration. Add the polymorphic association to the comment model.

belongs_to :commentable, polymorphic: true 

Add

has_many :comments, as: :commentable
to article, event and photo models. 

Let's experiment in the rails console. We can create a comment for an article.

> a = Article.first
  Article Load (0.2ms)  SELECT  "articles".* FROM "articles" ORDER BY "articles"."id" ASC LIMIT ?  [["LIMIT", 1]]
 => #<Article id: 1, name: "Batman", content: "Batman is a fictional character created by the art...", created_at: "2016-05-01 17:25:05", updated_at: "2016-05-01 17:25:05"> 
 > c = a.comments.create!(content: 'Hello World')
   (0.1ms)  begin transaction
  Article Load (0.1ms)  SELECT  "articles".* FROM "articles" WHERE "articles"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  SQL (0.5ms)  INSERT INTO "comments" ("content", "commentable_type", "commentable_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["content", "Hello World"], ["commentable_type", "Article"], ["commentable_id", 1], ["created_at", 2016-05-01 17:36:09 UTC], ["updated_at", 2016-05-01 17:36:09 UTC]]
   (56.1ms)  commit transaction
 => #<Comment id: 1, content: "Hello World", commentable_type: "Article", commentable_id: 1, created_at: "2016-05-01 17:36:09", updated_at: "2016-05-01 17:36:09"> 
We can use the polymorphic association to retrieve the article model.

 > c.commentable
 => #<Article id: 1, name: "Batman", content: "Batman is a fictional character created by the art...", created_at: "2016-05-01 17:25:05", updated_at: "2016-05-01 17:25:05"> 
Let's create comments controller to list and create new comments.

rails g controller comments index new
Define the nested resources in routes.rb.

Rails.application.routes.draw do
  resources :photos do
    resources :comments
  end

  resources :events do
    resources :comments
  end

  resources :articles do
    resources :comments
  end

  root to: 'articles#index'
end
We can list all the comments for a given article in the index action.

class CommentsController < ApplicationController
  def index
    @commentable = Article.find(params[:article_id])
    @comments = @commentable.comments
  end

  def new
  end
end
Copy the views for the comments and comments.scss. Go to http://localhost:3000/articles/1/comments to see the comment for the first article we created in the rails console. If you go to http://localhost:3000/photos/1/comments, you will get an exception because it is not implemented yet. Generalize the comments controller to handle any of the model involved in the polymorphic association:

class CommentsController < ApplicationController
  before_action :load_commentable

  def index
    @comments = @commentable.comments
  end

  def new
  end

  private

  def load_commentable
    resource, id = request.path.split('/')[1,2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end
end
You can now go to http://localhost:3000/photos/1/comments to see empty list for the photo comments. To create a comment, implement new and create action:

def new
  @comment = @commentable.comments.new
end

def create
  @comment = @commentable.comments.new(allowed_params)  
  if @comment.save
    redirect_to [@commentable, :comments], notice: 'Comment created'
  else
    render :new
  end
end
The comments/new.html.erb looks like this:

<h1>New Comment</h1>

<%= render 'form' %>
The comments/_form.html.erb looks like this:

<%= form_for [@commentable, @comment] do |f| %>
  <% if @comment.errors.any? %>
    <div class="error_messages">
      <h2>Please correct the following errors.</h2>
      <ul>
      <% @comment.errors.full_messages.each do |msg| %>
        <li><%= msg %></li>
      <% end %>
      </ul>
    </div>
  <% end %>

  <div class="field">
    <%= f.text_area :content, rows: 8 %>
  </div>
  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>
Go to http://localhost:3000/photos/1/comments/new. New comment form is displayed. You can now create a comment. Add the comments section and form for the comment to the bottom of the article, photo or event.

<h2>Comments</h2>

<%= render "comments/comments" %>
<%= render "comments/form" %>
Change the articles show action to initialize the variables required in the view:

def show
  @article = Article.find(params[:id])
  @commentable = @article
  @comments = @commentable.comments
  @comment = Comment.new
end
Change the redirect in the comments controller create action from:

redirect_to [@commentable, :comments], notice: 'Comment created'

to

redirect_to @commentable, notice: "Comment created."
Now, the user will be redirected to the show page of the article, photo or event when a new comment is created.