from random import randint

def main():
    with open("out.txt","w") as wf:
        with open("test.txt","r") as f:
            for line in f.readlines():
                line = line.replace('abc', str(randint(1,197)))
                wf.write(line)
main()