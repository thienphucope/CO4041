# Raw extract: pv-reconfig-vicente-2015.pdf

> Text extracted by PyMuPDF in PDF reading order. Figures and formulas must be checked against the original PDF.
> PDF: [../../pv-reconfig-vicente-2015.pdf](../../pv-reconfig-vicente-2015.pdf)
> Pages: 12
> DOI: https://doi.org/10.1155/2015/592383 · PDF download: https://pdfs.semanticscholar.org/58f8/0de73eab7daf06e768aa5a4ff31d2582b6c9.pdf

---

## Page 1

Research Article
Photovoltaic Array Reconfiguration Strategy for
Maximization of Energy Production
Paula dos Santos Vicente, Tales Cleber Pimenta, and Enio Roberto Ribeiro
Universidade Federal de Itajub´a, UNIFEI, Avenida BPS 1303, 37500-903 Itajub´a, MG, Brazil
Correspondence should be addressed to Paula dos Santos Vicente; paulasantos@unifei.edu.br
Received 28 November 2014; Revised 3 February 2015; Accepted 3 February 2015
Academic Editor: Emilio Bueno
Copyright © 2015 Paula dos Santos Vicente et al. This is an open access article distributed under the Creative Commons Attribution
License, which permits unrestricted use, distribution, and reproduction in any medium, provided the original work is properly cited.
This paper presents a dynamic reconfiguration method for electrical connections in a Series-Parallel connected photovoltaic array
under partial shading conditions. It is desirable to extract the maximum energy from the array, but it does not occur in situations
where the modules have different points of operation caused by shading. The proposed method is then characterized by the
maintenance of the PV array dimensions, that is; no module is removed or added to the array. Furthermore, the control algorithm
is based on the Rough Sets Theory, which allows the fast and efficient implementation of a control system, comprising rules that
identify the system optimal configuration.
1. Introduction
The use of photovoltaic (PV) systems has increased signifi-
cantly in recent years as a viable alternative to conventional
methods of generating electricity. The reduction of transmis-
sion and distribution losses and the possibility of injecting
energy into the utility power grid are also attractive factors
for their utilization.
The efficiency of PV systems is deeply influenced by
weather conditions. In many situations, the PV panel can be
illuminated in a nonuniform way due to shading caused by
clouds, trees, neighbor buildings, and even shadows caused
by the modules in the array.
Shading is a common phenomenon that causes severe
degradation to the extraction of energy in PV systems [1].
In a partially shaded array, the output power may be less
than the sum of the individual output powers of all modules.
The shading of a single module is able to decrease the
resulting current and consequently, the overall output power
is reduced.
There are several proposals to reduce the degradation of
energy in partially shaded systems [2–7]. A common solution
is to connect bypass diodes. This connection prevents the
existence of rows with low output voltages, which behave as a
load to all other parallel connected rows [2].
A different approach lies in systems with microinverters,
where each module of the PV array is connected to an inverter
with a dedicated MPPT (maximum power point tracking)
system [3]. Although this approach offers very good results,
since each PV module works at the optimum operating point,
its high cost is a drawback.
Recent studies suggest the reconfiguration of the PV array
electrical connections. In the reconfiguration system, the PV
modules are rearranged dynamically, in order to maximize
the output power [4–7].
The reconfiguration method depends on the type of
connection between the modules. One of the most com-
mon topologies is the Series-Parallel (SP) connection. The
PV modules in this case are connected in series and the
resulting rows are connected in parallel. In an SP matrix,
the reconfiguration process is based on the shaded modules
combination, where modules with similar irradiance levels
must be connected in series and the resulting rows are
connected in parallel.
Patnaik et al. [4] propose a reconfiguration method in
which the modules of the SP array are characterized by
two levels: fully illuminated and fully dark. The fully dark
modules are removed from the combination, while the fully
illuminated modules are rearranged.
Hindawi Publishing Corporation
International Journal of Photoenergy
Volume 2015, Article ID 592383, 11 pages
http://dx.doi.org/10.1155/2015/592383

## Page 2

