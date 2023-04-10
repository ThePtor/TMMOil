from tkinter import *
import random
def main():
    data_path = "C:/Users/pavel/Desktop/savetest/"
    #save.txt
    #tiles.txt
    #color-values.txt
    baseprice = 1000 #Základní cena pozemku
    baseincrease = 499 #zvýšení ceny při přihození

    class Team:
        def __init__(self,name:str) -> None:
            r = random.randrange(32, 128)
            g = random.randrange(32, 128)
            b = random.randrange(32, 128)
            self.name = name
            self.id = f"[{self.name}]"
            self.stats = {}
            self.fin = False
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
            k = Label(okno, text=f"{abeceda[l]}", font=(30))
            k.grid(column=(l+1), row=5)
            letters.append(k)

    def num_generate():
        for n in range(10): 
            l = Label(okno, text=f"{n+1}", font=(30))
            l.grid(row=(6+n), column=0)
            numbers.append(l)

    def grid_generate():
        for i in range(len(tiles)): #generátor políček
            b = Button(okno, text=f"", image=im, compound="c", width=80, height=80, command= lambda x=i: buy_tile(x))
            b.grid(row=(6+(i//10)), column=1+(i%10))
            gridtiles.append(b)

    def grid_engage():
        for i in range(100):
            if not tiles[i].active:
                gridtiles[i].config(text=f"{tiles[i].quality}", font=("TkDefaultFont", 24), compound="c", image=im, bg="#c1c1c1" ,state=DISABLED)
            if tiles[i].owner:
                tiles[i].owner.edit_stat("landQuality", tiles[i].quality)
                gridtiles[i].config(text=f"{tiles[i].quality}", font=("TkDefaultFont", 24), compound="c", image=im, bg=f"{tiles[i].owner.s_color}" ,state=DISABLED)
                tiles[i].active = False
                tiles[i].owner = None

    def top_screen():
        cash = "money"
        for y in range(len(teams)):
            body = []
            o = Label(okno, text=f"{teams[y].name}", font=("Calibri Bold", 20), bg=teams[y].s_color)
            o.grid(column=1+(2*y), row=0, columnspan=2)
            body.append(o)
            p = Label(okno, text=f"${teams[y].stats[cash]}", font=("Arial Bold", 15))
            p.grid(column=1+(2*y), row=1, columnspan=2)
            body.append(p)
            q = Label(okno, text=f"Utraceno: ${teams[y].spending}", font=("Arial Bold", 15))
            q.grid(column=1+(2*y), row=2, columnspan=2)   
            body.append(q)
            btn = Button(okno, text="Confirm", command= lambda x=y: quest_update(x))
            body.append(btn)
            topstats.append(body)

    def quest_update(x):
        value = topstats[x][2].get()
        value = int(value)
        teams[x].edit_stat("searchBonus", value)
        teams[x].fin = True
        if check_end():
            with open(data_path + "tiles.txt", "w", encoding="UTF-8") as soubor:
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
            topstats[y][0].config(text=f"{teams[y].name}", bg=teams[y].s_color)
            topstats[y][1].config(text=f"${teams[y].stats[cash]}")
            topstats[y][2].config(text=f"Utraceno: ${teams[y].spending}")


    def ts_end():
        for y in range(len(teams)):
            teams[y].fin = False
            topstats[y][1].destroy()
            topstats[y][1] = Label(okno, text="Počet úloh:")
            topstats[y][1].grid(column=1+(2*y), row = 1)
            topstats[y][2].destroy()
            topstats[y][2] = Entry(okno, width=5)
            topstats[y][2].grid(column=2+(2*y), row = 1)
            topstats[y][3].grid(column=2+(2*y), row = 2)
        

    def check_end():
        ended = True
        for team in teams:
            if not team.fin:
                ended = False
        return ended
        

    def konec():
        for x in range(len(tiles)):
            gridtiles[x].config(state=DISABLED)
            if tiles[x].owner:
                gridtiles[x].config(text=f"{tiles[x].quality}", font=("TkDefaultFont", 24))
        ts_end()

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
            ts_update()
            cur_player.fin = True
            if not check_end():
                while teams[turn].fin:
                    turn += 1
                    turn = turn%(len(teams))
                topstats[turn][0].config(bg=teams[turn].m_color)
            else:
                konec()


            

    #Začátek funkce týmů
    extras = []
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

    with open(data_path + "tiles.txt", "r", encoding="UTF-8") as soubor:
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
        team.stats["money"] = max(team.stats["money"], baseprice)
    add_colors(teams, colors)
    tiles = create_tiles(dilky)
    teams.sort(key= lambda x: x.stats["money"])
    print(teams)
    #vytvoří týmy a přiřadí k nim barvy a dílky


    #Tkinter část
    global turn
    turn = 0
    okno = Tk()
    numbers, letters, gridtiles, topstats = [], [], [], []
    im = PhotoImage()
    abeceda = "ABCDEFGHIJ"

    lt_generate()
    num_generate()
    grid_generate()
    grid_engage()
    top_screen()
    okno.mainloop()

if __name__=="__main__":
    main()