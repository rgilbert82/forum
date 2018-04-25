Fabricator(:message) do
  body { Faker::Lorem.paragraph(2) }
  unread true
end
