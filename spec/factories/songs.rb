FactoryGirl.define do
  factory :song do
    name "MySong"
    album

    sequence :song_sequence do |n|
      name "MySong#{n}"
    end
  end
end
