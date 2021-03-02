require 'rails_helper'

RSpec.describe 'create new user', type: :feature do
  before :each do
    @user = User.create(name: 'ahmed', email: 'ahmed@mail.com', password: '123456')
  end

  scenario 'Send Friend request' do
    visit new_user_registration_path
    fill_in 'Name', with: 'gustavo'
    fill_in 'Email', with: 'gustavo@email.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    visit users_path
    click_on 'Add'
    expect(page).to have_content('You Sent Friend request to')
  end

  scenario 'Accept friend request' do
    visit new_user_registration_path
    fill_in 'Name', with: 'gustavo'
    fill_in 'Email', with: 'gustavo@email.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    visit users_path
    click_on 'Add'
    expect(page).to have_content('You Sent Friend request to ahmed')

    click_on 'Sign out'
    visit user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password

    click_on 'Log in'
    click_on 'Welcome ahmed'
    click_on 'Accept'
    expect(page).to have_content('You and gustavo are now Friends !')
  end
end
