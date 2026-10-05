# Raw extract: pv-reconfig-ng-ertugrul-2025.pdf

> Text extracted by PyMuPDF in PDF reading order. Figures and formulas must be checked against the original PDF.
> PDF: [../../pv-reconfig-ng-ertugrul-2025.pdf](../../pv-reconfig-ng-ertugrul-2025.pdf)
> Pages: 16
> DOI: https://doi.org/10.3390/en18225866 · PDF download: https://mdpi-res.com/d_attachment/energies/energies-18-05866/article_deploy/energies-18-05866.pdf

---

## Page 1

Academic Editors: Mazhar Hussain
Baloch, Touqeer Ahmed Jumani and
Sohaib Tahir Chauhdary
Received: 5 September 2025
Revised: 16 October 2025
Accepted: 3 November 2025
Published: 7 November 2025
Citation:
Ng, W.K.; Ertugrul, N.
Real-Time Reconfiguration of PV
Arrays and Control Strategy Using
Minimum Number of Sensors and
Switches. Energies 2025, 18, 5866.
https://doi.org/10.3390/en18225866
Copyright: © 2025 by the authors.
Licensee MDPI, Basel, Switzerland.
This article is an open access article
distributed under the terms and
conditions of the Creative Commons
Attribution (CC BY) license
(https://creativecommons.org/
licenses/by/4.0/).
Article
Real-Time Reconfiguration of PV Arrays and Control Strategy
Using Minimum Number of Sensors and Switches
Wing Kong Ng *
and Nesimi Ertugrul
School for Electrical and Mechanical Engineering, The University of Adelaide, Adelaide 5005, Australia;
nesimi.ertugrul@adelaide.edu.au
* Correspondence: wingkong.ng@adelaide.edu.au
Abstract
This paper presents a reconfigurable switching circuit and control methodology for mit-
igating power losses in photovoltaic (PV) systems under partial shading. The proposed
hardware uses a simplified network of power MOSFETs and diodes to enable dynamic
reconfiguration between series and parallel connections, improving energy yield with
minimal conduction losses. Unlike conventional approaches that require irradiance mea-
surements or extensive sensing, the control algorithm uses only per-module voltage and
a single-current measurement to detect shading events in real time. A novel switching
strategy reduces the number of actively controlled transistors, simplifying the control cir-
cuitry and reducing power dissipation. Both simulation and experimental results validate
the method. Simulations of a 4-module PV system showed maximum power point (MPP)
increases from 900 W to over 1100 W and from 460 W to 900 W, with full recovery to 1500 W
after shading removal. Experimental verification on a 3-module setup under controlled
shading yielded similar improvements: MPP increased from 38.4 W to 45.6 W and from
38.4 W to 45.8 W. These results demonstrate rapid adaptability, effective mismatch loss
reduction, and maximisation of available power, making the proposed design a practical
and low-overhead solution for commercial PV systems with non-uniform irradiance.
Keywords: partial shading; photovoltaic; photovoltaic module; connection reconfiguration;
MPPT
1. Introduction
Photovoltaic (PV) systems have been widely utilised to generate electricity, which
commonly consist of long strings of series-connected solar modules, as shown in Figure 1a,
which reduces the module output current and minimises power losses in cables and power
converters. In addition, series-connected solar PV modules are connected to a central
DC–DC converter to achieve maximum power at a given solar irradiance. However, in
a practical system, not all PV modules are illuminated uniformly all the time. This may
be due to several factors, including cloud coverage, soiling, and shading from nearby
structures or trees. The topography of the solar PV system’s location can also be a factor,
with all of these conditions varying with the position of the sun. Furthermore, there are
times when some of the PV modules in the system are exposed to partial shading, hence
resulting in low power output. Also, when a PV module is partially shaded, some PV cells
may work in reverse bias and even reach breakdown voltage, which would not only lead
to hot-spot issues but also damage the shaded cells. Under such shaded conditions, the
common practice is to add a bypass diode in parallel with each module. The application of
Energies 2025, 18, 5866
https://doi.org/10.3390/en18225866

## Page 2

Energies 2025, 18, 5866
2 of 16
bypass diodes is to bypass the PV modules within a string with shaded PV cells, allowing
the illuminated PV modules to continue delivering power.
S1
S2
S(N)
D1
D2
D(N)
(b)
Sw1
Sw2
Sw3
Sw(3N−5)
Sw(3N−4)
Sw(3N−3)
(a)
Bypass diode
(c)
D(2N−3)
S( )
N
M(N−1)
D(2N−4)
Q1
M1
D1
S1
S2
+
−
+
−
+
−
Beginning Block
Subsequent Block
Figure 1. The schematic of (a) a number of N PV modules connected in series with bypass diode,
(b) a number of N PV modules connected with switches that allow reconfiguration, and (c) the newly
proposed PV array reconfiguration network implementation.
Despite this widely adopted approach, bypass diodes cannot recover the power
loss associated with mismatch among modules and only prevent catastrophic damage.
Consequently, the overall system power drops under non-uniform irradiance, due to the
losses in the bypass diode and its uncontrolled nature. This has motivated this research
into more adaptive and efficient methods to manage partial shading effects.
To address these shading-induced performance degradations, research has progressed
along several major directions, including the optimisation of PV array interconnection
topologies, the use of module-level power converters, and dynamic reconfiguration of
module connections.
In terms of connection topologies, methods such as Sudoku and total-cross-tied (TCT)
configurations have been proposed to redistribute current paths and mitigate mismatch
losses. Among these, the TCT topology is the most common due to its simplicity and ability
to improve power extraction without the need for active components. However, TCT wiring
is fixed, which limits its adaptability to dynamic shading conditions. Module-level power
converters have also been implemented either as full power converters, which process the
entire module output, or as partial power converters, which process only a fraction of the
power. Partial power converters offer a balance between performance improvement and re-
duced converter losses, yet they still add complexity, cost, and potential reliability concerns
at each module. Reconfiguration-based PV arrays, which dynamically alter the electrical
connections among modules, have also been proposed in both full reconfiguration [1,2] and
series–parallel reconfiguration forms [3,4]. Compared with fixed topologies such as TCT,
reconfiguration methods can dynamically alter the wiring to maximise power output under
any shading pattern and, compared with module-level converters, they avoid distributed

