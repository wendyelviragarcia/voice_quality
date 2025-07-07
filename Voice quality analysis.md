# Voice quality analysis

This scripts runs through all the sounds in a folder and gets their f0, jitter, shimmer, harmonics to noise ratio, H1, H2 and H1-H2 difference.

The values are measures for the whole sound. Optionally if you have a Textgrid that matches the sound, the values will be extracted for all the intervals that match a label.

The output is a tab-separated file. 


| "Filename" | "duration" | "f0_mean" |  "jitter"|  "shimmer"|  "HNR" |  "voice_breaks" | "locallyunvoiced"| "H1_dB" | "H2_dB" | "H1-H2" | "spectral_peak" |

