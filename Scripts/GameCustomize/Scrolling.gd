extends ScrollContainer

#this is only here because I can't get this stupid logic to work in other scenes lol

func ScrollDown():
	await get_tree().process_frame
	scroll_vertical = get_v_scroll_bar().max_value