2
International Journal of Photoenergy
A similar work [5] classifies the PV array modules into
three different levels: dark, gray, and bright. The dark modules
are removed from the array and the algorithm defines the
position of gray and bright modules.
The removal of shaded modules [4, 5] may produce
asymmetric arrangements. In these situations, the PV array
columns have different voltage levels. To solve this problem,
static converters can be connected to the disabled rows, thus
modifying its voltage levels [6, 7].
The aforementioned reconfiguration systems [4–7] have a
common feature: the removal of the worst case modules from
the array. Once again, the use of static power converters is a
possible solution [6, 7], but with high cost and complexity of
control algorithms.
This paper presents an alternative method for dynamic
reconfiguration of the connections in a shaded PV array.
The proposed method is characterized by the maintenance of
the PV array size; that is, no module is removed or added.
Another prominent advantage addressed to the proposal is
the use of Rough Sets Theory (RST), which can lead to a fast
and efficient algorithm of reconfiguration.
2. Reconfiguration Method of PV Modules
2.1. Shading Effect on PV System Efficiency. The performance
of PV systems is influenced by irradiance and temperature.
Therefore, environmental conditions are crucial for power
generation.
A common effect in PV systems is the shading, which can
be partial or full, consequently reducing the output power of
the PV system. The reduction depends on other factors such
as the type of arrangement, shade position, and intensity of
shading.
The work in [8] shows, through simulation and exper-
imental tests, that PV arrays with SP interconnection have
the best results when shaded modules are grouped. Thus, a
significant amount of energy can be recovered, which is not
typically extracted when the shaded modules are distributed
in the PV array.
2.2. Reconfiguration Method. The reconfiguration method
proposed in this paper aims to rearrange the PV array,
clustering the shaded modules in the least number of PV
array columns.
The rearrangement of shaded modules seems to be a
simple and intuitive process. However, depending on the
number of modules in the array, this can be a complex task.
In an array with 𝑛modules, shading may occur in
0, 1, 2, . . ., or 𝑛shaded modules simultaneously. Equation (1)
defines the number of different shading possibilities, 𝑆𝑃:
𝑆𝑃= 2𝑛.
(1)
It is possible to change the position of the modules in an
SP array with different ways and 𝑃possible configurations,
according to simple permutation:
𝑃= 𝑛!,
(2)
where 𝑛is the number of array modules.
In a permutation, the order of the elements is relevant;
for example, sequence ABC is different from sequence CBA.
However, from the electrical point of view, the order, in which
the PV modules are connected in a series row, does not affect
the overall result.
From 𝑃possible configurations calculated with (2), only
a few ones can produce different results in the system output
power. The number of interest settings, 𝐼𝑇, can be obtained
by the combination described in (3). This is related to the
symmetry of the PV array (number of rows and columns) [9]:
𝐼𝑇=
(𝑁⋅𝑀)!
(𝑁!)𝑀⋅𝑀!
,
(3)
where 𝑁is the number of rows and 𝑀is the number of
columns of the PV array.
Among all configurations of interest, one is the most
suitable for a given shading profile. This is defined by the
amount and position of shaded modules.
The identification of the PV module condition is obtained
from parameter 𝑆, which classifies the module as shaded or
unshaded according to (4). This classification can be made
through current and voltage measurements:
𝑆= 1 󳨀→shaded,
𝑆= 0 󳨀→unshaded.
(4)
The number of shaded modules is directly related to
the possibility of reconfiguration. In an 𝑁by 𝑀PV array,
reconfiguration is feasible in situations where the number of
shaded modules, 𝑆𝑀, is contained in the set defined by
𝑆𝑀= {𝑥| 𝑥∈N, (∃𝑦) (∃𝑧) (
𝑦∈{𝑀} , 𝑧∈{𝑁} ,
2 ≤𝑥≤(𝑧⋅𝑦−𝑧) )} . (5)
Equation (5) defines the set of natural numbers between 2
and the limit (𝑧⋅𝑦−𝑧), where 𝑧and 𝑦are numbers contained
in the unit sets defined by 𝑁and 𝑀, respectively.
It is important to notice that there are shapes of shade
where nothing can be done. In other words, the rearrange-
ment does not cause the output power to be modified.
However, in situations where reconfiguration is suitable,
at least one configuration may improve the output power.
Thereby, the control system is responsible for identifying the
best configuration.
3. Rough Sets Theory (RST)
The RST is an extension of the set theory, which focuses on
the extraction of intrinsic knowledge from a dataset and the
creation of rules that summarize the knowledge in this set. It
was originally developed by Pawlak at the beginning of the
1980s [10]. However, RST has become quite popular only in
the 1990s due to the increasing of processing capacity and the
widespread use of personal computers.
In order to handle the information, data must be orga-
nized in a table called information system (IS). IS is a syntactic
representation of knowledge of the objects set, represented by
the ordered pair 𝑅= (𝑈, 𝐴). 𝑈is a nonempty finite set of

## Page 3

