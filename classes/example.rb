FPS = 60

loop do
  start_time = Time.now
  # Do stuff
  sleep([0, (1 / FPS) - (Time.now - start_time)].max)
end