## Page 3

Energies 2025, 18, 5866
3 of 16
active electronics and associated reliability issues. Thus, PV module reconfiguration offers
better adaptability and reliability in shading-prone environments.
PV array reconfiguration techniques can be broadly categorised into full reconfigu-
ration and series–parallel reconfiguration. Full reconfiguration allows any PV module in
the array to be connected in series or parallel with any other module, providing maximum
flexibility to achieve the global optimum configuration under any irradiance pattern. How-
ever, this approach requires a large number of switches, extensive control signal routing,
and multiple voltage and current sensors, which increases system complexity, conduction
loss, and cost. In contrast, series–parallel reconfiguration restricts parallel connections to
consecutive modules within the same string, while unshaded modules remain in series.
While this reduces flexibility, it significantly lowers hardware overhead and enhances
reliability, making it more suitable for practical commercial PV installations.
Several reconfigurable switch networks have been proposed to improve performance
under partial shading. For example, refs. [1,2] introduces a fully configurable architec-
ture capable of establishing arbitrary series–parallel connections among modules. While
such designs can theoretically maximise power output, they require N2+3N
2
switches and
extensive inter-module wiring, leading to impractical hardware complexity and cost.
Ameen et al. [5] proposed a more compact solution using N −1 double-pole double-
throw (DPDT) relays, equivalent to 4N −4 transistors. While this reduces the component
count, it introduces rigid configuration constraints, as modules can only be paralleled in
fixed even-numbered pairs (e.g., Modules 1–2, 3–4). Consequently, configurations such as
parallel operation between Modules 2 and 3 are not possible. This limits the topology’s
adaptability under diverse shading conditions.
In addition, the use of electromechanical relays results in slower switching, higher
power consumption, and increased mechanical wear, further reducing suitability for dy-
namic reconfiguration in real-world PV arrays.
Several recent works focus on limiting switch counts while enabling adaptive reconfig-
uration. For instance, ref. [3] integrates a DC–DC converter to improve voltage control and
shading resilience, while [4] employs a detection mechanism to initiate parallel connections
under shading. However, ref. [4] lacks shading-removal detection, and reconfiguration
deconstruction relies on timed disconnection, potentially delaying energy recovery.
Other techniques, such as [6], permit module isolation under faults but do not support
dynamic topology reconfiguration, limiting shading adaptability. In contrast, this paper
proposes a selective reconfiguration strategy that combines lower hardware complexity
with enhanced adaptability and faster response.
This paper presents a simplified PV module reconfiguration architecture that retains
the practical constraint of forming parallel connections only between consecutive modules,
similar to [4], but significantly reduces circuit complexity. By replacing two-thirds of the
active switches with passive diodes, the proposed design lowers conduction loss and
reduces the number of required control signals from 3N −3 to N. Additionally, only one
voltage measurement per module and a single overall current measurement are required,
eliminating the need for distributed sensing or irradiance monitoring, as summarised in
Table 1.
A key advancement of the proposed method lies in its control scheme, which enables
real-time reconfiguration in response to both the onset and removal of shading conditions,
thereby maximising energy harvesting. Unlike prior work [4], which relies on timing-based
deconstruction, the presented approach enhances system responsiveness and reliability.
These improvements make the system well suited for residential and commercial PV
applications where adaptive reconfiguration under partial shading is critical.

## Page 4

Energies 2025, 18, 5866
4 of 16
Table 1. Comparison of PV Reconfiguration Approaches.
Category
Full Reconfiguration
Series-Parallel
Literature
[7]
[1,2]
[5]
[6]
[3]
[4]
This Paper
Number of PV Modules
N × M
N
N × M
N
N
N
N
Increment of Module
N or M
1
1
N or M
1
1
1
Component Count
Switch
Transistor:
N × M −1
Transistor: N(N+3)
2
Electromech. relay
Transistor:
N × M −1 Diode:
N + M
Transistor: 3N −3
Transistor: 3N −3
Transistor:
3N −3 2N −2 act
as passive diode
Passive
Component
0
0
0
Capacitor: N
0
0
0
Minimum Module Number
2
2
min. of 2 in N, M
2
2
2
2
Required Sensor
N×M Voltage
N×M Current
1 Voltage 1
Current
Undetermined
1 Voltage 1
Current
N Voltage
2N −2 Current
N Voltage 1
Current (shared
MPPT)
Reaction Time
Fault detection
Real-time
Slow interval
Undetermined
Real-time with
slow MPPT
Not available
Real-time
Real-time
Fault removal
Real-time
Slow interval
Undetermined
Real-time with
slow MPPT
Periodic
Periodic
Real-time
Configuration Flexibility
Any config.
Any config.
Highly limited
Limited
Limited parallel/series
Energy Loss
Conduction loss
Conduction loss
Conduction loss
Conduction loss
Conduction +
Switching loss
Conduction loss
Conduction loss
Primary Aims
Partial Shading,
Fault elimination
Partial Shading,
Fault
Partial Shading,
Fault
Fault (check
shading)
Wide Output
Voltage Range
Partial Shading,
Fault
Partial Shading,
Fault
Applications
Large-scale PV
Rooftop and
large-scale PV
Rooftop and
large-scale PV
Rooftop and
large-scale PV
Battery-powered
device
Rooftop and
large-scale PV
Rooftop and
large-scale PV

## Page 5

