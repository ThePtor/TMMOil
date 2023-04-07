#import os

data_path = "C:/Users/agon1/Desktop/TMMOil/data/save.txt"
soubor = open(data_path, "r", encoding="UTF-8")
stats = soubor.readlines()
soubor.close()



for x in range(len(stats)):
    stats[x] = stats[x].strip().split()

for x in stats:
    if x[1] == "money":
        x[2] = float(x[2])

for x in stats:
    if x[1] == "money":
        sub = float(input(f"{x[0]} mají {x[2]}$. Kolik utratili za pozemek?\n"))
        while sub > x[2]:
            print(f"{x[0]} nemají na pozemek. Zadejte novou hodnotu.")
            sub = float(input(f"{x[0]} mají {x[2]}$. Kolik utratili za pozemek?\n"))

        x[2] = str(round(x[2]-sub, 2))


with open(data_path, "w", encoding = "UTF-8") as file:
    for line in stats:
        file.write(' '.join(line))
        file.write('\n')


#try:os.remove("save.txt")
#except: pass
#os.rename("save.txt.tmp", "save.txt")
