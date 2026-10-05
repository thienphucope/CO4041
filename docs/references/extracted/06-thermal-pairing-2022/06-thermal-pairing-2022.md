# Raw extract: pv-reconfig-thermal-pairing-2022.pdf

> Text extracted by PyMuPDF in PDF reading order. Figures and formulas must be checked against the original PDF.
> PDF: [../../pv-reconfig-thermal-pairing-2022.pdf](../../pv-reconfig-thermal-pairing-2022.pdf)
> Pages: 22
> DOI: https://doi.org/10.3390/en15228450 · PDF download: https://mdpi-res.com/d_attachment/energies/energies-15-08450/article_deploy/energies-15-08450.pdf

---

## Page 1

Energies 2022, 15, 8450. https://doi.org/10.3390/en15228450 
www.mdpi.com/journal/energies 
Article 
Performance Analysis of Thermal Image Processing-Based  
Photovoltaic Fault Detection and PV Array Reconfiguration—A 
Detailed Experimentation 
Srinivasan Alwar 1, Devakirubakaran Samithas 2, Meenakshi Sundaram Boominathan 1,  
Praveen Kumar Balachandran 3 and Lucian Mihet-Popa 4,* 
1 Department of Electrical and Electronics Engineering, Sethu Institute of Technology,  
Virudhunagar 626115, India 
2 Department of Electrical and Electronics Engineering, QIS College of Engineering and Technology,  
Ongole 523272, India 
3 Department of Electrical and Electronics Engineering, Vardhaman College of Engineering,  
Hyderabad 501218, India 
4 Faculty of Information Technology, Engineering and Economics, Oestfold University College,  
1757 Halden, Norway 
* Correspondence: lucian.mihet@hiof.no 
Abstract: Due to the flexibility, sustainability, affordability, and ease of installation of solar photo-
voltaic systems, their use has significantly increased over the past two decades. The performance of 
a solar PV system can be constrained by a variety of external conditions, including hotspots, partial 
shade, and other minor faults. This causes the PV system to permanently fail and power losses. The 
power output in a partially shaded solar system is improved in this work by the introduction of a 
fault classifier based on thermal image analysis with a reconfiguration algorithm. For that purpose, 
the entire PV array is divided into two parts, with one of these being the male part and the other 
being the female part. MOSFET switches are used to build the switching matrix circuit that connects 
these parts. The Flir T420bx thermal camera captures thermal pictures, and MATLAB/Simulink® is 
used to extract the image properties. The pairing reconfiguration pattern is found using an algo-
rithm based on image processing and the image attributes. The switching signals to the switching 
circuit are triggered by an Arduino controller. The image attributes of the thermal images may also 
be used to categorize PV system defects. This reconfiguration technique is easy, simple to use, and 
it can also be used to check the health of each PV module. The performance of the proposed work 
was validated using a 5 kW PV system with a 4 × 5 TCT array configuration at Sethu Institute of 
Technology’s renewable energy lab in India. The proposed method was simulated using the 
MATLAB-Simulink software program, and the outcomes were verified on different hardware set-
ups. 
Keywords: image processing; reconfiguration; photovoltaics; mean; standard deviation; MOSFET 
 
1. Introduction 
The world’s energy demand and the rate at which traditional energy sources are be-
ing used up have both risen in recent decades and will continue to do so. If this phenom-
enon persists, conventional energy sources will no longer be accessible in the future. In 
order to maintain the equilibrium between energy demand and power supply, the energy 
need necessitates an alternate path for the energy sources. Utilizing renewable energy 
sources such as solar, wind, biomass, tidal energy, and others are needing a better way to 
maintain the balance between energy demand and power supply. The ecosystem is not 
harmed by renewable energy sources, which are abundant in nature. These sources are 
Citation: Alwar, S.; Samithas, D.; 
Boominathan, M.S.;  
Balachandran, P.K.; Mihet-Popa, L. 
Performance Analysis of Thermal 
Image Processing-Based Fault  
Detection and Reconfiguration  
Algorithm in Partially Shaded PV  
Systems—A Detailed Experimenta-
tion. Energies 2022, 15, 8450. 
https://doi.org/10.3390/en15228450 
Academic Editors: Athanasios I.  
Papadopoulos and Andrea  
Reverberi 
Received: 26 September 2022 
Accepted: 8 November 2022 
Published: 11 November 2022 
Publisher’s Note: MDPI stays neu-
tral with regard to jurisdictional 
claims in published maps and institu-
tional affiliations. 
 
Copyright: © 2022 by the authors. Li-
censee MDPI, Basel, Switzerland. 
This article is an open access article 
distributed under the terms and con-
ditions of the Creative Commons At-
tribution (CC BY) license (https://cre-
ativecommons.org/licenses/by/4.0/).

## Page 2

Energies 2022, 15, 8450 
2 of 22 
 
not always available during harvest, yet they nonetheless produce a consistent overall 
result. Renewable energy sources are now expected to overtake other energy sources be-
cause of advancements in harvesting technology. In terms of easy setup, operation, low 
maintenance, and other factors, solar energy harvesting offers several benefits over other 
renewable energy sources. Based on the photovoltaic effect, solar photovoltaic systems 
convert sunlight (and the photons contained within) into direct electricity [1,2]. 
The first solar photovoltaic modules, with an energy conversion rate of 6.33 percent, 
were introduced to the energy market in 1981. Compared to other renewable energy 
sources, the PV system’s installation has fewer drawbacks. While the current generated 
by a PV cell is directly proportional to the amount of solar radiation received by the PV 
cell surface, the power generated by a PV system depends heavily on solar radiation [3]. 
On the other hand, a variety of factors, some of which are diagnosable, such as partial 
shade, hotspots, diode failure, minor flaws, fractures, the burning of strings, PV cell fail-
ure, and others, restrict the amount of power that a PV system can produce. However, 
certain factors, such as hotspots and partial shading, are unavoidable [4]. PV systems com-
monly experiences partial shade, which is the most prevalent occurrence. The uneven dis-
tribution of solar irradiation caused by this partial shade reduces power output by creat-
ing hotspots that raise the temperature of the PV panel. Additionally, due to the excessive 
current flow, this causes the PV cell to fail. The building-integrated PV system is more 
affected by partial shade. To increase the power conversion rate of a PV system, the effect 
of partial shade must be reduced. There are several strategies available to lessen the effects 
of partial shadowing. By obtaining the GMPP (global maximum power point), as ex-
plained in [5], maximum power point tracking (MPPT) can be one of the approaches that 
creates an equilibrium between the source resistance and load resistance. Conventional 
MPPT approaches, such as MPPT algorithms based on perturb and observe (P&O) [6] and 
incremental conductance (InC) [7], may fail to acquire the GMPP in a complicated partial 
shading situation because of the high cost of MPPT implementation on PV systems. Opti-
mization techniques that make use of particle swarm optimization (PSO), neural networks 
(NNs), artificial neural networks (ANNs), ant colony optimization (ACO), the cuckoo 
search-based algorithm [8], and the musical chair-based algorithm [9] are integrated with 
conventional methods. The ability to precisely of produce the GMPP is slowly improving 
because of these strategies. 
PV array configurations can also reduce the impact of partial shadowing by distrib-
uting light equally over the array. In the beginning, two array configurations were used: 
series (S) and series-parallel (Se-P). In certain situations, a complex type of partial shading 
may cause the available power output at the load terminal to be zero. In [10], the total-
cross-tied (TCT) array configuration, which combines both series and series-parallel array 
design, was created. Although the TCT method lessens the impact of partial shade, it was 
ineffective in particular shading patterns. For increasing the power production, several 
PV array arrangements such as honeycomb, bridge-connected, and Sudoku pattern array 
configurations were discussed in [11]. The reconfiguration technique [12] is another 
method for reducing partial shadowing. In this method, the interconnections between the 
PV modules are switched based on the partial shading situation. The two types of recon-
figuration procedures are static reconfiguration and dynamic reconfiguration. The recon-
figuration strategy raises the cost of a PV system by requiring many sensors, switches, 
controlling units, and cables. Time is set aside during reconfiguration to measure the data 
and rearrange the interconnections of the modules. As mentioned before, the reconfigu-
ration technique is highly complicated due to the numerous measurements, scanning 
time, and pattern construction time involved. The reconfiguration technique is the focus 
of much research aimed at reducing the amount of data needed, the scanning time, and 
the complexity. 
The scanning pattern reconfiguration technique in [13] requires electrical data such 
as the current and voltage as well as values for temperature and radiation. This approach 
requires a longer scanning period, which is even shorter in [14]. The drawbacks have been

