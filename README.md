# Advent Of Code 2022

As my "do a random programming language every day" challenge failed last year after I ran out of free time to learn a new language each day, this year I've decided to allow any language of my choicew, with an aim to do as many languages as possible (otherwise defaulting back to a language I know well)

So far:
## Day 1 - F#

It's a cliché choice for me for sure, but always a nice way to start out. Being day 1, it was fairly simple and I got a solution I was fairly happy with

## Day 2 - ARM64 Assembly

Yeah, it's a bit of a step up from day 1, but I just got a fancy new MacBook Pro 14" so why not ~~torture myself~~ have fun writing raw assembly for it? This was pretty tricky as my knowledge of ARM assembly was pretty limited, and I had certainly never done Aarch64. My solution is certainly not the most optimized assembly code, but I think it's not bad for a day of research on a platform I barely know. 

I originally planned to avoid using any C library calls and just use plain syscalls, then I realised how much I didn't want to write an int to string converter, so I ended up using `_printf`. Oh well. 