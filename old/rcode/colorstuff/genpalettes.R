library(vcd)

pal <- function(col, border = "light gray", ...) {
  n <- length(col)
  plot(0, 0, type = "n", xlim = c(0, 1), ylim = c(0, 1),
       axes = FALSE, xlab = "", ylab = "", ...)
  rect(0:(n-1)/n, 0, 1:n/n, 1, col = col, border = border)
}

pal(c("#BF6363", "#5DD8A3", "#589DB9", "#B4D05A", "#BD8C3B", "#B586B6", "#527E49"))

# qualitative palettes
pal(rainbow_hcl(4, start =  30, end = 300))
pal(rainbow_hcl(4, start =  60, end = 240))
pal(rainbow_hcl(4, start = 270, end = 150))
pal(rainbow_hcl(4, start =  90, end = -30))

# sequential palettes
pal(sequential_hcl(12, c = 0, power = 2.2))
pal(sequential_hcl(12, power = 2.2))
pal(heat_hcl(12, c = c(80, 30), l = c(30, 90), power = c(1/5, 2)))
pal(terrain_hcl(12, c = c(65, 0), l = c(45, 90), power = c(1/2, 1.5)))
pal(heat_hcl(12, h = c(0, -100), l = c(75, 40), c = c(40, 80), power = 1))

# diverging palettes
pal(diverge_hcl(7))
pal(diverge_hcl(7, c = 100, l = c(50, 90), power = 1))
pal(diverge_hcl(7, h = c(130, 43), c = 100, l = c(70, 90)))
pal(diverge_hcl(7, h = c(180, 330), c = 59, l = c(75, 95)))