International Journal of Photoenergy
3
objects, named Universe, and 𝐴is a nonempty finite set of
conditional attributes or conditions, such that 𝑈→𝑉𝑎for
𝑎∈𝐴. Set 𝑉𝑎is defined as the set with 𝑎values [11].
RST is based on the indiscernibility, which is an
equivalence relationship between objects, given a subset of
attributes, which allows the partition of universe set 𝑈. The
general definition is as follows.
Given the information system 𝑅= (𝑈, 𝐴), then, for any
subset of attributes 𝐵⊆𝐴, there is an equivalence relation
IND(𝐵), defined by
IND (𝐵) = {(𝑥, 𝑥󸀠) ∈𝑈| ∀𝑎∈𝑉, 𝑎(𝑥) = 𝑎(𝑥󸀠)} .
(6)
IND(𝐵) is the 𝐵-indiscernibility relationship. If (𝑥, 𝑥󸀠) ∈
IND(𝐵), then the objects 𝑥and 𝑥󸀠are indiscernible or equal,
considering the attributes subset.
The equivalence class of the relation determined by 𝑥
objects, according to IND(𝐵), is denoted by [𝑥]𝐵.
Based on indiscernibility, it is possible to reduce the extra
attributes, obtaining data reduction. A reduction is a subset
𝐵⊆𝐴, where the equivalence classes are preserved by the set
of all attributes IND(𝐴). Thus, for a subset of attributes 𝐵⊆𝐴,
it seems that IND(𝐵) = IND(𝐴), as 𝐵is the reduction of 𝐴or
RED(𝐵).
The reduction can be a difficult task depending on the
amount of data. It is suitable, therefore, to submit such
tables to reduction and simplification procedures. In the
simplification process, the unnecessary attributes, duplicated
lines, and superfluous values are eliminated. This creates
simpler rules that represent the knowledge base of the system,
in the same way as the original data.
The manual development of a knowledge base using
rough sets is an exhaustive task. Considering this issue,
computer programs were developed specifically for this type
of application. ROSETTA [12] is one of the most popular
approaches, where it is possible to upload a table with system
information and choose the method for the creation of classes
and reducts. At the end of the process, the system rules are
created.
Due to the aforementioned characteristics, RST has been
chosen for the implementation of the automatic reconfigura-
tion system.
4. Reconfiguration System Project
In order to illustrate the methodology and operation of the
proposed reconfiguration system, three photovoltaic arrays
are taken as examples.
4.1. 2 × 2 Matrix. A 2 × 2 matrix (Figure 1) is the smallest SP
arrangement in which the reconfiguration technique can be
applied. There are a reduced number of shapes of shade where
the reconfiguration produces energy improvement. However,
this system can be used to evaluate the characteristics and
effectiveness of the proposed approach.
According to expression (2) it is possible to obtain 24
combinations for a 2 × 2 photovoltaic matrix. Nevertheless,
most arrangements are electrically equivalents; that is, they
provide the same result.
A
C
B
D
Figure 1: CF.01—the 2 × 2 SP matrix reference configuration.
A
A
A
A
C
C
C
C
B
B
B
B
D
D
D
D
Figure 2: Equivalent connections in a 2 × 2 matrix.
The arrangements shown in Figure 2 provide the same
electrical result. In the four matrices presented, modules A
and B are in series, C and D are also in series, and the two
sets are connected in parallel.
According to (3), there are three settings of interest.
Among the 24 arrangements of a 2×2 matrix, 3 configurations
do not have equivalencies. Those configurations can be found
through combinational analysis and are shown in Figure 3.
According to (1), the number of different possible shad-
ings, in a four modules array, is given by 24 = 16.
Among 16 possible shadings, there are situations where,
according to the shapes of shade, the module reconfiguration
is relevant. For the 2 × 2 array, the unitary set, obtained
with (5), is 𝑀𝑆
=
[2]. It means that reconfiguration is
performed only in situations where the number of shaded
modules is equal to two. If reconfiguration is not suitable,
the array will remain in the configuration CF.01, the reference
configuration (Figure 1).
The data for the system with four modules are shown in
Table 1. The 16 combinations of shading that can occur in a
2×2 matrix are represented by the set universe U. A, B, C, and
D represent the conditions attribute (shaded or unshaded)
and CF is the decision attribute, which indicates the optimum
configuration.
The decision attribute CF is obtained from a routine that
relates the condition attributes to the reconfiguration criteria
defined in Section 2.
Each line of Table 1 represents one of the shading situa-
tions that can occur on a 2 × 2 matrix and which is the most
suitable configuration for that condition.
By using the RST it is possible to obtain the essence of the
information and to identify the standard in the data. The data
in Table 1 can be reduced with ROSETTA software, which
generates eight rules.
(1) A(0) AND B(0) →CF(01)
(2) A(1) AND B(1) →CF(01)

## Page 4

4
International Journal of Photoenergy
CF.01
A
A
A
B
B
B
D
D
D
C
C
C
CF.02
CF.03
Figure 3: Settings of interest in a 2 × 2 matrix.
Table 1: Information System of a 2 × 2 matrix.
U
A
B
C
D
CF
1
0
0
0
0
CF.01
2
0
0
0
1
CF.01
3
0
0
1
0
CF.01
4
0
0
1
1
CF.01
5
0
1
0
0
CF.01
6
0
1
0
1
CF.02
7
0
1
1
0
CF.03
8
1
1
1
1
CF.01
9
1
0
0
0
CF.01
10
1
0
0
1
CF.03
11
1
0
1
0
CF.02
12
1
0
1
1
CF.01
13
1
1
0
0
CF.01
14
1
1
0
1
CF.01
15
1
1
1
0
CF.01
16
1
1
1
1
CF.01
(3) C(0) AND D(0) →CF(01)
(4) C(1) AND D(1) →CF(01)
(5) A(1) AND B(0) AND C(1) AND D(0) →CF(02)
(6) A(0) AND B(1) AND C(0) AND D(1) →CF(02)
(7) A(1) AND B(0) AND C(0) AND D(1) →CF(03)
(8) A(0) AND B(1) AND C(1) AND D(0) →CF(03)
The obtained rules express the logic relationship among
the condition attributes (A, B, C, and D) and the decision
attribute (CF). After combining the eight rules, one can get
the three rules listed next. Each rule is related to one of the
configurations presented in Figure 3.
(1) (A = B) OR (C = D) →CF.01
(2) (A = C) AND (B = D) AND (A̸ = B) →CF.02
(3) (A = D) AND (B = C) AND (A̸ = B) →CF.03
With these three rules, it is possible to create an algorithm
that defines the best configuration for the photovoltaic array
under partial shading conditions. Just one of the rules is
enabled at a time and the corresponding configuration must
be activated so that the system can have the best energy
configuration.
Table 2: Part of the Information System of a 3 × 2 matrix.
U
A
B
C
D
E
F
Q
CF
1
0
0
0
0
0
0
0
CF.01
2
0
0
0
0
0
1
1
CF.01
3
0
0
0
0
1
0
1
CF.01
4
0
0
0
0
1
1
2
CF.01 or CF.02 or CF.05 or CF.10
5
0
0
0
1
0
0
0
CF.01
6
0
0
0
1
0
1
2
CF.01 or CF.03 or CF.06 or CF.09
7
0
0
0
1
1
0
2
CF.01 or CF.04 or CF.07 or CF.08
8
0
0
0
1
1
1
3
CF.01
9
0
0
1
0
0
0
1
CF.1
10
0
0
1
0
0
1
2
CF.02 or CF.03 or CF.07 or CF.11
11
0
0
1
0
1
0
2
CF.02 or CF.04 or CF.06 or CF.09
...
...
...
...
...
...
...
...
...
61
1
1
1
1
0
0
4
CF.01
62
1
1
1
1
0
1
5
CF.01
63
1
1
1
1
1
0
5
CF.01
64 1
1
1
1
1
1
6
CF.01
4.2. 3 × 2 Matrix. A vertical expansion of the 2 × 2 matrix
presented in Section 4.1 leads to a 3 × 2 matrix, that is, three
rows and two columns.
The conception of IS is analogous. However, as the num-
ber of array modules increases, there are some redundancies
on the information system. There are cases in which the
clustering only occurs in one of the settings of interest,
although, in some situations, there is more than one possible
setting.
From (2) and (5), it can be seen that matrix has 64
different possibilities of shading for a six-PV module, which
can reach from 0 to 6 modules simultaneously. Among these
possibilities, in situations where two or three modules are
shaded, array reconfiguration may become feasible and could
improve energy extraction. In the opposite case, the system
keeps on the reference configuration (CF.01).
According to (3) there are 10 settings of interest, which are
presented in Figure 4.
Part of the information system for the 3×2 array is shown
in Table 2. In addition to the attributes A, B, C, D, E, and
F, the condition attribute Q (number of shaded modules) is
introduced in the IS to simplify the reducts creation.
From Table 2, it can be seen that E and F modules
are shaded and the other array modules are illuminated in
situation 4, for example. According to the reconfiguration
method given in Section 2, modules E and F remain grouped
in the same series row for the optimal configuration. This
situation occurs in the settings of interest 1, 2, 5, and 10 as
seen in Figure 4.
According to RST, shapes of shade that have more than
one configuration of interest, for example, situation 4, are
considered as inconsistent. In this case, for the same set of
condition attributes, there are different decision attributes.
However, in an electric circuit, these situations are redundant,
since any setting provides the same result.

