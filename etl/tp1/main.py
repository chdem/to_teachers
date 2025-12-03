import os

path = "data"


def main():
    files = [f for f in os.listdir(path) if os.path.isfile(os.path.join(path, f))]
    print(files)

if __name__=="__main__":
    main()

