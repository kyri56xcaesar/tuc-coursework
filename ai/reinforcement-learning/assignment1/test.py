
import tkinter as tk #loads standard python GUI libraries
import numpy as np
import time
import random

# You can uncomment the following lines to import the standard Frozen Lake environment from AI gym. Look it up for other options than the one I load

import gym
FL = gym.make('FrozenLake-v1', desc=None, map_name="4x4", is_slippery=True)
FL.reset()

P = FL.P

reward = np.zeros(len(P))
reward[len(P)-1] = 1
holes = [5,7,11,12]


# The next few lines are mostly for accounting
Tmax = 100000
size = len(P)
n = m = np.sqrt(size)

print("Size of P: ", end="")
print(size)
Vplot = np.zeros((size,Tmax)) #these keep track how the Value function evolves, to be used in the GUI
Pplot = np.zeros((size,Tmax)) #these keep track how the Policy evolves, to be used in the GUI
t = 0

#the commented policy eval has a small difference to be used with stochastic policies
"""
def policy_evaluation(pi, P, gamma = 1.0, epsilon = 1e-10):
    t = 0
    prev_V = np.zeros(len(P))
    while True:
        V = np.zeros(len(P))
        for s in range(len(P)):
            pol = pi(s)
            for a in pol:
                for prob, next_state, reward, done in P[s][a]:
                    V[s] += pol[a] * prob * (reward + gamma * prev_V[next_state] * (not done))
        if np.max(np.abs(prev_V - V)) < epsilon:
            break
        prev_V = V.copy()
        t += 1
        Vplot[:,t] = prev_V
    return V
"""
#this one is generic to be applied in many AI gym compliant environments

def policy_evaluation(pi, P, gamma = 1.0, epsilon = 1e-10):  #inputs: (1) policy to be evaluated, (2) model of the environment (transition probabilities, etc., see previous cell), (3) discount factor (with default = 1), (4) convergence error (default = 10^{-10})
    t = 0   #there's more elegant ways to do this
    prev_V = np.zeros(len(P)) # use as "cost-to-go", i.e. for V(s')
    while True:
        V = np.zeros(len(P)) # current value function to be learnerd
        for s in range(len(P)):  # do for every state
            for prob, next_state, reward, done in P[s][pi(s)]:  # calculate one Bellman step --> i.e., sum over all probabilities of transitions and reward for that state, the action suggested by the (fixed) policy, the reward earned (dictated by the model), and the cost-to-go from the next state (which is also decided by the model)
                V[s] += prob * (reward + gamma * prev_V[next_state] * (not done))
        if np.max(np.abs(prev_V - V)) < epsilon: #check if the new V estimate is close enough to the previous one; 
            break # if yes, finish loop
        prev_V = V.copy() #freeze the new values (to be used as the next V(s'))
        t += 1
        Vplot[:,t] = prev_V  # accounting for GUI  
    return V

def policy_improvement(V, P, gamma=1.0):  # takes a value function (as the cost to go V(s')), a model, and a discount parameter
    Q = np.zeros((len(P), len(P[0])), dtype=np.float64) #create a Q value array
    for s in range(len(P)):        # for every state in the environment/model
        for a in range(len(P[s])):  # and for every action in that state
            for prob, next_state, reward, done in P[s][a]:  #evaluate the action value based on the model and Value function given (which corresponds to the previous policy that we are trying to improve) 
                Q[s][a] += prob * (reward + gamma * V[next_state] * (not done))
    new_pi = lambda s: {s:a for s, a in enumerate(np.argmax(Q, axis=1))}[s]  # this basically creates the new (improved) policy by choosing at each state s the action a that has the highest Q value (based on the Q array we just calculated)
    # lambda is a "fancy" way of creating a function without formally defining it (e.g. simply to return, as here...or to use internally in another function)
    # you can implement this in a much simpler way, by using just a few more lines of code -- if this command is not clear, I suggest to try coding this yourself
    
    return new_pi

# policy iteration is simple, it will call alternatively policy evaluation then policy improvement, till the policy converges.

def policy_iteration(P, gamma = 1.0, epsilon = 1e-10):
    t = 0
    random_actions = np.random.choice(tuple(P[0].keys()), len(P))     # start with random actions for each state  
    print(f"Random actions: {random_actions}")
    
    pi = lambda s: {s:a for s, a in enumerate(random_actions)}[s]     # and define your initial policy pi_0 based on these action (remember, we are passing policies around as python "functions", hence the need for this second line)
    
    print(f"pi lambda: {pi}")
    
    while True:
        old_pi = {s: pi(s) for s in range(len(P))}  #keep the old policy to compare with new
        V = policy_evaluation(pi,P,gamma,epsilon)   #evaluate latest policy --> you receive its converged value function
        pi = policy_improvement(V,P,gamma)          #get a better policy using the value function of the previous one just calculated 
        
        t += 1
        Pplot[:,t]= [pi(s) for s in range(len(P))]  #keep track of the policy evolution
        Vplot[:,t] = V                              #and the value function evolution (for the GUI)
    
        if old_pi == {s:pi(s) for s in range(len(P))}: # you have converged to the optimal policy if the "improved" policy is exactly the same as in the previous step
            break
    print('converged after %d iterations' %t) #keep track of the number of (outer) iterations to converge
    return V,pi

n = 4
m = 4

# Simply implements the Value Iteration algorithm

