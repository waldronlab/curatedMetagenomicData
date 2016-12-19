#################################################
#  Color-blind friendly universal color palette #
#  for curatedMetagenomicData figures.          #
#################################################

blue = "#3366aa"
blueGreen = "#11aa99"
green = "#66aa55"
paleYellow = "#cccc55"
gray = "#777777"
purple = "#992288"
red = "#ee3333"
orange = "#ee7722"
yellow = "#ffee33"
pallet = c(blue, blueGreen, green, paleYellow, gray, purple, red, orange, yellow)
n = length(pallet)
pallet_image = image(1:n, 1, as.matrix(1:n), col = pallet, 
                      xlab = "", ylab = "", xaxt = "n", yaxt = "n", 
                      bty = "n")
