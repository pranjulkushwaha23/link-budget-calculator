# RF Link Budget Calculator

MATLAB-based link budget calculator for drone communication 
systems, developed for a 1W telemetry system operating in the 
865–867 MHz ISM band.

## System this was built for
- Frequency: 865–867 MHz ISM band (India WPC compliant)
- TX Power: 30 dBm (1W)
- Protocol: SiK Radio
- Achieved range: 15 km LOS
- Link margin: >47 dB

## What the script calculates
- EIRP (Effective Isotropic Radiated Power)
- Free-Space Path Loss (Friis equation)
- Received signal power
- Link margin
- Maximum theoretical and practical range
- Sensitivity analysis: how RX antenna gain affects range

## Outputs
- Console: full link budget table + sensitivity analysis
- Figure 1: Practical range vs frequency (400–2500 MHz)
- Figure 2: Link margin vs distance @ 866 MHz

## How to run
1. Open MATLAB
2. Open `link_budget.m`
3. Edit parameters in the SYSTEM PARAMETERS section
4. Run the script

## Author
Pranjul Kumar — RF & Embedded Systems Engineer  
M.Tech, IIT Jammu | linkedin.com/in/pranjulkumar
