#encoding: utf-8

School.destroy_all
School.create([{:name => 'University of Chicago' }, 
  {:name => 'Northwestern University' }, 
  {:name => 'City Charter High School, Pittsburgh' }])

Clip.destroy_all
Clip.create([{:interpretation_id => 27, :start => 14, :duration => 12 }, 
  {:interpretation_id => 62, :start => 14, :duration => 12},
  {:interpretation_id => 130, :start => 23, :duration => 9}])