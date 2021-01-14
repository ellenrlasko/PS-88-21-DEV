from enum import Enum
from random import choice, sample
from collections import namedtuple
import matplotlib.pyplot as plt
from itertools import product, chain
Pref = namedtuple('Pref', ['in_frac', 'color'])


def legend_without_duplicate_labels(ax):
    handles, labels = ax.get_legend_handles_labels()
    unique = [(h, l) for i, (h, l) in enumerate(
        zip(handles, labels)) if l not in labels[:i]]
    ax.legend(*zip(*unique), loc='upper right')


class Group(Enum):
    # Tuple of desired ingroup fraction, plotting color
    FRIENDLY = Pref(0, 'b')  # No need for any change
    FEARFUL = Pref(.5, 'r')  # Want half
    SHY = Pref(.25, 'g')  # Want at least a quarter
    RACIST = Pref(.8, 'y')

    @staticmethod
    def random_pick():
        """
        Pick a random group type
        """
        return choice(list(Group))


class Agent:
    def __repr__(self):
        return f'{self.x}, {self.y}, {self.group}'

    def __init__(self, group: Group, x: int, y: int):
        self.x, self.y, self.group = x, y, group

    # def satisfied(self, grid) -> bool:
    #     neighbors = Grid.neighbors(grid, self.x, self.y)
    #     return len(list(filter(lambda n: n.group == self.group, neighbors))) > len(neighbors)*self.group.value.in_frac


class Grid:
    @staticmethod
    def empty(grid) -> [(int, int)]:
        return [(x, y) for x, y in product(range(grid.N), repeat=2) if grid.matrix[x][y] is None]
        # return list(filter(lambda t: grid.matrix[t[0]][t[1]] is None, product(range(grid.N), repeat=2)))

    def __init__(self, N: int, vacancy_rate: float):
        self.N = N
        self.matrix = [[None]*N for _ in range(N)]
        for i, j in product(range(N), repeat=2):
            self.matrix[i][j] = Agent(Group.random_pick(), i, j)
        empty_n = int(N*vacancy_rate)
        for i, j in product(sample(range(N), empty_n), repeat=2):
            self.matrix[i][j] = None

    def neighbors(self, a):
        """
        Return the neighbors of the agent at the location
        """
        return [self.matrix[n_x][n_y] for n_x, n_y in product(*(range(n-1, n+2) for n in (a.x, a.y))) if (n_x, n_y) != (a.x, a.y) and all(0 <= n < self.N for n in (n_x, n_y)) and self.matrix[n_x][n_y] is not None]

    def satisfied(self, a):
        """
        If agent a has a sufficient number of the ingroup surrounding them, they are satisfied
        """
        neighbors = self.neighbors(a)
        return len(list(filter(lambda n: n.group == a.group, neighbors))) > len(neighbors)*a.group.value.in_frac

    def plot(self):
        fig, ax = plt.subplots(figsize=(8, 8))
        # plot_args = {'markersize': 8, 'alpha': 0.6}
        # ax.set_facecolor('azure')
        for i, j in product(range(self.N), repeat=2):
            a = self.matrix[i][j]
            if a is not None:
                # print(self.grid[i][j].group.value.color)
                ax.plot(i, j, 'o', c=a.group.value.color, label=a.group.name)
        legend_without_duplicate_labels(ax)
        # plt.legend()
        plt.show()

    def move_all(self):
        moved_any = False
        for i, j in product(range(self.N), repeat=2):
            a: Agent = self.matrix[i][j]
            if a is not None and not self.satisfied(a):
                acceptable_vacancies = [(x, y) for x, y in Grid.empty(
                    g) if self.satisfied(Agent(a.group, x, y))]
                if len(acceptable_vacancies) > 0:
                    spot_x, spot_y = acceptable_vacancies[0]
                    self.matrix[a.x][a.y] = None
                    a.x, a.y = spot_x, spot_y
                    self.matrix[spot_x][spot_y] = a
                    moved_any = True
        return moved_any

    def schelling(self):
        moved_any = True
        while moved_any:
            moved_any = self.move_all()
            self.plot()


if __name__ == "__main__":
    g = Grid(10, .5)
    g.plot()
    # print(len(Grid.empty(g)))
    # print(g.matrix[1][1].satisfied(g))
    # print(Grid.empty(g))
    g.schelling()
    # print(len(Grid.empty(g)))
    g.plot()
