import sys

output = []

with open(sys.argv[1], 'r') as src_file:
    for line in src_file.readlines():
        assembled = "0000\n"
        inst = line.strip("\n").split(" ")
        if inst[0] == "addx":
            data = int(inst[1]) & 0xFFF
            assembled = "1" + f"{data:03x}\n"
        output.append(assembled)

output.append("FFFF\n")

with open(sys.argv[1][:-2], 'w') as out_file:
    out_file.writelines(output)