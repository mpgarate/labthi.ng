require 'spec_helper'
require 'rails_helper'

describe 'validate FactoryGirl factories' do
  FactoryGirl.factories.each do |factory|
    context "with factory for :#{factory.name}" do
      subject { FactoryGirl.build(factory.name) }

      it "is valid" do
        is_valid = subject.valid?
        is_valid.should be_true, subject.errors.full_messages.join(',')
      end
    end
  end
end