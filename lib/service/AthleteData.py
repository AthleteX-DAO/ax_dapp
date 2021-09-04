import requests
import json

host = 'http://localhost:9000'

sql_query = "select * from nfl"

athletes = {}

try:
    response = requests.post(host + '/exec', params={'query': sql_query})
    json_response = json.loads(response.text)
    rows = json_response['dataset']
    for row in rows:
        if row[0] not in athletes:
            athletes[row[0]] = []
    for row in rows:
        athletes[row[0]].append([row[1], row[2]])

except requests.exceptions.RequestException as e:
  print("Error: %s" % (e))

with open('data.json', 'w') as f:
    json.dump(athletes, f)
    