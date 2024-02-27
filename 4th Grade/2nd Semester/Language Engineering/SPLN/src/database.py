from pymongo import MongoClient
from radio import Radio
from program import Program
import datetime
import streamlit as st

class BD:
    def __init__(self, client, collection="radio"):
        self.client = client
        self.db = self.client.radios
        self.collection = collection

    
    def checkUpdate(self):
        # drop if day is different
        col = self.db["radio"].find_one()
        if col:
            if col["updatedAt"] != datetime.date.today().strftime("%d/%m/%Y"):
                self.db.drop_collection("radio")
                self.db.drop_collection("programas")
                return True
            else:
                return False

        return True

    def insert_radio(self, name, img, link, schedule):
        radio = {
            "name": name,
            "img": img,
            "link": link,
            "updatedAt": datetime.date.today().strftime("%d/%m/%Y")
        }

        self.db["radio"].insert_one(radio)

        programas = []
        for item in schedule:
            programas.append({
                "title": item["title"],
                "link": item["link"],
                "start": item["start"],
                "end": item["end"],
                "img": item["img"],
                "day": item["day"],
                "details": item["details"],
                "radio": name
            })

        self.db["programas"].insert_many(programas)

    def getEntry(self, name):
        radio = self.db["radio"].find_one({"name": name})
        programas = self.db["programas"].find({"radio": name})

        if radio:
            prog_lst = []
            for item in programas:
                prog_lst.append(
                    Program(item["title"], item["link"], item["start"], item["end"], item["img"], item["day"],
                            item["details"]))
            return Radio(radio["name"], radio["img"], radio["link"], prog_lst)
        else:
            return None

    def getDayHour(self, day, hour):
        hour = hour + ":00"
        programas = sorted(list(self.db["programas"].find({"day": day, "start": {"$gte": hour}})),
                           key=(lambda x: (x["radio"], x["start"])))
        aux = []
        for programa in programas:
            if programa["radio"] not in aux:
                aux.append(programa["radio"])
        radios = []
        for radio in aux:
            radios.append(self.db["radio"].find_one({"name": radio}, {"_id": 0, "name": 1, "img": 1, "link": 1}))

        return radios, programas
