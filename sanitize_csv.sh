#!/bin/bash

sanitize() {
    sanitized_url=$(echo "$1" | sed 's/[^a-zA-Z0-9\/:-]//g')
    sanitized_title=$(echo "$2" | sed 's/[^a-zA-Z0-9[:space:]-]//g')
    echo "$sanitized_url,$sanitized_title"
}

process_csv() {
    input_file="$1"
    output_file="$2"

    overview=""
    campus=""
    courses=""
    scholarships=""
    admission=""
    placements=""
    results=""

    while IFS=, read -r url title; do
        sanitized=$(sanitize "$url" "$title")
        sanitized_url=$(echo "$sanitized" | cut -d',' -f1)
        sanitized_title=$(echo "$sanitized" | cut -d',' -f2)

        if [[ $sanitized_url == *"ai"* ]]; then
            overview+=",$sanitized_title"
        elif [[ $sanitized_url == *"php"* ]]; then
            campus+=",$sanitized_title"
            courses+=",$sanitized_title"
            scholarships+=",$sanitized_title"
            admission+=",$sanitized_title"
        elif [[ $sanitized_url == *"python"* ]]; then
            courses+=",$sanitized_title"
            scholarships+=",$sanitized_title"
            placements+=",$sanitized_title"
            results+=",$sanitized_title"
        else
            echo "Unknown category found: $sanitized_url"
        fi
    done < "$input_file"

    echo "URL,overview,campus,courses,scholarships,admission,placements,results" > "$output_file"
    echo "https://example.com/data/ai$overview" | tr -d '\r' >> "$output_file"
    echo "https://example.com/data/php$campus$courses$scholarships$admission" | tr -d '\r' >> "$output_file"
}


if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input_csv output_csv"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Input file not found!"
    exit 1
fi

process_csv "$1" "$2"

echo "CSV data processed successfully."
