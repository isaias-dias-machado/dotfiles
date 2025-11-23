#!/usr/bin/env python3
"""
Convert snipmate snippets to blink.cmp JSON format
"""
import re
import json

def parse_snipmate_snippet(snippet_text):
    """
    Parse a single snipmate snippet into a dict with prefix and body.
    
    Snipmate format:
    snippet prefix description
        body line 1
        body line 2
    """
    lines = snippet_text.strip().split('\n')
    if not lines or not lines[0].startswith('snippet '):
        return None
    
    # Parse the first line: "snippet prefix optional description"
    first_line = lines[0]
    parts = first_line.split(None, 2)  # Split on whitespace, max 3 parts
    
    if len(parts) < 2:
        return None
    
    prefix = parts[1]
    description = parts[2] if len(parts) > 2 else ""
    
    # Get the body lines (everything after the first line)
    # Remove the leading tab from each line
    body_lines = []
    for line in lines[1:]:
        # Remove one leading tab if present
        if line.startswith('\t'):
            body_lines.append(line[1:])
        elif line.startswith('    '):  # Handle spaces if used instead of tabs
            body_lines.append(line[4:])
        else:
            body_lines.append(line)
    
    # Process ${VISUAL} - convert to a placeholder or remove
    # Also handle ${n:${VISUAL}} patterns
    processed_lines = []
    for line in body_lines:
        # Replace ${n:${VISUAL}} with just ${n}
        line = re.sub(r'\$\{(\d+):?\$\{VISUAL\}\}', r'${\1}', line)
        # Replace standalone ${VISUAL} with empty string (user can edit)
        line = re.sub(r'\$\{VISUAL\}', '', line)
        processed_lines.append(line)
    
    return {
        'prefix': prefix,
        'body': processed_lines,
        'description': description
    }

def convert_snipmate_file(content):
    """
    Convert entire snipmate file to JSON format for blink.cmp.
    """
    # Split by "snippet " to get individual snippets
    # But be careful not to split on "snippet" in the middle of text
    snippet_pattern = r'^snippet\s+'
    
    snippets = {}
    current_snippet = []
    snippet_name = None
    prefix_counts = {}  # Track how many times we've seen each prefix
    
    for line in content.split('\n'):
        if re.match(snippet_pattern, line):
            # Save previous snippet if exists
            if current_snippet:
                snippet_text = '\n'.join(current_snippet)
                parsed = parse_snipmate_snippet(snippet_text)
                if parsed and snippet_name:
                    # Create unique key if we've seen this prefix before
                    base_name = snippet_name
                    if snippet_name in prefix_counts:
                        prefix_counts[snippet_name] += 1
                        snippet_name = f"{base_name}_{prefix_counts[snippet_name]}"
                    else:
                        prefix_counts[snippet_name] = 1
                    
                    snippets[snippet_name] = {
                        'prefix': parsed['prefix'],
                        'body': parsed['body']
                    }
                    if parsed['description']:
                        snippets[snippet_name]['description'] = parsed['description']
            
            # Start new snippet
            current_snippet = [line]
            # Use the prefix as the snippet name
            parts = line.split(None, 2)
            snippet_name = parts[1] if len(parts) > 1 else None
        else:
            if current_snippet or line.strip():  # Skip leading empty lines
                current_snippet.append(line)
    
    # Don't forget the last snippet
    if current_snippet:
        snippet_text = '\n'.join(current_snippet)
        parsed = parse_snipmate_snippet(snippet_text)
        if parsed and snippet_name:
            # Create unique key if we've seen this prefix before
            base_name = snippet_name
            if snippet_name in prefix_counts:
                prefix_counts[snippet_name] += 1
                snippet_name = f"{base_name}_{prefix_counts[snippet_name]}"
            else:
                prefix_counts[snippet_name] = 1
            
            snippets[snippet_name] = {
                'prefix': parsed['prefix'],
                'body': parsed['body']
            }
            if parsed['description']:
                snippets[snippet_name]['description'] = parsed['description']
    
    return snippets

# Test with a few examples
test_snippets = """snippet ot
\t{
\t\t${0}
\t}
snippet put IO.puts
\tIO.puts("${0}")
snippet if if .. do .. end
\tif ${1} do
\t\t${0:${VISUAL}}
\tend"""

if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1:
        # Read from file
        input_file = sys.argv[1]
        output_file = sys.argv[2] if len(sys.argv) > 2 else input_file.replace('.snippets', '.json')
        
        with open(input_file, 'r') as f:
            content = f.read()
        
        # Remove "extends" lines as they're not needed in JSON format
        lines = content.split('\n')
        filtered_lines = [line for line in lines if not line.startswith('extends ')]
        content = '\n'.join(filtered_lines)
        
        result = convert_snipmate_file(content)
        
        with open(output_file, 'w') as f:
            json.dump(result, f, indent=2)
        
        print(f"Converted {len(result)} snippets from {input_file} to {output_file}")
    else:
        # Test mode
        print("Testing conversion with sample snippets...")
        print("=" * 60)
        
        result = convert_snipmate_file(test_snippets)
        print(json.dumps(result, indent=2))
