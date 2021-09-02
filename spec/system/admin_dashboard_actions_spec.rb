require 'rails_helper'

RSpec.describe 'AdminDashboardActions', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:admin_account) { create(:user, :admin) }
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  def admin_login
    login_as(admin_account, scope: :user)
    visit rails_admin_path
  end

  it 'logs in as admin through login page' do
    visit root_path
    click_on 'Log in'

    find('#user_email').click.set(admin_account.email)
    find('#user_password').click.set(admin_account.password)
    click_on 'Log in'

    expect(page).to have_content('Site Administration')
  end

  it 'see all registered users in admin dashboard' do
    expect(admin_account.role).to eq('admin')
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
    find('#user_username').click.set('UsersNames123')
    find('#user_firstname').click.set('Thirdy')
    find('#user_lastname').click.set('Lasty')
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
    fill_in 'Username', with: 'JohnIsAmazing1001'
    fill_in 'Firstname', with: 'John'
    find('#user_reset_password_sent_at').set('August 11, 2021 12:00')
    find('#user_remember_created_at').set('August 11, 2021 12:00')
    click_button 'Save'

    expect(page).to have_content('User successfully updated')
    expect(page).to have_content('JohnIsAmazing1001')
    expect(page).to have_content('John')
  end

  it 'approves broker application' do
    admin_login
    visit "/admin/user/#{user1.id}/edit"

    page.select 'approved', from: 'Broker status'
    click_button 'Save'

    expect(page).to have_content('User successfully updated')

    # View user info and expect change in User's properties
    visit "/admin/user/#{user1.id}"

    expect(page).to have_content('broker')
    expect(page).to have_content('approved')
  end

  it 'makes user a broker from buyer account' do
    admin_login
    visit "/admin/user/#{user1.id}/edit"
    expect(page).to have_content('Broker status')

    find('#user_role').set('broker')
    click_button 'Save'

    expect(page).to have_content('User successfully updated')
  end
end