Energies 2025, 18, 5866
5 of 16
The remainder of this paper is organised as follows. Section 2 introduces the proposed
switching circuit topology, including voltage stress analysis and connection principles.
Section 3 presents the real-time control algorithm for series–parallel reconfiguration, includ-
ing flowcharts and implementation logic. Section 4 provides simulation studies demonstrat-
ing the reconfiguration method under different irradiance conditions. Section 5 presents
the experimental setup and results, validating the method using a hardware prototype and
solar simulator. Finally, Section 6 concludes the paper and discusses practical limitations.
2. Switching Circuit Topology
The proposed reconfigurable PV system consists of two types of blocks, as shown
in Figure 1c, the beginning block on the right and the subsequent block on the left. The
subsequent block has two diodes, which function like a bypass diode that allows the PV
module in concern to be connected in parallel to the neighbouring PV module. When the
series active switch, M(k−1), in the subsequent block is turned off, the series connection
of the PV module, S(k), that is connected by the switch will be changed to parallel with
the previous PV module, S(k). Notices that k is any integer between 1 and N, which is the
number of PV modules in the PV system. The beginning PV module, S1, has an active
bypass switch, Q1, constructed by connecting two MOSFETs back-to-back, and has no
bypass diode. As a result, when Q1 is on, S1 can only be parallelly connected to S2 or
isolated from the network. Series connections between S1 and S2 are formed when Q1 is off
and the series active switch, M1 is on. The PV module switch network can be constructed
by the blocks shown in Figure 2, which consists of 2N −3 diodes and N + 1 MOSFETs.
Q1
M1
D1
S1
S2
V1
D3
S3
M2
D2
V2
D(2N−3)
S(N)
M(N−1)
D(2N−4)
VN−1
VN
D(2k−1)
S(k+1)
M(k)
D(2k−2)
D(2k−3)
S(k)
M(k−1)
D(2k−4)
Vk−1
Vk
D(2k−5)
S(k−1)
M(k−2)
D(2k−6)
Vk−2
Vk+1
D(2 )
k
M(k+1)
I(Sk+1)
I
+I
(Sk+1)
(Sk)
VS(k+1,k−1)
+
−
Figure 2. The PV system consists of a number of N PV modules switch circuit with parallel connec-
tions, and sensing signals highlighted.
As an example, let us consider the connection between PV module Sk and S(k−1).
Normally, the MOSFET M(k−1) and M(k−2) are both turned on. When the PV module S(k)
and S(k−1) are both normally working, both diodes D(2k−3) and D(2k−4) will be inverted
and can be regarded as disconnected switches. As a result, the PV module S(k) is connected
in series to S(k−1) and the current flows from S(k−1) positive terminal thought M(k−1) to
S(k) negative terminal as shows in Figure 3 with the red arrow.
S(k)
M(k−1)
D(2k−4)
D(2k−5)
S(k−1)
M(k−2)
D(2k−6)
D(2k−3)
Figure 3. Current flow between adjacent PV modules in series and parallel connections.
Figure 3 shows the current of a parallel connection. When MOSFET M(k−1) turned off,
the diodes D(2k−3) and D(2k−4) will be correctly biased and become conducting. Note that
the two PV modules Sk and Sk−1 are connected in parallel, resulting in the currents directed
through D(2k−3) and D(2k−4) as shown in the two blue arrow. These two PV modules are
connected in series with the rest of the PV modules in the PV system.

## Page 6

Energies 2025, 18, 5866
6 of 16
On the other hand, for the connection of S1 and S2, a series connection is formed by
turning M1 on and Q1 off, and a parallel connection is formed by turning M1 off and Q1 on.
It is worth mentioning that the voltage stress across each type of switch varies depending
on its position and the switching configuration. The D(k) and Q1 are only subjected to
the voltage of a single module at most, as they connect adjacent modules in a parallel
configuration. In contrast, the M(k) may experience higher voltage stress. The worst-case
voltage stress occurs when the switch M(N−1), which is located at the terminal of the array,
is turned off while the final module S(N) is disconnected. In this case, the switch blocks
the total voltage of the preceding N −1 modules, resulting in a maximum stress of V(N−1),
i.e., the voltage of N −1 Vmodule. More generally, for switches Mk−1, the maximum voltage
stress is V(k−1), which corresponds to the scenario where all modules from SN down to Sk
are either disconnected or configured in parallel, and the remaining modules from S(k−1)
to S1 remain in series.
A typical current–voltage (I-V) and power–voltage (P-V) curve under different irra-
diance levels is shown in Figure 4. It is important to note that irradiance affects not only
the short circuit current ISC but also the output voltage when operating at low current.
In Figure 4a, assuming the modules are currently outputting 3 A, the module receiving
1000 W/m2 has the highest voltage at approximately 44 V, while the modules receiving 800,
600, and 300 W/m2 provide only 43.5 V, 43 V, and 41 V, respectively.
Furthermore, as each module operates closer to its ISC, the voltage drops even more
significantly. This characteristic allows for an estimation of module performance based
on module voltage when the system is operating at its global maximum power point
(GMPP) and identifies the low-performance module by comparing the module voltage to
the system’s average module voltage, VsAvg.
(a)
(b)
Figure 4. A typical IV (a) and PV (b) curve of a module under difference irradiance.
3. Control of Switching Network for Reconfiguration
When partial shading occurs during all PV modules connected in series, the shaded
panel will be disconnected by the bypass diode in the switching network. Therefore, the
shaded panel can be detected by detecting the voltage difference between the bypass diode
instead of the direct measurement of the solar radiation intensity on each PV module.
The above system has provided a similar series-parallel reconfiguration as the full
switch system in Figure 1b with a lower number of transistors and the possibility to use
diodes with low conduction loss as switches in the network.
The control flow, as illustrated in Figure 5, operates as follows. Upon system startup,
a series connection between all modules is initially established, the initial module array

