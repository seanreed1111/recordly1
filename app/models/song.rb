class Song < ActiveRecord::Base

  include PgSearch
  multisearchable :against => [:name]

  belongs_to :artist
  belongs_to :album
  has_many :favorites, as: :favoritable

  validates :name, presence: true

  PgSearch.multisearch_options = {
    using: {
      tsearch: {
        prefix: true,
        any_word: true,
        dictionary: 'english'
      }
    },
    ignoring: :accents
  }
end
