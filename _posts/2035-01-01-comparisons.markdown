---
layout: post
title: Comparisons
subtitle: 
date: 2010-1-1
tags: [toc]
---

Discrete Cosine Transform (DCT), Lempel-Ziv-Welch (LZW), and arithmetic encoding each work best for different kinds of data. We compare these three algorithms by looking at the amount of compression each algorithm achieves for the following image, which is comprised of 11,059,200 bytes, or 88,473,600 bits.

![original im]({{"/assets/images/DCT/yuzu.png" | prepend: site.baseurl }}){: style="height: 500px"}

- [**Discrete Cosine Transform (DCT)**]({{ site.posts[1].url | prepend: site.baseurl }}){: .underline--magical .scroll_top}

	Works well for: Images and signals. As DCT is a lossy compression algorithm, we can choose how much compression we want. In this case, we used the standard JPEG compression rate. To see how different compression rates affect the image quality, see the DCT page.

	Compressed image down to: **3,278,353 bytes**, **29.67%** of the original size.


- [**Lempel Ziv Welch (LZW)**]({{ site.posts[2].url | prepend: site.baseurl }}){: .underline--magical .scroll_top}

	Works well for: Large amounts of data that contains repetitive patterns. Data with excessive variability is harder to compress. 

	Compressed image down to: **19,909,220 bytes**, **180%** of the original size.

	LZW does not consistently compress images and sometimes the encoded file size may be larger than the original. This effect can be seen with this picture, as it almost doubled in size after "compressing". 


- [**Arithmetic Coding (AC)**]({{ site.posts[3].url | prepend: site.baseurl }}){: .underline--magical .scroll_top}

	Works well for: Data that has some symbols which appear frequently. The more similar the probablities of the symbols the less the data can be comrpessed.

	Compressed image down to: **10,687,081** bytes, **96%** of the original size.

