import requests
import json
import re

# from requests.sessions import _TextMapping

ATHLETES = []

with open('../../assets/nflAthletes.json', 'r') as athFile:
    data = athFile.read()

athJson = json.loads(data)

# list of abbreviated names
active_list = []
id_list = []

for ath in athJson:
    id_list.append(ath['id'])
    active_list.append(ath['name'])


# active_list = [
#     'T.Brady',
#     'P.Mahomes',
#     'J.Allen',
#     'L.Jackson',
#     'D.Adams',
#     'S.Diggs',
#     'C.Ridley',
#     'D.Metcalf',
#     'T.Hill',
#     'D.Henry',
#     'D.Cook',
#     'D.Harris',
#     'N.Harris'
# ]

host = 'http://54.38.139.134:9000'

class Athlete():
    def __init__(self, name):
        self.name = name
        self.id = 
        self.team = None
        self.position = None
        self.passingYards = []
        self.passingTouchdowns = []
        self.reception = []
        self.receiveYards = []
        self.receiveTouch = []
        self.rushingYards = []
        self.price = []
        self.time = []

    def make_dict(self):
        return (id, {"name": self.name, "team":self.team, "position":self.position, "passingYards":self.passingYards, "passingTouchdowns":self.passingTouchdowns, "reception":self.reception, "receiveYards":self.receiveYards, "receiveTouch":self.receiveTouch, "rushingYards":self.rushingYards, "price":self.price, "time":self.time})

for athlete in active_list: 
    new_athlete = Athlete(athlete)      
    try:
        sql_query = f"select * from nfl where name = '{athlete}'" # loop through current athletes and select only the data one by one
        response = requests.post(host + '/exec', params={'query': sql_query})
        json_response = json.loads(response.text)
        rows = json_response['dataset']
        # print(rows)
        new_athlete.team, new_athlete.position = rows[0][1], rows[0][2]
        for row in rows:
            new_athlete.passingYards.append(row[3])
            # print(row[3], 'passing yards')
            new_athlete.passingTouchdowns.append(row[4])
            # print(row[4], 'passing touch')
            new_athlete.reception.append(row[5])
            # print(row[5], 'reception')
            new_athlete.receiveYards.append(row[6])
            # print(row[6], 'receive yards')
            new_athlete.receiveTouch.append(row[7])
            # print(row[7], 'receive touch')
            new_athlete.rushingYards.append(row[8])
            # print(row[8], 'rushng yards')
            new_athlete.price.append(row[9])
            # print(row[9], 'price')
            new_athlete.time.append(row[10])
            # print(row[10], 'time')
        # print(new_athlete.name, new_athlete.price)

    except requests.exceptions.RequestException as e:
        print("Error: %s" % (e))
    
    ATHLETES.append(new_athlete)


jsondata = []
for athlete in ATHLETES:
    id, json_data = athlete.make_dict()
    jsondata.append(json_data)

with open('../../assets/data.json', 'w') as f:
    json.dump(jsondata, f)
    