import sys
import tty, termios

def readChar():
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(sys.stdin.fileno())          # Raw read
        ch = sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
    return ch

def handleLoop(rom, romIndex):
    op = 1 if rom[romIndex] == '[' else -1
    counter = op
    while (counter != 0):
        romIndex += op
        if rom[romIndex] == '[': counter += 1
        if rom[romIndex] == ']': counter -= 1
    return romIndex

def brainfuck(rom):
    tab = [0] * 30000
    tabIndex, romIndex = 0, 0
    while romIndex < len(rom):
        c = rom[romIndex]
        if c == '+':
            tab[tabIndex] += 1
            if tab[tabIndex] > 255:
                tab[tabIndex] = 0
        elif c == '-':
            tab[tabIndex] -= 1
            if tab[tabIndex] < 0:
                tab[tabIndex] = 255
        elif c == '>':
            tabIndex += 1
        elif c == '<':
            tabIndex -= 1
        elif c == '.':
            sys.stdout.write(chr(tab[tabIndex]))
        elif c == ',':
            tab[tabIndex] = ord(sys.stdin.read(1))
        elif c == '[':
            if tab[tabIndex] == 0:
                romIndex = handleLoop(rom, romIndex)
        elif c == ']':
            if tab[tabIndex] != 0:
                romIndex = handleLoop(rom, romIndex)
        romIndex += 1

for arg in sys.argv[1:]:
    f = open(arg, "r")
    rom = f.read()
    #optimized = "".join(filter(lambda c: c in ['+', '-', '>', '<', '.', ',', '[', ']'], rom))
    #brainfuck(optimized)
    brainfuck(rom)
