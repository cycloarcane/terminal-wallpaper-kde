#!/usr/bin/env python3
from flask import Flask, render_template_string
import subprocess
import threading
import time
import os
import re

app = Flask(__name__)

# Store the command output
command_output = []
stop_thread = False

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body {
            background-color: #000;
            color: #fff;
            margin: 0;
            padding: 0;
            overflow: hidden;
            width: 100vw;
            height: 100vh;
            display: flex;
        }
        #container {
            width: 100%;
            height: 100%;
            position: relative;
            overflow: hidden; 
            margin: 0;
            padding: 0;
        }
        pre {
            margin: 0;
            padding: 0;
            font-family: 'DejaVu Sans Mono', 'Courier New', monospace;
            /* Set a base font size that’s easy to read. Adjust as desired. */
            font-size: 16px; 
            line-height: 1.2;
            /* Let the text fill #container—no transform scaling. */
            white-space: pre;
        }
    </style>
</head>
<body>
    <div id="container">
        <pre id="output"></pre>
    </div>

    <script>
        // Poll for new output
        function updateOutput() {
            fetch('/output')
                .then(response => response.text())
                .then(data => {
                    document.getElementById('output').textContent = data;
                });
        }

        // Measure how many rows/columns fit in #container, then send to server
        function updateSize() {
            const container = document.getElementById('container');
            const pre = document.getElementById('output');

            // We can do a test character measure to see exact char width/height
            const testSpan = document.createElement('span');
            testSpan.textContent = 'X';
            testSpan.style.visibility = 'hidden';
            pre.appendChild(testSpan);
            const rect = testSpan.getBoundingClientRect();
            pre.removeChild(testSpan);

            // Each char's width & height
            const charWidth = rect.width;
            const charHeight = rect.height;

            // How many columns/rows fit within container
            const usableWidth = container.clientWidth;
            const usableHeight = container.clientHeight;
            const cols = Math.floor(usableWidth / charWidth);
            const rows = Math.floor(usableHeight / charHeight);

            // Send new rows/cols to server to resize tmux
            fetch('/resize', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ rows, cols })
            })
            .then(() => {
                // (Optional) You can immediately refresh output if you want
                updateOutput();
            });
        }

        function init() {
            updateSize();
            updateOutput();
            // Poll the output every couple seconds
            setInterval(updateOutput, 2000);
        }

        window.addEventListener('load', init);
        window.addEventListener('resize', updateSize);
    </script>
</body>
</html>

"""

# Store current terminal size
term_size = {'rows': 60, 'cols': 240}  # Increased default size

def clean_ansi(text):
    """Remove ANSI escape sequences"""
    ansi_escape = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
    return ansi_escape.sub('', text)

def run_command(command):
    global command_output, stop_thread, term_size
    
    # Create unique tmux session name
    session_name = f"wallpaper_{os.getpid()}"
    
    while not stop_thread:
        try:
            # Start new tmux session with current size
            subprocess.run([
                'tmux', 'new-session', '-d', '-x', str(term_size['cols']), 
                '-y', str(term_size['rows']), '-s', session_name
            ])
            
            # Set tmux options
            subprocess.run(['tmux', 'set', '-t', session_name, 'status', 'off'])
            subprocess.run(['tmux', 'set', '-t', session_name, 'history-limit', '50'])
            subprocess.run(['tmux', 'set', '-t', session_name, 'wrap-search', 'off'])
            
            # Set specific terminal type and encoding
            env = os.environ.copy()
            env['TERM'] = 'xterm-256color'
            env['LANG'] = 'en_US.UTF-8'
            env['LC_ALL'] = 'en_US.UTF-8'
            env['COLUMNS'] = str(term_size['cols'])
            env['LINES'] = str(term_size['rows'])
            
            # Start the command with environment
            subprocess.run([
                'tmux', 'send-keys', '-t', session_name,
                f'export TERM=xterm-256color LANG=en_US.UTF-8 COLUMNS={term_size["cols"]} LINES={term_size["rows"]}; {command}',
                'Enter'
            ])
            
            while not stop_thread:
                try:
                    # Resize tmux window if needed
                    subprocess.run([
                        'tmux', 'resize-window', '-t', session_name,
                        '-x', str(term_size['cols']), '-y', str(term_size['rows'])
                    ])
                    
                    # Capture tmux pane content
                    result = subprocess.run(
                        ['tmux', 'capture-pane', '-e', '-p', '-t', session_name],
                        capture_output=True,
                        text=True,
                        env=env
                    )
                    
                    if result.stdout:
                        # Clean and store the output
                        cleaned_lines = clean_ansi(result.stdout).splitlines()
                        # Remove empty lines at the end
                        while cleaned_lines and not cleaned_lines[-1].strip():
                            cleaned_lines.pop()
                        command_output.clear()
                        command_output.extend(cleaned_lines)
                    
                    time.sleep(0.3)
                    
                except Exception as e:
                    print(f"Error capturing output: {e}")
                    break
            
            # Clean up tmux session
            subprocess.run(['tmux', 'kill-session', '-t', session_name])
            
            if stop_thread:
                break
                
            time.sleep(1)
            
        except Exception as e:
            print(f"Error in command execution: {e}")
            try:
                subprocess.run(['tmux', 'kill-session', '-t', session_name])
            except:
                pass
            time.sleep(5)

@app.route('/')
def index():
    print("Template update test")  # Add this line
    return render_template_string(HTML_TEMPLATE)




@app.route('/output')
def output():
    return '\n'.join(command_output)

@app.route('/resize', methods=['POST'])
def resize():
    global term_size
    from flask import request, jsonify
    
    data = request.json
    term_size['rows'] = max(60, min(data.get('rows', 60), 200))
    term_size['cols'] = max(120, min(data.get('cols', 120), 300))
    return jsonify({'status': 'ok'})

def main(command):
    global stop_thread
    
    # Start the command thread
    command_thread = threading.Thread(target=run_command, args=(command,))
    command_thread.daemon = True
    command_thread.start()
    
    try:
        # Run the Flask app
        app.run(host='localhost', port=8484)
    finally:
        # Cleanup
        stop_thread = True
        command_thread.join(timeout=1)

if __name__ == '__main__':
    import sys
    if len(sys.argv) < 2:
        print("Usage: ./terminal_wallpaper.py <command>")
        sys.exit(1)
    
    main(' '.join(sys.argv[1:]))