## Page 3

Energies 2022, 15, 8450 
3 of 22 
 
solved by the suggested reconfiguration procedure, which effectively increases power 
production. Injecting the compensatory current across the shaded or defective PV rows is 
known as the current injection approach, and other techniques were presented in [15]. By 
operating the PV system with even current generation rows, the mismatch losses are 
greatly reduced, and the power produced is increased. 
For minimizing the impact of partial shadowing in a PV system, further configura-
tions derived from puzzle patterns were explored in spiral pattern reconfigurations [16] 
and both L-Shape propagating array [17] and KenKen puzzle [18] configurations. When 
developing any type of system, it is essential to consider fault detection and diagnosis 
equipment [19]. The energy production, transmission, and distribution units require extra 
attention. There are several approaches for finding faults in solar photovoltaic systems. 
The misidentification of issues might cause a PV system serious harm. Due to an unde-
tected diode failure or burning on the string, a PV module might malfunction perma-
nently. A defect detection approach based on electrical factors was suggested in [20]. Early 
on, each PV string’s performance is assessed to detect any abnormalities regarding the PV 
system. 
Later, measurements based on PV generating units are performed, and a thorough 
report is produced for each unit. This includes information on power generation in rela-
tion to the available radiation, power generation in relation to the temperature of the en-
vironment, a comparison of the neighboring producing units, and efficiency. The variance 
in these statistics reveals the proportion of faults in the PV system. The assessment in dig-
ital contexts lays the foundation for defect identification via image processing. In [21], the 
authors proposed employing resistance analysis by mapping of potential (RAMP) meth-
ods to map contact resistance (CoRRescan) and locate shunts on solar cells. Both reducing 
contact resistance losses and measuring contact resistance are crucial. 
The fine structure of solar cells with and without metallic coatings may be examined 
using a scanning electron microscope (SEM) and atomic force microscopy (AFM) images, 
allowing for rapid and simple structural analysis, according to a novel approach pre-
sented in [22]. The local photo-response of a solar cell may be determined using the light 
beam-induced current (LBIC) approach, allowing for the evaluation of the spatial distri-
bution of electrical characteristics and defects. In [23], the I–V characteristics, short-circuit 
current, carrier lifespan, and quantum efficiency of a solar cell were measured while the 
beam probe was being moved over a solar cell. The use of thermography image on the PV 
fault detection [24], MPPT techniques [25], temperature distribution analysis [26] were 
discussed. 
The main contributions of this research paper are as follows: 
- 
A novel defect classifier with dynamic reconfiguration based on thermal image pro-
cessing is proposed.  
- 
The power output in the partially shaded solar system is improved by the introduc-
tion of a fault classifier based on thermal image analysis with the reconfiguration 
algorithm. 
- 
The pairing reconfiguration pattern is found using an algorithm based on image pro-
cessing and the image attributes. 
- 
The performance of the proposed work was validated first using the MATLAB-Sim-
ulink software package and then using an experimental setup featuring a 5 kW PV 
system with a 4 × 5 TCT array configuration. 
The article is structured as follows: Section 2 explains how the reconfiguration algo-
rithm was created; Section 3 explains how the pairing reconfiguration was experimentally 
validated; Section 4 explains how a fault classifier based on thermal image processing was 
created; and Section 5 explains how the thermal image processing-based pairing reconfig-
uration algorithm was validated.

## Page 4

Energies 2022, 15, 8450 
4 of 22 
 
2. Pairing Reconfiguration Algorithm 
In a conventional TCT PV array, the current generation of each row should be almost 
equal; otherwise, current match will occur between the PV rows, causing a mismatch 
power loss on the PV system, which is when the minimum current generating rows limit 
the entire power generation. Therefore, it is important to operate the PV rows with an 
even current generation. The proposed pairing reconfiguration algorithm makes all PV 
rows as an even current generating row. This will reduce the mismatch losses, so that the 
power output can be enhanced. Initially, the PV system is split into two parts named male 
and female. Both the male and female parts must have an equal number of rows. These 
parts are connected through the switching matrix circuit, where the connections are es-
tablished by the pairing reconfiguration algorithm. The pairing pattern of the algorithm 
is obtained based on the current generating capability of the PV rows. The maximum cur-
rent generating row from the male part is paired with the minimum current generating 
row of the female part. The main constraint of the proposed pairing reconfiguration algo-
rithm is that at any instant of time one row from the male part is connected to only one 
row of the female part, but not more than one. 
Depending on the current generation, males and females are categorized and then 
paired to achieve optimum power generation. The healthier part, male or female, is 
ranked as 1 in the sorting process. In Figure 1, M1, M2, M3, and M4 are the rows of the 
male part, and F1, F2, F3, and F4 are the rows of female part. The health of M1 is good 
compared to M2, the health of M2 is good compared to M3, and the health of M3 is good 
compared to M4. The health of F2 is good compared to F4, the health of F4 is good com-
pared to F1, and the health of F1 is good compared to F3. For this group, the couples 
should be matched as M1–F3, M2–F1, M3–F4, and M4–F2, to achieve the best generation. 
The couple matching algorithm has been executed in this way by connecting the maxi-
mum current generating row of the male part with the minimum current generating row 
of the female part. This kind of couple matching results in almost equal health conditions 
in terms of the generations of the couples. 
 
