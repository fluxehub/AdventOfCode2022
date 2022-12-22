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

## [Day 5 - Rust + tui-rs](https://github.com/fluxehub/AdventOfCode2022/tree/main/Day5)

*or how to turn an easy problem into an all day problem*

Follow the link for pretty gifs!

Today's challenge was pretty simple and essentially boiled down to a parsing + stack manipulation problem, involving moving crates between stacks. However, of course it wasn't enough for me to just *solve* the problem, I had to see those crates flying before my own two eyes. And of course, I decided that, instead of any sane solution like a web canvas, SDL or literally any other graphics framework, today would be the day I use an ncurses like interface. This decision would later come to haunt me.

Turns out doing complex animation in a framework you barely know is not quite as good of an idea as it sounds, and I ended up spending my afternoon and evening writing my solution. I realised too late that you can't store any state in a tui-rs widget, as it gets consumed by the render call, meaning all the code I wrote had to be moved. I then realised even too-late-r that `StatefulWidget` exists, but I wasn't about to rewrite everything *again* so I left my code how it was. My solution is only mostly spaghetti, which I'm happy with considering that I was pretty tired of writing this at around the 3 hour mark. I had originally planned to write more GUI code, like button prompts and a move counter, but I decided literally anything else would be a better use of my time. Also the animation on part 2 is slightly broken, but not in a way that bothers me enough to fix it.

## [Day 6 - Haskell](https://github.com/fluxehub/AdventOfCode2022/tree/main/Day6)

Honestly nothing particularly funny or interesting here, the task was fairly simple and I needed to get other things done today. I knew the task could be concisely expressed in a functional language, and since I already did F#, Haskell was my next choice. Overall pretty happy with the solution.

## [Day 7 - Go](https://github.com/fluxehub/AdventOfCode2022/tree/main/Day7)

[INSERT JOKE ABOUT GO HERE]

I had a lot of uni work to do so I fell behind on this task. Once I finally got the chance to implement it, it wasn't too bad, although I misread part 2 and was confused for quite a long time. I also fell for the classic blunder of actually implementing a file tree for no reason, but I wasn't about to write even more Go than I had to just to make a more optimal solution.

## [Day 8 - Objective-C](https://github.com/fluxehub/AdventOfCode2022/tree/main/Day8)

Furthering my bizarre self-flagellation streak from Go yesterday, I decided to do Objective-C, which despite how it may appear, is in fact a real programming language. My original solution was pretty bad, with a lot of repeated code to check each direction. After finishing both parts, I realised how I could clean up the code to make it much less ugly, and I think the new solution is pretty decent all things considered. Hopefully I'll decide to use a good language tomorrow.

## Day 9

*in progress*

## [Day 10 - Verilog (+ a little C++ and Python)](https://github.com/fluxehub/AdventOfCode2022/tree/main/Day10)

> Emulating a processor is boring, instead let's build it for real!

\- *Me, seconds before making a tragic mistake.*

I'm finally done with exams at uni, so now it's time to grind out the rest of the exercises. As the problem this time was processor emulation, and since I just finished a uni module on processor design, I decided now would be a great time to put those skills to the test. Most of my time was spent on the processor itself and fixing all the weird timing edge cases I came across (sequential logic man). I think my CRT might be bugged, but it worked enough to solve the solution so that's good enough for me. I used C++ and Verilator (because Vivado projects and Git do not mix) to run the Verilog simulations and Python to make a tiny assembler for the processor. AFAIK it should synthesize but I never tested.