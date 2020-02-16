extends Label

var g_score = 0

func increment_score():
	g_score += 1
	text = str(g_score)
