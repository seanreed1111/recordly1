class Song < ActiveRecord::Base

  belongs_to :album
  has_one :artist, through: :album
  has_many :favorites, as: :favoritable

  validates :name, presence: true

  include PgSearch
  multisearchable :against => [:name]


  PgSearch.multisearch_options = {
    using: {
      tsearch: {
        prefix: true,
        any_word: true,
        dictionary: 'english'
      }
    }
  }
end
