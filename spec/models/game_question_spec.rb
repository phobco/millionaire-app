require 'rails_helper'

RSpec.describe GameQuestion, type: :model do
  let(:game_question) do
    FactoryBot.create(:game_question, a: 2, b: 1, c: 4, d: 3)
  end

  context 'game status' do
    it 'correct .variants' do
      expect(game_question.variants).to eq(
        'a' => game_question.question.answer2,
        'b' => game_question.question.answer1,
        'c' => game_question.question.answer4,
        'd' => game_question.question.answer3
      )
    end

    it 'correct .answer_correct?' do
      expect(game_question.answer_correct?('b')).to be(true)
    end

    it 'correct .level & .text delegates' do
      expect(game_question.text).to eq(game_question.question.text)
      expect(game_question.level).to eq(game_question.question.level)
    end

    it 'correct .correct_answer_key' do
      expect(game_question.correct_answer_key).to eq('b')
    end

    it 'correct .help_hash' do
      expect(game_question.help_hash).to eq({})

      game_question.help_hash[:some_key1] = 'value1'
      game_question.help_hash['some_key2'] = 'value2'

      expect(game_question.save).to be(true)

      gq = GameQuestion.find(game_question.id)

      expect(gq.help_hash).to eq({some_key1: 'value1', 'some_key2' => 'value2'})
    end
  end

  context 'user helpers' do
    it 'correct audience_help' do
      expect(game_question.help_hash).not_to include(:audience_help)

      game_question.add_audience_help

      expect(game_question.help_hash).to include(:audience_help)

      ah = game_question.help_hash[:audience_help]
      expect(ah.keys).to contain_exactly('a', 'b', 'c', 'd')
    end
  end

  it 'correct fifty_fifty' do
    expect(game_question.help_hash).not_to include(:fifty_fifty)
    game_question.add_fifty_fifty
  
    expect(game_question.help_hash).to include(:fifty_fifty)
    ff = game_question.help_hash[:fifty_fifty]
  
    expect(ff).to include('b')
    expect(ff.size).to eq(2)
  end

  describe '#add_friend_call' do
    it 'has empty key before use' do
      expect(game_question.help_hash).not_to include(:friend_call)
    end

    context 'when the user call friend help' do
      before { game_question.add_friend_call }
      
      it 'include the key after use' do
        expect(game_question.help_hash).to include(:friend_call)
      end

      it 'displays a correct friend call help phrase' do
        friend_call = game_question.help_hash[:friend_call]

        expect(friend_call).to match('считает, что это вариант')
      end

      it 'contain one of keys' do
        friend_call = game_question.help_hash[:friend_call]

        expect(friend_call.last).to match(/[ABCD]/)
      end
    end
  end
end
