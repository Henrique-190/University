class Program:
    def __init__(self, title, link, start, end, img, days, details):
        self.title = title
        self.link = link
        self.start = start
        self.end = end
        self.img = img
        self.day = days
        self.details = details

    def formatDay(self):
        dias = ["SEG", "TER", "QUA", "QUI", "SEX", "SAB", "DOM"]

        dia_lst = self.day.split(" ")
        dia_lst = list(dia_lst)
        if len(dia_lst) == 1:
            self.day = dia_lst[0]
        else:
            dia_lst = [x for x in dia_lst if x in dias]

            fst = dias.index(dia_lst[0])
            lst = dias.index(dia_lst[1])

            if fst > lst:
                aux = fst
                fst = lst
                lst = aux

            self.day = dias[fst:lst + 1]

    # day = False -> Verifica se todos os atributos estão preenchidos
    # day = True -> Verifica se todos os atributos estão preenchidos, exceto o dia
    def isComplete(self, day=False):

        if day:
            return self.title and self.link and self.start and self.end and self.img

        if self.title and self.link and self.start and self.end and self.img and self.day:
            self.formatDay()
            return True
        else:
            return False

    def toJson(self):
        return {
            "title": self.title,
            "link": self.link,
            "start": self.start,
            "end": self.end,
            "img": self.img,
            "day": self.day,
            "details": self.details
        }

    def print(self):
        print("Title: ", self.title)
        print("Link: ", self.link)
        print("Start: ", self.start)
        print("End: ", self.end)
        print("Img: ", self.img)
        print("Day: ", self.day)
        print("Details: ", self.details)