Figure 1. Male and female couple matching. 
The Figure 2 shows the proposed 4 × 5 TCT array system for implementing the pair-
ing reconfiguration algorithm.

## Page 5

Energies 2022, 15, 8450 
5 of 22 
 
S11
S21
S31
S41
S12
S22
S32
S42
S13
S23
S33
S43
S14
S24
S34
S44
S44'
S34'
S24'
S14'
S43'
S33'
S23'
S13'
S42'
S32'
S22'
S12`
S41'
S31'
S21'
S11'
Male Part 
(4×3 PV Array)
4×4 SWITCHING CIRCUIT 
– I
(Positive Pair)
4×4 SWITCHING CIRCUIT – II
(Negative Pair)
CONTROLLER
Male Part 
Short Circuit 
Current
Trigger signal to 
Switching 
circuit I
Female Part 
Short Circuit 
Current
Trigger signal to 
Switching 
circuit II
Female Part
(4×3 PV Array)
P11
P14
P15
P21
P22
P23
P31
P32
P33
P41
P42
P43
P24
P25
P34
P35
P44
P45
P12
P13
 
Figure 2. Proposed 4 × 5 TCT array with twenty panels. 
The 4 × 5 TCT array can be split into a 4 × 3 male part and a 4 × 2 female part, and so, 
the male part has four males and female part has four females. Figure 3 shows the 
flowchart of the proposed method. Initially, the load current is measured, and after five 
seconds, the load current is measured again, before the percentage change in current (% 
∆IL) is calculated by Equation (1). 
1
2
1
%
100
L
L
L
L
I
I
I
I
−
Δ
=
×
  
(1)
The working of the proposed methodology is represented as a flowchart, as shown 
in Figure 3. Under daytime normal conditions, the load current gradually increases in the 
morning and then decreases in the afternoon. During partial shading, the load current 
suddenly decreases (more than 5% within a fraction of a second). This helps to identify 
the partial shading period. In the pairing reconfiguration algorithm, if the first condition 
is satisfied (if the percentage change in the load current exceeds five percent), then the 
panels are reconfigured. The change in load current is calculated after the time period ∆Dt 
(the delay time). In this paper, the value for ∆Dt is taken as five seconds. To find the re-
configuration pattern, first, this algorithm disconnects the load away from the array and 
measures the short circuit current of each male in the male part and each female in the 
female part. Then, according to the values of their short circuit current, males and females 
are sorted (in descending order). Finally, a reconfiguration pattern is obtained by using 
Equation (2) and implemented by operating the matrix switching circuit accordingly. The 
matrix switching circuit has 16 switches for positive side control and 16 switches for neg-
ative side control. The matrix switching circuit can connect any female to any male, as 
described by the Equation (2).

## Page 6

Energies 2022, 15, 8450 
6 of 22 
 
1
2
2
1
.
Re
_
(
)
.
.
.
SS
SSX
SS
SS
SSX
SS
M
F
M
confguration
Pattern RC
F
M
F








=








  
(2)
 
Figure 3. Flow chart of the proposed algorithm. 
3. Experimental Setup Description 
A 5-kW solar plant was installed in the Department of Electrical and Electronics of 
Sethu Institute of Technology, India and the specification of the PV panel are given in 
table 1. The rated capacity of the plant is 5 kW, and it was constructed by using twenty 
numbers of 250 W mono-crystalline PV panel, as shown in Figure 4. The array size of the 
PV array is 4 × 5, which can be split into 4 × 3 male parts and 4 × 2 female parts or 4 × 2 
male parts and 4 × 3 female parts. 
 
Figure 4. 5 kW PV Array. 
The panel rating is given below.

## Page 7

Energies 2022, 15, 8450 
7 of 22 
 
Table 1. Specifications of PV panel. 
S.No 
Parameters 
Specification 
1 
Maximum Power of a Single Panel (POUT) 
250 W 
2 
Open Circuit Voltage (VOC) 
37.23 V 
3 
Short Circuit Current (ISC) 
8.95 A 
4 
Maximum Voltage (VM) 
29.7 V 
5 
Maximum Current (IM) 
8.42 A 
6 
Tolerance (%) 
±5% 
7 
STC Temperature (TSTC) 
25 °C 
8 
Normal Operating Temperature (TA) 
45 °C 
9 
Temperature Coefficient (%/°C) 
−0.43%/°C 
For the execution of the project, the positive and negative terminals of each PV panel 
were brought into the Centre for Renewable Energy Systems Laboratory on the second 
floor of the department, where the image processing technique reconfiguration algorithm 
could be performed. The photograph of the hardware setup is shown in Figure 5. 
 
Figure 5. Photograph of the hardware setup. 
Twenty positive and negative terminals of the PV modules were brought into the 
laboratory, as shown in the hardware setup. The hardware setup was initiated from the 
isolation circuit and protection circuit. If the system was to handle the high current flow 
of 30 A to 40 A of DC, it was necessary to provide the proper isolation and protective setup 
for avoiding electrical hazards. Therefore, the PV terminals were brought into the testing 
panel via the isolator and OLR (overload protective relay). The isolator circuit provided 
complete control over each PV module. During the wiring and interfacing of the measure-
ment units, the power output from the modules can be turned off by the isolators. It is 
challenging work to interface any measuring units or switches or wires on active PV sys-
tems because it may damage the equipment, components, or the PV modules and some-
times it causes a fire accident. Such a protective step allowed for the completion of the 
testing and measurements in the PV system without any difficulties. Twenty 60 A, 2Pole 
isolators were used for the isolation circuit, and twenty 20 A DC cartage fuses with

## Page 8

Energies 2022, 15, 8450 
8 of 22 
 
cartages were used for the protective circuit. The positive and negative terminals of each 
PV module were connected to the testing panels through the isolation circuit and protec-
tive circuit. 
At this stage, each module was ready for the integration of the experimental setup. 
A testing panel was fabricated for the project execution. This testing panel allowed for the 
easy interfacing of the necessary units, such as measuring units or switching units, with 
the 5 kW PV system, and the array configuration of the PV system could be changed in a 
desired manner, such as in a series-parallel (SE-P), total-cross-tied (TCT) or Sudoku puz-
zle pattern, etc.  
For executing the couple matching algorithm, the inputs to the controller must be 
obtained appropriately. The short circuit current of each male part and female part is the 
input for the controller, which is measured by the current sensing unit, as shown in Figure 
6. The R11, R12, R13, R14, R21, R22, R23, and R24 are the solid-state relays, which are terminals 
that are connected across each row of male and female parts for shorting the male parts 
and female parts. AM1, AM2, AM3, and AM4 are the current sensors connected across male 
parts and AF1, AF2, AF3, AF4 are the current sensors connected across female parts. During 
the enabling time of the relays, the sensors measured the short circuit and stored it for the 
pairing reconfiguration algorithm. The short circuit period was 2 s and it was opened after 
this time. 
 
Figure 6. Photograph of current sensing unit. 
The switching circuit was constructed with MOSFET for coupling the male part with 
the female part. The switching circuit size for any kind n×m PV array will be (2 × n × n) 
where n is the number of rows. In this work, the required number of switches was 32 (2 × 
4 × 4) for the 4 × 5 PV array. The switching configuration is shown in the Figure 7a,b. The 
working principle of this circuit is to connect any one of the male part rows with any one 
of the female part rows. The layout diagram and a photograph of the switching matrix 
circuit are shown in Figure 7c.

## Page 9

Energies 2022, 15, 8450 
9 of 22 
 
 
 
(a) 
(b) 
 
(c) 
Figure 7. (a) Positive pair of switching matrix circuit; (b) negative pair of switching matrix circuit; 
(c) photograph of the switching matrix circuit. 
The switching representation is given below in Table 2. 
Table 2. Details of switching circuit. 
S.No 
Switch Name 
Operation 
1 
S11, S11′ 
Connects Row 1 with Row 1 
2 
S12, S12′ 
Connects Row 1 with Row 2 
3 
S13, S13′ 
Connects Row 1 with Row 3 
4 
S14, S14′ 
Connects Row 1 with Row 4 
5 
S21, S21′ 
Connects Row 2 with Row 1 
6 
S22, S22′ 
Connects Row 2 with Row 2 
7 
S23, S23′ 
Connects Row 2 with Row 3 
8 
S24, S24′ 
Connects Row 2 with Row 4 
9 
S31, S31′ 
Connects Row 3 with Row 1 
10 
S32, S32′ 
Connects Row 3 with Row 2 
11 
S33, S33′ 
Connects Row 3 with Row 3 
12 
S34, S34′ 
Connects Row 3 with Row 4 
13 
S41, S41′ 
Connects Row 4 with Row 1 
14 
S42, S42′ 
Connects Row 4 with Row 2 
15 
S43, S43′ 
Connects Row 4 with Row 3 
16 
S44, S44′ 
Connects Row 4 with Row 4 
S represents connection from male to female; S′ represents connection from female to male.

## Page 10

Energies 2022, 15, 8450 
10 of 22 
 
The triggering pulse from the Arduino controller was not sufficient for operating the 
switching matrix circuit. So, a switching driver circuit was designed for amplifying the 
switching signals, as shown in Figure 8. There sixteen numbers relay drivers were used 
for operating the sixteen solid-state relays of positive and negative pairs of the switching 
matrix circuit. The rating of the SSR allowed for a 60 A DC current to be passed through 
it, and 3–32 V DC is the operating range of triggering pulses. 
 
Figure 8. Photograph of switching driver circuit. 
The couple matching algorithm-based reconfiguration method was implemented in 
the installed 5 kW PV system. All the required equipment, such as the current sensing 
unit, switching matrix circuit, protection, and isolation circuits, were related to the PV 
system. The shading patterns were created manually in the PV system using cardboard 
sheets. 
The output analysis was carried out under the eight kinds of possible shading pat-
terns, such as uneven row shading (UR), uneven column shading (UC), diagonal shading, 
random shading, short and narrow shading (SN), short and wide shading (SW), long and 
narrow shading (LN), and long and wide shading (LW). These are the most common shad-
ing patterns caused by nearby objects, trees, buildings, and clouds. The effectiveness of 
the proposed couple matching algorithm was analyzed under these shading patterns and 
validated with the other array configurations such as series-parallel and total-cross-tied 
configurations. The eight kind of shading patterns were applied on the PV system, as 
shown in Figure 9. The power output and short circuit current were measured and are 
given in Tables 3–5. The output comparison chart is shown in Figure 10. 
Table 3. Output Power of Series-Parallel Array Configuration. 
S. No 
Shading Type 
Series-Parallel Configuration 
Simulation 
Experimental 
ISC 
POUT 
ISC 
POUT 
(A) 
(Watts) 
(A) 
(Watts) 
1 
UR 
35.8 
4001 
33.1 
3691 
2 
UC 
25.1 
2633 
23.6 
2662 
3 
Diagonal 
23.3 
2523 
21.2 
2394 
4 
Random 
12.5 
1330 
11.4 
1265 
5 
SN 
30.9 
3381 
29.1 
2317 
6 
SW 
22.4 
2501 
20.6 
2304 
7 
LN 
14.3 
1600 
12.8 
1539 
8 
LW 
12.5 
1432 
10.9 
1096

## Page 11

Energies 2022, 15, 8450 
11 of 22 
 
Table 4. Output Power of Total-Cross-Tied Array Configuration. 
S. No 
Shading Type 
Total-Cross-Tied Configuration 
Simulation 
Experimental 
ISC 
POUT 
ISC 
POUT 
(A) 
(Watts) 
(A) 
(Watts) 
1 
UR 
35.8 
4001 
32.9 
3630 
2 
UC 
25.1 
2605 
23.7 
2649 
3 
Diagonal 
29.5 
3268 
28.2 
3134 
4 
Random 
21.6 
2305 
20.1 
2243 
5 
SN 
30.9 
3347 
28.4 
3168 
6 
SW 
24.4 
2899 
21.8 
2517 
7 
LN 
17.9 
2040 
16.3 
1895 
8 
LW 
16.1 
1826 
14.5 
1686 
Table 5. Output Power of Proposed Method. 
S. No 
Shading Type 
Couple Matching Algorithm Based Reconfiguration 
Simulation 
Experimental 
ISC 
POUT 
% ∆IL 
ISC 
POUT 
% ∆IL 
(A) 
(Watts) 
(A) 
(Watts) 
1 
UR 
35.8 
4001 
20.0% 
33.2 
3711 
17.0% 
2 
UC 
31.3 
3361 
30.1% 
28.7 
3207 
28.3% 
3 
Diagonal 
34.5 
3793 
22.9% 
32.6 
3631 
18.5% 
4 
Random 
26.4 
2818 
41.0% 
25.1 
2817 
37.3% 
5 
SN 
35.8 
3914 
20.0% 
31.8 
3554 
20.5% 
6 
SW 
29.5 
3303 
34.1% 
26.9 
2998 
32.8% 
7 
LN 
25.9 
2898 
42.1% 
24.3 
2735 
39.3% 
8 
LW 
21.5 
2432 
52.0% 
18.7 
2096 
53.3% 
 
Figure 9. (a) Uneven row shading; (b) uneven column shading; (c) diagonal shading; (d) random 
shading (e) short and narrow shading; (f) short and wide shading; (g) long and narrow shading; (h) 
long and wide shading.

## Page 12

Energies 2022, 15, 8450 
12 of 22 
 
 
Figure 10. Comparison chart of output power. 
By comparing the power output of existing and proposed methods, the proposed 
pairing reconfiguration scheme generates maximum power. In the context of uneven row 
shading, the power output of all methods is nearly the same because the shade dispersion 
is similar in all methods. In uneven column shading patterns, the dispersion of shading in 
the proposed method made a difference in the power output. The couple matching algo-
rithm reconfigures the shaded column to uniformly disperse the shading as much as pos-
sible in the PV array. In the context of diagonal shading patterns, the TCT configuration 
disperses the shading more than the Se-P configuration, but the proposed method is su-
perior to the TCT in shade dispersion and power generation. In a random shading pattern, 
an uneven shading is spread over the PV array. The Se-P array configuration generates 
very low power due to the high mismatch loss due to the shading. The TCT disperses the 
shading more than the Se-P but failed to extract maximum power from the PV array. The 
pairing reconfiguration algorithm disperses the shading as much as possible in the PV 
array by reconfiguring the shaded PV modules and extracts maximum power from it. In 
short and narrow, short and wide, long and narrow, and long and wide shading patterns, 
the effectiveness of the reconfiguration algorithm is increased. The reconfigured PV sys-
tem extracts high power from the PV array, which is almost two times greater than when 
using existing methods. The main reason behind the effectiveness of the proposed work 
is the dispersion of shading levels. The reconfigured PV array highly disperses the shad-
ing over the PV array, which reduces the mismatch losses and enhances the power output. 
The pairing reconfiguration algorithm is an effective and simple PV system approach for 
maximum power extraction. 
4. Implementations of the Image Processing Technique and Results 
For the image processing techniques, the Flir T420bx thermography camera (USA) 
was used in this work. It is necessary to capture thermal images with a clear top view so 
that the image processing process can be carried out with more accuracy. The 5 kW PV 
system was installed on the rooftop of the institution with the proper clearance for receiv-
ing the solar irradiation. A 15m high lightning arrester was available near the PV system. 
For capturing the top viewed thermal image of the PV system, a setup was implemented 
on the tower of the lighting arrester, as shown in Figure 11.

## Page 13

Energies 2022, 15, 8450 
13 of 22 
 
 
Figure 11. Photograph of thermal camera arrangements. 
A wheel with rope and a camera base was fabricated in the lath of our institution. 
The thermal camera was placed in the camera stand with safe base, and this base was 
knotted with the wheel. Thanks to these arrangements, the camera could be placed at the 
top of the lightning arrester tower to capture the top view of the PV system. The thermal 
images could be captured through Wi-Fi or Bluetooth connectivity. These images were 
fed to the computer via Wi-Fi connectivity. The images were further fed to MATLAB/Sim-
ulink® for image processing. The individual images of each panel were cropped by the 
creation of a window and, the image features and attributes were extracted from each 
window. Image attributes, such as the mean, standard deviation, contrast, and entropy, 
were extracted for image processing and fault classification. For classifying the faults, a 
neural network (NN)-based fault classifier was used. The fault classifier was operated 
with three components, i.e., trained variables, testing variables, and classifying sets. 
Trained variables possess the data of known structures, classifying sets possess classifica-
tion detail data, and trained variables to possess the image attribute data to be tested. 
ANN is an information processing architecture inspired by biological nervous sys-
tems. The key element of this processing system is the neurons which are interconnected 
in large numbers. ANN’s can be used to solve specific problems such as pattern recogni-
tion and data classification. The process structure of the feed-forward NN and the block 
diagram of the proposed image processing-based fault detection and reconfiguration al-
gorithm are shown in Figure 12. ANN learns by example, and learning in biological sys-
tems involves adjustments to the synaptic connections that exist between the neurons. 
 
Figure 12. Block diagram of the proposed work.

## Page 14

Energies 2022, 15, 8450 
14 of 22 
 
The neural network has the two kinds of data sets, i.e., trained data sets (known data) 
and testing data sets (unknown data). In this work, the trained data set was obtained from 
thermal images of healthy PV modules and faulted PV modules. Under different irradia-
tion conditions (from minimum to maximum), the thermal images were captured using 
the Flir T-420bx thermal camera. The features of the thermal images were extracted using 
an image processing tool in MATLAB. These features were fed to the neural networks as 
the trained data sets. These data sets had individual values such as healthy, shaded, 
cracked, partially shaded, hotspot, and delaminated PV modules. The training data set 
contained individual data for each kind of fault. Four image features were extracted from 
the thermal images and the features were mean, standard deviation (STD), entropy, and 
norm. The trained data were also considered the reference data for classifying faults. After 
the trained data set was obtained, fault classification details were given to the neural net-
work. The trained data possess the details of various faults in the PV system, and when 
the testing input carries the unknown detail to the classifier, it then adjusts its weights, 
and the classifier compares this with the trained and testing variables and classifies the 
input. For analyzing the performance of the proposed fault detection method, some faults 
were intentionally created on the PV array. This work was validated in the 4 × 5 PV array. 
In the PV array, dust and talcum powder were spread over the surface of the PV modules 
P12, P13, P14, P22, P23, and P24. In P33 and P44, the interconnections were reversed, so 
that the heat would be dissipated, creates the hotspot in this location. In the position of 
P35 and P45, the PV modules were replaced with four-years-old panels which were almost 
delaminated due t poor maintenance. The PV modules P42, P43, and P44 were completely 
shaded by cardboard sheets. and the PV modules P21 and P31 were partially shaded. The 
fault classification types are provided in Table 6. If the testing variable carries the data of 
a healthy module, then the classifier produces an output of 1, for shaded modules the 
output is 2, for partially shaded modules it is 3, for the cracked modules it is 4, for the 
modules with a hotspot it is 5, and for delaminated modules it produces 6. 
Table 6. Fault classification details of NN. 
S. No 
Type of Panel 
Classification Type 
1. 
Healthy 
1 
2. 
Shaded  
2 
3. 
Partially shaded 
3 
3. 
Cracked 
4 
4. 
Hotspot 
5 
6. 
De-lamination 
6 
A flow chart of the image processing-based fault classification and reconfiguration 
algorithm is shown in Figure 13. A thermal image of the 5 kW PV system with various 
faults was captured by the Flir T420bx thermography camera, as is also shown in the fig-
ure. This image was processed using MATLAB, and each module was cropped by the 
creation of a window. Then, image features such as mean, standard deviation, entropy, 
and norm were categorized. These features were provided as testing variables to the neu-
ral network (NN)-based fault classifier. The neural network was already trained by the 
training data set so that it could easily classify the operating state of each panel. The neural 
network processed the trained and testing data, and it showed the operating state of each 
PV module. After the classification of the defects, the image features were fed to the con-
troller. The individual windows of the thermal images were sorted according to the male 
part and female part. Then, the image features of the PV modules belonging to the male 
part 1 were added together. Based on the image features, the pairing reconfiguration al-
gorithm found the best pairs to form couples for maximum power generation. Then, the 
controller generated the reconfiguration pattern and executed the pairing via the switch-
ing matrix circuit.

## Page 15

Energies 2022, 15, 8450 
15 of 22 
 
 
Figure 13. Flow chart of neural network-based fault classification with image processing-based re-
configuration. 
Output Analysis of Image Processing Technique 
Initially, defects such as shading, hotspots, delamination, and dust accumulation 
were created intentionally in the PV system, as shown in Figure 14. Each PV module had 
a different kind of defect so that it could be cross-validated using the image processing-
based fault classification. The top view of the PV system was captured by the thermogra-
phy camera. Certain kinds of faults such as hotspots, dust accumulation, and delamina-
tion could be viewed by the naked eye from the thermal images. However, to identify the 
exact defect and extract the defect details as digital data, the thermal images were fed into 
the computer, so that the image processing could be carried out. The image processing 
process extracts the attributes of every individual PV module and characterizes the oper-
ating state of each module, classifying it, for example, as healthy or defected. The fault 
classification and image processing process are provided below. The thermal image of the 
PV array was fed to MATLAB, which cropped each PV module by creating the windows, 
as shown in Figure 15. The excess area in each window of PV modules was suppressed 
based on an image’s contrast features. The various steps involved in the image processing 
based fault classification has been represented as the block diagram as shown in Figure 
16.

## Page 16

Energies 2022, 15, 8450 
16 of 22 
 
 
Figure 14. Thermal Image of 5 kW PV System with Various Defects. 
 
Figure 15. Window creation for each PV module. 
 
Figure 16. Steps in fault classification. 
From each window, the necessary image features, such as the mean, standard devia-
tion, entropy, and norm, were extracted. The neural network-based fault classifier was 
already trained with the 900 items of trained data. The trained data included details of the 
six defects. The trained data possessed 150 items of data on healthy modules, 150 items of 
data on shaded modules, 150 items of data on partially shaded modules, 150 items of data 
on cracked modules, 150 on hotspot-affected modules, and 150 on deaminated modules.

## Page 17

Energies 2022, 15, 8450 
17 of 22 
 
These data were already trained in the neural network-based fault classifier. From the 
figure of window creation, the image features were extracted. These features were fed into 
the neural network as the trained data, made up of 900 samples. The classifier uses the 
feed-forward back propagation neural network for the fault classification. This repeats the 
classification of each testing data until it is accurately classified.  
The faults created on the PV array were randomly varied. Almost seventy-five kinds 
of different fault combinations were created on the PV array. For each fault combination, 
a thermal image was captured. Each thermal image was fed into the MATLAB tools for 
feature extraction. Thus, 150 samples of each fault condition were categorized and fed to 
the fault classifier. The NN-based fault classifier classified the testing data according to 
the trained variables. Based on the four features, the fault classification was obtained. The 
percentage of accuracy for each kind of image feature was validated. The accuracy can be 
obtained from the number of correctly and wrongly classified samples. The number of 
trained data and testing data which were correctly classified and the number of wrongly 
classified samples provide the percentage of accuracy, as given in Table 7. 
Table 7. Comparison of various classifications during training. 
Parameters 
Image Features for Classification 
Mean 
STD 
Entropy 
Norm 
Total no. of samples 
900 
900 
900 
900 
Correctly classified 
812 
831 
792 
818 
Total no. of 1 
150 
150 
150 
150 
Total no. of 2 
150 
150 
150 
150 
Total no. of 3 
150 
150 
150 
150 
Total no. of 4 
150 
150 
150 
150 
Total no. of 5 
150 
150 
150 
150 
Total no. of 6 
150 
150 
150 
150 
Classified samples 
 
1 as 1 
135 
139 
139 
136 
2 as 2 
138 
136 
131 
143 
3 as 3 
143 
134 
127 
141 
4 as 4 
137 
139 
130 
135 
5 as 5 
127 
143 
129 
131 
6 as 6 
132 
140 
136 
132 
Wrongly classified 
88 
69 
108 
82 
Total % accuracy 
90.22% 
92.33% 
88.00% 
90.89% 
There were 150 samples of each defect that were collected from the windows of ther-
mal images. These data were further tested with the feed-forward back propagated neural 
network-based fault classifier with the trained variables. The classified outputs are dis-
played in Table 6. The accuracy of the classification was varied with respect to the feature-
based classifier. A total of 150 samples of each defect were tested, and the classification 
details show the accuracy of the fault classification. The confusion matrix diagram of each 
fault classifier shows the number of correctly classified samples and the number of 
wrongly classified samples. The percentage of accuracy is shown in the confusion matrix 
diagram of Figure 17.

## Page 18

Energies 2022, 15, 8450 
18 of 22 
 
 
 
(a) 
(b) 
 
(c) 
(d) 
Figure 17. Confusion matrix diagram of (a) mean-based NN classifier, (b) standard deviation-based 
NN classifier, (c) entropy-based NN classifier, and (d) norm-based NN classifier. 
5. Image Processing-Based Reconfiguration Method 
The thermal image processing extracts the features of each PV modules, which is 
useful for obtaining the reconfiguration pattern. After achieving the fault classification, 
the controller initiates the reconfiguration process. If the controller found no faults in the 
PV system, the reconfiguration process will be skipped. Otherwise, the controller starts to 
find the image feature-based pairing reconfiguration pattern. The image features contain 
various details regarding the panel temperature variation in terms of mean, standard de-
viation, and entropy. The mismatch of losses in the PV system has a directly proportion-
ality to the temperature variation between the PV cells. When the PV cell experiences de-
fects such as partial shading or hotspots, the temperature will be raised. Normally, the 
faulted cell or module experiences a high temperature than healthy cells. The temperature 
difference can be identified by the controller using the image features. The mean and 
standard deviation shows the level of difference between the nearby cell and modules. 
Based on this data, abnormal PV modules in the PV system are identified. The controller 
possesses the details of each module’s data. In the classification of faults, the standard 
deviation-based classification provides better accuracy compared to other features. There-
fore, the standard deviation features were considered for the reconfiguration process. 
During window analysis, the standard deviation value for each panel was obtained. Con-
cerning the reconfiguration pattern, a tolerance limit of ±10% was considered. If the toler-
ance level was lesser than ±10%, the PV module was operated in a healthy condition. For 
a normal healthy panel, 11.8869 was obtained as the threshold value. Additionally, 
±1.18869 was chosen as the tolerance limit. If the standard deviation value was between 
10.698 and 13.076, then the value of that corresponding panel was considered to be zero. 
If the obtained standard deviation value was greater than 13.076, then the threshold value 
was subtracted from the obtained value, and if the obtained value was lesser than 10.698,

## Page 19

Energies 2022, 15, 8450 
19 of 22 
 
then the obtained value has been subtracted from the threshold value. If the obtained 
value was between 10.698 and 13.076, then this value was considered to be zero. The above 
procedure was followed for each PV panel, and the obtained values were used for the 
reconfiguration process. For each male and female part, the obtained values were added, 
and the reconfiguration process was carried out. The sum of each male and female part 
were sorted in ascending order. The minimum value defines the minimum amount of 
fault presented in the system. Thus, the maximum value demonstrated that the male or 
female part has been affected with specific faults. After the sorting process, the male part 
with the lowest value was connected to the female part with the highest value. Thus, the 
male part with second lowest value was connected to the female part with second highest 
value. This process was continued until the male part with the highest value was con-
nected to the female part with the lowest value. Thanks to this process, the pairing recon-
figuration pattern as obtained. Based on the obtained pairing reconfiguration pattern, the 
controller generated the triggering signals to the switches and the switching matrix circuit 
established the reconfiguration. The power generation after the image processing-based 
reconfiguration is given in Table 8. 
Table 8. Output power of image processing-based reconfiguration. 
S. No Shading Type 
Paring Reconfiguration Algorithm 
Accuracy 
Current Measurement Based Image Processing Based 
IM 
POUT 
IM 
POUT 
(A) 
(Watts) 
(A) 
(Watts) 
% 
1 
UR 
31.2 
3711 
30.9 
3671 
98.9% 
2 
UC 
27.0 
3207 
23.4 
2780 
86.7% 
3 
Diagonal 
30.7 
3631 
29.7 
3528 
96.8% 
4 
Random 
23.6 
2817 
23.4 
2780 
99.1% 
5 
SN 
29.9 
3554 
27.3 
3243 
91.3% 
6 
SW 
25.3 
2998 
24.7 
2934 
97.6% 
7 
LN 
22.9 
2735 
19.6 
2328 
85.7% 
8 
LW 
17.6 
2096 
17.3 
2055 
98.3% 
The power generated by the image processing-based reconfiguration is given in Ta-
ble 8. The image processing-based reconfiguration nearly achieves optimum couples with 
90% accuracy in every case. This approach can generate more power than existing array 
configurations such as Se-P and TCT. In terms of UR, UC, diagonal, SN, and LN shading 
patterns, the image processing-based reconfiguration method achieves 98% accuracy with 
the current generation-based couple matching reconfiguration method. In terms of une-
ven column shading and long and narrow shading, this approach generates nearly 85% 
power , and this may be caused by the non-perfect matching of a couple. Perfect couples 
were achieved in terms of uneven row shading, diagonal shading, random shading, short 
and narrow shading, short and wide shading, and long and wide shading. The image 
processing-based reconfiguration approach achieved perfect couples in six kinds of shad-
ing patterns among eight, and the accuracy can be increased by repeated classification and 
iterations. An output power comparison chart comparing the image processing-based re-
configuration method and current measurement-based reconfiguration methods is pro-
vided in Figure 18.

## Page 20

Energies 2022, 15, 8450 
20 of 22 
 
 
Figure 18. Comparison chart of output power. 
The image processing technique was successfully achieved in real time. The fault 
classification result, along with the accuracy, and the image processing-based reconfigu-
ration method with the power output were presented. The image processing technique 
provides a result with almost 90% accuracy in all cases of testing. This approach can be 
used for the any kind of electrical system for the fault classification, and it can be imple-
mented without any additional setup. The image processing-based fault identification and 
classification method requires only a thermal image camera and image processing tools, 
and it does not require any additional measurements. 
The accuracy of this method can be enhanced further by considering solar irradiance. 
In this work, we trained and tested the values based on the mean, standard deviation, 
entropy, and norm, which were obtained from the temperature values. This method pro-
vided efficient performance with regard to the obtainment of PV cell defects as well as in 
terms of reconfiguration. However, the measurement of irradiation can increase the effi-
ciency of this method. The irradiance must be measured all day using a data logger. The 
irradiance values must be trained and tested according to the above classification proce-
dure, providing improved performance.  
The proposed thermal image processing-based fault classification process can be 
used for large power plants. Using the proper arrangements, it is possible capture the 
thermal images of every individual PV unit in a large PV plant. The thermal camera 
should capture the thermal images at regular intervals. An automated setup is required 
for operating the thermal camera, i.e., after capturing the thermal image of one PV unit, it 
should move on to the next unit until it reaches the last PV unit. After the completion of 
this cycle, it should start again in a cyclic process. Thus, the entire PV plant can be moni-
tored regularly, and faults can be identified earlier. Furthermore, the reconfiguration 
method can be implemented in a unit-wise manner. This proposed method is feasible and 
can be implemented in real time applications. 
6. Conclusions 
The proposed pairing reconfiguration algorithm was successfully implemented in a 
5 kW PV system. The performance of the proposed method was validated under all-pos-
sible shading patterns, and the proposed method performed better than the existing meth-
ods. The fault classification is performed by the neural network-based feed forward back 
propagated fault classifier. The fault classification is made possible by mean-, standard 
deviation-, entropy-, and norm-based image features. The accuracy of the fault classifica-
tion was also confirmed, where the standard deviation-based fault classifier provided bet-
ter accuracy. Furthermore, the thermal image processing-based reconfiguration is

## Page 21

Energies 2022, 15, 8450 
21 of 22 
 
developed from image features which are validated under all possible shading patterns. 
The performance of the electrical parameter-based pairing reconfiguration and thermal 
image processing-based reconfiguration were compared, where the thermal image pro-
cessing-based reconfiguration provided the equivalent performance with the normal re-
configuration. There are no electrical measurements involved, but the isolation of panel 
connections is required in the thermal image processing-based pairing reconfiguration. 
This method is most useful for PV systems for health monitoring, as it successfully miti-
gates the consequences of partial shading and minor faults. The proposed work was suc-
cessfully executed on a 4 × 5 PV array, and we plan to implement this work in a large PV 
power plant for the purpose of identifying the faults and reconfigure the PV system. This 
is a future work that the authors plan to execute. 
Author Contributions: Conceptualization, D.S. and P.K.B.; Data curation, M.S.B.; Formal analysis, 
S.A., M.S.B. and L.M.-P.; Investigation, M.S.B. and L.M.-P.; Methodology, D.S. and P.K.B.; Software, 
D.S. and P.K.B.; Writing – original draft, D.S. and P.K.B.; Writing – review & editing, S.A. and L.M.-
P. All authors have read and agreed to the published version of the manuscript. 
Funding: This research received no external funding. 
Data Availability Statement: Not applicable. 
Conflicts of Interest: The authors declare no conflict of interest. 
References 
1. 
Serna-Garcés, S.I.; Bastidas-Rodríguez, J.D.; Ramos-Paja, C.A. Reconfiguration of Urban Photovoltaic Arrays Using Commercial 
Devices. Energies 2015, 9, 2. 
2. 
Kumar, S.; Sharma, A.; Roy, B. Solar energy market developments in India. Renew. Sustain. Energy Rev. 2016, 62, 121–133. 
https://doi.org/10.1016/j.rser.2016.04.043. 
3. 
Parida, B.; Iniyan, S.; Goic, R. A review of solar photovoltaic technologies. Renew. Sustain. Energy Rev. 2011, 15, 1625–1636. 
https://doi.org/10.1016/j.rser.2010.11.032. 
4. 
Abdullah, M.; Mamun, A.; Selvaraj, J. Experimental investigation of the effect of partial shading on photovoltaic performance. 
IET Renew. Power Gener. 2017, 11, 912–921. https://doi.org/10.1049/iet-rpg.2016.0902. 
5. 
Zhou, T.; Sun, W. Study on maximum power point tracking of photovoltaic array in irregular shadow. Int. J. Electr. Power Energy 
Syst. 2015, 66, 227–234. 
6. 
Mohapatra, A.; Nayak, B.; Das, P.; Mohanty, K.B. A review on MPPT techniques of PV system under partial shading condition. 
Renew. Sustain. Energy Rev. 2017, 80, 854–867. https://doi.org/10.1016/j.rser.2017.05.083. 
7. 
Podder, A.K.; Roy, N.K.; Pota, H.R. MPPT methods for solar PV systems: A critical review based on tracking nature. IET Renew. 
Power Gener. 2019, 13, 1615–1632. https://doi.org/10.1049/iet-rpg.2018.5946. 
8. 
Eltamaly, A.M. An improved cuckoo search algorithm for maximum power point tracking of photovoltaic systems under partial 
shading conditions. Energies 2021, 14, 953. https://doi.org/10.3390/en14040953. 
9. 
Eltamaly, A.M. A novel musical chairs algorithm applied for MPPT of PV systems. Renew. Sustain. Energy Rev. 2021, 146, 111135. 
https://doi.org/10.1016/j.rser.2021.111135. 
10. 
Sai Krishna, G.; Moger, T. Optimal SuDoKu Reconfiguration Technique for Total-Cross-Tied PV Array to Increase Power Out-
put under Non-Uniform Irradiance. IEEE Trans. Energy Convers. 2019, 34, 1973–1984. https://doi.org/10.1109/TEC.2019.2921625. 
11. 
Pendem, S.R.; Mikkili, S. Modeling, simulation and performance analysis of solar PV array configurations (Series, Series–Paral-
lel and Honey-Comb) to extract maximum power under Partial Shading Conditions. Energy Rep. 2018, 4, 274–287. 
https://doi.org/10.1016/j.egyr.2018.03.003. 
12. 
Srinivasan, A.; Devakirubakaran, S.; Meenakshi Sundaram, B. Mitigation of mismatch losses in solar PV system - Two-step 
reconfiguration approach. Solar Energy. 2020, 206, 640–654. doi:10.1016/j.solener.2020.06.004. 
13. 
Parlak, K. PV array reconfiguration method under partial shading conditions. Int. J. Electr. Power Energy Syst. 2014, 63, 713–721. 
https://doi.org/10.1016/j.ijepes.2014.06.042. 
14. 
Murugan, M.S.; David, P.W.; Murugesan, P. Analysis of voltage/current mismatch in solar photovoltaic power plants during 
fault panel replacement. Energy Sources Part A Recovery Util. Environ. Eff. 2021. https://doi.org/10.1080/15567036.2021.1909676. 
15. 
Shakthivel, S.K.; David, P.W.; Backiyam, S.P.; Murugan, M.S. Square dynamic reconfiguration for the partial shaded photovol-
taic system–simulation and experimental analysis. Energy Sources Part A Recovery Util. Environ. Eff. 2022, 44, 6868–6885. 
https://doi.org/10.1080/15567036.2022.2103215. 
16. 
Cherukuri, S.K.; Balachandran, P.K.; Kaniganti, K.R.; Buddi, M.K.; Butti, D.; Devakirubakaran, S.; Babu, T.S.; Alhelou, H.H. 
Power Enhancement in Partial Shaded Photovoltaic System Using Spiral Pattern Array Configuration Scheme. IEEE Access 2021, 
9, 123103–123116.

## Page 22

Energies 2022, 15, 8450 
22 of 22 
 
17. 
Srinivasan, A.; Devakirubakaran, S.; Sundaram, B.M.; Balachandran, P.K.; Cherukuri, S.K.; Winston, D.P.; Babu, T.S.; Alhelou, 
H.H. L-Shape Propagated Array Configuration with Dynamic Reconfiguration Algorithm for Enhancing Energy Conversion 
Rate of Partial Shaded Photovoltaic Systems. IEEE Access 2021, 9, 97661–97674. 
18. 
Palpandian, M.; Winston, D.P.; Kumar, B.P.; Kumar, C.S.; Babu, T.S.; Alhelou, H.H. A New Ken-Ken Puzzle Pattern Based 
Reconfiguration Technique for Maximum Power Extraction in Partial Shaded Solar PV Array. IEEE Access 2021, 9, 65824–65837. 
19. 
Wu, Z.; Hu, Y.; Wen, J.X.; Zhou, F.; Ye, X. A Review for Solar Panel Fire Accident Prevention in Large-Scale PV Applications. 
IEEE Access 2020, 8, 132466–132480. https://doi.org/10.1109/ACCESS.2020.3010212. 
20. 
Silvestre, S.; da Silva, M.A.; Chouder, A.; Guasch-Murillo, D.; Karatepe, E. New procedure for fault detection in grid connected 
PV systems based on the evaluation of current and voltage indicators. Energy Convers. Manag. 2014, 86, 241–249. 
https://doi.org/10.1016/j.enconman.2014.05.008. 
21. 
Van der Heide AS, H.; Schönecker, A.; Wyers, G.P.; Sinke, W.C.; Energy, E.S. Mapping of contact resistance and locating shunts 
on solar cells using Resistance Analysis by Mapping of Potential (RAMP) techniques. In Proceedings of the 16th European 
Photovoltaic Solar Energy Conference, Glasgow, UK, 1–5 May 2000; p. 1438. 
22. 
González-Díaz, B.; González, J.F.G. SEM & AFM analysis for silicon-based solar cells. In Microscopy: Advances in Scientific Re-
search and Education; Méndez-Vilas, A., Ed.; Formatex Research Center: Badajoz, Spain, 2014. 
23. 
Bezuidenhout, L.J.; van Dyk, E.E.; Vorster, F.J.; du Plessis, M.C. On the Characterization of Solar Cells Using Light Beam Induced 
Current Measurements; Nelson Mandela Metropolitan University, Centre for Energy Research, Gqeberha, South African, 2012. 
24. 
Breitenstein, O.; Bauer, J.; Bothe, K.; Hinken, D.; Müller, J.; Kwapil, W.; Schubert, M.C.; Warta, W. Luminescence imaging versus 
lock-in thermography on solar cells and wafers. In Proceedings of the 26th European Photovoltaic Solar Energy Conference and 
Exhibition, Hamburg, Germany, 5–6 September 2011; pp. 1031–1038. 
25. 
Hu, Y.; Cao, W.; Wu, J.; Ji, B.; Holliday, D. Thermography-based virtual MPPT scheme for improving PV energy efficiency 
under partial shading conditions. IEEE Trans. Power Electron. 2014, 29, 5667–5672. 
26. 
Hu, Y.; Cao, W.; Ma, J.; Finney, S.J.; David Li, D. Identifying PV module mismatch faults by a thermography based temperature 
distribution analysis. IEEE Trans. Device Mater. Reliab. 2014, 14, 951–960.
