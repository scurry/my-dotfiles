# show number of files in each directory sorted by max files for top 10
# https://unix.stackexchange.com/questions/122854/find-the-top-50-directories-containing-the-most-files-directories-in-their-first

sudo ls -AiR1U $1 | 
sed -rn '/^[./]/{h;n;};G;
    s|^ *([0-9][0-9]*)[^0-9][^/]*([~./].*):|\1:\2|p' | 
sort -t : -uk1.1,1n |
cut -d: -f2 | sort -V |
uniq -c |sort -rn | head -n10
