Fabricator(:topic) do
  title { Faker::Name.title }
  body { Faker::Lorem.paragraph(1) }
end
