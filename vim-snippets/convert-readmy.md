# Snipmate to Blink.cmp Conversion

## Summary

Successfully converted **125 Elixir snippets** from snipmate format to blink.cmp JSON format.

## Conversion Process

### Regex Patterns Used

The conversion script uses the following key patterns:

1. **Snippet detection**: `^snippet\s+` - Matches lines starting with "snippet" followed by whitespace
2. **Visual selection removal**: `\$\{(\d+):?\$\{VISUAL\}\}` → `${\1}` - Converts visual selections to regular tabstops
3. **Standalone VISUAL**: `\$\{VISUAL\}` → `` (empty) - Removes standalone visual markers

### Key Changes

1. **Format**: Converted from snipmate's indented format to JSON with "prefix" and "body" array
2. **Visual selections**: `${VISUAL}` removed since blink.cmp doesn't have direct equivalent
3. **Duplicate prefixes**: Handled by creating unique keys (e.g., `put` and `put_2`) while preserving the same prefix value
4. **Vim functions**: Preserved as-is (e.g., backtick expressions in `defmo` snippet) - these become literal text in blink.cmp
5. **Descriptions**: Preserved from snipmate comments as JSON "description" field

## Notable Conversions

### Simple snippet
**Before (snipmate)**:
```
snippet put IO.puts
	IO.puts("${0}")
```

**After (JSON)**:
```json
{
  "put": {
    "prefix": "put",
    "body": [
      "IO.puts(\"${0}\")"
    ],
    "description": "IO.puts"
  }
}
```

### Complex multi-line snippet
**Before (snipmate)**:
```
snippet genserver basic genserver structure
	use GenServer

	@doc false
	def start_link(init_args) do
		GenServer.start_link(__MODULE__, init_args, name: __MODULE__)
	end

	@impl true
	def init(state) do
		{:ok, state}
	end
```

**After (JSON)**:
```json
{
  "genserver": {
    "prefix": "genserver",
    "body": [
      "use GenServer",
      "",
      "@doc false",
      "def start_link(init_args) do",
      "\tGenServer.start_link(__MODULE__, init_args, name: __MODULE__)",
      "end",
      "",
      "@impl true",
      "def init(state) do",
      "\t{:ok, state}",
      "end"
    ],
    "description": "basic genserver structure"
  }
}
```

## Duplicate Prefixes Handled

The following snippets had duplicate prefixes and were renamed:
- `put` → `put` (IO.puts) and `put_2` (PUT route)
- `res` → `res` (resources route) and `res_2` (resource route)

Both versions are available with the same trigger prefix, so typing "put" will show both options.

## Installation

Place the `elixir.json` file in your Neovim snippets directory:

```bash
mkdir -p ~/.config/nvim/snippets
cp elixir.json ~/.config/nvim/snippets/
```

Or if you want to use a custom location, configure blink.cmp:

```lua
require('blink.cmp').setup {
  sources = {
    providers = {
      snippets = {
        opts = {
          search_paths = { "/path/to/your/snippets" }
        }
      }
    }
  }
}
```

## Testing Results

All snippets were successfully converted and tested:
- ✅ Simple single-line snippets (e.g., `t1`, `t2`)
- ✅ Multi-line snippets with indentation (e.g., `genserver`, `super`)
- ✅ Snippets with special characters and quotes (e.g., `lv` with ~H heredoc)
- ✅ Snippets with nested tabstops (e.g., `defs`, `defsd`)
- ✅ Phoenix-specific snippets (e.g., `pipel`, `live`, `controller`)

## Reusable Converter

The `convert_snippets.py` script can be used to convert other snipmate files:

```bash
python3 convert_snippets.py input.snippets output.json
```

The script handles:
- Tab/space indentation normalization
- `${VISUAL}` removal/conversion
- Duplicate prefix detection
- Description preservation
- Multi-line bodies with proper escaping
