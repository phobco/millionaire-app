class GameHelpGenerator
  TOTAL_WATCHERS = 100

  # Returns a hash with an array of keys
  def self.audience_distribution(keys, correct_key)
    result_array = []

    keys.each do |key|
      if key == correct_key
        result_array << rand(45..90)
      else
        result_array << rand(1..60)
      end
    end

    sum = result_array.sum
    result_array.map! { |v| TOTAL_WATCHERS * v / sum }

    Hash[keys.zip(result_array)]
  end

  # Returns a hint string
  def self.friend_call(keys, correct_key)
    # Choose wright key with 80% probability.
    key = (rand(10) > 2) ? correct_key : keys.sample

    I18n.t(
      'game_help.friend_call', variant: key.upcase,
      name: I18n.t('game_help.friends').sample
    )
  end
end
