extends AudioStreamPlayer

func play_music(new_music: AudioStream):
	if stream == new_music and playing:
		return

	stream = new_music
	play()

func stop_music():
	stop()
