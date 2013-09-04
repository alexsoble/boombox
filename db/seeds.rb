#encoding: utf-8

Interpretation.where(:user_id => 0).destroy_all

School.destroy_all
School.create([{:name => 'University of Chicago' }, 
  {:name => 'Northwestern University' }, 
  {:name => 'City Charter High School, Pittsburgh' },
  {:name => 'East Brooklyn Community HIgh School' }])