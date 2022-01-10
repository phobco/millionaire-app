require 'rails_helper'
require 'support/my_spec_helper'

RSpec.describe GamesController , type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, is_admin: true) }
  let(:game_w_questions) { FactoryBot.create(:game_with_questions, user: user) }

  context 'when the user is not logged in' do
    it 'kicks user from #show' do
      get :show, params: { id: game_w_questions.id }

      expect(response.status).not_to eq(200)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to be
    end
  end
  
  context 'when user is logged in' do
    before(:each) { sign_in user }

    it 'creates the game' do
      generate_questions(15)

      post :create
      game = assigns(:game)

      expect(game.finished?).to be(false)
      expect(game.user).to eq(user)
      expect(response).to redirect_to(game_path(game))
      expect(flash[:notice]).to be
    end

    it '#show game' do
      get :show, params: { id: game_w_questions.id }
      game = assigns(:game) 
      expect(game.finished?).to be(false)
      expect(game.user).to eq(user)

      expect(response.status).to eq(200) 
      expect(response).to render_template('show')
    end

    it 'answers correct' do
      put :answer, params: { id: game_w_questions.id, letter: game_w_questions.current_game_question.correct_answer_key }
      game = assigns(:game)

      expect(game.finished?).to be(false)
      expect(game.current_level).to be > 0
      expect(response).to redirect_to(game_path(game))
      expect(flash.empty?).to be(true)
    end

    it '#show alien game' do
      alien_game = FactoryBot.create(:game_with_questions)

      get :show, params: { id: alien_game.id }

      expect(response.status).not_to eq(200)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to be
    end

    it 'takes money' do
      game_w_questions.update_attribute(:current_level, 2)

      put :take_money, params: { id: game_w_questions.id }
      game = assigns(:game)
      expect(game.finished?).to be(true)
      expect(game.prize).to eq(200)

      user.reload
      expect(user.balance).to eq(200)

      expect(response).to redirect_to(user_path(user))
      expect(flash[:warning]).to be
    end

    it 'try to create second game' do
      expect(game_w_questions.finished?).to be(false)
      expect { post :create }.to change(Game, :count).by(0)

      game = assigns(:game)
      expect(game).to be_nil

      expect(response).to redirect_to(game_path(game_w_questions))
      expect(flash[:alert]).to be
    end
  end
end
