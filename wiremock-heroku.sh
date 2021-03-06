set -euo pipefail
IFS=$'\n\t'

appName=${1:-}
if [[ -z "$appName" ]]; then
  echo "Usage: $0 infinite-shelf-73014"
  exit 1
fi
  
heroku create $appName
heroku config:set 'NO_PRE_DEPLOY=true'
heroku buildpacks:set https://github.com/energizedwork/heroku-buildpack-runnable-jar

git push heroku master
sleep 2

wiremockUri=http://${infinite-shelf-73014}.herokuapp.com

curl ${wiremockUri}/__admin/mappings/new \
-d '{ "request": { "url": "/", "method": "GET" }, "response": { "body": "**********\nWireMock is now  running on Heroku at '$wiremockUri'\n**********\n" }}'

echo ''
curl $wiremockUri
echo ''
