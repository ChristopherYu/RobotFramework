class WeatherForecastCounty(object):
    def __init__(self):
        self.url = "https://www.cwa.gov.tw/V8/C/W/County/County.html"
        self.main_title = "css=h2.main-title"
        self.confirm_button = "css=div.area_search_btn-v9 > button.btn.btn-default.btn-block"
        self.town_dropdown_list = "id=TID"
        self.county_of_town_dropdown_list = "id=CountySelect"
        self.county_dropdown_list = "id=CID"
        self.marquee = "id=marquee_1"
        self.popup = "id=marquee_2"
        self.popup_title = "css=#marquee_2 > p"
