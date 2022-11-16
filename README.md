# NeRNA: a negative data generation framework for machine learning applications of non-coding RNAs
**NeRNA is a novel negative data generation framework that is developed on the KNIME analytics platform. This workflow employs non-coding RNA sequences to generate negative RNAs.**

Supervised machine learning-based non-coding RNA (ncRNA) analysis methods have been developed to classify and identify novel sequences. During such analysis, the positive learning data sets usually have known examples of ncRNAs published in databases. On the contrary, neither databases listing the confirmed negative sequences for a specific ncRNA class nor standardized methodologies developed to generate high-quality negative examples. To achieve this challenge, we developed a novel negative data generation method, NeRNA (negative RNA).



## **Requirements**
You can download NeRNA workflow in [**Knime Workflow**](https://github.com/Mehmeteminorhan/NegativeRNA/tree/main/Knime%20Workflow) folder or directly [**here**](https://github.com/Mehmeteminorhan/NegativeRNA/raw/main/Knime%20Workflow/NeRNA%20Published%20Version.knwf).

Firstly, the NeRNA framework is developed on the [**KNIME Analytics platform**](https://www.knime.com/); therefore KNIME should be installed. A second required tool is **RNAfold** application from Vienna RNA package (Please follow the instruction, for the installation RNAfold on their [**website**](https://www.tbi.univie.ac.at/RNA/).). R software enviroment, [**seqinR**](https://seqinr.r-forge.r-project.org/) and [**stringR**](https://github.com/tidyverse/stringr) packages are required for R scripts.

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

In case studies, machine learning-based classifiers like Decision Trees (DT), Random Forest (RF), and Naive Bayes (NB) are employed to test novel negative sequences. In the test condition, equal numbers of negative and positive sequences are used to train the models, and the data sets are divided into learning and testing portions at a 70/30 ratio. Additionally, 1000-fold Monte Carlo Cross-Validation is used in the process.



| RNA type              	| Organisms 	| Size 	| Sequence Length  Min 	| Sequence Length Max 	| Sequence Length Average 	| Source         	|
|-----------------------	|:---------:	|:----:	|:--------------------:	|:-------------------:	|:-----------------------:	|----------------	|
| Human miRNA  hairpins 	|   Human   	| 1917 	|          41          	|         180         	|          81.89          	| [miRBase](https://www.mirbase.org/)        	|
| tRNA                  	|    103    	| 1110 	|          54          	|          99         	|          77.56          	| [Psi-C Database](https://tpsic.igcz.poznan.pl/info/start/) 	|
| lncRNA                	|   Human   	| 1000 	|          202         	|        29066        	|         1496.97         	| [LNCipedia](https://lncipedia.org/)      	|
| circRNA               	|   Mouse   	| 1000 	|          51          	|        29991        	|         1566.49         	| [circBase](http://www.circbase.org/)       	|



**Positive sequences, NeRNA generated negative sequences and the classification results of case studies are available in [_Case Studies folder_](https://github.com/Mehmeteminorhan/NegativeRNA/tree/main/Case%20Studies). [_NeRNA Structure Result_](https://github.com/Mehmeteminorhan/NegativeRNA/tree/main/NeRNA%20Structure%20Result) contains the secondary structures of 5 negative and 5 normal example sequences. Secondary structures of RNAs are constructed using [StructureEditortool](http://rna.urmc.rochester.edu/RNAstructure.html).**

![Result](https://github.com/Mehmeteminorhan/NegativeRNA/blob/main/Figures/Case_Studies.jpg)

## Comparison Analysis

Negative RNA sources in the literature are used to compare with negative data from NeRNA.
<img src="https://github.com/Mehmeteminorhan/NegativeRNA/blob/main/Figures/Comparison_Analysis.jpg" width="90%"></img> <img>
