local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  height = 40,
  color = colors.bar.bg,
  padding_right = 5,
  padding_left = 5,
  topmost = true,
  blur_radius = 5,
})
