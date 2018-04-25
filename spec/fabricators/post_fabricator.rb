Fabricator(:post) do
  body { Faker::Lorem.paragraph(2) }
end
