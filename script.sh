#!/bin/bash
apiKey="X-Okapi-Key: izWPOGosQPXl36l+xFS1r96jURMFgBkiPpypvgWX5IiDOYWzeWSIRipILA6xkic8"
ES_HOST=https://es.prod.okapi.laposte.io
esbuildpayload() {
  ES_SIZE=${1:-10}
  ES_DAYS=${2:-1}
  cat << EOL
  {
    "size": ${ES_SIZE},
    "query": {
      "bool": {
        "must": [
          {
            "term": {
              "type": "request"
            }
          },
          {
            "term": {
              "server": "api"
            }
          },
          {
            "term": {
              "apiName.raw": "Suivi"
            }
          },
          {
            "range": {
              "timestamp": {
                "gt": "now-${ES_DAYS}d/d",
                "lte": "now/d"
              }
            }
          }
        ]
      }
    }
  }
EOL
}

statusCode(){
 ES_SIZE=${1:-10}
 ES_DAYS=${2:-1}
 ES_PAYLOAD=$(esbuildpayload ${ES_SIZE} ${ES_DAYS})
 
echo ${ES_PAYLOAD} | \
   curl -XGET "${ES_HOST}/logstash-*/_search" \
     -d @- -s | \
   jq -r '[.hits.hits[]._source.statusCode] | sort | .[]'
}

 essearch() {
  ES_SIZE=${1:-10}
  ES_DAYS=${2:-1}
  ES_PAYLOAD=$(esbuildpayload ${ES_SIZE} ${ES_DAYS})
 

  echo ${ES_PAYLOAD} | \
    curl -XGET "${ES_HOST}/logstash-*/_search" \
      -d @- -s | \
    jq -r '[.hits.hits[]._source.url | capture("\/suivi\/v1\/(?<number>.{13})").number] | sort | .[]'
}

esserh(){
ES_SIZE=${1:-10}
ES_DAYS=${2:-1}
ES_EARCH=($(essearch ${ES_SIZE} ${ES_DAYS}))
message="Ce code produit n\'est pas valide."
for element in "${ES_EARCH[@]}"; do 
 curl -X GET "https://api.laposte.fr/suivi/v1/${element}" -H "$apiKey"  | \
jq '[.message] | map(select(. != "Aucun produit ne correspond à votre recherche")) | .[]'
  echo -e "\n"
done 
}
esserh 1 50
file_exist(){
ES_SIZE=${1:-10}
ES_DAYS=${2:-1}
content=$(esserh ${ES_SIZE} ${ES_DAYS})
name_file="numero_jour_${ES_DAYS}_size_${ES_SIZE}"
name_ls="`ls | grep '^[a-z_]*[0-9]\{2\}'`"


for element in "${name_ls[@]}"; do
  if [ "$element" != "$name_file" ]; 
   then
     echo "$content" > "$name_file"
     echo "fichier crée : $name_file"
   elif [ "$element" == "$name_file" ]; 
    then
	echo "rien du tous"
   	 	
   fi
done 
}

file_exist