## Page 7

Energies 2025, 18, 5866
7 of 16
is created as [1, 2, 3, . . . , n] and an initial MPPT operation is performed. Once the system
finds the GMPP and starts to generate electricity, A series to parallel sub-flow, as shown
on the left side of Figure 6, is performed. If the switches change flap is true, i.e., changes
were made on the switch network, an MPPT will be performed before starting the parallel
to series sub-flow as shown on the right side of Figure 6. After performing the parallel
to series sub-flow, if the switches change flap is true, another MPPT will be performed
before returning to the series to parallel decision flow and starting another cycle. It is worth
mentioning that the switch network flap is reset to false at the beginning of each sub-flow.
Start
Series Mode
Start MPPT
Start MPPT
Series-parallel Sub-ﬂow
Update
Switches Change Flap
Module_Array Create
Switches Change
Flap == true?
Yes
No
Parallel-Series Sub-ﬂow
Update
Switches Change Flap
Switches Change
Flap == true?
Yes
No
Switches Change
Flap = False
Switches Change
Flap = False
Figure 5. Flow chart of the control logic.
Yes
No
V
>V
s
s
(k,g)
(Avg)
No
Parallel Set S
*
(k,g)
Deconstruct,
module_Array updated
If all I
for
(sx)
k
x
g
≥≥
are equal
Yes
No
last element
in Parallel_array
ﬁnished?
k,g= element in
Parallel_Array
Calculate modules
Current array [I
,..., I
]
s
s
(k)
(g)
Yes
Switches Change
Flap = true
Yes
No
V
<V
s
s
k
Avg
Parallel set
S
created
k,k-1
module_array
Updated
Yes
No
*V
>V
s
s
k-1
k+1
Parallel set
S
d
k+1,k create
module_array
Updated
Get System Voltage
Calculate Module voltage
and Vsavg
Yes
No
last element
in module_Array
ﬁnished?
k= element in
module_Array
*Output Yes if +1 did not exist.
k
Output no if k-1 did not exist.
Switches Change
Flap = true
Switches Change Flap = False
Start
End with returning
module_Array and
Switches Change Flap
Parallel-Series Subﬂow
Series-Parallel Subﬂow
Figure 6. Flow chart of series to parallel conversion sub-flow.

## Page 8

Energies 2025, 18, 5866
8 of 16
3.1. Series-to-Parallel Reconfiguration
The series-to-parallel sub-flow is illustrated on the left side of Figure 6. The system
voltage is measured and the voltage of each module is calculated using Vsk = Vk −Vk−1
or Vs(k,g) = Vk −Vg−1, depends on whether it is a single module, Sk, or a parallel set of
modules, Sk,g. The average module voltage, VsAvg, is then calculated as VsAvg = VN
M −o f f set,
where M is the number of modules in series and an offset is introduced to prevent the
parallel connections from forming when the PV system is operated with low performance
difference across the module. Note that a parallel set could be interpreted as a module
in series connections. The switch change flap is then reset to indicate no switch network
changes were made.
Any module in module-Array with a voltage lower than VsAvg, denoted as Sk, is
then paralleled to its weaker neighbouring module. This effectively pairs a weak module
with a relatively weaker neighbouring module, such as Sk+1 or Sk−1. This means either
switch Mk or Mk−1 will be turned off, respectively. The module array is also updated form
[1, 2, 3, . . . , k −1, k, k + 1, . . . , n] to [1, 2, 3, . . . , k −1, [k, k + 1], . . . , n] for the case that Sk+1
is selected, and to [1, 2, 3, . . . , [k −1, k], k + 1, . . . , n] for the case that Sk−1 is selected. The
[k, k + 1] and [k −1, k] means a parallel set of Sk+1,k and Sk,k−1 respectively.
It is worth mentioning that in case a parallel set, Sk,g, is being evaluated. Either
Sk+1 or Sg−1 will be added to the parallel set, and either switch Mk or Mg−1 will be
turned off. The module array is also updated form [1, 2, 3, . . . , g −1, [g, k], k + 1, . . . , n] to
[1, 2, 3, . . . , g −1, [k, k + 1], . . . , n] for the case that Sk+1 is being added, and to [1, 2, 3, . . . ,
[g −1, k], k + 1, . . . , n] for the case that Sg−1 is being added.
When a parallel connection is formed, the switches change flap is changed to true, and
after all modules in the module array that have a voltage lower than VsAvg have the parallel
connections formed, the switches change flap will tell the main thread whether to perform
another MPPT operation to go directly to the parallel to series sub-flow.
A 4-module reconfiguration system in Figure 7 is used to demonstrate the process
of parallel connection forming and deforming, which will also be used to demonstrate
the effectiveness of the proposed system. Note that in Figure 7, the voltage and current
measuring point has been labelled along with all the components, including PV modules,
S1, , . . . , S4, bypass diode, D1, . . . , D5, series active switch, M1, M2, M3, and active bypass
switch , Q1.
The operating condition of the 4-module system before reconfiguration is listed in the
left column of Table 2, which is initially connected in series. Noted that the information of
the PV module used in this example is the full panel listed in Table 3. A partial shading
condition is being emulated in this setup. That is the modules 1 and 4 receive 1000 W/m2,
while modules 2 and 3 receive 600 W/m2. The series connections are achieved by turning
on switches M3, M2, and M1.
When the system operates at this configuration’s GMPP, i.e., 168.0 V, 5.48 A, the system
voltages V4, V3, V2, and V1 are recorded, and the individual module voltages are identified
using equation Vsk = Vk −Vk−1. Module S1 and module S4 exhibit voltages of 43.8 V, while
modules S2 and S3 show voltages of 40.2 V, resulting in an average module voltage of
VsAvg = 42 V.
Following the flowchart procedure in Figure 6, modules S2 and S3 in Figure 7, with
voltages lower than 42 V, are identified for parallel reconfiguration. For module S2, since
module S3 has a lower module voltage than module S1, a parallel set S3,2 is formed.
Similarly, for module S3, a comparison of module voltages between modules S2 and S4
confirms that parallel set S3,2 should be established. Consequently, the parallel set S3,2 is
formed by turning off M2, and a new MPPT operation is performed.

