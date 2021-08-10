## Sample codes for ML-PIV

This repository contains source codes utilized in a part of "Experimental velocity data estimation for imperfect particle images using machine learning," Phys. Fluids (2021).

In this repostiry, we provide sample codes for;
1. generating artificial particle images (API) from numerical velocity data and
2. construction of autoencoder-like convolutional neural network

![alt text](https://github.com//Masaki-Morimoto/ML-PIV/blob/images/fig02_overview.png?raw=true)

<div style="text-align: center;">Overview of the machine learning based experimental flow data estimation. 
(a) Preparation of training data set.
(b) Schematic of the API.
(c) Training of machine learning model.</div>

## Information

Author: Masaki Morimoto (masaki.morimoto[at]kflab.jp, [Keio University](https://kflab.jp/ja/))

This repository contains

- Generating API (wirtten in MTALB)
  - m01_main.m
  - m02_F_intensity.m
  - m03_F_make_API.m
  - m04_RK3.m
  - m05_UVINTPL.m
- Constructing a machine learning model (wirtten in python)
  - AE-like_CNN_for_ML-PIV.py

For citations, please refer you to the information below:

Masaki Morimoto, Kai Fukami, and Koji Fukagata "Experimental velocity data estimation for imperfect particle images using machine learning," Phys. Fluids, accepted, 2021.

Authors provide no guarantees for this code.
Use as-is and for academic research use only; no commercial use allowed without permission.
The code is written for educational clarity and not for speed.

## Requirements
- Python 3.X
- keras
- tensorflow
- numpy
- pandas
- Matlab
