FactoryGirl.define do
  factory :user do
    username "MyName"
    email "my_email@example.com"
    password "great_password"
    password_confirmation "great_password"
    avatar "http://some_domain.com"
  end

end
