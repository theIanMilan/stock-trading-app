require 'rails_helper'

RSpec.describe 'AdminDashboardActions', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:admin) { User.create(email: 'helloWorld@test.com', password: 'pa55w0rd1234', role: 'admin') }
  let!(:user1) { User.create(email: 'buyer1@test.com', password: 'pa55w0rd1234') }
  let!(:user2) { User.create(email: 'buyer2@test.com', password: 'pa55w0rd1234') }

  def admin_login
    login_as(admin, scope: :user)
    visit rails_admin_path
  end

  it 'logs in as admin through login page' do
    @admin1 = User.create(email: 'testWorld@test.com', password: 'pa55w0rd1234', role: 'admin')
    visit root_path
    click_on 'Log in'

    fill_in 'Email', with: 'testWorld@test.com'
    fill_in 'Password', with: 'pa55w0rd1234'
    click_on 'Log in'

    expect(page).to have_content('Site Administration')
  end

  it 'see all registered users in admin dashboard' do
    admin_login

    within 'table.table-striped' do
      click_link 'Users'
    end

    expect(page).to have_content(user1.email)
    expect(page).to have_content(user2.email)
  end

  it 'view specific user and show details' do
    admin_login

    visit "/admin/user/#{user1.id}"

    expect(page).to have_content(user1.email)
    expect(page).to have_content(user1.role)
  end

  it 'create a new user to manually add them to app' do
    admin_login

    visit '/admin/user/new'
    fill_in 'Email', with: 'userCreation@test.com'
    fill_in 'Password', with: 'pa55w0rd1234'
    fill_in 'Password confirmation', with: 'pa55w0rd1234'
    find('#user_reset_password_sent_at').set('August 11, 2021 12:00')
    find('#user_remember_created_at').set('August 11, 2021 12:00')
    click_button 'Save'

    expect(page).to have_content('User successfully created')
  end

  it 'edit a specific user to update details' do
    admin_login
    visit "/admin/user/#{user1.id}/edit"

    fill_in 'Password', with: 'helloWorld'
    fill_in 'Password confirmation', with: 'helloWorld'
    find('#user_reset_password_sent_at').set('August 11, 2021 12:00')
    find('#user_remember_created_at').set('August 11, 2021 12:00')
    click_button 'Save'

    expect(page).to have_content('User successfully updated')
  end
end
