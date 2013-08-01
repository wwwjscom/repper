require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "the user basics" do
     assert_equal(users(:jason).id, 1)
   end
end
