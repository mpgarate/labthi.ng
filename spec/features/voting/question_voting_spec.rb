require 'spec_helper'

feature 'Visitor votes' do
  before(:each) do
  	@question = FactoryGirl.create(:question)
  	sign_in
  end

  scenario 'in favor of a question' do
  	visit url_for(@question)
  	page.should have_content("Votes: 0")
  	click_link '.vote-up-question-#{@question.id}'
  	page.should have_content("Votes: 1")
  end
  scenario 'against a question' do
  	visit url_for(@question)
  	page.should have_content("Votes: 0")
  	click_link '.vote-down-question-#{@question.id}'
  	page.should have_content("Votes: -1")
  end
  scenario 'to undo an upvote on a question' do
    visit url_for(@question)
    click_link '.vote-up-question-#{@question.id}'
    click_link '.vote-undo-question-#{@question.id}'
    page.should have_content("Votes: 0")
  end
  scenario 'to undo a dowvote on a question' do
    visit url_for(@question)
    click_link '.vote-down-question-#{@question.id}'
    click_link '.vote-undo-question-#{@question.id}'
    page.should have_content("Votes: 0")
  end

end
