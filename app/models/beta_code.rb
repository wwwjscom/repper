class BetaCode < ActiveRecord::Base
  attr_accessible :assigned_to_email, :code, :used
  
  def self.valid?(code)
    self.exists?({:code => code, :used => false})
  end
  
  def self.used(code)
    self.where(:code => code).first.update_attribute(:used, true)
  end
end