## Page 9

Energies 2025, 18, 5866
9 of 16
Figure 7. PV system with 4 modules reconfiguration examples.
Table 2. The operating conditions of the PV system for control signal explanation.
Series to Parallel
Parallel to Series
Irradiance on modules
S1
1000 W/m2
1000 W/m2
S2
600 W/m2
1000 W/m2
S3
600 W/m2
1000 W/m2
S4
1000 W/m2
1000 W/m2
Voltage levels at MPP
V1
43.8 V
41.06 V
V2
84.0 V
40.94 V
V3
124.2 V
85.09 V
V4
168.0 V
126.15 V
Current at MPP
I
5.48 A
9.04 A
Activated Switches
M1, M2, M3
D1, D2, D3, M1, M3
Table 3. Characteristics of the PV module under test.
Name
Panel: Karra 350
Module: 1/3 of Panel
Rated Power (Pmax)
350 W
116 W
Rated Power Voltage (Vmp)
37.55 V
12.5 V
Rated Power Current (Imp)
9.32 A
9.32 A
Open Circuit Voltage (Voc)
45 V
15 V
Short Circuit Current (Isc)
9.94 A
9.94 A
Total Number of Cells
66
22
Dimension
1827 × 1000 mm
1827 × 333 mm
3.2. Parallel-to-Series Reconfiguration
The parallel to series sub-flow, as shown on the right side of Figure 6, is executed once
the system stabilises with all the parallel connections in place, the voltage of the system is
measured, and the module voltage and VsAvg is calculated again. It is worth mentioning that
VsAvg is defined as VsAvg = VN
M + o f f set, noted that a positive offset is in place to prevent a
not strong enough parallel set being deconstructed.
All the parallel sets in the module array will be extracted and put into a parallel array
for the following process. For any parallel set, Sk,g, in the parallel array, the set voltage
Vs(k,g) is calculated by Vs(k,g) = Vk −Vg−1 as a module voltage and a check is performed
to assess the energy-generating potential of each parallel set. Noted that g in Sk,g is any
integer number between 1 and k −1, denoting the lower module in the parallel set, while k
ranges from N to 2 and represents the upper module in the parallel set. This check involves
comparing the parallel set voltage Vs(k,g) with VsAvg. If Vs(k,g) exceeds VsAvg, the parallel set is
identified as operating in the high-voltage, low-current region, indicating that additional
power may be extracted. At this stage, the current of each module within the parallel set is
examined to verify current uniformity.

## Page 10

Energies 2025, 18, 5866
10 of 16
The current of the first module, ISk, in the parallel group is obtained by using the
voltage drop across the diode D(2k−4), VSk−1, and, subsequently, the current of each module
in the parallel set can be found. To accurately sense both the module voltage (10–20 V) and
the diode forward drop (10 mV to 1 V), a differential analog-to-digital converter (ADC)
with an integrated programmable gain amplifier (PGA) can be employed. This configu-
ration enables high-resolution measurements across a wide dynamic range, essential for
reliable current estimation. Assuming the diode’s voltage-to-current function is defined as
I = f (V), the current of each module in the parallel set can be calculated as follows:
ISk = f (VSk−1),
ISk−1 = f (VSk−2) −ISk,
ISk−2 = f (VSk−3) −ISk −ISk−1,
...
ISg+1 = f (VSg) −ISg+2 −ISg+3 −· · · −ISk−1 −ISk,
ISg = Isys −f (VSg).
(1)
An example parallel set from Sk+1 to Sk−1, denoted S(k+1,k−1), is shown in the middle
section of Figure 2. The current of the first module, ISk+1, is determined by the voltage drop
on diode D2k−2, measured as VSk. The current of the second module, ISk, is then calculated
as f (VSk−1) −ISk+1, and the current of the last module, ISk−1, is given by Isys −f (VSk−1). It
is worth noting that the parallel set can be bypassed by D2k when the performance of the
parallel set is still unable to match the other module in the system.
If the current across each module in the parallel set is found to be equal, or within
range, and if the set has a higher voltage than VsAvg, it is concluded that all modules have
recovered from shading conditions. In this case, the parallel set is dismantled, allowing
individual modules to reconnect in series. This physically means that for parallel set s(k,g),
all the switch from MK−1 to Mg is turned back on in order to form the series connections.
The module array [1, 2, 3, . . . , [g, k], . . . , n] will also be updated to [1, 2, 3, . . . , g, . . . , k, . . . , n]
to show a series connection between all module Sg to Sk is formed.
After the check has been performed in all parallel sets, if one or more reconfigurations
have occurred, the switch’s change flap is changed to true, which tells the main thread to
perform an MPPT operation before initiating a new cycle. If no reconfiguration is performed
after the check, a new control cycle begins without performing MPPT.
While it is acknowledged that the forward voltage of a diode exhibits a strong de-
pendence on junction temperature, this limitation is mitigated in the proposed system by
placing all diode-connected transistors within a common heat sink. This configuration
ensures a high degree of thermal coupling, thereby maintaining a relatively uniform tem-
perature across all bypass diodes. Given that the objective is to identify relative mismatches
in current among parallel modules—rather than to extract absolute current values—the
uniform thermal environment allows for meaningful comparison. Specifically, the diode
voltage of each module is compared against the average across all modules. Under the
assumption of similar thermal conditions, deviations in forward voltage can be attributed
primarily to differences in current, thus enabling the detection of shaded or underperform-
ing modules.
The same 4-module system, as shown in Figure 7, in a series-parallel configuration, is
used to demonstrate the action of parallel-to-series conversion. The operating condition
of the system initially is listed in the right colume of Table 2, i.e., with modules S2 and
S3 connected in parallel to form the parallel set S3,2, which is in series with modules S1
and S4. In this setup, all modules receive 1000 W/m2. This configuration is achieved by

