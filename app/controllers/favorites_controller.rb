class FavoritesController < ApplicationController
  before_action :authenticate_user!
end

# create_table "favorites", force: :cascade do |t|
#     t.integer  "user_id"
#     t.integer  "favoritable_id"
#     t.string   "favoritable_type"
#   end

# ok we want a link that toggles 
#from add-to-favorites on the Album, Song, and Artist partials
#add a favorite? method to each Model, so we get a boolean back
# that we can check.