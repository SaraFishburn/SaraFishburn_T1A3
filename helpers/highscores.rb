# frozen_string_literal: true

# Method to check if the final score is high enough to place on the highscores board
def places?(final_score, highscores)
  return true if final_score > highscores[-1]['score'].to_i

  false
end

# Method to find the position in the score array that the final score should be placed
def find_position(final_score, highscores)
  # Only look for the position if the final score is elegible
  return unless places?(final_score, highscores)

  position = 0
  # Loop through the highscores array until the final score is no longer smaller than a score on the board
  highscores.each_with_index do |row, i|
    next if final_score < row['score'].to_i

    position = i
    break
  end
  position
end

# Method to insert the final score into the highscores array and write to json file
def insert_score(final_score, file, highscores, initials)
  # Insert the final score at the correct position in the array
  highscores.insert(find_position(final_score, highscores), { 'name' => initials, 'score' => final_score.to_s })

  # Remove the last score on the board so the array only contains the top 10
  highscores.delete_at(-1)
  File.write(file, JSON.dump(highscores))
end

# Resets the highscores array to default empty state (for testing purposes)
def reset_json(file, highscores)
  highscores.each do |row|
    row['name'] = '---'
    row['score'] = '000'
  end

  # Write array to json file
  File.write(file, JSON.dump(highscores))
end

# Populates an empty json file with a new empty highscores array
def create_json(empty_file)
  highscores_array = []
  10.times do
    highscores_array += [{ name: '---', score: '000' }]
  end
  File.write(empty_file, JSON.dump(highscores_array))
end
