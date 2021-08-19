require 'rails_helper'

RSpec.describe "UserCreations", type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'signs up as a buyer' do
    visit root_path
    click_on 'Sign up'
    
    find('#user_email').click.set('buyer3@test.com')
    find('#user_role').click
    find("option[value='Buyer']").click
    find('#user_password').click.set('pa55w0rd1234')
    find('#user_password_confirmation').click.set('pa55w0rd1234')
    click_on 'Sign up'

    expect(page).to have_content('Logout')
  end

  it 'signs up as a broker' do
    visit root_path
    click_on 'Sign up'
    
    find('#user_email').click.set('broker4@test.com')
    find('#user_role').click
    find("option[value='Broker']").click
    find('#user_password').click.set('pa55w0rd1234')
    find('#user_password_confirmation').click.set('pa55w0rd1234')
    click_on 'Sign up'

    expect(page).to have_content('Logout')
  end

end
