# SVD_Gifs
Animate images with Singular Value Decomposition
[img]
[img]

### Description
This program animates images into GIFs where the frames have varying amounts of compression levels. 
The way it works is that images are treated as an array of RGB matrices, [img].
From there we can apply a Singular Value Decomposition on each of the matrices to get
[img]

Then we select our number of singular values, and recompose, like [img].

Strung together, the varying amounts of singular values in the recomposition of the image creates the animated bluring effect.
