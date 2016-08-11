class Artist < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:name]

  has_many :albums
  accepts_nested_attributes_for :albums
  has_many :songs, through: :albums
  has_many :favorites, as: :favoritable #polymorphic
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