## Page 5

International Journal of Photoenergy
5
A
A
A
B
B
A
B
A
B
A
B
C
D
C
D
C
C
C
D
D
D
E
F
A
A
C
B
D
E
F
A
A
B
C
E
D
F
C
B
D
F
E
F
F
F
F
E
E
E
E
C
B
D
E
F
B
C
D
E
F
CF.01
CF.06
CF.07
CF.08
CF.09
CF.10
CF.02
CF.03
CF.04
CF.05
Figure 4: Settings of interest for a 3 × 2 matrix.
The concept and effectiveness of the knowledge reduction
process become evident in the 3 × 2 system. From the IS
presented in Table 2, it is possible to extract 25 rules that
represent the essence of the knowledge base.
Part of 25 rules is written in a simplified form and listed
as follows.
(1) ((Q = 0 OR Q = 1 OR Q = 4 OR Q = 5 OR Q = 6) OR
(D = 1 AND E = 1 AND F = 1) OR (A = 1 AND B = 1
AND C = 1)) →CF.01
(2) ((Q = 3) AND ((A = 0 AND B = 0 AND D = 0) OR (A
= 1 AND B = 1 AND D = 1))) →CF.02
(3) ((Q = 3) AND ((A = 0 AND B = 0 AND E = 0) OR (A
= 1 AND B = 1 AND E = 1))) →CF.03
(4) ((Q = 3) AND ((A = 0 AND B = 0 AND F = 0) OR (A
= 1 AND B = 1 AND F = 1))) →CF.04
(5) ((Q = 3) AND ((A = 0 AND C = 0 AND D = 0) OR
(A = 1 AND C = 1 AND D = 1))) →CF.05
(6) ((Q = 3) AND ((A = 0 AND C = 0 AND E = 0) OR (A
= 1 AND C = 1 AND E = 1))) →CF.06
(7) ((Q = 3) AND ((A = 0 AND C = 0 AND F = 0) OR (A
= 1 AND C = 1 AND F = 1))) →CF.07
(8) ((Q = 3) AND ((A = 0 AND D = 0 AND E = 0) OR (A
= 1 AND D = 1 AND E = 1))) →CF.08
(9) ((Q = 3) AND ((A = 0 AND D = 0 AND F = 0) OR (A
= 1 AND D = 1 AND F = 1))) →CF.09
(10) ((Q = 3) AND ((A = 0 AND E = 0 AND F = 0) OR (A
= 1 AND E = 1 AND F = 1))) →CF.10
(11) (E = 1 AND F = 1 AND Q = 2) →(CF.01 OR CF.02
OR CF.05 OR CF.10)
...
(23) (A = 1 AND B = 1 AND Q = 2) →(CF.01 OR CF.02
OR CF.03 OR CF.04)
(24) (B = 1 AND F = 1 AND Q = 2) →(CF.04 OR CF.05
OR CF.06 OR CF.08)
(25) (A = 1 AND F = 1 AND Q = 2) →(CF.04 OR CF.07
OR CF.09 OR CF.10)
For each one of the 64 different shading possibilities,
only one rule is satisfied, which indicates the most suitable
configuration of interest.
In cases where there are redundancies (rules 11 to 25),
the choice of the best configuration is performed in a second
stage of the algorithm, where the previous configuration is
evaluated.
The previous information setting is used to achieve the
least number of changes in the layout of modules under
shading conditions. The definition of optimal configuration
in redundant conditions is made based on two criteria:
(1) if the previous configuration is one of the optimal
configurations: the previous setting is maintained;
(2) if the previous configuration is not one of the optimal
configurations, it is necessary to choose the setting
where the least number of modules is displaced.
4.3. 2 × 3 Matrix. The horizontal expansion of the 2 × 2
matrix, presented in Section 4.1, leads to a 2 × 3 matrix (two
rows and three columns).
The procedure for the IS creation and determination of
rules is similar to the 3 × 2 matrix, presented in Section 4.2.
In the 2 × 3 system, there are 15 settings of interest as shown
in Figure 5.

## Page 6

