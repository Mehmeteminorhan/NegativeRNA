# NeRNA: a negative data generation framework for machine learning applications of non-coding RNAs

## About
If you use workflow in your research, please consider citing;
> Orhan, M. E., Demirci, Y. M., & Saçar Demirci, M. D. (2023). NeRNA: A negative data generation framework for machine learning applications of noncoding RNAs. Computers in biology and medicine, 159, 106861. https://doi.org/10.1016/j.compbiomed.2023.106861

**NeRNA is a novel negative data generation framework that is developed on the KNIME analytics platform. This workflow employs non-coding RNA sequences to generate negative RNAs.**

Supervised machine learning-based non-coding RNA (ncRNA) analysis methods have been developed to classify and identify novel sequences. During such analysis, the positive learning data sets usually have known examples of ncRNAs published in databases. On the contrary, neither databases listing the confirmed negative sequences for a specific ncRNA class nor standardized methodologies developed to generate high-quality negative examples. To achieve this challenge, we developed a novel negative data generation method, NeRNA (negative RNA).



## **Requirements**
You can download NeRNA workflow in [**Knime Workflow**](https://github.com/Mehmeteminorhan/NegativeRNA/tree/main/Knime%20Workflow) folder or directly [**here**](https://github.com/Mehmeteminorhan/NegativeRNA/raw/main/Knime%20Workflow/NeRNA%20Framework.knwf).

Firstly, the NeRNA framework is developed on the [**KNIME Analytics platform**](https://www.knime.com/); therefore KNIME should be installed. A second required tool is **RNAfold** application from Vienna RNA package (Please follow the instruction, for the installation RNAfold on their [**website**](https://www.tbi.univie.ac.at/RNA/).). R software environment, [**seqinR**](https://seqinr.r-forge.r-project.org/) and [**stringR**](https://github.com/tidyverse/stringr) packages are required for R scripts.

To configure R settings in KNIME:
-   Inside KNIME File -> Preferences -> KNIME (left side of the pop-up) -> R
-   Set to R path and Rserve memory.

- **Please use the following commands in your R / R Studio to install the required packages.**
```R
library("Rserve")
Rserve(args = "--vanilla")
#Additionally, the seqinr and stringr packages are required in order to use R scripts.
install.packages("seqinr")
install.packages("stringr")
```
## KNIME Workflow Overview

![KNIME Workflow Overview](https://github.com/Mehmeteminorhan/NegativeRNA/blob/main/Figures/Main_Workflow.JPG)

-   **Select Sequence File, Sequence Type, and RNAfold Path:** This node configures the location of the Sequence fasta file and RNAfold path. Also, non-coding RNA types should be selected.
-  **NeRNA Generation:** NeRNA Generation is the primary node of the NeRNA workflow. There are two subgroups in this node: CASE switch and NeRNA generation.
	- **CASE switch:** This node changes RNAfold and Sequence Converter Calculation parameters by Sequence type condition. Such as, for circRNA sequences, the --circ parameter is used in RNAfold, and for the tRNA condition, the Sequence converter node is modified.
	- **NeRNA Generator:** **Main node of Negative RNA workflow.**
	![NeRNA component figure](https://github.com/Mehmeteminorhan/NegativeRNA/blob/main/Figures/NeRNA_Generation.JPG)
		- **RNAfold Calculation:** This node calculates secondary structures for each sequence. Secondary structures are essential since negative sequences are generated based on these structural representations.

			>Sequences that RNAfold does not calculate are removed. Check **Std Output** and **R error Output** on the RNAfold Calculation node.

		-  **Checking Wrong Calculation:** This node checks the for the structures without mfe(minimum free energy) values.
		-   **Check Missing Value:** This node checks non-calculated sequences. These sequences are removed before the sequence converter process.
		-  **Sequence Converter:** This meta node's task is to reconfigure sequences based on their secondary structures and base pairing.
		- **Negative Generator Binary Index Change:** This meta node is the main calculation of NeRNA workflow. All sequences are converted to octal representation, and then a novel methodology is applied to each sequence for creating negative RNA sequences.
- **Column Filter:** Filtering unused columns like iteration number.
- **Column Rename:** This node renames the Column for the FASTA Writer.
-  **FASTA Writer:** Writes a fasta file based on the file name and output location information taken from the user.


## Case Studies
NeRNA workflow is tested on four non-coding RNA classes: microRNA, long non-coding RNA, circular RNA, and tRNA sequences.

In case studies, machine learning and deep learning-based classifiers like Decision Trees (DT), Random Forest (RF), Naive Bayes (NB), Multilayer perceptron (MLP), Convolutional neural network (CNN), and Feed-forward neural networks (FNN) are employed to test novel negative sequences. In the test condition, equal numbers of negative and positive sequences are used to train the models, and the data sets are divided into learning and testing portions at a 70/30 ratio. Additionally, 1000-fold Monte Carlo Cross-Validation is used in the process.

<table class="tg">
<thead>
  <tr>
    <th class="tg-0pky">RNA type</th>
    <th class="tg-0pky">Organisms</th>
    <th class="tg-0pky">Number</th>
    <th class="tg-0pky">Sequence Length  Min</th>
    <th class="tg-0pky">Sequence Length Max</th>
    <th class="tg-0pky">Sequence Length Average</th>
    <th class="tg-0pky">Source</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-c3ow" rowspan="10"><br><br><br>miRNA<br>hairpins<br><br></td>
    <td class="tg-f8tv"><i>Homo sapiens</td>
    <td class="tg-0pky">1917</td>
    <td class="tg-0pky">41</td>
    <td class="tg-0pky">180</td>
    <td class="tg-0pky">81.89</td>
    <td class="tg-0pky"><a href="https://www.mirbase.org/" target="_blank" rel="noopener noreferrer">miRBase</a></td>
  </tr>
  <tr>
    <td class="tg-0pky"><i>Mus musculus</td>
    <td class="tg-0pky">1234</td>
    <td class="tg-0pky">39</td>
    <td class="tg-0pky">147</td>
    <td class="tg-0pky">82.6</td>
    <td class="tg-0pky"><a href="https://www.mirbase.org/" target="_blank" rel="noopener noreferrer">miRBase</a></td>
  </tr>
  <tr>
    <td class="tg-f8tv"><i>Bos taurus</td>
    <td class="tg-0pky">1064</td>
    <td class="tg-0pky">43</td>
    <td class="tg-0pky">149</td>
    <td class="tg-0pky">76.23</td>
    <td class="tg-0pky"><a href="https://www.mirbase.org/" target="_blank" rel="noopener noreferrer">miRBase</a></td>
  </tr>
  <tr>
    <td class="tg-f8tv"><i>Gallus gallus</td>
    <td class="tg-0pky">882</td>
    <td class="tg-0pky">48</td>
    <td class="tg-0pky">169</td>
    <td class="tg-0pky">87.36</td>
    <td class="tg-0pky"><a href="https://www.mirbase.org/" target="_blank" rel="noopener noreferrer">miRBase</a></td>
  </tr>
  <tr>
    <td class="tg-f8tv"><i>Oreochromis niloticus</td>
    <td class="tg-0pky">812</td>
    <td class="tg-0pky">40</td>
    <td class="tg-0pky">100</td>
    <td class="tg-0pky">61.05</td>
    <td class="tg-0pky"><a href="https://www.mirbase.org/" target="_blank" rel="noopener noreferrer">miRBase</a></td>
  </tr>
  <tr>
    <td class="tg-f8tv"><i>Equus caballus</td>
    <td class="tg-0pky">715</td>
    <td class="tg-0pky">52</td>
    <td class="tg-0pky">145</td>
    <td class="tg-0pky">104.61</td>
    <td class="tg-0pky"><a href="https://www.mirbase.org/" target="_blank" rel="noopener noreferrer">miRBase</a></td>
  </tr>
  <tr>
    <td class="tg-f8tv"><i>Glycine max</td>
    <td class="tg-0pky">684</td>
    <td class="tg-0pky">54</td>
    <td class="tg-0pky">473</td>
    <td class="tg-0pky">135.92</td>
    <td class="tg-0pky"><a href="https://www.mirbase.org/" target="_blank" rel="noopener noreferrer">miRBase</a></td>
  </tr>
  <tr>
    <td class="tg-f8tv"><i>Monodelphis domestica</td>
    <td class="tg-0pky">680</td>
    <td class="tg-0pky">44</td>
    <td class="tg-0pky">111</td>
    <td class="tg-0pky">64.92</td>
    <td class="tg-0pky"><a href="https://www.mirbase.org/" target="_blank" rel="noopener noreferrer">miRBase</a></td>
  </tr>
  <tr>
    <td class="tg-f8tv"><i>Medico truncatula</td>
    <td class="tg-0pky">672</td>
    <td class="tg-0pky">54</td>
    <td class="tg-0pky">910</td>
    <td class="tg-0pky">165.26</td>
    <td class="tg-0pky"><a href="https://www.mirbase.org/" target="_blank" rel="noopener noreferrer">miRBase</a></td>
  </tr>
  <tr>
    <td class="tg-f8tv"><i>Pan troglodytes</td>
    <td class="tg-0pky">655</td>
    <td class="tg-0pky">69</td>
    <td class="tg-0pky">148</td>
    <td class="tg-0pky">89.94</td>
    <td class="tg-0pky"><a href="https://www.mirbase.org/" target="_blank" rel="noopener noreferrer">miRBase</a></td>
  </tr>
  <tr>
    <td class="tg-0pky">tRNA</td>
    <td class="tg-f8tv"><i>101*</td>
    <td class="tg-0pky">1110</td>
    <td class="tg-0pky">54</td>
    <td class="tg-0pky">99</td>
    <td class="tg-0pky">77.56</td>
    <td class="tg-0pky"><a href="https://tpsic.igcz.poznan.pl/info/start/" target="_blank" rel="noopener noreferrer">Psi-C Database</a></td>
  </tr>
  <tr>
    <td class="tg-0pky">lncRNA</td>
    <td class="tg-f8tv"><i>Homo sapiens</td>
    <td class="tg-0pky">1000</td>
    <td class="tg-0pky">202</td>
    <td class="tg-0pky">29066</td>
    <td class="tg-0pky">1496.97</td>
    <td class="tg-0pky"><a href="https://lncipedia.org/" target="_blank" rel="noopener noreferrer">LNCipedia</a></td>
  </tr>
  <tr>
    <td class="tg-0pky">circRNA</td>
    <td class="tg-f8tv"><i>Mus musculus</td>
    <td class="tg-0pky">1000</td>
    <td class="tg-0pky">51</td>
    <td class="tg-0pky">29991</td>
    <td class="tg-0pky">1566.49</td>
    <td class="tg-0pky"><a href="http://www.circbase.org/" target="_blank" rel="noopener noreferrer">circBase</a></td>
  </tr>
</tbody>
</table>



**Positive sequences, NeRNA generated negative sequences and the classification results of case studies are available in [_Case Studies folder_](https://github.com/Mehmeteminorhan/NegativeRNA/tree/main/Case%20Studies). [_NeRNA Structure Result_](https://github.com/Mehmeteminorhan/NegativeRNA/tree/main/NeRNA%20Structure%20Result) contains the secondary structures of 5 negative and 5 normal example sequences. Secondary structures of RNAs are constructed using [StructureEditortool](http://rna.urmc.rochester.edu/RNAstructure.html).**

![Result](https://github.com/Mehmeteminorhan/NegativeRNA/blob/main/Figures/Case_Studies.jpg)

## Comparison Analysis

Negative RNA sources in the literature are used to compare with negative data from NeRNA.

<img src="https://github.com/Mehmeteminorhan/NegativeRNA/blob/main/Figures/Comparison_Analysis.jpg" width="90%"></img> <img>
