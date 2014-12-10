require 'finland/git_diff'

describe Finland::GitDiff do
  it 'should parse git diff' do
    git_diff = <<-DIFF
diff --git a/db/seeds/development.rb b/db/seeds/development.rb
index 8843d8f..fac62bf 100644
--- a/db/seeds/development.rb
+++ b/db/seeds/development.rb
@@ -155,2 +155 @@ booking = Booking.find_or_create_by!(seller_id: seller.id, customer_id: customer
-  booking.parking_start = 20.days.from_now
-  booking.parking_end   = 20.days.from_now + 3.hours
+  booking.parking_period = (20.days.from_now..(20.days.from_now + 3.hours))
    DIFF

    result = Finland::GitDiff.parse(git_diff)
    expect(result).to eq({"db/seeds/development.rb" => [154..155]})
  end

  it 'should parse git diff with multiple diffs' do
    git_diff = <<-DIFF
diff --git a/db/seeds/development.rb b/db/seeds/development.rb
index 8843d8f..fac62bf 100644
--- a/db/seeds/development.rb
+++ b/db/seeds/development.rb
@@ -155,2 +155 @@ booking = Booking.find_or_create_by!(seller_id: seller.id, customer_id: customer
-  booking.parking_start = 20.days.from_now
-  booking.parking_end   = 20.days.from_now + 3.hours
+  booking.parking_period = (20.days.from_now..(20.days.from_now + 3.hours))
@@ -174,2 +173 @@ booking = Booking.find_or_create_by!(seller_id: seller.id, customer_id: customer
-  booking.parking_start = 22.days.from_now
-  booking.parking_end   = 22.days.from_now + 3.hours
+  booking.parking_period = (22.days.from_now..(22.days.from_now + 3.hours))
@@ -192,2 +190 @@ booking_yesterday = Booking.find_or_create_by!(seller_id: seller.id, customer_id
-  booking.parking_start = 2.days.ago
-  booking.parking_end   = 2.days.ago + 3.hours
+  booking.parking_period = (2.days.from_now..(2.days.from_now + 3.hours))
@@ -210,2 +207 @@ booking_in_past = Booking.find_or_create_by!(seller_id: seller.id, customer_id:
-  booking.parking_start = 4.days.ago
-  booking.parking_end   = 4.days.ago + 3.hours
+  booking.parking_period = (4.days.from_now..(4.days.from_now + 3.hours))
    DIFF

    result = Finland::GitDiff.parse(git_diff)
    expect(result).to eq({"db/seeds/development.rb" => [154..155, 173..174, 191..192, 209..210]})
  end

  it 'should parse git diff with multiple files' do
    git_diff = <<-DIFF
diff --git a/app/models/booking.rb b/app/models/booking.rb
index 09ad575..09e485b 100644
--- a/app/models/booking.rb
+++ b/app/models/booking.rb
@@ -108 +108 @@ class Booking < ActiveRecord::Base
-    parking_period.first
+    parking_period.first.in_time_zone Time.zone
@@ -112 +112 @@ class Booking < ActiveRecord::Base
-    parking_period.last
+    parking_period.last.in_time_zone Time.zone
diff --git a/app/models/cancellation.rb b/app/models/cancellation.rb
index 19749b1..4b61910 100644
--- a/app/models/cancellation.rb
+++ b/app/models/cancellation.rb
@@ -34,2 +34,2 @@ class Cancellation < ActiveRecord::Base
-      event_date: Date.today,
-      post_date: Date.today,
+      event_time: Time.zone.now,
+      post_time: Time.zone.now,
@@ -43,2 +43,2 @@ class Cancellation < ActiveRecord::Base
-      event_date: Date.today,
-      post_date: Date.today,
+      event_time: Time.zone.now,
+      post_time: Time.zone.now,
    DIFF

    result = Finland::GitDiff.parse(git_diff)
    expect(result).to eq({"app/models/booking.rb" => [107..107, 111..111], "app/models/cancellation.rb" => [33..34, 42..43]})
  end
end
