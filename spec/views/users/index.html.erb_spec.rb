require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  before do
    assign(:users, [
      FactoryBot.build_stubbed(:user, name: 'User1', balance: 1000),
      FactoryBot.build_stubbed(:user, name: 'User2', balance: 2000)
    ])

    render
  end

  it 'render player names' do
    expect(rendered).to match('User1')
    expect(rendered).to match('User2')
  end

  it 'render player balances' do
    expect(rendered).to match('1 000 ₽')
    expect(rendered).to match('2 000 ₽')
  end

  it 'render player names in right order' do
    expect(rendered).to match(/User1.*User2/m)
  end
end