## Page 11

Energies 2025, 18, 5866
11 of 16
turning on switches M3 and M1, while M2 is turned off. The switches that are turned on
are highlighted in red in the figure.
When the system operates at the GMPP for this configuration, i.e., 126.15 V, 9.04 A,
the system voltages V4, V3, V2, and V1 are recorded, and the individual module voltages
are identified as 41.06 V, 44.03 V, and 41.06 V for S4, S3,2, and S1, respectively. It is worth
mentioning that the parallel set voltage is identified using Vs(k,g) = Vk −Vg−1. The average
module voltage is then calculated as VsAvg = 42.05 V. Next, the parallel set voltage is
compared to VsAvg. In this case, since the voltage for set S3,2 is higher than VsAvg, a current
uniformity check is required.
To perform this check, the voltage across the parallel diode D2 is measured and
identified as −0.12 V. Using the diode characteristics, the current through S3 is determined
to be 4.52 A. By subtracting the current of S3 from the system current of 9.04 A, the current
through S2 is also calculated to be 4.52 A, confirming current uniformity within this parallel
set. Consequently, the parallel set is deconstructed, and a series connection is re-established
by turning M2 from off to on. Following the deconstruction of the parallel set, an MPPT
operation is performed.
4. Simulation Study to Demonstrate Reconfiguration Method
An example of a 4-module reconfiguration system is shown in Figure 7. The PV
module employed in the simulations and in the experiment is detailed in Table 3, where its
key electrical specifications—including rated power, maximum voltage and current, and
cell count—are summarised. The corresponding IV and PV characteristics for this module
are depicted in Figure 4, providing the foundational performance curves upon which the
dynamic reconfiguration analysis is based.
Simulation examples are provided for four distinct shading and reconfiguration sce-
narios. Each case is analysed in terms of switch states, module voltages, resulting current
flow, and IV/PV characteristics.
The equivalent conduction resistances of the switching elements were derived directly
from their datasheet specifications. The diode exhibits an initial forward voltage drop of
28 mV, and has an equivalent resistance of approximately 10 mOhm. In contrast, the switch
presents an on-state resistance of 2.8 mOhm in its single-device configuration. For the
back-to-back MOSFET arrangement employed in Q1, the combined resistance was taken as
twice the single-device value, yielding 5.6 mOhm.
In the simulation environment, each switch element was thus modelled as a simple
series resistor reflecting these equivalent resistances. This abstraction permits direct compar-
ison of conduction losses between the ideal-diode controller and the MOSFET-based switch,
while preserving computational efficiency and ensuring that dynamic reconfiguration
effects can be observed without the complexity of full nonlinear semiconductor models.
The first example demonstrates the sensing and connections reconfiguration from
series to parallel, which is controlled by the proposed control system on a four-module
PV string under non-uniform irradiance. That is S4 at 1000 W/m2, S3 at 800 W/m2, S2 at
500 W/m2, and S1 at 300 W/m2. Figure 7 and the first column of condition 1 in Table 4
depicts the initial series connection of all four modules under differing shading levels.
Switches M1 through M4 were enabled to establish a single-path current flow. The GMPP
is at 169.4 V (V4) and 2.73 A (I), the module voltages were calculated as VS4 = 44.70 V,
VS3 = 44.30 V, VS2 = 43.26 V, and VS1 = 37.14 V, yielding an average module voltage of
VsAvg = 42.35 V.

## Page 12

Energies 2025, 18, 5866
12 of 16
Table 4. The operating conditions of the PV system in the example.
Condition 1
Condition 2
Before
Reconfigure
After Reconfigure
Before
Reconfigure
After Reconfigure
Irradiance on modules
S1
1000 W/m2
1000 W/m2
S2
800 W/m2
1000 W/m2
S3
500 W/m2
1000 W/m2
S4
300 W/m2
1000 W/m2
Voltage levels at MPP
V1
37.14 V
−24.17 mV
−25.14 mV
40.21 V
V2
80.40 V
38.63 V
44.02 V
80.42 V
V3
124.7 V
79.06 V
83.75 V
120.63 V
V4
169.4 V
121.99 V
123.51 V
160.86 V
Current at MPP
I
2.73 A
7.34 A
9.40 A
9.31 A
Activated Switches
M1, M2, M3
Q1, D1, M2, M3
Q1, D1, M2, M3
M1, M2, M3
Because VS1 < VsAvg, the series-to-parallel decision flow in Figure 6 was invoked.
Switch M1 was opened to form the parallel set S2,1. The operating voltage of each PV
module and system current after the reconfiguration have been shown in the second
column of condition 1 at Table 4. The disables of M1 isolate S1 from the series chain, and Q1
is enabled to connect it in parallel with S2. The individual branch currents are recombining
at M2. As illustrated in Figure 8a, this configuration increases the extractable power from
463 W to 895 W, corresponding to 90.6% efficiency and a 193% improvement over the
original series-only connection.
The second example demonstrated how the proposed control method handles a
recovery of the same PV system from a partial shading condition. The irradiance on the
four PV modules is uniform and is at 1000 W/m2. Consider the partial shading condition
has just been removed and modules S1 and S2 are still connected in parallel, which switch
M1 is turned off and transistor Q1 is enabled, resulting in the parallel set S2,1. Using the
information listed in Condition 2 column 1 at Table 4, the average module voltage can be
calculated and is VsAvg = 41.18 V. By applying VS1 and the known on-resistance of Q1, the
branch current of S1 is calculated as 4.88 A. Given the total system current of 9.40 A, the
complementary branch current of S2 is determined to be 4.52 A. The minor discrepancy
between these two values is attributed to the slight resistance difference between the ideal-
diode path and the back-to-back MOSFET switch, which shifts the individual maximum
power points (MPPs).
0
50
150
200
100
0
500
1000
1500
Power(W)
0
50
150
200
100
Voltage(V)
0
10
20
Current(I)
(b)
0
50
150
200
100
0
500
1000
1500
Power(W)
0
50
150
200
100
0
5
10
Current(I)
(a)
Voltage(V)
896W
463W
1154W
740W
1495W
Figure 8. The associated PV and IV curves of the system (a) suffering partial shading and (b) having
the partial shading condition removed.
Because the parallel set voltage VS2,1 exceeds VsAvg and the branch currents are closely
matched, the deconstruction criterion of the parallel-to-series decision flow, as shown

