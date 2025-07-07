
#	voice_quality.praat (2025)
#	
# 
# 								INSTRUCTIONS
#	0. You need a .wav (with an optional Textgrid saved in the same folder and with at least 1 interval tier).
#	1. Run
#	2. FORM EXPLANATIONS:
#		In the first field you must write the path of the folder where your files are kept
# 			in a mac something like: /Users/yourName/Desktop
# 			for windows: C:\Users\yourUserName\Desktop
# 			if you have a linux, you don't need me to tell you your path
#		
#	2. OUTPUT: txt file saves in the same folder as the data with:
#  "Filename", tab$, "duration", tab$, "f0_mean", tab$,  "jitter", tab$,  "shimmer", tab$,  "HNR",tab$,  "voice_breaks",tab$, "locallyunvoiced", tab$, "H1_dB", tab$, "H2_dB", tab$, "H1-H2", tab$, "spectral_peak"
#	Any feedback is welcome, please if you notice any mistakes or come up with anything that can improve this script, let me know!
#
#		Wendy Elvira-García
#		Laboratory of Phonetics (University of Barcelona)
#		wendy el vira@ ub.edu
#		
#		
##############################################################################################################


form Voice quality
	sentence Folder ./recordings
	comment _____
	comment If you have a TextGrid and want to analyse only certain sounds:
	sentence label_of_intervals non-empty
	integer tier 1

endform

########################################
 f0_floor =75
 f0_ceiling= 600

#folder$ = chooseDirectory$ ("Choose a directory to read")
#creates txt file
writeFileLine: folder$+ "/"+ "quality_log.txt" , "Filename", tab$, "Interval", tab$, "Interval_label", tab$, "duration", tab$, "f0_mean", tab$,  "jitter", tab$,  "shimmer", tab$,  "HNR",tab$,  "voice_breaks",tab$, "locallyunvoiced", tab$, "H1_dB", tab$, "H2_dB", tab$, "H1-H2", tab$, "H1-A1", tab$, "spectral_peak"

#creates the list of files
myList= Create Strings as file list: "list", folder$+ "/" +"*.wav"
numberOfFiles = Get number of strings

interval = 0
label$ = "-"
#empieza el bucle
for ifile to numberOfFiles
	selectObject: myList
	fileName$ = Get string: ifile
	base$ = fileName$ - ".wav"

	# reads sound
	mySound = Read from file: folder$+ "/" + base$ + ".wav"

	# reads paired textgrid if it exists
	if fileReadable(folder$ +"/"+ base$ + ".TextGrid")
		myText= Read from file: folder$ +"/"+ base$ + ".TextGrid"
		Convert to Unicode
		existsText = 1

		nIntervals = Get number of intervals: tier

		for interval to nIntervals
			selectObject: myText
			label$= Get label of interval: tier, interval

			if label$ != "" and (label$ == label_of_intervals$ or label_of_intervals$ == "non-empty") 
				start = Get start time of interval: tier, interval
				end = Get end time of interval: tier, interval

				selectObject: mySound
				mySoundOfInterest = Extract part: start, end, "rectangular", 1, "no"
				@voice_quality
				removeObject: mySoundOfInterest

			endif
		endfor
		removeObject: mySound

	else 
		existsText = 0
		@voice_quality

		removeObject: mySound
	endif

endfor




