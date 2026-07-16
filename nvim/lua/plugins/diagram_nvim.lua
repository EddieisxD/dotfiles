
return {
  {
    "3rd/diagram.nvim",
    dependencies = {
      "3rd/image.nvim",
    },
    opts = { -- basic configuration
      renderer_options = {
        mermaid = {
          background = nil, -- uses terminal bg or "white"
          theme = "dark",    -- "default", "dark", "forest", or "neutral"
        },
      },
    },
  }
}
