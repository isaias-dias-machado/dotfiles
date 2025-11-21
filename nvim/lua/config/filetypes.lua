vim.filetype.add({
  extension = {
    j2 = "jinja",
  },
  pattern = {
    [".*%.yaml%.ansible"] = "yaml",
    [".*%.yml%.ansible"] = "yaml",
  },
})