6
International Journal of Photoenergy
A
A
A
A
A
A
A
A
A
B
B
B
E
E
D
D
D
B
D
C
C
C
F
F
C
F
E
E
F
B
E
F
D
C
C
D
B
F
E
C
D
C
E
E
E
E
E
F
F
F
F
F
D
D
D
D
B
B
C
A
A
A
B
B
B
D
F
C
E
A
B
A
B
D
D
D
F
F
F
C
C
A
B
C
E
E
E
C
C
B
CF.01
CF.02
CF.03
CF.04
CF.05
CF.06
CF.07
CF.08
CF.09
CF.10
CF.11
CF.12
CF.13
CF.14
CF.15
Figure 5: Settings of interest for a 2 × 3 matrix.
Table 3: Part of the Information System of a 2 × 3 matrix.
U
A
B
C
D
E
F
Q
CF
1
0
0
0
0
0
0
0
CF.01
2
0
0
0
0
0
1
1
CF.01
3
0
0
0
0
1
0
1
CF.01
4
0
0
0
0
1
1
2
CF.01 or CF.04 or CF.07
5
0
0
0
1
0
0
1
CF.01
6
0
0
0
1
0
1
2
CF.02 or CF.05 or CF.12
7
0
0
0
1
1
0
2
CF.03 or CF.06 or CF.13
8
0
0
0
1
1
1
0
CF.01 or CF.02 or CF.03 or CF.04 or CF.05 or CF.06 or CF.07 or CF.12 or CF.13
...
...
...
...
...
...
...
...
...
59
1
1
1
0
1
0
4
CF.02 or CF.05 or CF.12
60
1
1
1
0
1
1
5
CF.01
61
1
1
1
1
0
0
4
CF.01 or CF.04 or CF.07
62
1
1
1
1
0
1
5
CF.01
63
1
1
1
1
1
0
5
CF.01
64
1
1
1
1
1
1
6
CF.01
With the horizontal expansion, the 2×3 system reconfig-
uration is feasible in situations where the number of shaded
modules is 2, 3, or 4 according to (3). This fact increases the
amount of redundant conditions as seen in Table 3.
The rules generated from the IS in Table 3 are similar to
those presented in Section 4.2.
(1) (Q = 0 OR Q = 1 OR Q = 5 OR Q = 6) →(CF.01)
(2) ((E = 1 AND F = 1 AND Q = 2) OR (E = 0 AND F = 0
AND Q = 4)) →(CF.01 OR CF.04 OR CF.07)
(3) ((A = 0 AND B = 0 AND C = 0 AND Q = 3) OR (A =
1 AND B = 1 AND C = 1 AND Q = 3)) →(CF.01 OR
CF.02 OR CF.03 OR CF.04 OR CF.05 OR CF.06 OR
CF.07 OR CF.12 OR CF.13)
(4) ((A = 0 AND B = 0 AND D = 0 AND Q = 3) OR (A =
1 AND B = 1 AND D = 1 AND Q = 3)) →(CF.01 OR
CF.02 OR CF.03 OR CF.04 OR CF.07 OR CF.08 OR
CF.09 OR CF.11 OR CF.14)
(5) ((C = 1 AND D = 1 AND Q = 2) OR (C = 0 AND D =
0 AND Q = 4)) →(CF.01 OR CF.10 OR CF.15)
(6) ((A = 0 AND B = 0 AND E = 0 AND Q = 3) OR (A =
1 AND B = 1 AND E = 1 AND Q = 3)) →(CF.01 OR
CF.02 OR CF.03 OR CF.05 OR CF.08 OR CF.10 OR
CF.11 OR CF.12 OR CF.15)
...
(23) ((B = 1 AND F = 1 AND Q = 2) OR (B = 0 AND F = 0
AND Q = 4)) →(CF.06 OR CF.09 OR CF.10)
(24) ((B = 1 AND E = 1 AND S = 2) OR (B = 0 AND E = 0
AND S = 4)) →(CF.05 OR CF.08 OR CF.15)
(25) ((A = 0 AND E = 0 AND Q = 4) OR (A = 1 AND E =
1 AND Q = 2)) →(CF.10 OR CF.11 OR CF.12)
(26) ((A = 0 AND F = 0 AND Q = 4) OR (A = 1 AND F =
1 AND Q = 2)) →(CF.13 OR CF.14 OR CF.15)
5. Simulation Results
In order to evaluate the proposed methodology, the circuits
designed in Section 4 were implemented in PSIM software.
The software accurately represents the operation of commer-
cial PV modules and is able to execute microprocessor codes
through the use of DLL (Dynamic Link Library) logical block.

## Page 7