## Page 13

Energies 2025, 18, 5866
13 of 16
in Figure 6, is satisfied. In order to restore the series connection on all four modules,
all switches M1–M4 are on and Q1 is off, producing a unified current path through the
series string.
Figure 8b shows the PV and IV curve on these conditions before and after the recon-
figures. Before the reconfiguration, the global maximum extractable power under this
configuration is 1161 W, corresponding to 77% efficiency. And after the reconfiguration,
the new GMPP occurs at 1498 W, achieving 100% of the panel string’s summed individual
MPPs and demonstrating full recovery of the original power capacity.
5. Experiential Result
The experiments were conducted using Karra 350 PV panel, which is listed in Table 3,
from which one-third of the panel area was electrically isolated and treated as an individual
“module” for testing purposes. The electrical characteristics of the full panel and individual
“module” under standard test conditions (STC) are provided in Table 3. They are captured
by Spire Sun Simulator 4600SLP.
To evaluate the proposed reconfiguration method under controlled irradiance patterns,
a custom solar simulator was constructed. The simulator consists of eight LED grow light
panels arranged in a 4 × 2 grid, mounted above the PV panel plane. The vertical separation
between the lights and the PV plane was fixed at 30 cm to ensure repeatable irradiance
mapping. The resulting heat map is shown in Figure 9. The map shows higher irradiance
in the central region, consistent with the overlapping beams from adjacent light panels.
Light
Source
Light
Source
Light
Source
Light
Source
Light
Source
Light
Source
40cm
6.6cm
Light
Source
Light
Source
60cm
Figure 9. The irradiance heat map of the solar simulator.
This irradiance profile was overlaid onto the PV panel geometry to determine the light
incident on each submodule, as shown in Figure 10. In the configuration used for testing,
the middle submodule S2 received the highest irradiance, while the outer submodules S1
and S3 experienced similar, lower irradiance levels. These patterns were used to define the
partial shading conditions in the test matrix.
A programmable DC electronic load (Tenma 72–13210, 300 W, 0–120 V, 0–30 A) was
used to obtain IV characteristics for each test condition. This load are used as a data
collection device as well. The internal voltage/current measurement resolutions of the load
is 1/10 mV and 0.1/1 mA respectively, and typical accuracies of ±(0.03% set + 0.025% f.s.)
for voltage and ±(0.05% set + 0.045% f.s.) for current. A control program communicated
with the load to perform voltage sweeps from the open-circuit voltage Voc down to 0 V in
fixed steps of 0.1 V. At each step, the load operated in constant-voltage mode, holding the

## Page 14

