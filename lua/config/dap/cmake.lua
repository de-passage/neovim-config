return {
  configurations = {
    {
      name = "Build",
      type = "cmake",
      launch = "launch"
    }
  },
  adapters = {
    cmake = {
      type       = "pipe",
      pipe       = "${pipe}",
      executable = {
        command = "cmake",
        args = { "--debugger", "--debugger-pipe", "${pipe}", "--debugger-dap-log", require 'workspace'.data_directory .. 'cmake.log' },
      }
    }
  }
}