International Journal of Photoenergy
7
DLL block
Microcontroller
PV array
Switching circuit
Pulse
Pulse
Pulse
Pulse
Pulse
+
−
+
+
−
−
+
−
sm1
sm2
sm4
sm3
R
Current sensor
ISC1
ISC2
ISC3
ISC4
sw1
sw2
sw3
sw4 sw5
sw6 sw7 sw8
sw9
sw10
Figure 6: Simplified circuitry of the reconfiguration system for a 2 × 2 matrix.
Table 4: KS10 specifications.
Parameters
Value
Maximum Power (𝑃MPP)
10 W
Short-circuit current (𝐼SC)
0.62 A
Open-circuit Voltage (𝑉OC)
21.5 V
Maximum Power Current (𝐼MPP)
0.60 A
Maximum Power Voltage (𝑉MPP)
16.9 V
5.1. 2 × 2 Matrix. Figure 6 shows the simplified circuitry
of the reconfiguration system for a 2 × 2 matrix. The
circuit can be divided into three individual blocks: PV array,
microcontroller, and switching circuit.
The array consists of four PV modules that simulates the
behavior of the KS10 by Kyocera module. Its specifications are
presented in Table 4.
Since the output current through each module is propor-
tional to the respective solar irradiance, shading is identi-
fied by periodic measurements of the short-circuit current
𝐼SC. The measurements of currents 𝐼SC are synchronized
with the alterations of irradiance in the photovoltaic mod-
ules. At each new condition of irradiance, the switches
sw1, sw2, . . . , sw𝑁are opened and the short-circuit currents
𝐼SC1, 𝐼SC2, . . . , 𝐼SC𝑁are measured through the switching mod-
ules sm1, sm2, . . . , sm𝑁.
The DLL block executes an algorithm compiled with
DEV C++ software. This algorithm is built from the rules
obtained with ROSETTA program as presented in Section 4.
The flowchart of the proposed method is shown in Figure 7.
In the flowchart, the current supplied by each photo-
voltaic array module is read (𝐼SC(𝑘)). If this current is lower
than the reference current (𝐼ref), the module is considered
shaded. Otherwise, the module is considered unshaded. The
information of each module is sent to the DLL block, where
the corresponding rule is chosen. After the definition of the
suitable configuration, the switching circuit is set.
Read
Unshaded module
Shaded module
Identification of the 
corresponding rule
Switching commands
No
Yes
ISC(k)
ISC(k)
< Iref?
Figure 7: Flowchart of the proposed method.
PV systems are usually associated with MPPT systems
[13]. However, in order to properly evaluate if the reconfigu-
ration provides improved results, the module was connected
to a resistive load. The resistance value has been established
for the system to operate close to the maximum power point
(MPP) under standard test conditions (STC—1000 W/m2
and 25∘C). Therefore, when shading occurs, the operating
conditions change and the system no longer operates at the
MPP.
To evaluate the sixteen different shading situations in a
single simulation test, the current through each PV module is
adjusted. In the following tests, the module current has been
reduced by 40% so that shading situations can be emulated.

## Page 8

8
International Journal of Photoenergy
t0
t1
t2
t3
t4
t5
t6
t7
t8
t9 t10 t11 t12 t13 t14 t15 t16
After reconfiguration
Before reconfiguration
0
10
20
20
30
30
40
50
0
10
40
50
Power (W)
Power (W)
Time (s)
Figure 8: Power versus time curve for a 2 × 2 array and progressive
shading (before and after reconfiguration).
Before reconfiguration
After reconfiguration
t0
t16
t32
t48
t64
0
20
40
60
0
20
40
60
Power (W)
Power (W)
Time (s)
Figure 9: Power versus time curve for a 3 × 2 array and progressive
shading (before and after reconfiguration).
The curves presented in Figure 8 reproduce the output
power of PV array, in all shading situations, before and after
reconfiguration.
The shading sequence is performed according to Table 1.
In the first interval (𝑡0-𝑡1), all modules are unshaded. In the
second one (𝑡1-𝑡2), module D is shaded, and so on. Among
16 different shading possibilities, reconfiguration is feasible
in only four situations. Under the system reconfiguration, it
is possible to increase the power output from 15 W to 29 W,
which corresponds to an increase about 14 W.
5.2. 3 × 2 Matrix. The reconfiguration system developed for
a 3 × 2 array is similar to the one presented in the previous
section. Six KS10 PV modules are connected to the switching
circuit and control system. The module is connected to a fixed
resistive load, and the power output is sampled before and
after the system reconfiguration.
Figure 9 presents the power output curves before and
after system reconfiguration for 64 different shading situa-
tions. The increase of output power after system reconfigu-
ration changed from 17 W to 34 W, that is achieved with the
reconfiguration of electrical connections.
Before reconfiguration
After reconfiguration
t0
t16
t32
t48
t64
0
20
40
60
0
20
40
60
Power (W)
Power (W)
Time (s)
Figure 10: Power versus time curve for a 2×3 array and progressive
shading (before and after reconfiguration).
5.3. 2 × 3 Matrix. The simulation results for the 2 × 3 matrix
are shown in Figure 10. It also confirms the effectiveness of
the proposed method.
Although the 2 × 3 system has the same number of
modules as the 3 × 2 system, it is important to notice that
the results (of the 3 × 2 matrix) are quite distinct. This
new arrangement has one extra column. Its reconfiguration
system seems to be more robust, since the reconfiguration is
possible even in situations with four shaded modules, which
does not occur in the 3 × 2 system.
The simulation results for 64 shading situations are seen
in Figure 10. There are different power levels due to the physi-
cal structure of the arrangement, which enhance the possible
situations of reconfigurations but limit the concentration of
modules in a smaller number of columns.
For example, the output power is reduced in the 3 ×
2 arrangement in the case of three shaded PV modules,
what can be mitigated with the concentration of all affected
modules in one series row. In the 2 × 3 arrangement, the
shading of three PV modules inevitably reaches two columns
of the matrix even after the system reconfiguration, thus
reducing the output power.
6. Experimental Results
In order to evaluate the proposed method, a reconfiguration
system with four PV modules (2 × 2) was implemented. The
system is presented in Figure 11.
The implementation of this reconfiguration methodology
in photovoltaic systems requires additional circuitry such as
sensors, switching, and the control system (hardware and
software). Those structures can be seen in the schematic of
Figure 6.
The PV array is composed of four KS10 modules (Table 4)
resulting in a total output power of 40 W. The identification
of each module condition is made through the measurement
circuit.
The shading identification is performed by measuring the
short-circuit current 𝐼SC. The measurements are performed

## Page 9

