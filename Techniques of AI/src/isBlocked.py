# -*-coding:utf-8 -* 

def isBlocked(map,posBox,width):
	# return 1 if the box is blocked, 0 if not
	# 1 = true
	# 0 = false
	
	i = posBox
		
	# only care about case where the box is blocked because of another box
	#since the others are avoided by the dead zones
	#by exemple             ##
        #                       $$

	
	if (map[i+1] == '$'):
		if ((map[i+1+width]=='#' and map[i+width]=='#') or (map[i+1-width]=='#' and map[i-width]=='#')):
			return 1
			
	if (map[i-1] == '$'):
		if ((map[i-1+width]=='#' and map[i+width]=='#') or (map[i-1-width]=='#' and map[i-width]=='#')):
			return 1
			
	if (map[i+width] == '$'):
		if ((map[i+1+width]=='#' and map[i+1]=='#') or (map[i-1+width]=='#' and map[i-1]=='#')):
			return 1
		
	if (map[i-width] == '$'):
		if ((map[i+1-width]=='#' and map[i+1]=='#') or (map[i-1-width]=='#' and map[i-1]=='#')):
			return 1
		

		
	return 0 # if all tests failed the box is not blocked,


