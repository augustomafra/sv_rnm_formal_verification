import matplotlib.pyplot as plt
import numpy as np

R = 4.2e6
C = 270e-9
f = 5

Vi = 1

time_constant = 1.0 / (R * C)
clock_period = 1.0 / f

simulation_time = 5 * time_constant
#simulation_time = 40. * clock_period
simulation_step = simulation_time / 1000.

print(f"Time constant 1/RC = {time_constant}s")
print(f"Clock period 1/f = {clock_period}s")
print(f"Simulation time = {simulation_time}s")

t = np.arange(0.0, simulation_time, simulation_step)
v = np.zeros(len(t))
va = np.zeros(len(t))
clk = np.zeros(len(t))

v[0] = 0.0
va[0] = 0.0

for i, ti in enumerate(t):
    if i == 0:
        continue

    if int((2. * ti) / clock_period) % 2 == 1:
        clk[i] = 0.2

    # Analog simulation
    va[i] = Vi + (va[0] - Vi) * np.e ** (-ti / (R * C))

    # Digital simulation
    if clk[i] > clk[i - 1]: # @(posedge clk)
        v[i] = v[i - 1] + (1.0 / f*R*C) * (Vi - v[i - 1])
    else:
        v[i] = v[i - 1]

root_mean_sq_deviation = 0.0
for v_d, v_a in zip(v, va):
    root_mean_sq_deviation += (v_d - v_a) ** 2.0
root_mean_sq_deviation = np.sqrt(root_mean_sq_deviation / len(v))
print(f"RMSD = {root_mean_sq_deviation}")

fig, ax = plt.subplots()
ax.plot(t, va, label="Analog Voltage")
ax.plot(t, v, label="Discrete Model Voltage")
ax.plot(t, clk, label="Clock")
ax.legend()

ax.set(xlabel='time (s)', ylabel='v (V)',
       title='Capacitor step response')
ax.grid()
#ax.set_axis_off()

plt.savefig("capacitor.png")
#plt.show()
