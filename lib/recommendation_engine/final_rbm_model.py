import numpy as np
import pandas as pd
import sys

class RBM():
    def __init__(self, nv = 4000, nh = 100, learning_rate = 0.08):
        self.rng = np.random.RandomState(1234)
        self.learning_rate = learning_rate
        self.W = np.random.randn(nh, nv)
        self.a = np.random.randn(1, nh)
        self.b = np.random.randn(1, nv)
    def sample_h(self, x):
        wx = np.dot(x, self.W.T)
        activation = wx + self.a
        p_h_given_v = self.sigmoid(activation)
        return p_h_given_v, self.rng.binomial(size = p_h_given_v.shape, n = 1, p = p_h_given_v)
    def sample_v(self, y):
        wy = np.dot(y, self.W)
        activation = wy + self.b
        p_v_given_h = self.sigmoid(activation)
        return p_v_given_h, self.rng.binomial(size = p_v_given_h.shape, n = 1, p = p_v_given_h)
    def train(self, v0, vk, ph0, phk):
        self.W += self.learning_rate * (np.dot(v0.T, ph0) - np.dot(vk.T, phk)).T
        self.b += self.learning_rate * np.sum((v0 - vk), axis = 0)
        self.a += self.learning_rate * np.sum((ph0 - phk), axis = 0)
    def predict(self, x):
        _, h = self.sample_h(x)
        _, v = self.sample_v(h)
        return v
    def sigmoid(self, x):
        return 1 / (1 + np.exp(-x))

class Recommendations():
    def __init__(self):
        self.rbm = RBM()#RBM(4000, 100, 0.08)
        self.rbm.W = self.readFromFile('weights.csv', False)
        self.rbm.a = self.readFromFile('hidden_units_biases.csv', False)
        self.rbm.b = self.readFromFile('visible_units_biases.csv', False)
        self.mp_id_to_movidId = self.getMap()
    # takes input as array of numbers [imdb ids], return recommendations
    # as array of numbers [imdb ids]
    def getRecommendation(self, x):
        v = self.convertFromImdbID(x)
        recommendations = self.rbm.predict(v)
        imdbIds = self.convertFromID(recommendations)
        return imdbIds
    def convertFromID(self, x):
        links = self.readFromFile('links.csv', True)
        ids = []
        for i in range(len(x[0])):
            if x[0, i] == 1:
                idx = 0
                for row in links:
                    if i == self.mp_id_to_movidId[idx]:
                        ids.append(row[1])
                        break
                    idx += 1
        return ids
    def getMap(self):
        movies = pd.read_csv('movies.csv')
        movies = movies.iloc[:, 0:1]
        movies = np.array(movies, dtype = 'int')
        idx = 0
        mp_id_to_movieID = {}
        for row in movies:
            mp_id_to_movieID[idx] = row[0]
            idx += 1
        return mp_id_to_movieID
    def convertFromImdbID(self, x):
        links = self.readFromFile('links.csv', True)
        v = np.zeros((1, 4000))
        for i in range(len(x)):
            idx = 0
            ok = False
            for row in links:
                if x[i] == row[1]:
                    ok = True
                    break
                idx += 1
            if ok == True:
                v[0,idx] = 1
        return v
    def readFromFile(self, fileName, rem):
        ret = pd.read_csv(fileName)
        if(rem == False):
            ret = ret.drop('Unnamed: 0', 1)
        ret = np.array(ret)
        return ret

def main():
    ids = []
    for arg in sys.argv[1:]:
        ids.append(int(arg));
    if len(ids) == 0:
        return;
    recommender = Recommendations();
    recommmendations = recommender.getRecommendation(ids);
    s = ''
    for movie in recommmendations:
        s += str(int(movie))
        s += str(" ")
    print(s)
        
if __name__ == "__main__":
    main()