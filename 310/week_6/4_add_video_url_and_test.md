* Add text field video url in form  
* Create migration for video url  
* add button to play video point to video url  

## Feature test for admin add video  
* create `spec/features/admin_adds_new_video_spec.md`  
* Test happy path  
~> fabricate admin, category    
~> sign in as admin  
~> visit admin add video path  
~> fill in form, select category  
~> upload test image to `spec/support/uploads`  
~> attach_file "name","path"  
~> sign_out  

~> sign in as regular user  
~> visit video_path(Video.first), since only one video exists  
~> expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
~> expect(page).to have_selector("a[href='http://www.example.com/test_video.mp4']")