procedure voice_quality

	selectObject: mySound
	duration = Get total duration

	myPitchCheck= To Pitch (filtered autocorrelation): f0_floor, f0_ceiling, 800, 15, "no", 0.03, 0.09, 0.5, 0.055, 0.35, 0.14
	f0medial= Get mean: 0, 0, "Hertz"
	
	#cuantiles teoría de Hirst (2011) analysis by synthesis of speach melody
	q25 = Get quantile: 0, 0, 0.25, "Hertz"
	q75 = Get quantile: 0, 0, 0.75, "Hertz"

	if q25 != undefined
		f0_floor = q25 * 0.75
	else
		f0_floor = f0_floor

	endif
	
	if q75 != undefined
		f0_ceiling = q75 * 2.5
		#set to 2.5 for expressive speech for being safe, else 1.5
	else
		f0_ceiling= f0_ceiling
	endif

	removeObject: myPitchCheck

	selectObject: mySound
	myPitch= To Pitch (raw cross-correlation): 0, f0_floor, f0_ceiling, 15, "no", 0.03, 0.45, 0.01, 0.35, 0.14
	
	selectObject: mySound
	myPoints= To PointProcess (zeroes): 1, "yes", "no"


	selectObject: mySound, myPitch, myPoints
	voiceReport$ = Voice report: 0, 0, f0_floor, f0_ceiling, 1.3, 1.6, 0.03, 0.45

	minF0= extractNumber (voiceReport$, “Minimum pitch: ”)
	maxF0= extractNumber (voiceReport$, “Maximum pitch: ”)
	medianF0 = extractNumber (voiceReport$, “Median pitch: ”)
	meanF0= extractNumber (voiceReport$, “Mean pitch: ”)
    jitter = extractNumber (voiceReport$, “Jitter (ppq5): ”)
    shimmer = extractNumber (voiceReport$, “Shimmer (apq5): ”)
    hnr = extractNumber (voiceReport$, “Mean harmonics-to-noise ratio: ”)
    locallyunvoiced = extractNumber (voiceReport$, “Fraction of locally unvoiced frames: ”)
    voiceBreaks = extractNumber (voiceReport$, “Number of voice breaks:”)



	###### LTAS
	selectObject: mySound
	ltas = To Ltas (pitch-corrected): f0_floor, f0_ceiling, 8000, 100, 0.0001, 0.02, 1.3
	spectral_peak = Get frequency of maximum: 0, 11000, "Cubic"
	spectral_peak$ = fixed$ (spectral_peak, 0)
	removeObject: ltas

	#### H1-H2
	selectObject: mySound
	To Pitch: 0, f0_floor, f0_ceiling
	f0 = Get quantile: 0, 0, 0.5, "Hertz"
	Remove

	selectObject: mySound
	Filter (pass Hann band): f0 - 50, f0 + 50, 100
	Rename: "H1band"
	h1_energy = Get power: 0, 0
	Remove

	# H2
	selectObject: mySound
	Filter (pass Hann band): 2 * f0 - 50, 2 * f0 + 50, 100
	Rename: "H2band"
	h2_energy = Get power: 0, 0
	Remove

	# Convert to dB scale and compute difference
	# breathy → high H1-H2
	# creaky → low/negative H1-H2
	if h1_energy > 0 and h2_energy > 0
	    h1_db = 10 * log10(h1_energy)
	    h2_db = 10 * log10(h2_energy)
	    h1h2 = h1_db - h2_db
	else
	    h1h2 = undefined
	endif


	# H1-A1: difference in dB between the first harmonic (H1) and the first formant region (A1)
	# want to do this dynamically when I have the time (I have the code in the formants script)
	if f0 > 180
		maximum_formant = 5500
	else
		maximum_formant = 5000
	endif


	nFormants = 5

	selectObject: mySound

	myFormants = To Formant (burg): 0, nFormants, maximum_formant, 0.025, 50
	f1 = Get quantile: 1, 0, 0, "hertz", 0.5
	removeObject: myFormants


	# Extract A1
	selectObject: mySound
	a1band = Filter (pass Hann band): f1 - 100, f1 + 100, 200  ; Broader window around F1
	a1_energy = Get power: 0, 0
	removeObject: a1band


	# Compute H1 and A1 in dB and their difference
	if h1_energy > 0 and a1_energy > 0
	    h1_dB = 10 * log10(h1_energy)
	    a1_dB = 10 * log10(a1_energy)
	    h1a1 = h1_dB - a1_dB
	else
	    h1a1= undefined
	endif

		appendFile: folder$+ "/"+ "quality_log.txt" , fileName$, tab$, interval, tab$, label$, tab$


appendFileLine: folder$+ "/"+ "quality_log.txt" , fixed$ (duration, 2), tab$, meanF0, tab$,
	... fixed$ (jitter, 3), tab$, fixed$ (shimmer, 3), tab$, fixed$ (hnr, 2), tab$, 
	... voiceBreaks, tab$, fixed$ (locallyunvoiced,2), tab$, 
	... fixed$ (h1_db,2), tab$, fixed$ (h2_db, 2), tab$, fixed$ (h1h2,2), tab$, fixed$ (h1a1,2), tab$, 
	... spectral_peak$


	removeObject: myPoints, myPitch

endproc