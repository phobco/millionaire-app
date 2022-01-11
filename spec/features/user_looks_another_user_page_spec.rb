require 'rails_helper'

RSpec.feature 'USER looks another user page', type: :feature do
  let(:user_1) { FactoryBot.create(:user, name: 'User_1') }
  let(:user_2) { FactoryBot.create(:user, name: 'User_2') }

  let!(:games) do
    [
      FactoryBot.create(:game, id: 1, user: user_2, current_level: 0, created_at: Time.parse('09.01.2022, 12:00')),
      FactoryBot.create(:game, id: 2, user: user_2, prize: 1000000, current_level: 15, created_at: Time.parse('10.01.2022, 12:00'), finished_at: Time.parse('10.01.2022, 12:10'))
    ]
  end

  before { login_as(user_1) }

  scenario 'User_1 looks User_2 page' do
    visit '/'

    click_link 'User_2'

    expect(page).to have_current_path("/users/#{user_2.id}")
    expect(page).not_to have_content('Сменить имя и пароль')
    expect(page).to have_content('User_2')
    
    expect(page).to have_content('#')
    expect(page).to have_content('Дата')
    expect(page).to have_content('Вопрос')
    expect(page).to have_content('Выигрыш')
    expect(page).to have_content('Подсказки')

    expect(page).to have_content('1')
    expect(page).to have_content('в процессе')
    expect(page).to have_content('09 янв., 12:00')
    expect(page).to have_content('0')
    expect(page).to have_content('0 ₽')

    expect(page).to have_content('2')
    expect(page).to have_content('победа')
    expect(page).to have_content('10 янв., 12:00')
    expect(page).to have_content('15')
    expect(page).to have_content('1 000 000 ₽')
  end
end
