require 'spec_helper'

feature 'User visits explore page' do
    before(:each) do
      visit '/'
      click_link 'Explore'
    end

  scenario 'and submits an idea' do
    click_link 'Submit Idea'
    fill_in 'Brief', with: 'valid brief'
    click_button 'Create Idea'
    update_idea
  end

  scenario 'and sees a listing of ideas' do
    brief = 'iPhone app that enables multitasking while beekeeping'
    submit_idea brief
    update_idea
    click_link 'Explore'
    expect(page).to have_content(brief)
  end

end