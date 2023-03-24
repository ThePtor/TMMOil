#import os
soubor = open("save.txt", "r", encoding="UTF-8")
stats = soubor.readlines()
soubor.close()

tmpout = open("save.txt", "w", encoding="UTF-8")


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

        x[2] = round(x[2]-sub, 2)

for line in stats:
    print(*line, file=tmpout)

tmpout.close()

#try:os.remove("save.txt")
#except: pass
#os.rename("save.txt.tmp", "save.txt")
