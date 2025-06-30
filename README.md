expression-recog-svd
====================

A MATLAB/C++ project that recognizes facial expressions (Happy, Sad, Angry, Surprised, Neutral). This is a university project for the final year Computer Science engineering course.

It works by applying Singular Value Decomposition ("SVD perturbation") as part of the image processing.
The basic flow goes like this:

Input
- --> Histogram Equalisation
- --> Face Localization and Segmentation
- --> SVD perturbation
- --> Feature Vector output.
  
A large collection of face images are given to the system as part of the Training Set.
Feature Vectors from this Training Set are fed to a neural network for training.

A face-detection library is used to detect faces, and needs to be compiled on your machine.

To run, the code needs .mat files holding the facial data (not part of the repository currently)
