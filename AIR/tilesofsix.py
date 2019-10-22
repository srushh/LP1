import math
import random

goal = ['B', 'W', 'B', 'W', 'B', 'W', '_']

def index(item, sequence) :
    if item in sequence :
        return sequence.index(item) 
    return -1

class SixTiles :

    def __init__ (self) :
        self.conf = ['B', 'B', 'B', 'W', 'W', 'W', '_']
        self.depth = 0
        self.parent = None
        self.hval = 0
    
    def __eq__ (self, other) :
        if self.__class__ != other.__class__ :
            return False
        return self.conf == other.conf

    def __str__ (self) :
        res = ''
        for i in range (7) :
            res += self.conf[i] + ' '
        return res

    def Locate (self) :
        for i in range (7) :
            if self.conf[i] == '_' :
                return i

    def Clone (self) :
        cloned = SixTiles ()
        for i in range(7) :
            cloned.conf[i] = self.conf[i]
        return cloned

    def PossibleMoves (self) :
        position = self.Locate()
        possible = []
        if position < 6:
            possible.append(position+1)
        if position < 5:
            possible.append(position+2)
        if position > 0:
            possible.append(position-1)
        if position > 1:
            possible.append(position-2)
        
        return possible

    def swap (self, a, b) :
        temp = self.conf[a] 
        self.conf[a] = self.conf[b] 
        self.conf[b] = temp 

    def GenerateAllCombinations (self) :
        moves = self.PossibleMoves ()
        position = self.Locate ()

        def GenAndClone (a, b) :
            AnotherConf = self.Clone()
            AnotherConf.swap (a, b)
            AnotherConf.depth = self.depth + 1
            AnotherConf.parent = self
            return AnotherConf

        return map(lambda pair: GenAndClone(position, pair), moves)

    def GenerateSolution(self, path):
        if self.parent == None:
            return path
        else:
            path.append(self)
            return self.parent.GenerateSolution(path)

    def Solve (self, h):
        
        def isSolved(puzzle) :
            return puzzle.conf == goal
        
        Open = [self]
        Closed = []
        movecount = 0
        while len(Open) > 0:
            x = Open.pop(0)
            movecount += 1
            if isSolved(x):
                if len(Closed) > 0:
                    return x.GenerateSolution([]), movecount
                else :
                    return [x], 0

            Successor = x.GenerateAllCombinations()

            OpenIndex, ClosedIndex = -1, -1

            for move in Successor :
                OpenIndex = index(move, Open)
                ClosedIndex = index(move, Closed)
                hval = h(move)
                fval = hval+move.depth

                if OpenIndex == -1 and ClosedIndex == -1:
                    move.hval = hval
                    Open.append(move)
                
                elif OpenIndex > -1:
                    copy = Open[OpenIndex]
                    if fval < copy.hval + copy.depth :
                        copy.hval = hval
                        copy.parent = move.parent
                        copy.depth = move.depth

                elif ClosedIndex > -1 :
                    copy = Closed[ClosedIndex]
                    if fval < copy.hval + copy.depth :
                        move.hval = hval
                        Closed.remove(copy)
                        Open.append(move)

            Closed.append(x)
            Open = sorted(Open, key=lambda p: p.hval+p.depth)
    
        return [], 0

def h_dist(tiles):
    count = 0
    for i in range (7) :
        if tiles.conf[i] != goal[i] :
            count += 1
    return count
    
if __name__ == "__main__" :
    six = SixTiles ()

    print (six)

    path, count = six.Solve(h_dist)
    path.reverse()
    print(count)
    for i in path: 
        print(i)

