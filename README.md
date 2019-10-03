# A Hybrid $L_2-L_p$ Variational Model for Single Low-light Image Enhancement with Bright Channel Prior
Fu Gang, Duan Lian, Xiao Chunxia

Note: if you have any question, please contact me by Email: xyzgfu@gmail.com

## Introduction
In this paper, we consider and study the norm variable and propose a hybrid
$L_{2}-L_{p}$ variational model with bright channel prior based on Retinex to
decompose an observed image into a reflectance layer and an illumination
layer. Different from the existing methods, our proposed model can preserve
the reflectance layer with more fine details while enforcing the illumination
layer to be texture-less, avoiding the texture-copy problem. Moreover, for
solving our non-linear optimization, we adopt an alternating minimization
scheme to find the optimal. Finally, we test our algorithm on a large number
of images and the experimental results illustrate that the proposed method has
achieved the better result than other state-of-the-art methods both
qualitatively and quantitatively.

If you use the code for your research, please cite our paper as follows:

```
@inproceedings{fu-2019-hybrid-l,
author =       {Fu Gang, Duan Lian, Xiao Chunxia},
title =        {A Hybrid $L_2-L_p$ Variational Model for Single Low-light Image Enhancement with Bright Channel Prior},
booktitle =    {IEEE International Conference on Image Processing (ICIP)},
year =         {2019},
}
```

## Execution platform
I have tested this code on Linux (Manjaro) system with Matlab 2014b (2017a), but
it shoud work on other version of Matlab. For any question about the code,
please contact me by xyzgfu@gmail.com.
