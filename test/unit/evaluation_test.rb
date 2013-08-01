require 'test_helper'

class EvaluationTest < ActiveSupport::TestCase
   test "one rep max" do
     e = users(:jason).evaluations.first
     assert_equal(150, e.one_rep_max(:chest))
     assert_equal(45, e.one_rep_max(:shoulder))
     assert_equal(66.66666666666666, e.one_rep_max(:bicep))
     assert_equal(42.0, e.one_rep_max(:tricep))
     assert_equal(nil, e.one_rep_max(:legs))
     assert_equal(133.33333333333331, e.one_rep_max(:back))
     assert_equal(41.666666666666664, e.one_rep_max(:"lower back"))
     assert_equal(30.0, e.one_rep_max(:abs))
   end
end