International Journal of Photoenergy
9
Figure 11: Reconfiguration system.
on 10-second interval (𝑓= 0.1 Hz) and the current of each
PV module is monitored through an INA193 current sensor.
After signal conditioning, the parameter specifications
are sent to the microprocessor (PSoC—CY8C29466). Then,
the switching circuit, which is composed of reed relays
(HE721A1210), is triggered.
Partial shading conditions were created with the use of
tracing paper, which produce uniform shading, thus filtering
the incident radiation [8]. Although the shading profiles that
affect the PV array in the real system are different from the
pattern created by the paper, its use is justified by the necessity
of controlling the shading intensity. In the performed tests,
the tracing paper has presented a uniform shade between 40%
and 45%.
The PV array is connected to a fixed resistive load, where
voltage, current, and output power are measured. During
the tests, the module temperature reached 60∘C, which
consequently reduces the available power.
As discussed in Section 5.1, the 2 × 2 matrix has four
shading conditions where the system reconfiguration is inter-
esting. Thus, the following sections present the experimental
results of the aforementioned case studies.
6.1. Two Shaded Modules (A and C): CF.01 →CF.02. Figure 12
presents the waveforms for the current, voltage, and output
power. The time interval includes the shading of modules
A and C and also the performance of the reconfiguration
system.
The test shown in Figure 12 lasts 10 seconds and can be
divided into four time intervals.
𝑡0 to 𝑡1—all modules are illuminated and remain in
configuration 1.
𝑡1 to 𝑡2—A and C modules are shaded; the tran-
sient oscillation due to artificial shading can also be
noticed.
𝑡2 to 𝑡3—measurement time; all matrix switches are
off in order to measure the modules’ parameters.
𝑡3 to 𝑡4—reconfigured system: configuration 2.
When modules A and C are shaded, the setting of interest
is configuration 2. Through reconfiguration, it is possible
to increase the output power by about 13.5 W according to
Figure 12.
ΔP = 13.5W
1.29 A
0.75A
1.06 A
31.0 V
19.5 V
26.5V
40.0 W
14.6W
28.1 W
2
1
T
M
t0
t1
t2t3
t4
Current: 1A/div
Voltage: 20V/div
Power: 15W/div
Time: 1s/div
Figure 12: Experimental results: CF.01-CF.02.
ΔP = 13.3W
1.29 A
0.75A
1.05 A
31.0 V
19.5V
26.5V
40.0 W
14.6W
27.9W
t0
t1
t2 t3
t4
2
1
T
M
Current: 1A/div
Voltage: 20V/div
Power: 15W/div
Time: 1s/div
Figure 13: Experimental results: CF.01–CF.03.
6.2. Two Shaded Modules (B and C): CF.01 →CF.03. A similar
test is performed to verify the system performance when
modules B and C are shaded. As expected, the output power
increases by 13.3 W after system reconfiguration as seen in
Figure 13.
6.3. Two Shaded Modules (A and C) →(A and D): CF.02 →
CF.03. Analogous to the previous sections, this test can also
be divided into four time intervals as seen in Figure 14.
However, modules A and C in this test are shaded in the
time interval between 𝑡0 and 𝑡1, and the setting of interest
is configuration 2. Between 𝑡1 and 𝑡2, the shading profile
changes, while modules A and D are now shaded, thus
causing the output power to be reduced.
After the measurement period (𝑡2 to 𝑡3), the recon-
figuration system chooses the new setting of interest as
configuration 3 (𝑡3 to 𝑡4).
6.4. One Shaded Module (A): CF.01 →CF.01. As indicated in
Section 2, there are some shading conditions where nothing
can be done. The test carried out in Figure 15 evidences this
situation, where a single module is shaded.

## Page 10

