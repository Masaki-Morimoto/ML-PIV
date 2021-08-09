## Sample codes for ML-PIV

This repository contains source codes utilized in a part of "Experimental velocity data estimation for imperfect particle images using machine learning," Phys. Fluids (2021) (arXiv:2005.00756 [physics.flu-dyn]).

In this repostiry, sample codes for;
1. generating artificial particle images from numerical velocity data and
2. construction of autoencoder-like convolutional neural network

![alt text](https://github.com//Masaki-Morimoto/ML-PIV/blob/images/fig02_overview.png?raw=true)

<div style="text-align: center;">Overview of the machine learning based experimental flow data estimation. 
(a) Preparation of training data set.
(b) Schematic of the API.
(c) Training of machine learning model.</div>

## Information

Author: Masaki Morimoto ([Keio University](https://kflab.jp/ja/))

This repository contains

- CNN-MLP_model_with_scalar-input.py
- CNN-AE_model_with_scalar_input.py


For citations, please use the reference below:

Masaki Morimoto, Kai Fukami, Kai Zhang, Aditya, G. Nair, and Koji Fukagata "Convolutional neural networks for fluid flow analysis: toward effective metamodeling and low-dimensionalization," arXiv:2101.02535 (2020).

Authors provide no guarantees for this code.
Use as-is and for academic research use only; no commercial use allowed without permission.
The code is written for educational clarity and not for speed.

## Requirements
- Python 3.X
- keras
- tensorflow
- numpy
- pandas
- cv2
