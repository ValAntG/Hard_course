require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belongs_to :question }
  it { should validate_present_of :body }
end
