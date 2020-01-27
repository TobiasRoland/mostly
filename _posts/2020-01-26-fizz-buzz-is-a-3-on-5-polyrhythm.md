Fizz Buzz is a party game where you go round in a circle, counting up. FizzBuzz is also 
THE classic programming [litmus test](https://www.merriam-webster.com/dictionary/litmus%20test) for
sussing out whether a potential new hire has a basic grasp of programming.

It's an easy enough game. If the number is evenly divisible by 3, you say fizz: 🟠

```
1 2 Fizz 4 5 Fizz 7 8 Fizz 10 11 Fizz 13 14  
```

and if the number is evenly divisible by 5, you say buzz: 🟢

```
1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14
```

When the number is both divisible by 3 and 5, we say FizzBuzz: 🟣

```
1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz
```
So let's continue that chain of numbers and we'll start to see a pattern emerge of
length 15 because, well, `3 * 5 = 15`:

```text
1  - 2  - 🟠 - 4  - 🟢 - 🟠 - 7  - 8  - 🟠 - 🟢 - 11 - 🟠 - 13 - 14 - 🟣
16 - 17 - 🟠 - 19 - 🟢 - 🟠 - 22 - 23 - 🟠 - 🟢 - 26 - 🟠 - 28 - 29 - 🟣
31 - 32 - 🟠 - 34 - 🟢 - 🟠 - 37 - 38 - 🟠 - 🟢 - 41 - 🟠 - 43 - 44 - 🟣
```

So we have a repeating pattern, or: a rhythm. 

So naturally, we can make some music with this. Try to count **1-15 out loud** (no realy, do it)
and clap your hands during on the events at least a few times. Don't rush it, try it at a slow pace, and forget that
there's a difference between fizz and buzz. Just focus on the clapping and counting:

```
1 2 👏 4 👏 👏 7 8 👏 👏 11 👏 13 14 👏
```

It can be a bit difficult to keep time. Once you reach numbers with multiple syllables,
it's harder to keep the pulse going . So let's break it into three groups of five instead:

```
1 2 👏 4 👏 | 👏 2 3 👏 👏 | 1  👏 3  4  👏
1 2 👏 4 👏 | 👏 2 3 👏 👏 | 1  👏 3  4  👏
1 2 👏 4 👏 | 👏 2 3 👏 👏 | 1  👏 3  4  👏
```
right? This is equivalent to:

```
1  - 2  - 🟠 - 4  - 🟢 - 🟠 - 7  - 8  - 🟠 - 🟢 - 11 - 🟠 - 13 - 14 - 🟣
```
, just broken into groups of five.

Try it.

Feels a bit unnatural right? That's becaus we're clapping a **3 on 5** polyrhythm, or to rephrase it,
a sequence that repeats in 3 steps, on top of a sequence that repeats in 5. We'll dive into the 3-on-5-ness in the
next exercise, but for now now, if you're like most people... this will feel weird. 

Since we're trying to get a rhythm down here, it would be most 
natural to always have a hit on the "one" beat, the first hit in each group of five. So, let's shift over our
pattern one step to the right.

Fundamentally still the same pattern, right?

```
👏 2 3 👏 5 | 👏 👏 3 4 👏 | 👏 2 👏 4 5 👏
👏 2 3 👏 5 | 👏 👏 3 4 👏 | 👏 2 👏 4 5 👏
👏 2 3 👏 5 | 👏 👏 3 4 👏 | 👏 2 👏 4 5 👏
```

Did you clap it? Did you say the numbers out loud? Did it feel easier? No? 
Yeah I know. Still feels weird. That's because this is a very uncommon 
rhythm to most people, and your ears
need to get used to listening to it. Try to cycle the patterns until you can get the three bars 
down before moving onto the next exercise.

I'm going to bring Fizz and Buzz back now. 🟠 is Fizz, 🟢 is Buzz. 

👏 2 3 👏 5 | 👏 👏 3 4 👏 | 👏 2 👏 4 5 👏
👏 2 3 👏 5 | 👏 👏 3 4 👏 | 👏 2 👏 4 5 👏



Ready? Ok. This is the next exercise. We're bringing Fizz and Buzz back. But since
we've committed to the idea of rhythm, we'll keep counting "one, two, three, four, five" to keep the
pulse. Thankfull we have BOTH our hands free to dedicate to the rhythm. So.

Let's say 🟠 is your left hand and 🟢 is your right.





Now let's bring back the difference between fizz and buzz. Let's say fizz stays as 👏, then buzz will be 🙌:


```
1 2 👏 4 🙌 | 👏 2 3 👏 🙌 | 1  👏 3  4  🙌
```



```
🙌 2 3 👏 5 | 👏 🙌 3 4 👏 | 🙌 2 👏 4 5 👏
👏 2 3 👏 5 | 👏 👏 3 4 👏 | 👏 2 👏 4 5 👏

```



If we shift this pattern one to the right, so the final hit (the "FizzBuzz" as it were) becomes our first hit, 





