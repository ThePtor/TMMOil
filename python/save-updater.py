from tkinter import *
import random

data_path = "C:/Users/agon1/Desktop/TMMOil/data/"
#save.txt
#map.txt
#color-values.txt - optional
baseprice = 1000 #Základní cena pozemku
baseincrease = 500 #zvýšení ceny při přihození

class Team:
    def __init__(self,name:str) -> None:
        r = random.randrange(32, 128)
        g = random.randrange(32, 128)
        b = random.randrange(32, 128)
        self.name = name
        self.id = f"[{self.name}]"
        self.stats = {}
        self.fin = False
        self.quest = False
        self.spending = 0
        self.m_color = "#"+hex(r)[2:]+hex(g)[2:]+hex(b)[2:]
        self.s_color = "#"+hex(r+128)[2:]+hex(g+128)[2:]+hex(b+128)[2:]



    def __repr__(self) -> str:
        return(self.name)
    
    def __eq__(self, __value: object) -> bool:
        if self.name == __value:
            return True
        else:
            return False
    
    def spend_money(self):
        self.stats["money"] -= self.spending
        self.spending = 0
    
    def export(self, file):
        for i in self.stats:
            print(self.name, i, self.stats[i], file=file)
    
    def stat_print(self):
        print()
        for i in self.stats:
            print(self.id, i, self.stats[i])

    def feed(self, stats):
        for line in stats:
            if line[0] == self.name:
                self.edit_stat(line[1], line[2])
    
    def edit_stat(self, stat_name, stat_value):
        if not type(stat_value) in (int, float):
            try:
                stat_value = float(stat_value)
            except:
                pass
        self.stats[stat_name] = stat_value
        self.stats = dict(sorted(self.stats.items()))    

    def stat_names(self):
        return [x for x in self.stats]

class Tile:
    def __init__(self, qual, ownername, active:bool) -> None: 
        self.quality = qual
        self.active = active
        self.owner = None
        self.isriver = False
        if qual == -1:
            self.active = False
            self.isriver = True
        if ownername:
            for x in range(len(teams)):
                if teams[x].name == ownername:
                    self.owner = teams[x]

    def __repr__(self) -> str:
        return f"{self.quality}"
    
    def export(self, file):
        print(self.quality, self.owner, self.active, file=file)


# Funkce pro týmy
def create_teams(seznam) -> list[Team]:
    teams = []
    for i in seznam:
        if i[0] not in teams:
            teams.append(i[0])
    teams = [Team(team) for team in teams]
    return teams

def create_tiles(dilky) ->list[Tile]:
    tiles = []
    for i in dilky:
        tile = Tile(int(i[0]), i[1], i[2])
        tiles.append(tile)
    return tiles

def add_colors(teams:list[Team], colorkeys):
    for team in teams:
        if team.name in colorkeys:
            team.m_color = colorkeys[team.name][0]
            team.s_color = colorkeys[team.name][1]

#tkinter funkce
def lt_generate():
    for l in range(10): 
        k = Label(okno, text=f"{abeceda[l]}", image=im, height=80, width=80, compound="c", font=("TkDefaultFont Bold", 30))
        k.grid(column=1+l, row=0, rowspan=2)
        letters.append(k)

def num_generate():
    for n in range(10): 
        l = Label(okno, text=f"{n+1}",image=im, height=80, width=80, compound="c", font=("TkDefaultFont Bold",30))
        l.grid(row=(2*n)+2, column=0, rowspan=2)
        numbers.append(l)

