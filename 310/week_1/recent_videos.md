## create recent videos method 
```ruby
#category model
def recent_videos(limit=6)
  videos.limit(limit).reorder("created_at DESC")
end
```

```ruby
describe "#recent_videos" do
  it "returns an empty array if no videos." do
    comedy = Category.create(name: "comedy")

    expect(comedy.recent_videos).to eq([])
  end

  it "returns array of all videos if has less than 6 videos." do
    comedy = Category.create(name: "comedy")
    south_park = Video.create(title: "south park", description: "comedy cartoon", category: comedy)
    house = Video.create(title: "house", description: "house MD", category: comedy)

    expect(comedy.recent_videos.size).to eq(2)
  end

  it "returns array of recent 6 videos if has more than 6 videos." do
    comedy = Category.create(name: "comedy")

    7.times { |n| Video.create(title: "south park #{n}", description: "comedy cartoon", category: comedy) }

    expect(comedy.recent_videos.size).to eq(6)
  end

  it "returns videos in DESC order." do
    comedy = Category.create(name: "comedy")

    6.times { |n| Video.create(title: "south park #{n}", description: "comedy cartoon", category: comedy) }
    conan = { title: "conan", description: "conan", created_at: 2.days.ago }
    
    expect(comedy.recent_videos).not_to include(conan)
  end
end
```