from enum import Enum
from random import choices, sample
from collections import namedtuple
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation, writers
from itertools import product, chain
Pref = namedtuple('Pref', ['in_frac', 'color'])


def legend_without_duplicate_labels(ax):
    handles, labels = ax.get_legend_handles_labels()
    unique = [(h, l) for i, (h, l) in enumerate(
        zip(handles, labels)) if l not in labels[:i]]
    ax.legend(*zip(*unique), loc='upper right')


class Group(Enum):
    # Tuple of desired ingroup fraction, plotting color
    # FRIENDLY = Pref(0, 'b')  # No need for any change
    FEARFUL = Pref(.5, 'r')  # Want half
    SHY = Pref(.25, 'g')  # Want at least a quarter
    RACIST = Pref(.8, 'y')

    @staticmethod
    def random_pick():
        """
        Pick a random group type
        """
        return choices(list(Group))[0]


class Agent:
    def __repr__(self):
        return f'{self.x}, {self.y}, {self.group}'

    def __init__(self, group: Group, x: int, y: int):
        self.x, self.y, self.group = x, y, group
        self.satified = None

    # def satisfied(self, grid) -> bool:
    #     neighbors = Grid.neighbors(grid, self.x, self.y)
    #     return len(list(filter(lambda n: n.group == self.group, neighbors))) > len(neighbors)*self.group.value.in_frac


class Grid:
    def vacancies(self) -> [(int, int)]:
        return [(x, y) for x, y in product(range(self.N), repeat=2) if self.matrix[x][y] is None]
        # return list(filter(lambda t: grid.matrix[t[0]][t[1]] is None, product(range(grid.N), repeat=2)))

    def __init__(self, N: int, vacancy_rate: float):
        self.N = N
        self.moved_any = True
        self.matrix = [[None]*N for _ in range(N)]
        self.fig, self.ax = plt.subplots(figsize=(8, 8))
        self.ann_list = []
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

    def move_all(self):
        for ann in self.ann_list:
            ann.remove()
        self.moved_any = False
        self.ann_list[:] = []
        for i, j in product(range(self.N), repeat=2):
            a: Agent = self.matrix[i][j]
            if a is not None and a.satified is not True and not self.satisfied(a):
                acceptable_vacancies = [
                    (x, y) for x, y in self.vacancies() if self.satisfied(Agent(a.group, x, y))]
                if len(acceptable_vacancies) > 0:
                    spot_x, spot_y = acceptable_vacancies[0]
                    mid_x, mid_y = (spot_x+a.x)/2, (spot_y+a.y)/2

                    self.ann_list.append(plt.annotate("swapping", (a.x, a.y),
                                                      xytext=(mid_x, mid_y), arrowprops={'arrowstyle': '->'}))
                    self.ann_list.append(plt.annotate("swapping", (spot_x, spot_y),
                                                      xytext=(mid_x, mid_y), arrowprops={'arrowstyle': '->'}))

                    self.matrix[a.x][a.y] = None
                    a.x, a.y = spot_x, spot_y
                    self.matrix[spot_x][spot_y] = a
                    a.satified = True
                    self.moved_any = True
        
        # if len(self.ann_list) > 10:
        #     keep = choices(self.ann_list, k=10)
        #     for a in self.ann_list[:]:
        #         # print(a in keep)
        #         if a in keep:
        #             a.remove()
        # return moved_any

    # def schelling(self):
    #     # self.plot()
    #     moved_any = True
    #     while moved_any:
    #         moved_any = self.move_all()
    #     # self.plot()
    def plot(self):
        lns = []
        for i, j in product(range(self.N), repeat=2):
            a = self.matrix[i][j]
            if a is not None:
                # print(self.grid[i][j].group.value.color)
                p = self.ax.plot(i, j, 'o', c=a.group.value.color,
                                 label=a.group.name)
                # self.ax.add_artist(p)
                lns.append(p)
        legend_without_duplicate_labels(self.ax)
        # print(lns)
        return lns

    def run(self, frame_num):
        title = f"Round {frame_num}"
        self.move_all()
        if  not self.moved_any:
            title += ", ended"
            # self.anim.event_source.stop()
        self.ax.set_title(title)
        lns = self.plot()
        # print(lns)
        return lns

    def frame_gen(self):
        i = 0
        while self.moved_any:
            i += 1
            yield i

    def schelling(self):
        self.anim = FuncAnimation(self.fig, self.run,
                                  init_func=self.plot, frames=self.frame_gen, interval=1000)
        # plt.show()
        Writer = writers['ffmpeg']
        writer = Writer(fps=1, metadata=dict(artist='Me'), bitrate=-1)
        self.anim.save('schelling.mp4', writer=writer)


if __name__ == "__main__":
    g = Grid(20, .5)
    g.schelling()
