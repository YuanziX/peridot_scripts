# unified function to download
download() {
    local url=$1
    local output=$2
    
    if [ -f "$output" ]; then
        echo "$output file already exists, skipping download."
    else
        curl -L -o "$output" "$url"
    fi
}

# List of Recovery URLs
recoveries=(
    "https://sourceforge.net/projects/peridot-release/files/recovery/TWRP_A15_POCOF6.img/download"
    "https://sourceforge.net/projects/crdroid/files/peridot/11.x/recovery/recovery.img/download"
)

# clear old recoveries.list
> recoveries.list

# loop through recovery urls and download them as projectName_fileName
for recovery in "${recoveries[@]}"; do
    file_name=$(echo "$recovery" | sed -n 's#.*/projects/\([^/]*\)/.*files/.*/\([^/]*\)/download#\1_\2#p')
    echo "$file_name" >> recoveries.list
    download "$recovery" "$file_name"
done

# create flashable zip
mkdir -p flashable
cp *.img flashable/
cp recoveries.list flashable/
cp -r META-INF flashable/
cd flashable
zip -r ../flashable_recovery.zip *
cd ..
rm -rf flashable
