print("colour_space = [", end="")
for r in range(0, 255, 16):
    for g in range(0, 255, 16):
        for b in range(0, 255, 16):
            print(f"[{r}, {g}, {b}]", end="")
print("]")