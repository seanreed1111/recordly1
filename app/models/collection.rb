class Collection < ActiveRecord::Base
  belongs_to :user


  belongs_to :album
  accepts_nested_attributes_for :album


  # adds global search to Collection class
  def self.search(search_string)
    #verify that PgSearch sanitizes inputs
    PgSearch.multisearch(search_string)
  end
end
