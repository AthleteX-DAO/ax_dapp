import requests
import json

# from requests.sessions import _TextMapping

ATHLETES = []

active_list = [
    'T.Brady',
    'P.Mahomes',
    'J.Allen',
    'L.Jackson',
    'D.Adams',
    'S.Diggs',
    'C.Ridley',
    'D.Metcalf',
    'T.Hill',
    'D.Henry',
    'D.Cook',
    'D.Harris',
    'N.Harris'
]

host = 'http://54.38.139.134:9000'

class Athlete():
    def __init__(self, name):
        self.name = name
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
        id = self.name[-5:].replace('_', '')
        return (id, {"name": self.name[:-5].replace('_', ''), "history":self.history})

for athlete in active_list[:1]: 
    new_athlete = Athlete(athlete)      
    try:
        sql_query = f"select * from nfl where name = '{athlete}'" # loop through current athletes and select only the data one by one
        response = requests.post(host + '/exec', params={'query': sql_query})
        json_response = json.loads(response.text)
        rows = json_response['dataset']
        new_athlete.team, new_athlete.position = rows[0][1], rows[0][2]
        for row in rows:
            new_athlete.passingYards.append(row[3])
            new_athlete.passingTouchdowns.append(row[4])
            new_athlete.reception.append(row[5])
            new_athlete.receiveYards.append(row[6])
            new_athlete.receiveTouch.append(row[7])
            new_athlete.rushingYards.append(row[8])
            new_athlete.price.append(row[9])
            new_athlete.time.append(row[10])
        print(new_athlete.price)

    except requests.exceptions.RequestException as e:
        print("Error: %s" % (e))


# jsondata = []
# for athlete in ATHLETES:
#     id, json_data = athlete.make_dict()
#     jsondata.append(json_data)

# with open('../../assets/data.json', 'w') as f:
#     json.dump(jsondata, f)
    