def grid_generate():
    for i in range(len(tiles)): #generátor políček
        b = Button(okno, text=f"", image=im, compound="c", width=80, height=80, command= lambda x=i: buy_tile(x))
        b.grid(row=2*(1+(i//10)), column=1+(i%10), sticky="e", rowspan=2)
        gridtiles.append(b)
    l1 = Label(okno, image=im, compound="c", height=80, text=f"Základní cena pozemku: ${baseprice}     Cena za přihození: ${baseincrease}", font=("Arial", 24))
    l1.grid(row=11*2, column=1, columnspan=10)

def grid_engage():
    for i in range(100):
        if not tiles[i].active:
            gridtiles[i].config(text=f"{tiles[i].quality}", font=("TkDefaultFont", 24), compound="c", image=im, bg="#c1c1c1" ,state=DISABLED)
        if tiles[i].isriver:
            gridtiles[i].config(text="", bg="#00FFFF")
        if tiles[i].owner:
            tiles[i].owner.edit_stat("landQuality", tiles[i].quality)
            gridtiles[i].config(text=f"{tiles[i].quality}", font=("TkDefaultFont", 24), compound="c", image=im, bg=f"{tiles[i].owner.s_color}" ,state=DISABLED)
            tiles[i].active = False
            tiles[i].owner = None

def top_screen():
    cash = "money"
    for y in range(len(teams)):
        body = []
        o = Label(okno, text=f"${int(teams[y].stats[cash])}", font=("Arial Bold", 30), image=im, compound="c", bg=teams[y].s_color, width=240, height=160)
        o.grid(column=22, row=2*(y*2+1), rowspan=4)
        body.append(o)
        col = Label(okno, image=im, width=40, height=160, bg=teams[y].s_color)
        col.grid(column=21, row=2*(y*2+1), rowspan=4, padx=10)
        body.append(col)
        prompt = Label(okno, text="Počet vyřešených příkladů:", image=im, compound="r")
        prompt.grid(column=23, row=2+(y*4))
        body.append(prompt)
        inp = Entry(okno)
        inp.grid(column=24, row=2+(y*4))
        body.append(inp)
        cnf = Button(okno, text="Confirm", command=lambda x=y: quest_update(x))
        cnf.grid(column=24, row=3+(y*4))
        body.append(cnf)
        topstats.append(body)

def quest_update(x):
    try:
        value = topstats[x][3].get()
        value = int(value)
        teams[x].edit_stat("searchBonus", value)
        topstats[x][1].config(bg=teams[x].m_color)
        teams[x].quest = True
    except:
        pass
    if check_questions() and check_end():
        s_button()

def s_button():
    sv = Button(okno, text="Save&Quit", image=im, width=120, command=save_quit, compound="c")
    sv.grid(column=22, row=0)

def save_quit():
    with open(data_path + "map.txt", "w", encoding="UTF-8") as soubor:
        for tile in tiles:
            tile.export(soubor)

    with open(data_path + "save.txt", "w", encoding="UTF-8") as soubor:    
        for line in extras:
            print(*line, file=soubor)
        for team in teams:
            team.spend_money()
            team.export(soubor)
    okno.destroy()


def ts_update():
    cash = "money"
    for y in range(len(teams)):
        topstats[y][0].config(text=f"${int(teams[y].stats[cash])}")
        topstats[y][1].config(text=f"Utraceno: ${teams[y].spending}")
        if not teams[y].fin:
            topstats[y][0].config(bg=teams[y].s_color)
        else:
            topstats[y][0].config(bg="#c1c1c1")
    topstats[turn][0].config(bg=teams[turn].m_color)


def check_end():
    ended = True
    for team in teams:
        if not team.fin:
            ended = False
    return ended
    
def check_questions():
    ended = True
    for team in teams:
        if not team.quest:
            ended = False
    return ended

def konec():
    cash = "money"
    for x in range(len(tiles)):
        gridtiles[x].config(state=DISABLED)
        if tiles[x].owner:  
            gridtiles[x].config(text=f"{tiles[x].quality}", font=("TkDefaultFont", 24))
    for y in range(len(teams)):
        topstats[y][0].config(bg=teams[y].m_color, text=f"${int(teams[y].stats[cash])}\n-${teams[y].spending}")

    

def buy_tile(i):
    global turn
    cur_player = teams[turn]
    if tiles[i].owner == None:
        price = baseprice
    else:
        price = tiles[i].owner.spending + baseincrease
    if cur_player.stats["money"] >= price:
        if tiles[i].owner:
            tiles[i].owner.fin = False
            tiles[i].owner.spending = 0
        tiles[i].owner = cur_player
        cur_player.spending = price
        gridtiles[i].config(bg=f"{cur_player.m_color}", text=f"${price}", font=("TkDefaultFont", 16))
        cur_player.fin = True
        if not check_end():
            while teams[turn].fin:
                turn += 1
                turn = turn%(len(teams))
            ts_update()
        else:
            konec()
            if check_questions():
                s_button()

    elif tiles[i].owner == None:
        tiles[i].owner = cur_player
        cur_player.spending = price
        gridtiles[i].config(bg=f"{cur_player.m_color}", text=f"${price}", font=("TkDefaultFont", 16))
        ts_update()
        cur_player.fin = True
        if not check_end():
            while teams[turn].fin:
                turn += 1
                turn = turn%(len(teams))
            ts_update()
        else:
            konec()
            if check_questions():
                s_button()

#Začátek funkce týmů
def main():
    global tiles, teams
    try:
        with open(data_path + "color-values.txt", "r", encoding="UTF-8") as soubor:
            colors = {}
            for color in soubor.readlines():
                color = color.strip().split()
                colors[color[0]] = color[1:]
    except:
        colors = {}

    with open(data_path + "save.txt", "r", encoding="UTF-8") as soubor:
        vstup = []  
        for line in soubor.readlines():
            line = line.strip().split(maxsplit=2)
            if len(line) < 3:
                extras.append(line)    
            else:
                vstup.append(line)

    with open(data_path + "map.txt", "r", encoding="UTF-8") as soubor:
        dilky = []
        for line in soubor.readlines():
            x = line.strip().split()
            while len(x)<3:
                x.append(None)
            x[0] = int(x[0])
            if x[1] == "None":
                x[1] = None
            if x[2] == "False":
                x[2] = False
            else:
                x[2] = True
            dilky.append(x)

    teams = create_teams(vstup)
    for team in teams:
        team.feed(vstup)
    add_colors(teams, colors)
    tiles = create_tiles(dilky)
    teams.sort(key= lambda x: x.stats["money"])
    print(teams)
    #vytvoří týmy a přiřadí k nim barvy a dílky


    #Tkinter část
    global turn
    turn = 0
    
    okno.attributes("-fullscreen", True)
    okno.title("TMMoil pozemková aukce")
    #qu = Button(okno, text="Quit", image=im, width=120, command=okno.destroy, compound="c")
    #qu.grid(column=22, row=1) 
    lt_generate()
    num_generate()
    grid_generate()
    grid_engage()
    top_screen()
    ts_update()
    okno.mainloop()

okno = Tk()
tiles, teams = [], []
extras = []
numbers, letters, gridtiles, topstats = [], [], [], []
im = PhotoImage()
abeceda = "ABCDEFGHIJ"

if __name__=="__main__":
    main()
