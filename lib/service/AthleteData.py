import requests
import json

host = 'http://localhost:9000'

sql_query = "select * from nfl"

class Athlete():
    def __init__(self, name):
        self.name = name
        self.time = []
        self.war = []

    def add_data(self, time, war):
        self.time.append(time)
        self.war.append(war)

    def make_dict(self):
        id = self.name[-5:].replace('_', '')
        # return (id, {"name": self.name[:-5].replace('_', '')})
        return (id, {"name": self.name[:-5].replace('_', ''), "time":self.time, "war":self.war})

ATHLETES = []

def is_Active(ATHLETES, name):
    for athlete in ATHLETES:
        if athlete.name == name:
            return True
    return False

def append_Data(ATHLETES, name, time, war):
    for athlete in ATHLETES:
        if athlete.name == name:
            athlete.add_data(time, war)

try:
    response = requests.post(host + '/exec', params={'query': sql_query})
    json_response = json.loads(response.text)
    rows = json_response['dataset']
    
    for row in rows: # create athlete objects
        if is_Active(ATHLETES, row[0]) == False:
            new_entry = Athlete(row[0])
            ATHLETES.append(new_entry)
    for row in rows: # append historical data
        append_Data(ATHLETES, row[0], row[2], row[1])
        
except requests.exceptions.RequestException as e:
  print("Error: %s" % (e))

jsondata = []
for athlete in ATHLETES:
    id, json_data = athlete.make_dict()
    jsondata.append(json_data)

with open('../../assets/data.json', 'w') as f:
    json.dump(jsondata, f)
    