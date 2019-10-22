class Board:
    def __init__(self,arr,level,size):
        self.size=size

        self.tiles = []
        for item in arr:
            self.tiles.append(item)

        self.gX = level
        self.hX = self.calculate_hX()


    def calculate_hX(self):
        no_of_misplaced = 0
        for i in range(len(self.tiles)):
            if self.tiles[i]!= i+1:
                no_of_misplaced+=1

        return no_of_misplaced

    def return_gX(self):
        return self.gX

    def return_hX(self):
        return self.hX

MAX_SIZE = -1

OPEN = []

CLOSE = []

#take size of array as input
#tile for movement will be denoted by '-1'
MAX_SIZE = int(input('Enter dimension'))

arr = [1,2,3,-1,4,8,7,6,5]

'''for i in range(0,MAX_SIZE*MAX_SIZE):
    temp = int(input())
    arr.append(temp)
'''
obj = Board(arr,0,MAX_SIZE)

OPEN.append(obj)


def generate_successors(booard,depth):
    successors = []
    #find position of misplaced tile
    mis_pos = -1
    for i in range(0,MAX_SIZE*MAX_SIZE):
        if booard[i] == -1:
            mis_pos=i
            break

    #now empty tile can be swapped with tiles on its left right up and down but not in every case
    #( if empty tile is at rightmost side of board then we can't swap it for right side)

    '''
    0 1 2
    3 4 5
    6 7 8
    '''

    print('missing tile position = ',mis_pos)

    print('===============================================')

    new_row = []
    for j in range(MAX_SIZE*MAX_SIZE):
        new_row.append(booard[j])

    #check for left
    i = mis_pos-1
    #print(' i = ',i)
    #print('i/MAX = ',i//MAX_SIZE,'and mis/M = ',mis_pos//MAX_SIZE)
    if i>=0 and (i//MAX_SIZE) == (mis_pos//MAX_SIZE):
        print('left branch')

        temp = new_row[mis_pos]
        new_row[mis_pos]=new_row[i]
        new_row[i]=temp
        obj = Board(new_row,depth,MAX_SIZE)
        successors.append(obj)
        print(new_row)


    #check for right
    new_row = []
    for j in range(MAX_SIZE * MAX_SIZE):
        new_row.append(booard[j])
    i = mis_pos + 1
    #print(' i = ', i)
    if i < MAX_SIZE*MAX_SIZE and i // MAX_SIZE == mis_pos // MAX_SIZE:
        print('right branch')

        temp = new_row[mis_pos]
        new_row[mis_pos] = new_row[i]
        new_row[i] = temp
        obj = Board(new_row, depth, MAX_SIZE)
        successors.append(obj)
        print(new_row)

    #check for up
    new_row = []
    for j in range(MAX_SIZE * MAX_SIZE):
        new_row.append(booard[j])
    i = mis_pos - 3
    #print(' i = ', i)
    if i >= 0:
        print('up branch')

        temp = new_row[mis_pos]
        new_row[mis_pos] = new_row[i]
        new_row[i] = temp
        obj = Board(new_row, depth, MAX_SIZE)
        successors.append(obj)
        print(new_row)

    #check for down
    new_row = []
    for j in range(MAX_SIZE * MAX_SIZE):
        new_row.append(booard[j])
    i = mis_pos + 3
    #print(' i = ', i)
    if i < MAX_SIZE*MAX_SIZE:
        print('down branch')

        temp = new_row[mis_pos]
        new_row[mis_pos] = new_row[i]
        new_row[i] = temp
        obj = Board(new_row, depth, MAX_SIZE)
        successors.append(obj)
        print(new_row)
    print('===============================================')

    return successors


def board_with_minimum_fX():

    fX = 999999
    oppen = []
    ans = None
    for i in range(len(OPEN)):
        obj = OPEN[i]

        hX = obj.return_hX()
        gX = obj.return_gX()

        if hX+gX < fX:
            fX = hX+gX
            ans = obj
        oppen.append(obj)
        CLOSE.append(obj)

    for obj in oppen:
        OPEN.remove(obj)

    return ans


def is_Goal(board):
    for i in range(MAX_SIZE*MAX_SIZE-1):
        if board.tiles[i] != i+1:
            return False
    return True



def belong_to_CLOSED_list(board):
    flag = 0;
    for obj in CLOSE:
        array = obj.tiles
        flag = 0
        for i in range(MAX_SIZE*MAX_SIZE):
            if array[i]!=board[i]:
                flag = 1
                break
        if flag == 1:
            continue
        else:
            return True

    return False

FOUND = False

level = 0

while(len(OPEN)>0):

    current_best = board_with_minimum_fX()

    print('current best node = ',current_best.tiles)

    #OPEN.remove(current_best)

    level+=1

    if is_Goal(current_best):
        print('current best node is goal node')
        FOUND = True
        break

    else:
        print('current node is not goal')
        succ = generate_successors(current_best.tiles,level)

        for s in succ:
            if not belong_to_CLOSED_list(s.tiles):
                OPEN.append(s)
            else:
                print('current successors belongs to CLOSED list')

if FOUND:
    print('path found to goal')
else:
    print('path to goal does not exist')

