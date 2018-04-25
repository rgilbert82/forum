Fabricator(:user) do
  username { Faker::Name.first_name }
  password 'password'
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end
