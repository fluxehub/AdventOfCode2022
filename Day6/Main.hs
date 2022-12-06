module Main where
import System.Environment (getArgs)
import System.IO (hPutStrLn, stderr)
import Data.List (nub)

findMarkerPosition :: Int -> String -> Int
findMarkerPosition marker_length = scan 0
  where
    scan counter input =
      if nub marker == marker then
        counter + marker_length
      else
        scan (counter + 1) ((drop 1 marker) ++ rest)
      where
        (marker, rest) = splitAt marker_length input

part1 :: String -> Int
part1 = findMarkerPosition 4

part2 :: String -> Int
part2 = findMarkerPosition 14

main :: IO ()
main = do
  args <- getArgs
  case args of
    [filename] -> do
      input <- readFile filename
      putStrLn $ "Part 1: " ++ (show $ part1 input)
      putStrLn $ "Part 2: " ++ (show $ part2 input)
    _ -> hPutStrLn stderr "Usage: day6 <input>"