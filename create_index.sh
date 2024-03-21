#!/bin/bash
# Copyright (c) 2024 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


# Directory to scan
root_dir="./staging"

# Function to generate HTML index for a directory
generate_html_index() {
    local dir_path=$1
    local html_path="${dir_path}/index.html"

    # Start the HTML file
    echo "<html><body><h1>Index of ${dir_path}</h1><ul>" > "$html_path"

    # Find and process all files in the directory matching the patterns
    find "$dir_path" -maxdepth 1 \( -name "*.ttl" -o -name "*.jsonld" -o -name "*.txt" \) -not -type d -print0 | while IFS= read -r -d $'\0' file; do
        # Check if the file is a symbolic link
        if [ -L "$file" ]; then
            # It's a symbolic link, resolve it and compute the relative path
            local target=$(readlink -f "$file")
            local rel_target=$(realpath --relative-to="$dir_path" "$target")
            echo "<li><a href='$rel_target'>$(basename "$file")</a> (Symbolic Link)</li>" >> "$html_path"
        else
            # It's a regular file, just add it to the index
            echo "<li><a href='$(basename "$file")'>$(basename "$file")</a></li>" >> "$html_path"
        fi
    done

    # Finish the HTML file
    echo "</ul></body></html>" >> "$html_path"
}

# Export the function so it's available in subshells spawned by find
export -f generate_html_index

# Find all directories under the root directory and generate an HTML index for each
find "$root_dir" -type d -exec bash -c 'generate_html_index "$0"' {} \;
