import matplotlib.pyplot as plt
def formatting(title):
    plt.xticks(rotation=90)
    plt.ylim(0,700)
    plt.title(title)
    plt.legend()
    plt.axvline('2004-01-01', color='black', linestyle='--')