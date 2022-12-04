# Advent Of Code 2022

As my "do a random programming language every day" challenge failed last year after I ran out of free time to learn a new language each day, this year I've decided to allow any language of my choice, with an aim to do as many languages as possible (otherwise defaulting back to a language I know well)

So far:
## [Day 1 - F#](https://github.com/fluxehub/AdventOfCode2022/tree/main/Day1)

It's a cliché choice for me for sure, but always a nice way to start out. Being day 1, it was fairly simple and I got a solution I was fairly happy with.

## [Day 2 - ARM64 Assembly](https://github.com/fluxehub/AdventOfCode2022/tree/main/Day2)

Yeah, it's a bit of a step up from day 1, but I just got a fancy new MacBook Pro 14" so why not ~~torture myself~~ have fun writing raw assembly for it? This was pretty tricky as my knowledge of ARM assembly was pretty limited, and I had certainly never done Aarch64. My solution is certainly not the most optimized assembly code, but I think it's not bad for a day of research on a platform I barely know. 

I originally planned to avoid using any library calls and just use plain syscalls, then I realised how much I didn't want to write an int to string converter, so I ended up using `_printf`. Oh well. 

## [Day 3 - C](https://github.com/fluxehub/AdventOfCode2022/tree/main/Day3)

Turns out writing raw assembly is not great, so these two random guys decided to create a language called "C" (not to be confused with C# or C++), featuring all the power of assembly with only around 80% of its verbosity. My solution was fine, but not having access to hashsets was painful and I didn't optimize as much as I probably could have. As for C, I'm not sure it'll catch on, I've read through all of K&R and the ISO spec and not once did I see the words "blazingly fast".

## [Day 4 - Siri Shortcuts](https://github.com/fluxehub/AdventOfCode2022/tree/main/Day4)

After the previous days of Assembly and C, I decided to go As High Level As Possible™. Siri Shortcuts is an unreasonably powerful language considering what it is - a drag and drop language mainly designed to automate HomeKit devices - featuring everything from JSON decoding to API requests. Writing (dragging?) the code for this task was fairly simple. One downside however is the script takes around a minute to run, so replacing your web backend with a Siri Shortcut running behind a CGI gateway may not be as promising as it sounds.
