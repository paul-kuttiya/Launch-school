## Capybara  
* Use for features testing   
~> Feature testings is the test that test on user interfaces at higher level  

* add `gem 'capybara'` in test group gems then `bundle`  

* add `require 'capybara/rails'` to `spec_helper.rb`

* create feature spec file under `spec/features`  
~> for example `spec/features/user_sign_in_spec.rb`  

* use cheatsheet for DSL look up  
~> `feature "..." == describe "..."`   
~> `scenaraio "..." == it "..."`  

* debugging by `require 'pry'; binding.pry`  
~> install gem `gem launchy` in group development
~> open current capybara html with `save_and_open_page`  

* For test query add data in html   
~> expect will return string in html
```ruby
  #view
  data: {video_id: queue.video.id}

  #specs
  find("input[data-video-id='#{video.id}']").set(3)
  expect(find("input[data-video-id='#{video.id}']").value).to eq("3")
```  

* Query with within  
~> within xpath find tr that has video1.title inside  
~> fill in the input with specific name 
```ruby
within(:xpath, "//tr[contains(., '#{video1.title}')]") do
  fill_in "queue_items[][list_order]", with: 3
end

click_button "Update Instant Queue"

expect(find(:xpath, "//tr[contains(., '#{video1.title}')]//input[@type='text']").value).to eq("3")
```