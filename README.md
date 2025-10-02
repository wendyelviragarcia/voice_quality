# Voice quality analysis

Script to analyze voice quality in Praat (jitter, shimmer, H1-H2, H1-A1, HNR, Spectral peak...)

This scripts runs through all the sounds in a folder and gets their f0, jitter, shimmer, harmonics to noise ratio, H1, H2 and H1-H2 difference.

The values are measures for the whole sound. Optionally if you have a Textgrid that matches the sound, the values will be extracted for all the intervals that match a label.

The output is a tab-separated file with a header like:

| Filename                 | Interval | Interval_label | duration | f0_mean | jitter | shimmer | HNR   | voice_breaks | locallyunvoiced | H1_dB  | H2_dB  | H1-H2 | H1-A1 | spectral_peak |
| ------------------------ | -------- | -------------- | -------- | ------- | ------ | ------- | ----- | ------------ | --------------- | ------ | ------ | ----- | ----- | ------------- |
| wendy_healthy.wav        | 0        | -              | 12.73    | 213.461 | 0.046  | 0.063   | 12.86 | 2            | 0.03            | -34.53 | -54.93 | 20.40 | 10.61 | 248           |
| wendy_not_so_healthy.wav | 0        | -              | 14.91    | 154.503 | 0.063  | 0.138   | 13.04 | 0            | 0.14            | -25.86 | -33.79 | 7.93  | 4.23  | 165           |

This is the form:
![Form](form.png)

> **Tip:** breathy → high H1-H2, high H1-A1;
>     creaky → low H1-H2;
>     jitter → f0 oscillation;
>     shimmer → int. oscillation

# Threshold Values for WhatsApp Recordings

This section reports the **threshold values** obtained for assessing **voice quality** in recordings made via WhatsApp (initially in .ogg format, later converted to .wav).  
The analysis was performed using this script, and the values below were estimated using linear mixed-effects regression (LME, implemented with lmer).

Beware: The script outputs percentages as decimals. For example, a value of 0.03 in the output corresponds to 3% at the table below.

| Measure               | Mean     | Standard Deviation | Lower Range | Upper Range |
|-----------------------|----------|--------------------|-------------|-------------|
| Min F0 (Hz)           | 163.61   | 46.63              | 93.67       | 233.56      |
| Max F0 (Hz)           | 213.27   | 15.64              | 189.82      | 236.73      |
| F0 SD (Hz)            | 8.59     | 12.84              | -10.66      | 27.85       |
| Min Intensity (dB)    | 72.77    | 4.79               | 65.58       | 79.95       |
| Duration of [a]       | 6.56     | 3.10               | 1.91        | 11.20       |
| Jitter (ppq5, %)      | 0.30%    | 0.10%              | 0.10%       | 0.40%       |
| Shimmer (%)           | 4%       | 1%                 | 3%          | 5%          |
| HNR (dB)              | 16.23    | 2.19               | 12.95       | 19.52       |
| Devoiced Samples      | 0.10%    | 0.20%              | -0.20%      | 0.40%       |
| Degree of Breaks      | 0.01     | 0.05               | -0.06       | 0.08        |
| Number of Breaks      | 1.11     | 3.98               | -4.86       | 7.09        |
| DSI                   | -0.36    | 0.17               | -0.61       | -0.11       |

> **Citation:** Elvira-García, Wendy (2024). Creando voice checker: definición de valores de normalidad para los parámetros de calidad de voz en grabaciones realizadas a través de dispositivos móviles. En Elvira-García, W & Roseano, P. (eds). Avances metodológicos en fonética y prosodia. Madrid: UNED. pp 97 - 107. ISBN: 978-84-362-7874-3.
