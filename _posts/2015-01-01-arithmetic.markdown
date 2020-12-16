---
layout: post
title:  "Arithmetic Coding"
subtitle: ""
date:   2014-08-19 23:56:45
tag: toc
---

## Context

When compressing data, it makes sense that we would want symbols which appear frequently to be represented efficiently. Arithmetic coding, much like Huffman coding, is built on this intuition. It was designed concurrently by Jorma J. Rissanen, a researcher at IBM, and Richard C. Pasco, a PhD student at Stanford, in 1976, then patented by IBM later that year.  This led to some compression software, like bzip2, and some standards, like the JPEG standard, to choose Huffman coding instead - despite arithmetic coding being theoretically more efficient.

## Overview

Arithmetic coding is a form of lossless compression that takes a string of input symbols and encodes it as a single high precision floating point number. As it is lossless, we can perfectly recover the original input from the compressed output. The core idea of the algorithms is rooted in the properties of intervals that make up a portion of a larger number line. Imagine we have an interval that takes up half of the number line that it sits on. We can “zoom in” on this interval, creating a new number line that is half the length of the original number line. Notice then that we can define the same interval, this time relative to the new, smaller number line. In fact, we can repeat this process of starting with a number line and then zooming in on a specific proportion as many times as we want! Just with smaller and smaller numbers lines at every step. Arithmetic coding takes this principle and applies it to compression - read the next section to find out how.

![ac line]({{"/assets/images/AC/overview.png" | prepend: site.baseurl }}){: style="width:90%;"}

## Algorithm

To start, we must define a statistical model that tells us how likely each symbol we encounter is. This model does not have to be good for the algorithm to be able to encode the information, but the better it is the closer to optimal the compression will be. Understanding why this is true is better saved for after understanding the algorithm. For now, the model simply assigns a probability to each possible symbol, with the probabilities of all symbols summing up to one. For this walkthrough, we define a simple model where ‘A’ has a probability of 0.5, ‘B’ has a probability of 0.3 and ‘C’ has a probability of 0.2.

![ac model]({{"/assets/images/AC/model.png" | prepend: site.baseurl }}){: style="width:70%;"}

Once we have a model we can start on the algorithm. The first step is to utilize our model to map each symbol to a proportion of the number line from 0 to 1. How we do this mapping is arbitrary, as long as the range that the symbol occupies on the number line is equal to its probability under our model. However, the simplest mapping is simply starting from your largest probability and filling in the number line from the left. 

![ac line]({{"/assets/images/AC/line.png" | prepend: site.baseurl }}){: style="width:90%;"}

These ranges are then used to represent our letters. If we wanted to represent the symbol A, for example, we could use any value between 0 - 0.5. As A has “ownership” over that range, any value that falls in that range is read as A. Similarly, a value in the range 0.5 - 0.8 would be a B, and any value in the range 0.8 - 1 would be a C. The genius behind this encoding scheme is that it allows us to represent sequences of symbols in a way that is both compact and easy to decode.
                    
Let’s look at how that’s possible. Imagine that we are trying to encode the message “ABA” with the model we built. As mentioned above, the first A can be encoded as a value between 0 - 0.5. We then treat this range as our new number line and redefine the area tied to each symbol. The portion of the number line that each symbol occupies remains the same, only the range we are subdividing is smaller. Now, if we wanted to encode a B on this number line we could place a value between 0.25 and 0.4. And, we can repeat this process as many times as we want!

![ac encode ab]({{"/assets/images/AC/A.png" | prepend: site.baseurl }})

Our new range is 0.25 - 0.4, and we can once again subdivide our new range into three parts. Then, as our next letter is A, our final value would be in the range 0.25 - 0.325. To finish encoding, we simply select a number in the range. Here, we will use 0.3, but any value between 0.25 - 0.325 would work. 

![ac encode aba]({{"/assets/images/AC/ABA.png" | prepend: site.baseurl }})

Notice that at each step, our encoded range is within our initial range - our final range of 0.25 - 0.325 is within our first encoded range of 0 - 0.5. And, this is always true! As we are simply “zooming in” on our range at each step, we never step outside the ranges that we have already encoded.

![ac encode decoding done]({{"/assets/images/AC/decoding_done.png" | prepend: site.baseurl }})

This makes decoding trivial. We simply repeat the steps we took while encoding with small changes. Our initial range is once again 0 - 1. We subdivide the range using our model, but now look at which range our encoded value falls into. In our example, we see that 0.3 falls into the range 0 - 0.5. Now, due to the aforementioned property where our value can never stray outside of our initial range, we know that the first step in our encoding must have been selecting the range 0 - 0.5. So, we also know that the first symbol was A.

![ac decode a]({{"/assets/images/AC/A_decode.png" | prepend: site.baseurl }})

And we can simply continue to retrace our steps. We define our new range from 0 - 0.5, subdivide our range, and notice that 0.3 falls within the range 0.25 - 0.4. We know that this range corresponds to B, so we know our second value is B.

![ac decode ab]({{"/assets/images/AC/AB_decode.png" | prepend: site.baseurl }})

Finally, we subdivide for the last time and note that 0.3 falls in the range 0.25 - 0.325. So, we know our final letter is A and our entire, decoded message is “ABA”.

![ac decode abc]({{"/assets/images/AC/ABA_decode.png" | prepend: site.baseurl }})

We don’t do it in this example, but normally we should define a stop symbol. If we don’t, like in this case, we can continue reading forever, zooming in more and more on 0.3.

And that's the entire algorithm! You will notice that a long message will require a large amount of precision, both for the intermediate ranges and final values, which is why an actual implementation will use bit strings instead of floats. The other interesting thing to note is that values that require more precision will require more bits to represent, and that smaller ranges will increase the amount of required precision faster than large ranges. This comes back to the idea of optimal encoding. If we have a good model that properly predicts the probability of symbols, then symbols that are used often will increase the required precision by very little, leading to our compression being efficient. On the other hand, if our model is poor, we might end up with small ranges for our commonly used symbols. In this case, the amount of required precision would rapidly increase, requiring us to allocate more memory to represent the final value.
