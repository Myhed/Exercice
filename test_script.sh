#!/bin/bash
function getMessage(){
NUM_COLIS=${1:-1}
curl -XGET "https://api.laposte.fr/suivi/v1/8R31328640593" -H "X-Okapi-Key: izWPOGosQPXl36l+xFS1r96jURMFgBkiPpypvgWX5IiDOYWzeWSIRipILA6xkic8" -s \ |
jq '[.message] | .[]'
}
getMessage
function getLs(){
 
#PATHS=${1:-~}
if [ "$PATHS" != " " ]
then 
REGXP=${1:-}
PATHS=${2:-~}
echo $PATHS
else 
PATHS=${1:-~}
REGEXP=${2:-}
fi


command=`ls -a $PATHS`
for elements in "${command[@]}"; do
echo "$elements\n"| grep $REGXP
done
}
