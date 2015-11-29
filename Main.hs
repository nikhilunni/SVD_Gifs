{-# LANGUAGE ParallelListComp #-}

import Codec.Picture
import Data.Packed.Matrix
import Numeric.LinearAlgebra.Algorithms
import Numeric.Container
import Data.Maybe
import Data.Either
import Control.Applicative
import Control.Monad
import System.Environment


pixelToTuple :: Num a => PixelRGB8 -> (a, a, a)
pixelToTuple (PixelRGB8 r g b) = (fromIntegral r,fromIntegral g,fromIntegral b)

toRGBMatrices :: DynamicImage -> Maybe (Matrix Double, Matrix Double, Matrix Double)
toRGBMatrices img = (liftM3 (,,)) (toMatrix img fst3)
                                  (toMatrix img snd3)
                                  (toMatrix img thd3)
  where fst3 (a, _, _) = a
        snd3 (_, b, _) = b
        thd3 (_, _, c) = c

fromRGBMatrices :: (Matrix Double, Matrix Double, Matrix Double) -> Image PixelRGB8
fromRGBMatrices (r,g,b) = generateImage getXYPixel (min (cols r) (rows r)) (min (cols r) (rows r))
  where getXYPixel x y = PixelRGB8 (toPixel8 r x y) (toPixel8 g x y) (toPixel8 b x y)
        toPixel8 col x y = (fromIntegral . round) $ col @@> (y,x)
        
toMatrix :: DynamicImage -> ((Double,Double,Double) -> Double) -> Maybe (Matrix Double)
toMatrix (ImageRGB8 img@(Image w h _)) fn = Just $ buildMatrix h w getPixelValue
  where getPixelValue :: (Int, Int) -> Double
        getPixelValue (i, j) = (fn . pixelToTuple) (pixelAt img i j)
toMatrix _ _ = Nothing



processImage :: (Either String DynamicImage) -> Maybe (Matrix Double,
                                                       Matrix Double,
                                                       Matrix Double)
processImage eith = case eith of
  Left msg -> Nothing
  Right resp -> toRGBMatrices resp


compress :: (Matrix Double, Matrix Double, Matrix Double) -> Int -> Matrix Double
compress (u,s,v) k = trans $ (takeColumns k u) <>
                             (takeColumns k . takeRows k) s <>
                             (takeRows k $ trans v)

getGifFrames :: (Matrix Double, Matrix Double, Matrix Double) -> [Image PixelRGB8]
getGifFrames (r,g,b) = frames ++ (reverse frames)
  where frames = [fromRGBMatrices (compress svdR n, compress svdG n, compress svdB n) | n <- list]
        svdR = fullSVD r
        svdG = fullSVD g
        svdB = fullSVD b
        top = foldl min 100 [rows r, cols b]
        list = (replicate 10 top) ++ [n*n | n <- [top,top-1..0], n*n >= 10, n*n <= top] ++ [10,9..1]

main :: IO ()
main = do
  args <- getArgs
  img <- readImage (args !! 0)
  let rgbMats = processImage img
  case rgbMats of
    Nothing -> print "ERROR"
    Just rgb -> either print id
                (writeGifAnimation (args !! 1) 1 LoopingForever (getGifFrames rgb))