def value_iteration(P, gamma = 1.0, epsilon = 1e-10): #takes as input the model transitions and rewards (P), discount factor, and convergenc error
    t = 0
    V = np.zeros(len(P),dtype=np.float64)

    # our loop will keep
    # calculating the latest Q table after a single Bellman step
    # setting the new V as the max of all actions at the respective state
    while True:
        Q = np.zeros((len(P), len(P[0])), dtype=np.float64) #init the Q table to 0 at each iteration. This is IMPORTANT as we'll be adding all possible transition that the environment could do, given an action (remember, the environment can be stochastic)
        for s in range(len(P)): # the following is essentially a single policy evaluation step
#           pol = pi(s)
            for a in range(len(P[s])):
                for prob, next_state, reward, done in P[s][a]:
                    Q[s][a] += prob * (reward + gamma * V[next_state] * (not done))
        if np.max(np.abs(V - np.max(Q, axis = 1))) < epsilon:  # end loop if the value function seems to have converged - we are comparing the old V(s), to the maximum Q(s,a) over actions a we can take (i.e., the new V(s))
            break
        V = np.max(Q, axis = 1) # set V(s) to the expected return of the best action for that state s (according to our freshly calculated Q table)
        t += 1
        Pplot[:,t]= np.argmax(Q, axis = 1)  #accounting for GUI
        Vplot[:,t] = V                      #accounting for GUI
    pi = lambda s: {s:a for s, a in enumerate(np.argmax(Q, axis=1))}[s]  # return the final covnerged policy (hence optimal) as a python "function"
    print('converged after %d iterations' %t)  # number of iterations to converge
    return V, pi


#two sample policies to use if you want to test policy evaluation. NOTE: to run "random" you need to use the (commented out) policy evaluation for stochastic policies

def pi_random(s):  
    return {0:1/4, 1: 1/4, 2: 1/4, 3: 1/4}

def pi_down(s):
    return {0:0, 1:1, 2:0, 3:0}
    


#V = policy_evaluation(pi_down,P,1, 0.001)
#V_opt,P_opt = value_iteration(P,0.5,0.001)
V_opt,P_opt = policy_iteration(P,0.5,0.001)   #just example of calling the various new functions we created.

print("V_opt: ")
print(V_opt)


# You can uncomment the following if you are going to use it on your own PC. It will not run as is on Colab. The following basically creates the simple GUI I showed in class to keep track of how the policy, and value functions evolve over time....useful for debugging
# I would recommend to maintain some sort of simple GUI like this for your own implementations as well...it might help you. But it is not mandatory



def P_to_text(a):
    if a == 0: return 'L' 
    if a == 1: return 'D'
    if a == 2: return 'R'
    if a == 3: return 'U'
    


print("Print P_opt of P ")
for s in range(len(P)): print(P_opt(s))



frame_text_V = tk.Frame()
frame_V = tk.Frame(highlightbackground="blue", highlightthickness=2)
frame_text_P = tk.Frame()
frame_P = tk.Frame(highlightbackground="green", border=2, highlightthickness=2)
frame_text_R = tk.Frame()
frame_R = tk.Frame(highlightbackground="red", highlightthickness=2)



def submit():
 
    iter = int(e.get())
    
    rows = []

    for i in range(n):

        cols = []

        for j in range(m):

#        e = Entry(relief=GROOVE, master = frame_V)

            e2 = tk.Label(master = frame_V, text = ( '%.3f'  %(Vplot[i*m+j,iter])), font=("Arial", 14))

            e2.grid(row=i, column=j, sticky=tk.NSEW, padx=10, pady = 10)
        
            
#        e.insert(END, '%f'  %(v[i,j]))

            cols.append(e2)
           
        rows.append(cols)
    
    rows = []

    for i in range(n):

        cols = []

        for j in range(m):

#        e = Entry(relief=GROOVE, master = frame_V)
            if i*m+j in holes:
                e3 = tk.Label(master = frame_P, text = 'H', font=("Arial", 18))
            else:
                e3 = tk.Label(master = frame_P, text = P_to_text((Pplot[i*m+j,iter])), font=("Arial", 14))
            e3.grid(row=i, column=j, sticky='N'+'S'+'E'+'W', padx=10, pady = 10)
            
#        e.insert(END, '%f'  %(v[i,j]))

            cols.append(e3)
           
        rows.append(cols)
         




            

    
rows = []
    
for i in range(n):

    cols = []

    for j in range(m):

        e2 = tk.Label(master = frame_R, text = ( '%f'  %(reward[i*m+j])), font=("Arial", 14))

        e2.grid(row=i, column=j, sticky='N'+'S'+'E'+'W', padx=10, pady = 10)

#        e2.insert(END, '%f'  %(r[i,j]))

        cols.append(e2)
        

    rows.append(cols)
    



    
label_V = tk.Label(master=frame_text_V, text="Value Function at Iteration:", font=("Arial", 18))
label_V.pack()
iter_btn=tk.Button(frame_text_V,text = 'Submit', command = submit, font=("Arial", 18))
iter_btn.pack()
e = tk.Entry(relief=tk.GROOVE, master = frame_text_V, font=("Arial", 18))
e.pack()



label_P = tk.Label(master=frame_text_P, text="Optimal Policy:", font=("Arial", 18))
label_P.pack()

label_R = tk.Label(master=frame_text_R, text="Reward Function:", font=("Arial", 18))
label_R.pack()

frame_text_V.pack()
frame_V.pack()
frame_text_P.pack()
frame_P.pack()
frame_text_R.pack()
frame_R.pack()


tk.mainloop()




    
