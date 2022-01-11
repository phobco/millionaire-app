require 'rails_helper'

RSpec.describe 'users/_game', type: :view do
  let(:game) do
    FactoryBot.build_stubbed(
      :game, id: 5, created_at: Time.parse('2022.01.01, 12:00'), current_level: 10, prize: 1000
    )
  end

  before do
    allow(game).to receive(:status).and_return(:in_progress)
    
    render partial: 'users/game', object: game
  end

  it 'render game id' do
    expect(rendered).to match('5')
  end

  it 'render game start time' do
    expect(rendered).to match('01 янв., 12:00')
  end

  it 'render current question level' do
    expect(rendered).to match('10')
  end

  it 'render game status' do
    expect(rendered).to match('в процессе')
  end

  it 'render game prize' do
    expect(rendered).to match('1 000 ₽')
  end
end
