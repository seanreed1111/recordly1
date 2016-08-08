class User < ActiveRecord::Base
  has_many :favorites
  has_many :favorite_feeds, :through =>  :favorites, :source => :favorable, :source_type => "Feed"
  has_many :favorite_entries, :through =>  :favorites, :source => :favorable, :source_type => "Entry"
end

class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorable, :polymorphic => true
  attr_accessible :user, :favorable
end

class Feed < ActiveRecord::Base
  has_many :favorites, :as => :favorable
  has_many :fans, :through => :favorites, :source => :user
end

class Entry < ActiveRecord::Base
  has_many :favorites, :as => :favorable
  has_many :fans, :through => :favorites, :source => :user
end
The migration:

create_table :favorites do |t|
  t.references :user
  t.references :favorable
  t.string :favorable_type
end

add_index :favorites, [:user_id, :favorable_id, :favorable_type], unique: true
The test:

user.favorite_entries
user.favorite_feeds

feed.fans
entry.fans

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
https://stackoverflow.com/questions/21817019/rails-polymorphic-favorites-user-can-favorite-different-models
Your Favorite model looks like this:

class Favorite < ActiveRecord::Base
  belongs_to :favoritable, polymorphic: true
  belongs_to :user, inverse_of: :favorites
end
Then, your User model will look like this:

class User < ActiveRecord::Base
  has_many :favorites, inverse_of: :user
end

Then, the models that can be favorited should look like this:

class Category < ActiveRecord::Base
  has_many :favorites, as: :favoritable
end
Yes, you will need a favorites table in your database.

Favoriting Items

So, this should allow you to do stuff like:

@user.favorites << Favorite.new(favoritabe: Category.find(1))  
# add favorite for user
Just keep in mind that you need to add instances of Favorite to @user.favorites, not instances of favoritable models. 
The favoritable model is an attribute on the instance of Favorite.

But, really, the preferred way to do this in Rails is like so:

@user.favorites.build(favoritable: Category.find(1))


Finding Favorites of a Certain Kind

If you wanted to find only favorites of a certain type, 
you could do something like:

@user.favorites.where(favoritable_type: 'Category')  
# get favorited categories for user
Favorite.where(favoritable_type: 'Category')         
# get all favorited categories
If you're going to do this often, 
I think adding scopes to a polymorphic model is pretty clean:

class Favorite < ActiveRecord::Base
  scope :categories, -> { where(favoritable_type: 'Category') }
end
This allows you to do:

@user.favorites.categories
Which is gets you the same result as @user.favorites.where(favoritable_type: 'Category') from above.

Allowing Users to Favorite an Item Only Once

I'm guessing that you might also want to allow users to only be able to favorite an item once, so that you don't get, for example, duplicate categories when you do something like, @user.favorites.categories. 
Here's how you would set that up on your Favorite model:

class Favorite < ActiveRecord::Base
  belongs_to :favoritable, polymorphic: true
  belongs_to :user, inverse_of: :favorites

  validates :user_id, uniqueness: { 
    scope: [:favoritable_id, :favoritable_type],
    message: 'can only favorite an item once'
  }
end

This makes it so that a favorite must have a unique combination of user_id, favoritable_id, and favoritable_type. 
Since favoritable_id and favoritable_type are combined to get the favoritable item, this is equivalent to specifying that all favorites must have a unique combination of user_id and favoritable. 
Or, in plain English, "a user can only favorite something once".

Adding Indexes to the Database

For performance reasons, when you have polymorphic relationships, you want database indexes on the _id and _type columns. If you use the Rails generator with the polymorphic option, I think it will do this for you. Otherwise, you'll have to do it yourself.

If you're not sure, take a look your db/schema.rb file. If you have the following after the schema for your favorites table, then you're all set:

add_index :favorites, :favoritable_id
add_index :favorites, :favoritable_type

Otherwise, put those lines in a migration and run that bad boy.

While you're at it, you should make sure that all of your foreign keys also have indexes. In this example, that would be be the user_id column on the favorites table. Again, if you're not sure, check your schema file.

And one last thing about database indexes: if you are going to add the uniqueness constraint as outlined in the section above, 
you should add a unique index to your database. You would do that like this:

add_index :favorites, [:favoritable_id, :favoritable_type], unique: true

This will enforce the uniqueness constraint at the database level, 
which is necessary if you have multiple app servers all using a single database, and generally just the right way to do things.



http://schmidt-happens.com/articles/2014/06/04/favoriting-system-in-rails.html

React 
https://gist.github.com/travisdmathis/dd665a2935a5fead059cd6d92c6c0c96
https://snippets.aktagon.com/snippets/588-how-to-implement-favorites-in-rails-with-polymorphic-associations


