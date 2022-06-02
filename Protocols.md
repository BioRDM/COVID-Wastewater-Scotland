---
title: COVID Wastewater Scotland
---
{% include navbar.html %} 
# Protocols
The protocols developed during these projects aiming to stablish methodologies for the detection 
of SARS-CoV-2 and its new variants in wastewater are published in the public protocol platform [protocols.io](https://www.protocols.io).

## RT-qPCR for detection of SARS-Cov2 in wastewater

Viral RNA is extracted from a known volume of STW influent and amplified by Reverse Transcription Quantitative Polymerase Chain Reaction (RT-qPCR)

RT-qPCR is a process whereby RNA is first converted to complementary DNA (cDNA) after which it can undergo amplification and quantification via PCR. The amplification of a non-target sequence, in this case the Porcine Reproductive and Respiratory Syndrome Virus (PRRSV), can also be carried out to act as an internal control.

This procedure outlines the method for amplification and quantification of the RNA extracted from Crude Sewage samples but could equally apply to other RNA extracted from other types of environmental sample.

The complete protocol is available under:
[dx.doi.org/10.17504/protocols.io.bzwap7ae](https://dx.doi.org/10.17504/protocols.io.bzwap7ae)

## SARS-Cov2 RNA extraction from wastewater

This procedure outlines the method for wastewater sample preparation, concentration of viral RNA in wastewater, and viral RNA extraction from using QIAamp Viral RNA kit. This procedure works also with all types of environmental and potable water samples.
In this method, a known volume of sample is concentrated using a centrifugal filter to allow for the extraction and detection of SARS-CoV-2 RNA.

As an analytical control, samples are spiked with a known quantity of non-target RNA (PRRS1) at the start of the process to demonstrate that the method has been successful at concentrating and recovering RNA particles.

The complete protocol is available under:
[dx.doi.org/10.17504/protocols.io.bzv5p686](https://dx.doi.org/10.17504/protocols.io.bzv5p686)

## Data normalisation of RT-qPCR data

After obtaining the raw measurements as gene copies per litre using RT-qPCR, a normalisation process is required 
prior to reporting the data as RNA copies per person. 
This is because the concentration of viral RNA in wastewater is affected by both the population of the catchment 
area at each waterworks, as well as the amount of flow into the works. For example, an area with heavy rainfall 
will have high volumes of fluid flow, which will dilute RNA values. 

Therefore, parameters such as the flow volume of wastewater and population size are used to overcome this bias. 

The complete protocol is available under:
[dx.doi.org/10.17504/protocols.io.b4eqqtdw](https://dx.doi.org/10.17504/protocols.io.b4eqqtdw)

## cDNA library preparation using ARTIC v3 primers and NEB UDI UMI adaptors for NGS

This is a cDNA library preparation protocol with the aim to quantify SARS-CoV-2 in wastewater and potentially detect its different variants using Next Generation Sequencing (Illumina). In this protocol, we amplified cDNA from viral RNA extracted from wastewater. The main steps involve:
-Amplification of cDNA with ARTIC v3 primers
-Ligation of amplified cDNA to NEB UDI UMI adaptors
-PCR enrichment of the libraries
-Pooling libraries together for sequencing
The further analysis pipeline used to perform assembly and intra-host/low-frequency variant calling is the nf-core/viralrecon:  https://nf-co.re/viralrecon
This protocol is still under revision

The complete protocol is available under:
[dx.doi.org/10.17504/protocols.io.3byl4b99ovo5/v1](https://dx.doi.org/10.17504/protocols.io.3byl4b99ovo5/v1)


{% include bottomnavbar.html %}