Energies 2025, 18, 5866
14 of 16
target voltage for a dwell time of 1.5 s to allow current stabilisation before recording both
voltage and current readings. The instantaneous power P = VI was calculated for each
point, and the maximum power point (Pmpp) was determined for each configuration.
S3
S2
S1
D3
D1
D2
Q1
M1
M2
S3
S2
S1
M3
I
v2
v1
v3
+
-
Figure 10. The irradiance heat map of the solar simulator overlaid with the proposed PV system
under test.
Two experimental scenarios were evaluated to demonstrate the effectiveness of the
proposed reconfiguration method. In both cases, the initial and reconfigured P-V and
I-V characteristics are shown in Figure 11a,b, while the typical non-shaded P-V and I-V
characteristics are illustrated in Figure 11c.
(b)
(a)
45.8W
38.4W
38.4W
45.6W
0
5
15
20
25
30
35
40
45
10
Voltage (V)
0
50
100
Power (W)
0
5
15
20
25
30
35
40
45
10
Voltage (V)
0
1
2
3
Current (A)
99.2W
c)
(
Figure 11. The associated PV and IV curves of the system with (a) S1 and S2, and (b) S2 and S3,
suffered from partial shading, and (c) normal non-shaded condition.
In the first test, partial shading was applied to submodules S1 and S2 (Figure 11a). With
the active bypass switch disabled, the array current was limited by the lowest-performing
module, S1, and no local maximum power point (LMPP) was observed. After reconfig-
uration, S1 and S2 were connected in parallel to form a combined unit S(2,1), which was
then placed in series with the fully illuminated S3. This increased the overall MPP from
38.4 W (three modules in series) to 45.6 W. Because S(2,1) produced higher voltage than S3
under these conditions, S3 was driven into reverse bias, activating its bypass diode D3 and
creating a LMPP near 12 V after reconfiguration.
In the second test, shading was applied to S2 and S3 (Figure 11b). Before reconfigura-
tion, the bypass diode across S3 automatically provided an alternative current path when
S3 entered reverse bias, resulting in the appearance of a LMPP. After reconfiguration, S2
and S3 were connected in parallel to form S(3,2), which was then connected in series with

## Page 15

Energies 2025, 18, 5866
15 of 16
the fully illuminated S1. This arrangement increased the MPP from 38.4 W (three modules
in series) to 45.8 W, demonstrating improved utilisation of the available irradiance.
In both cases, the reconfiguration redistributed the mismatch losses more effectively,
enabling a higher operating power point under the given shading conditions.
6. Conclusions
This work proposed a novel switching circuit and control methodology to address
the reduction in output power of PV systems caused by partial shading. The design
emphasises efficiency and simplicity, leveraging power MOSFETs and diodes to enable
dynamic series-to-parallel reconfiguration with minimal conduction losses. The proposed
method eliminates the need for solar radiation intensity measurements, rather than detect-
ing shading conditions through bypass current and voltage measurements. By reducing the
number of switches through diode integration and requiring only a single voltage sensor
per module, the control system is significantly simplified compared to existing methods.
The proposed circuit and control method not only detect shading conditions but also
identify their removal, enabling real-time reconfiguration to maximise energy generation.
Both simulation and experimental results validate the effectiveness of the approach. In
simulations, a 4-module PV system achieved significant MPP increases—from 900 W to over
1100 W and from 460 W to 900 W—while restoring performance to 1500 W once shading
was removed. Experimental verification on a 3-module setup under controlled partial
shading demonstrated similar gains: for shading on S1 and S2, the MPP increased from
38.4 W to 45.6 W after reconfiguration; for shading on S2 and S3, the MPP increased from
38.4 W to 45.8 W. In both cases, the reconfiguration successfully redistributed mismatch
losses and improved utilisation of the available irradiance.
The voltage stress across each active and passive switch in the array has been analyti-
cally identified, ensuring that each device operates within its safe voltage range under all
possible configurations. The implementation challenges posted by the proposed PV system,
i.e., wide-range accurate voltage measurement and the effect of temperature variation on
current measurements, have also been addressed in this paper. These refinements enhance
the reliability of detection and control, marking the proposed switch network and its control
strategy as more practical for real-world deployment.
However, the proposed topology allows the formation of parallel connections only
between consecutive modules. This structural limitation constrains the flexibility of the
reconfiguration and may prevent the system from achieving the absolute global maximum
power point under certain irregular shading patterns where non-adjacent modules share
similar irradiance levels. Nevertheless, this design trade-off greatly reduces circuit com-
plexity, conduction loss, and control overhead, rendering the method practical and scalable
for real-world PV systems.
In summary, the proposed switching circuit and control scheme provide a highly
efficient and responsive solution to partial shading, reducing component complexity while
maximising energy yield. These characteristics make the method a promising candidate for
deployment in commercial PV applications.
Author Contributions: Conceptualization, W.K.N.; Methodology, N.E.; Formal analysis, W.K.N.;
Investigation, W.K.N.; Resources, N.E.; Writing—original draft, W.K.N.; Writing—review & editing,
W.K.N. and N.E.; Supervision, N.E.; Funding acquisition, N.E. All authors have read and agreed to
the published version of the manuscript.
Funding: This research received no external funding.
Data Availability Statement: The original contributions presented in this study are included in the
article. Further inquiries can be directed to the corresponding author.

## Page 16

Energies 2025, 18, 5866
16 of 16
Conflicts of Interest: The authors declare no conflict of interest.
Abbreviations
The following abbreviations are used in this manuscript:
PV
Photovoltaic
MPPT
Maximum Power Point Tracking
TCT
Total-Cross-Tied
DPDT
Double-pole Double-throw
I-V
Current–voltage
P-V
Power–voltage
MPP
Maximum Power Point
GMPP
Global Maximum Power Point
STC
Standard Test Conditions
LMPP
Local Maximum Power Point
References
1.
Calcabrini, A.; Muttillo, M.; Weegink, R.; Manganiello, P.; Zeman, M.; Isabella, O. A fully reconfigurable series-parallel
photovoltaic module for higher energy yields in urban environments. Renew. Energy 2021, 179, 1–11. [CrossRef]
2.
Calcabrini, A.; Muttillo, M.; Zeman, M.; Manganiello, P.; Isabella, O. Electrical performance of a fully reconfigurable series-parallel
photovoltaic module. Nat. Commun. 2023, 14, 8113. [CrossRef] [PubMed]
3.
Kukunuru, S.R.; Naeimi, Y.; Salem, L.G. A Series-Parallel Switched-Photovoltaic DC–DC Converter. IEEE J. Solid-State Circuits
2023, 58, 742–756. [CrossRef]
4.
Tanemo, M.; Matsudate, K.; Nomura, S. Change in Circuit Configuration of Photovoltaic Modules Using Series/Parallel Switching
Circuits Composed of Power MOSFETs. IEEE J. Ind. Appl. 2020, 9, 73–81. [CrossRef]
5.
Ameen, F.; Siddiq, A.; Trohák, A.; Benotsmane, R. A Scalable Hierarchical Dynamic PV Array Reconfiguration under Partial
Shading. Energies 2023, 17, 181. [CrossRef]
6.
Yadav, V.K.; Yadav, A.; Yadav, R.; Mittal, A.; Wazir, N.H.; Gupta, S.; Pachauri, R.K.; Ghosh, S. A novel reconfiguration technique
for improvement of PV reliability. Renew. Energy 2022, 182, 508–520. [CrossRef]
7.
Yang, B.; Ye, H.; Wang, J.; Li, J.; Wu, S.; Li, Y.; Shu, H.; Ren, Y.; Ye, H. PV arrays reconfiguration for partial shading mitigation:
Recent advances, challenges and perspectives. Energy Convers. Manag. 2021, 247, 114738. [CrossRef]
Disclaimer/Publisher’s Note: The statements, opinions and data contained in all publications are solely those of the individual
author(s) and contributor(s) and not of MDPI and/or the editor(s). MDPI and/or the editor(s) disclaim responsibility for any injury to
people or property resulting from any ideas, methods, instructions or products referred to in the content.
