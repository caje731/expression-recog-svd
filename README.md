expression-recog-svd
====================

A MATLAB project that recognizes facial expressions (Happy, Sad, Angry, Surprised, Neutral).

It works by applying Singular Value Decomposition ("SVD perturbation") as part of the image processing.
The basic flow goes like this:
Input --> Histogram Equalisation --> Face Localization and Segmentation --> SVD perturbation --> Feature Vector output.

A large collection of face images are given to the system as part of the Training Set.
Feature Vectors from this Training Set are fed to a neural network for training.

A face-detection library is used to detect faces, and needs to be compiled on your machine.
If you need to run the code, please make sure you have the .mat files containing required variables for the library.
Contact "r_cajetan-at-yahoo-dot-com" to acquire them, or for queries.
