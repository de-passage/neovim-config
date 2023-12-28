local nf = require('nightfox')

local specs = {
}

local groups = {
  all = {
    NormalFloat = { bg = "bg1"},
    FloatBorder = { bg = "bg1"},
  }
}

local palettes = {
}

nf.setup {
  groups = groups,
  specs = specs,
  palettes = palettes,
  options = {
    dim_inactive = true
  }
}
