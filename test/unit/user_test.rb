require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "the user basics" do
     assert_equal(users(:jason).id, 1)
   end
   
   test "muscle groups" do
     mg = users(:jason).muscle_groups
     assert_equal(5, mg.size)
     assert_equal(muscle_groups(:chest).name, mg[0].name)
   end
end