10
International Journal of Photoenergy
ΔP = 13.4W
1.05 A
0.74A
1.05 A
26.0V
19.7V
26.5V
27.3W
14.5W
27.9W
2
1
T
M
t0
t1
t2 t3
t4
Current: 1A/div
Voltage: 20V/div
Power: 15W/div
Time: 1s/div
Figure 14: Experimental results: CF.02-CF.03.
1.29 A
0.95A
0.95A
31.0 V
25.4V
25.4V
40.0 W
24.1W
24.1W
2
1
T
M
t0
t1
t2t3
t4
Current: 1A/div
Voltage: 20V/div
Power: 15W/div
Time: 1s/div
Figure 15: Experimental results: CF.01-CF.01.
At the beginning, all modules are illuminated and, after
𝑡1, module A is shaded. Then, the system parameters are
measured, and the setting of interest keeps the same config-
uration (configuration 1). As expected, there is no change in
the output power.
7. Conclusions
This paper has presented the design of a dynamic reconfigu-
ration system for shaded PV arrays with SP interconnection.
The proposed method is characterized by the maintenance of
the PV array size; that is, the array dimensions do not change.
The methodology is based in Rough Sets Theory, in which
the behavior of the proposed reconfiguration system can be
defined by simple logical rules, implemented in a low-coast
microcontroller.
The operation of the proposed system has been evaluated
through computer simulations and experimental tests, while
the obtained results have shown its effectiveness. When com-
pared to an array with static connections, the reconfiguration
system provides improved extraction of energy under partial
shading conditions.
Thus, reconfiguration provides a significant increase in
the output power under different situations. The negative
effects of shading in the overall efficiency of the PV system
are minimized by the reorganization of the array electrical
connections; that is, the shaded PV modules are reconnected
in the best possible position, according to the settings of
interest.
Conflict of Interests
The authors declare that there is no conflict of interests
regarding the publication of this paper.
Acknowledgments
The authors would like to thank CAPES, CNPq, and
FAPEMIG for the financial support for this work.
References
[1] H. S. Rauschenbach, “Electrical output of shadowed solar
arrays,” IEEE Transactions on Electron Devices, vol. 18, no. 8, pp.
483–490, 1971.
[2] A. Abete, E. Barbisio, F. Cane, and P. Demartini, “Analysis
of photovoltaic modules with protection diodes in presence
of mismatching,” in Proceedings of the 21st IEEE Photovoltaic
Specialists Conference, vol. 2, pp. 1005–1010, May 1990.
[3] J. H. R. Enslin, M. S. Wolf, D. B. Snyman, and W. Swiegers, “Inte-
grated photovoltaic maximum power point tracking converter,”
IEEE Transactions on Industrial Electronics, vol. 44, no. 6, pp.
769–773, 1997.
[4] B. Patnaik, P. Sharma, E. Trimurthulu, S. P. Duttagupta, and
V. Agarwal, “Reconfiguration strategy for optimization of solar
photovoltaic array under non-uniform illumination condi-
tions,” in Proceedings of the 37th IEEE Photovoltaic Specialists
Conference (PVSC ’11), pp. 1859–1864, June 2011.
[5] B. Patnaik, J. Mohod, and S. P. Duttagupta, “Dynamic loss
comparison between Fixed-State and Reconfigurable Solar
Photovoltaic Array,” in Proceedings of the 38th IEEE Photovoltaic
Specialists Conference (PVSC ’12), pp. 1633–1638, June 2012.
[6] M. Alahmad, M. A. Chaaban, S. K. Lau, J. Shi, and J. Neal,
“An adaptive utility interactive photovoltaic system based on
a flexible switch matrix to optimize performance in real-time,”
Solar Energy, vol. 86, no. 3, pp. 951–963, 2012.
[7] J. Storey, P. R. Wilson, and D. Bagnall, “The optimized-string
dynamic photovoltaic array,” IEEE Transactions on Power Elec-
tronics, vol. 29, no. 4, pp. 1768–1776, 2014.
[8] P. dos Santos, E. M. Vicente, and E. R. Ribeiro, “Relationship
between the shading position and the output power of a photo-
voltaic panel,” in Proceedings of the Brazilian Power Electronics
Conference (COBEP ’11), pp. 676–681, September 2011.
[9] J. D. Bastidas-Rodriguez, C. A. Ramos-Paja, and A. J. Saavedra-
Montes, “Reconfiguration analysis of photovoltaic arrays based
on parameters estimation,” Simulation Modelling Practice and
Theory, vol. 35, pp. 50–68, 2013.
[10] Z. Pawlak, Rough Sets: Theoretical Aspects of Reasoning about
Data, Kluwer Academic, London, UK, 1991.
[11] J. Komorowski, Z. Pawlak, L. Polkowski, and A. Skowron,
“Rough sets: a tutorial,” in Rough Fuzzy Hybridization: A New
Trend in Decision-Making, S. K. Pale and A. Skowron, Eds.,
Springer, Singapore, 1999.

## Page 11

International Journal of Photoenergy
11
[12] A. Øhrn and J. Komorowski, “ROSETTA: a rough set toolkit
for analysis of data,” in Proceedings of the 3rd International
Joint Conference on Information Sciences (JCIS ’97), Aachen,
Germany, September 1997.
[13] K. S. Tey, S. Mekhilef, H.-T. Yang, and M.-K. Chuang, “A
differential evolution based MPPT method for photovoltaic
modules under partial shading conditions,” International Jour-
nal of Photoenergy, vol. 2014, Article ID 945906, 10 pages, 2014.

## Page 12

Submit your manuscripts at
http://www.hindawi.com
Hindawi Publishing Corporation
http://www.hindawi.com
Volume 2014
Inorganic Chemistry
International Journal of
Hindawi Publishing Corporation 
http://www.hindawi.com
Volume 2014
 International Journal of
Photoenergy
Hindawi Publishing Corporation
http://www.hindawi.com
Volume 2014
Carbohydrate 
Chemistry
International Journal of
Hindawi Publishing Corporation
http://www.hindawi.com
Volume 2014
Journal of
Chemistry
Hindawi Publishing Corporation
http://www.hindawi.com
Volume 2014
Advances in
Physical Chemistry
Hindawi Publishing Corporation
http://www.hindawi.com
 Analytical Methods 
in Chemistry
Journal of
Volume 2014
Bioinorganic Chemistry 
and Applications
Hindawi Publishing Corporation
http://www.hindawi.com
Volume 2014
Spectroscopy
International Journal of
Hindawi Publishing Corporation
http://www.hindawi.com
Volume 2014
The Scientific 
World Journal
Hindawi Publishing Corporation 
http://www.hindawi.com
Volume 2014
Medicinal Chemistry
International Journal of
Hindawi Publishing Corporation
http://www.hindawi.com
Volume 2014
 Chromatography  
Research International
Hindawi Publishing Corporation
http://www.hindawi.com
Volume 2014
Applied Chemistry
Journal of
Hindawi Publishing Corporation
http://www.hindawi.com
Volume 2014
Hindawi Publishing Corporation
http://www.hindawi.com
Volume 2014
Theoretical Chemistry
Journal of
Hindawi Publishing Corporation
http://www.hindawi.com
Volume 2014
Journal of
Spectroscopy
Analytical Chemistry
International Journal of
Hindawi Publishing Corporation
http://www.hindawi.com
Volume 2014
Journal of
Hindawi Publishing Corporation
http://www.hindawi.com
Volume 2014
Quantum Chemistry
Hindawi Publishing Corporation
http://www.hindawi.com
Volume 2014
 Organic Chemistry 
International
Electrochemistry
International Journal of
Hindawi Publishing Corporation 
http://www.hindawi.com
Volume 2014
Hindawi Publishing Corporation
http://www.hindawi.com
Volume 2014
Catalysts
Journal of
