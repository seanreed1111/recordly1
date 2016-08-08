FactoryGirl.define do
  factory :favorite do
    user nil
    favoritable_id 1
    favoritable_type "MyString"
  end
end
