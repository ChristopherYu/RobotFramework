from pymongo import MongoClient


class TaiwanCountiesInfo(object):
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self):
        self.client = MongoClient("mongodb://admin:123456@localhost:27017/?directConnection=true")
        self.CWA_document = self.client['CWA']
        self.taiwan_counties_collection = self.CWA_document["taiwan_counties"]

    def get_counties(self) -> list[dict]:
        return [county for county in self.taiwan_counties_collection.find()]

    def get_districts_by_county(self, county: str) -> list[dict]:
        county = self.taiwan_counties_collection.find({}, {"name": county})
        return county["districts"]

    def get_county_by_name(self, name: str) -> dict:
        return self.taiwan_counties_collection.find_one({"name": name})

    def get_all_counties_name(self) -> list[str]:
        return [county["name"] for county in self.get_counties()]

    def get_all_districts_name_by_county(self, county: str) -> list[str]:
        return [district["name"] for district in self.get_county_by_name(county)["districts"]]
