Fabricator(:conversation) do
  title { Faker::Name.title }
  sender_trash false
  recipient_trash false
end
