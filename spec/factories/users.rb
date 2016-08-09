FactoryGirl.define do
  factory :user do
    email "myemail@email.com" 
    password "password"
    password_confirmation "password"
  end
end
