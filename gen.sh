#!/bin/sh
cat head.tpl > ${1%%.*}.html
cat $1 | pandoc -f markdown -t html >> ${1%%.*}.html
echo "  </body>\n</html>" >> ${1%%.*}.html
