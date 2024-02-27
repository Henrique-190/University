class Radio:
    def __init__(self, name, img, link, schedule):
        self.name = name
        self.img = img
        self.link = link
        self.schedule = schedule  # Sorted List of Program objects

    def scheduleToJson(self):
        res = []
        for program in self.schedule:
            res.append(program.toJson())
        return res

    def print(self):
        print("Name: ", self.name)
        print("Img: ", self.img)
        print("Link: ", self.link)
        print("Schedule: ")
        for program in self.schedule:
            program.print()
            print("")
