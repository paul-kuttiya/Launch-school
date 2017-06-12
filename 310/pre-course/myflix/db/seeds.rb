# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

category = ['comedy', 'drama', 'action']

category.each do |cat|
  Category.create(
    name: cat
  )
end

10.times do |n|
  Video.create(
    title: "dummy #{n + 1}",
    category_id: Category.all.sample.id,
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
    Maecenas posuere faucibus sapien vel aliquam. Aliquam at metus ipsum. 
    Integer a dignissim magna. In blandit venenatis elementum.",
    small_cover: "/tmp/monk.jpg",
    large_cover: "/tmp/monk_large.jpg"
  )
end

