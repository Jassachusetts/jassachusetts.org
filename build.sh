#!/bin/dash

gemtext_to_xhtml() {
	echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>'

	# get title
	i=0
	while IFS= read -r line; do
		case $line in
			"# "*) echo "\t<title>$line</title>" | sed 's/# //'
			break
			;;
			*)
		esac
	done< $1
	
	echo "\t<link rel=\"stylesheet\" href=\"style.css\"/>
</head>
<body>"
	while IFS= read -r line; do
		case $line in
			"# "*) echo "\t<h1>$line</h1>" | sed 's/# //' ;;
			"## "*) echo "\t<h2>$line</h2>" | sed 's/## //' ;;
			"### "*) echo "\t<h3>$line</h3>" | sed 's/### //' ;;
			"=> "*) 
				case $line in
					*".gif"*) echo "$line\"/>" | sed 's/=> /<img src=\"/' | sed "s/\t/\" alt=\"/" ;;
					*) echo "$line</a>" | sed 's/=> /<a href=\"/' | sed "s/\t/\">/" ;;
				esac ;;
			*) [ -z "$line" ] && echo '' || echo "\t<p>$line</p>" ;;
		esac
	done< $1
	echo "</body>\n</html>"
}

mkdir -p _site

for file in ./*; do
	[ ${file##*.} = 'gmi' ] && gemtext_to_xhtml $file > _site/"${file%.*}.xhtml" || [ -d $file ] || cp $file _site/
done
