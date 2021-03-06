require 'rails_helper'

feature 'Visitor votes' do
  before(:each) do
  	@answer = FactoryGirl.create(:answer)
    @comment_before = FactoryGirl.create(:comment, commentable: @answer)
    @comment = FactoryGirl.create(:comment, commentable: @answer)
    @comment_after = FactoryGirl.create(:comment, commentable: @answer)
  	@selector = ".comment-#{@comment.id}-vote-wrapper .vote-count"
  	sign_in
    visit url_for(@answer.question)
  end

  scenario 'in favor of an answer comment' do
  	find(@selector).should have_content("1")
  	click_link "vote-up-comment-#{@comment.id}"
  	find(@selector).should have_content("2")
    page.should have_selector("ul.comments li:first-child #{@selector}", :text => "2")
  end
  scenario 'against an answer comment' do
  	find(@selector).should have_content("1")
  	click_link "vote-down-comment-#{@comment.id}"
  	find(@selector).should have_content("0")
    page.should have_selector("ul.comments li:last-child #{@selector}", :text => "0")
  end
  scenario 'to undo an upvote on an answer comment' do
    click_link "vote-up-comment-#{@comment.id}"
    click_link "vote-undo-comment-#{@comment.id}"
    find(@selector).should have_content("1")
  end
  scenario 'to undo a dowvote on an answer comment' do
    click_link "vote-down-comment-#{@comment.id}"
    click_link "vote-undo-comment-#{@comment.id}"
    find(@selector).should have_content("1")
  end

end
