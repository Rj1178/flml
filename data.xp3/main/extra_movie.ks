*op
	[call target=*fadeout]
	[ムービー再生 canskip file="bocchimusume_op"]
	[jump target=*back]

*ed1
	[call target=*fadeout]
	[ムービー再生 canskip file="bocchimusume_ed1"]
	[jump target=*back]
*ed2
	[call target=*fadeout]
	[ムービー再生 canskip file="bocchimusume_ed2"]
	[jump target=*back]
*ed3
	[call target=*fadeout]
	[ムービー再生 canskip file="bocchimusume_ed3"]
	[jump target=*back]

*fadeout
	[linemode]
	[locklink]
	[set name="tf.extraLastBGM" value=&kag.bgm.playingStorage]
	[fadeoutbgm time=500]
	[begintrans]
	[clearlayers page=back]
	[allimage hide delete]
	[endtrans fade=500 sync]
	[call storage=start.ks target=*reset]
	[return]

*back
	[call storage=start.ks target=*reset]
	[clearlayers page=fore]
	[clearlayers page=back]
	[sysinit]
	[call storage=custom.ks target=*extra_bgm]
	[jump storage=cgmode.ks target=*open]

