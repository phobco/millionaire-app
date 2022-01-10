require 'rails_helper'
require 'support/my_spec_helper'

RSpec.describe Game, type: :model do
  let(:user) { FactoryBot.create(:user) }

  let(:game_w_questions) do
    FactoryBot.create(:game_with_questions, user: user)
  end

  context 'Game Factory' do
    it 'Game.create_game! new correct game' do
      generate_questions(60)

      game = nil

      expect {
        game = Game.create_game_for_user!(user)
      }.to change(Game, :count).by(1).and(
        change(GameQuestion, :count).by(15).and(
          change(Question, :count).by(0)
        )
      )

      expect(game.user).to eq(user)
      expect(game.status).to eq(:in_progress)

      expect(game.game_questions.size).to eq(15)
      expect(game.game_questions.map(&:level)).to eq (0..14).to_a
    end
  end

  context 'game mechanics' do
    it 'answer correct continues game' do
      level = game_w_questions.current_level
      q = game_w_questions.current_game_question
      expect(game_w_questions.status).to eq(:in_progress)

      game_w_questions.answer_current_question!(q.correct_answer_key)

      expect(game_w_questions.current_level).to eq(level + 1)
      expect(game_w_questions.current_game_question).not_to eq(q)

      expect(game_w_questions.status).to eq(:in_progress)
      expect(game_w_questions.finished?).to be_falsey
    end

    it 'take_money! finishes the game' do
      q = game_w_questions.current_game_question
      game_w_questions.answer_current_question!(q.correct_answer_key)

      game_w_questions.take_money!

      prize = game_w_questions.prize
      expect(prize).to be > 0

      expect(game_w_questions.status).to eq :money
      expect(game_w_questions.finished?).to be_truthy
      expect(user.balance).to eq prize
    end

    it '.current_game_question' do
      expect(game_w_questions.current_game_question).to be_a(GameQuestion)
    end

    it '.previous_level' do
      expect(game_w_questions.previous_level).to eq(game_w_questions.current_level - 1)
    end
  end

  describe '.status' do
    context 'when the game is finished' do
      before(:each) do
        game_w_questions.finished_at = Time.now
        expect(game_w_questions.finished?).to be_truthy
      end
      
      it 'finishes game with a fail status' do
        game_w_questions.is_failed = true
        expect(game_w_questions.status).to eq(:fail)
      end

      it 'finishes the game with timeout status' do
        game_w_questions.created_at = 1.hour.ago
        game_w_questions.is_failed = true
        expect(game_w_questions.status).to eq(:timeout)
      end
      
      it 'finishes game with won status' do
        game_w_questions.current_level = Question::QUESTION_LEVELS.max + 1
        expect(game_w_questions.status).to eq(:won)
      end
    
      it 'finishes game with money status' do
        expect(game_w_questions.status).to eq(:money)
      end
    end
  end

  describe '.answer_current_question!' do
    context 'when answer is correct' do
      let(:q) { game_w_questions.current_game_question }
      
      it 'continues the game with in_progress status' do
        expect(game_w_questions.answer_current_question!('d')).to eq(true)
        expect(game_w_questions.status).to eq(:in_progress)
        expect(game_w_questions.finished?).to be(false)
      end

      context 'and the question is last' do
        it 'finishes the game with won status' do
          game_w_questions.current_level = Question::QUESTION_LEVELS.max
          game_w_questions.answer_current_question!(q.correct_answer_key)

          expect(game_w_questions.status).to eq(:won)
          expect(game_w_questions.finished?).to be(true)
        end

        it 'assigns the maximum prize' do
          game_w_questions.current_level = Question::QUESTION_LEVELS.max
          game_w_questions.answer_current_question!(q.correct_answer_key)

          expect(game_w_questions.prize).to eq(Game::PRIZES.last)
        end
      end
    
      context 'and the time is out' do
        it 'finishes game with a timeout status' do
          game_w_questions.created_at = 36.minutes.ago
          
          expect(game_w_questions.answer_current_question!('d')).to eq(false)
          expect(game_w_questions.status).to eq(:timeout)
          expect(game_w_questions.finished?).to be(true)
        end
      end
    end

    context 'when answer is incorrect' do
      it 'finishes the game with fail status' do
        expect(game_w_questions.answer_current_question!('a')).to eq(false)
        expect(game_w_questions.status).to eq(:fail)
        expect(game_w_questions.finished?).to be(true)
      end
    end
  end
end
