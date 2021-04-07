require 'csv'

scoreboard = CSV.parse(File.read('scoreboard.csv'), headers: true)