from makescript.parse import *

code_outputpath = getenv("code_outputpath")
cmds = {
    0 : "parse all",
    1 : "python parse_item.py ../xls/item.xls " + os.path.join(code_outputpath,"item"),
    
}

def show_menu():
    for choice in sorted(cmds):
        print choice,":",cmds[choice]

def main():
    while True:
        show_menu()
        choice = raw_input("enter choice(q to quit):")
        print "choice:",choice
        if choice == "q":
            break
        elif choice.isdigit():
            choice = int(choice)
            if choice == 0:
                for i,cmd in cmds.iteritems():
                    if i != 0:
                        os.system(cmd)
            elif cmds.get(choice):
                os.system(cmds[choice])

if __name__ == "__main__":
    main()
