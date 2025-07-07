# Voice quality analysis
Scripts to analyze voice quality in Praat (H1-H2, HNR, Spectral peak, jitter, shimmer...)


This scripts runs through all the sounds in a folder and gets their f0, jitter, shimmer, harmonics to noise ratio, H1, H2 and H1-H2 difference.

The values are measures for the whole sound. Optionally if you have a Textgrid that matches the sound, the values will be extracted for all the intervals that match a label.

The output is a tab-separated file with a header like:

| Filename                  | duration | f0_mean | jitter | shimmer | HNR   | voice_breaks | locallyunvoiced | H1_dB  | H2_dB  | H1-H2 | spectral_peak |
|---------------------------|----------|---------|--------|---------|-------|---------------|------------------|--------|--------|--------|----------------|
| wendy_healthy.wav         | 12.73    | 213.461 | 0.046  | 0.063   | 12.86 | 0             | 0.03             | -34.53 | -54.93 | 20.40  | 248            |
| wendy_not_so_healthy.wav | 14.91    | 154.503 | 0.063  | 0.138   | 13.04 | 2             | 0.14             | -25.86 | -33.79 | 7.93   | 165            |


This is the form:
![Form](form.png)
