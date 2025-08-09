#!/bin/bash

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <binary1> <binary2>"
    exit 1
fi

binary1=$1
binary2=$2

# Create output directory
output_dir="comparison_results"
mkdir -p $output_dir

# Compare symbols
nm $binary1 > $output_dir/symbols_bin1.txt
nm $binary2 > $output_dir/symbols_bin2.txt
diff $output_dir/symbols_bin1.txt $output_dir/symbols_bin2.txt > $output_dir/diff_symbols.txt

# Compare sizes
size $binary1 > $output_dir/size_bin1.txt
size $binary2 > $output_dir/size_bin2.txt
diff $output_dir/size_bin1.txt $output_dir/size_bin2.txt > $output_dir/diff_size.txt

# Compare sections
readelf -S $binary1 > $output_dir/sections_bin1.txt
readelf -S $binary2 > $output_dir/sections_bin2.txt
diff $output_dir/sections_bin1.txt $output_dir/sections_bin2.txt > $output_dir/diff_sections.txt

# Compare headers
readelf -h $binary1 > $output_dir/headers_bin1.txt
readelf -h $binary2 > $output_dir/headers_bin2.txt
diff $output_dir/headers_bin1.txt $output_dir/headers_bin2.txt > $output_dir/diff_headers.txt

echo "Comparison results are saved in the '$output_dir' directory."
