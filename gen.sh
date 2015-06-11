#!/bin/sh
cat head.html > ${1%%.*}.html
cat $1 | pandoc -f markdown+lhs -t html >> ${1%%.*}.html
echo "  </body>\n</html>" >> ${1%%.*}.html
