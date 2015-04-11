using SFML

music = Music("music.ogg")

set_loop(music, true)
play(music)
playing = true

println("Press 'p' to pause and resume")
println("Press escape to quit")

while true
	sleep(0.1)
	
	if is_key_pressed(KeyCode.ESCAPE)
		stop(music)
		destroy(music)
		exit(0)
	end

	if is_key_pressed(KeyCode.P)
		if !playing
			play(music)
		else
			pause(music)
		end
		playing = !playing
	end
end