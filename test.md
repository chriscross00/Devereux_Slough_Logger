test
================
Christoper Chan
March 12, 2019

additive decomposition, this is where the seasonal variation is constant across time. A additive model is describe as:

![Time series = Seasonal + Trend + Random](https://latex.codecogs.com/png.latex?Time%20series%20%3D%20Seasonal%20%2B%20Trend%20%2B%20Random "Time series = Seasonal + Trend + Random")

![\\text{4(measurements per hour) \* 24(hours in a day) = 96(measurements per day)}\\\\
\\text{96(measurements per day) \* 365.25(days per year) = 35064(measurements per year)}](https://latex.codecogs.com/png.latex?%5Ctext%7B4%28measurements%20per%20hour%29%20%2A%2024%28hours%20in%20a%20day%29%20%3D%2096%28measurements%20per%20day%29%7D%5C%5C%0A%5Ctext%7B96%28measurements%20per%20day%29%20%2A%20365.25%28days%20per%20year%29%20%3D%2035064%28measurements%20per%20year%29%7D "\text{4(measurements per hour) * 24(hours in a day) = 96(measurements per day)}\\
\text{96(measurements per day) * 365.25(days per year) = 35064(measurements per year)}")

![Y\_{t} = c + \\phi\_{1}y\_{dt-1} + \\phi\_{p}y\_{dt-p} + ... + \\theta\_{1}\\epsilon\_{t-1} + \\theta\_{q}\\epsilon\_{t-q} + \\epsilon\_{t}](https://latex.codecogs.com/png.latex?Y_%7Bt%7D%20%3D%20c%20%2B%20%5Cphi_%7B1%7Dy_%7Bdt-1%7D%20%2B%20%5Cphi_%7Bp%7Dy_%7Bdt-p%7D%20%2B%20...%20%2B%20%5Ctheta_%7B1%7D%5Cepsilon_%7Bt-1%7D%20%2B%20%5Ctheta_%7Bq%7D%5Cepsilon_%7Bt-q%7D%20%2B%20%5Cepsilon_%7Bt%7D "Y_{t} = c + \phi_{1}y_{dt-1} + \phi_{p}y_{dt-p} + ... + \theta_{1}\epsilon_{t-1} + \theta_{q}\epsilon_{t-q} + \epsilon_{t}")

![y = mx + \\beta](https://latex.codecogs.com/png.latex?y%20%3D%20mx%20%2B%20%5Cbeta "y = mx + \beta")
