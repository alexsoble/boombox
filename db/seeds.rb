#encoding: utf-8

School.destroy_all
School.create([{:name => 'University of Chicago' }, 
  {:name => 'Northwestern University' }, 
  {:name => 'City Charter High School, Pittsburgh' },
  {:name => 'East Brooklyn Community HIgh School' }])

Clip.destroy_all
Clip.create([{:interpretation_id => 27, :start => 14, :duration => 12 }, 
  {:interpretation_id => 28, :start => 2, :duration => 15 },
  {:interpretation_id => 119, :start => 23, :duration => 18}])