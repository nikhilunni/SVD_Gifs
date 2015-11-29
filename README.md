# SVD_Gifs
Animate images with Singular Value Decomposition

<img src="https://github.com/nikhilunni/SVD_Gifs/blob/master/screenshots/gambino.gif" width="300">
<img src="https://github.com/nikhilunni/SVD_Gifs/blob/master/screenshots/animated.gif" width="300">


<img src="" width="300">

### Description
This program animates images into GIFs where the frames have varying amounts of compression levels. 
The way it works is that images are treated as an array of RGB matrices, <img src="https://github.com/nikhilunni/SVD_Gifs/blob/master/screenshots/latex/rgb.png" width="75">.
From there we can apply a singular value decomposition on each of the matrices to get <img src="https://github.com/nikhilunni/SVD_Gifs/blob/master/screenshots/latex/svd.png" width="400">

Then we select our number of singular values, and recompose, like <img src="https://github.com/nikhilunni/SVD_Gifs/blob/master/screenshots/latex/mult.png" width="350">.

Strung together, the varying amounts of singular values in the recomposition of the image creates the animated bluring effect.

### Usage
You can try building with ghc, but there are dependencies with Juicy.Pixels and hmatrix. Or you can build through Cabal:

```
cabal build
./dist/build/SVDGifs/SVDGifs [name of image going in] [name of animated gif going out]
```
