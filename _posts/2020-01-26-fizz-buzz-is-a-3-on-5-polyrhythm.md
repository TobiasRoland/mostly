Fizz Buzz is a party game where you go round in a circle, counting up. FizzBuzz is also 
THE classic programming [litmus test](https://www.merriam-webster.com/dictionary/litmus%20test) for
sussing out whether a potential new hire has a basic grasp of programming.

It's an easy enough game. If the number is evenly divisible by 3, you say fizz. For sake of brevity, I'll just use 🟠

```
1 2 🟠 4 5 🟠 7 8 🟠 10 11 🟠 13 14  
```

and if the number is evenly divisible by 5, you say buzz (🟢)

```
1 2 3 4 🟢 6 7 8 9 🟢 11 12 13 14
```

When the number is both divisible by 3 and 5, we say FizzBuzz (🟣)

```
1 2 3 4 5 6 7 8 9 10 11 12 13 14 🟣
```

So let's continue that chain of numbers and we'll start to see a pattern emerge of
length 15 because, well, `3 * 5 = 15`:

```
1  - 2  - 🟠 - 4  - 🟢 - 🟠 - 7  - 8  - 🟠 - 🟢 - 11 - 🟠 - 13 - 14 - 🟣
16 - 17 - 🟠 - 19 - 🟢 - 🟠 - 22 - 23 - 🟠 - 🟢 - 26 - 🟠 - 28 - 29 - 🟣
31 - 32 - 🟠 - 34 - 🟢 - 🟠 - 37 - 38 - 🟠 - 🟢 - 41 - 🟠 - 43 - 44 - 🟣
46 - 47 - 🟠 - 49 - 🟢 - 🟠 - 52 - 53 - 🟠 - 🟢 - 56 - 🟠 - 58 - 59 - 🟣
```

So we have a repeating pattern... or, a rhythm. 

So naturally, we can make some music with this. Try to count **1-15 out loud** (no really, try it)
and clap your hands during on the events at least a few times. Don't rush it, try it at a slow pace, and forget that
there's a difference between fizz and buzz. Just focus on the clapping and counting:

```
1 2 👏 4 👏 👏 7 8 👏 👏 11 👏 13 14 👏
```

It can be a bit difficult to keep time. Once you reach numbers with multiple syllables,
it's harder to keep the pulse going . So let's break it into three groups of five instead:

```
1 2 🟠 4 🟢 🟠 7 8 🟠 🟢 11 🟠 13 14 🟣
1 2 👏 4 👏 | 👏 2 3 👏 👏 | 1 👏 3 4 👏
1 2 👏 4 👏 | 👏 2 3 👏 👏 | 1 👏 3 4 👏
1 2 👏 4 👏 | 👏 2 3 👏 👏 | 1 👏 3 4 👏
```

Still feels a bit unnatural right? That's becaus we're clapping a **3 on 5** polyrhythm, or to rephrase it,
a sequence that repeats in 3 steps, on top of a sequence that repeats in 5. We'll dive into the 3-on-5-ness in the
next exercise, but for now now, if you're like most people... this will feel weird. To make it a little nicer, 
it would be most natural to always have a hit on the "one" beat (the first hit in each group of five). So, let's shift over our
pattern one step to the right. Fundamentally still the same pattern, right?

Again, don't bother saying Fizz, Buzz, or FizzBuzz, just focus on clapping and counting it.

```
🟣 2 3 🟠 5 | 🟢 🟠 3 4 🟠 | 🟢 2 🟠 4 5 🟠
👏 2 3 👏 5 | 👏 👏 3 4 👏 | 👏 2 👏 4 5 👏
👏 2 3 👏 5 | 👏 👏 3 4 👏 | 👏 2 👏 4 5 👏
👏 2 3 👏 5 | 👏 👏 3 4 👏 | 👏 2 👏 4 5 👏
👏 2 3 👏 5 | 👏 👏 3 4 👏 | 👏 2 👏 4 5 👏
```

Did you clap it? Did you say the numbers out loud? Did it feel easier? No? 

Yeah I know. Still feels weird. That's because this is a very uncommon 
rhythm to most people, and your ears
need to get used to listening to it. Try to cycle the patterns until you can get the three bars 
down before moving onto the next exercise.

So let's bring the 3-on-5-ness back to the forefront of our mind.


| 1   | 2   | 3   | 4   | 5   | 1   | 2   | 3   | 4   | 5   | 1 | 2  | 3  | 4  | 5 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 🟠 |     |     |  🟠 |     |     | 🟠  |     |    | 🟠  |     |     | 🟠 |     |     | 
| 🟢  |     |     |     |     |  🟢 |     |     |     |     | 🟢 |     |     |     |     |
| 🟣  |     |     |     |     |     |     |     |     |     |     |     |     |     |     |

Now try to use both your hands to slap this rhythm on the table. As slowly as you need to, don't worry about 
a steady pulse until you've done it a few times:

* 🟠 = **left** 
* 🟢 = **right** 
* 🟣 = **together**

Try to **really** exaggerate ("accent") the 1-beat, when counting, too: "**one** two three _four_ five, **one** _two_ three four _five_, **one** two three _four_ five". It will make it easier to have this this distinction between your dominant and non-dominant rhythms. 

If you nailed that, try to swap hands s

**BUT WAIT! THERE'S MORE!**

So this was our 3-on-5 rhythm; it took 3 bars of 5 to get "back home". We could've also phrased this as a 5-on-3 polyrhythm, that is, a repeating pattern of 5 atop a pattern of 3. Well, we know it has to take at least 15 beats to get home:


| 1   | 2   | 3   | 1   | 2   | 3   | 1   | 2  | 3   | 1   | 2 | 3  | 1  | 2  | 3 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 🟢 |     |     |  🟢 |     |     | 🟢  |     |    | 🟢  |     |     | 🟢 |     |     | 
| 🟠  |     |     |     |     |  🟠 |     |     |     |     | 🟠 |     |     |     |     |
| 🟣  |     |     |     |     |     |     |     |     |     |     |     |     |     |     |

The "trick" to this is to just feel the waltz-y rhythm of "**one** two three, **one** two three" and let
that become a regular pulse - then all you have to worry about is adding in the beat of the now non-dominant hand.

It's really interesting to me that while I find the 3-on-5 rhythm really difficult to feel and master, the 5-on-3 seems 
to be much easier (not easy, but easier) to intiuit how to play.




