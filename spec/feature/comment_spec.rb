require 'rails_helper'

RSpec.describe 'Show comments', type: :feature do
  scenario 'With valid user and valid information' do
    visit new_user_registration_path
    fill_in 'Name', with: 'gustavo'
    fill_in 'Email', with: 'gustavo@email.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    visit posts_path
    fill_in 'Add New Post', with: 'Post to test'
    click_on 'Save'
    fill_in 'Add new Comment', with: 'Comment to test'
    click_on 'Comment'

    expect(page).to have_content('Comment to test')
  end
  scenario 'With valid user and unvalid information' do
    visit new_user_registration_path
    fill_in 'Name', with: 'gustavo'
    fill_in 'Email', with: 'gustavo@email.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    visit posts_path
    fill_in 'Add New Post', with: 'Post to test'
    click_on 'Save'
    fill_in 'Add new Comment', with: ''
    click_on 'Comment'

    expect(page).to have_content("Content can't be blank")
  end
  scenario 'With unvalid user' do
    visit new_user_registration_path
    fill_in 'Name', with: ''
    fill_in 'Email', with: 'gustavo@email.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    visit posts_path

    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end

RSpec.describe 'Show other users comments', type: :feature do
  before :each do
    @user = User.create(name: 'ahmed', email: 'ahmed@mail.com', password: '123456')
    @post = Post.create(user_id: 1, content: 'Post')
    @comment = Comment.create(user_id: 1, post_id: 1, content: 'Comment to test')
  end

  scenario 'With valid user' do
    visit new_user_registration_path
    fill_in 'Name', with: 'gustavo'
    fill_in 'Email', with: 'gustavo@email.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    visit users_path
    click_on 'Add'

    visit posts_path
    fill_in 'Add New Post', with: 'Post to test'
    click_on 'Save'
    fill_in 'Add new Comment', with: 'Comment to test'
    click_on 'Comment'

    click_on 'Sign out'

    visit user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_on 'Log in'
    click_on 'Welcome ahmed'
    click_on 'Accept'

    visit posts_path
    expect(page).to have_content('Comment to test')
  end
end
