FactoryGirl.define do
  factory :album do
    name "My Album Name"
    sequence(:id) {|n| "#{n}"}
    artist

    factory :album_with_songs do
      transient do 
        songs_count 5
      end

      after(:create) do |album, evaluator|
        create_list(generate :song_sequence, evaluator.songs_count, album: album)
      end
    end
  end
end
