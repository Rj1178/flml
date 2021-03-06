*
	; 選択肢配置領域の指定
	;[selopt left=0 top=60 width=800 height=360 shadow bold shadowColor=0 color=0xCBCACB overColor=0xFFFFFF]
	;normal="select_normal" over="select_over" entersebuf=8 clicksebuf=9
	;enterse='' clickse=''
	[selopt msgon fadetime=200 size=20 left=0 top=60 width=&kag.scWidth height=480 selectbasecolor=0 normal="select_normal" over="select_over" on="select_on" focus="select_readed" selectedColor=0xff9da0 disabledcolor=0x808080 edge edgeEmphasis=2048 edgeExtent=2 edgeColor=0]

	; ヒストリレイヤの uipsd
	[historyopt storage=backlog fontname=""]

	; ゲーム中の右クリックメニューのデフォルト設定を変更
	; [sysrclickopt enabled=true call=true storage=sysmenu.ks target=""]

	; メッセージウィンドウの uipsd
	; メッセージウィンドウのオプション
;	[meswinopt layer=message0 storage=text_window opacity=255 faceLeft=0 faceTop=0 faceWidth=150 faceHeight=150 nameLeft=181 nameTop=24 nameWidth=166 nameHeight=26 nameAlign=0 marginL=181 marginT=46 marginR=70 marginB=20 transparent=true visible=false]
;	[meswinopt layer=message0 storage=window_adv transparent=true visible=false nameAlign=-1 nameVAlign=0 faceOrigin=6 faceabsolute=1 nameabsolute=2 textabsolute=3]
	[meswinopt layer=message0                    transparent=true visible=false nameAlign=-1 nameVAlign=0 faceOrigin=6 faceabsolute=1 nameabsolute=2 textabsolute=3]
	@eval exp='messageWindowOptions.storage=["window_adv","quickmenu"]'


	; 辞書
	;;[encyclopedia color=0xFFC0C0]

	[addSysScript name="game" storage="start"]

	[addSysScript name="voice" storage="voice.ks"]
	[addSysScript name="voice.from.game.save" target=*start_save]
	[addSysScript name="voice.from.game.load" target=*start_load]
	[addSysScript name="game.from.voice" storage="voice.ks" target=*return]

	[addSysHook   name="first.logo"  call storage="custom.ks" target=*logo]

	[addSysHook   name="title.loop"  jump storage="custom.ks" target=*title]
	[addSysHook   name="title.game"  call storage="custom.ks" target=*title_game]

	[addSysScript name="title.from.load"   storage="custom.ks" target=*title_restore]
	[addSysScript name="title.from.option" storage="custom.ks" target=*title_restore]

	[addSysScript name="title.from.cgmode"    storage="custom.ks" target=*title_restore_cgmode]
	[addSysScript name="title.from.scenemode" storage="custom.ks" target=*title_restore_scenemode]
	[addSysScript name="title.from.soundmode" storage="custom.ks" target=*title_restore_soundmode]
	[addSysScript name="title.from.voice"     storage="custom.ks" target=*title_restore_voice]
	[addSysScript name="title.from.extra"     storage="custom.ks" target=*title_restore_extra]

	[addSysHook   name="option.page.done"        call storage="custom.ks" target=*title_bgm_from_title]
	[addSysHook   name="load.page.done"          call storage="custom.ks" target=*title_bgm_from_title]
;;	[addSysHook   name="cgmode.page.done"        call storage="custom.ks" target=*extra_bgm]
;;	[addSysHook   name="scenemode.page.done"     call storage="custom.ks" target=*extra_bgm]

	[addSysHook   name="scenemode.view.init"     jump storage="custom.ks" target=*replay_start]
	[addSysHook   name="scenemode.restore"       call storage="custom.ks" target=*replay_end]
	[addSysHook   name="scenemode.start.restore" call storage="custom.ks" target=*extra_bgm]

	[macro name=title_bgm]
		[if exp="SystemConfig.titleBGM!=''"]
			[if exp="mp.paused"]
				[trace exp="'pause'"]
				[playbgm storage=&SystemConfig.titleBGM paused]
			[elsif exp="mp.stop"]
				[trace exp="'stop'"]
				[fadeoutbgm time=%time cond="mp.time>0"]
				[stopbgm cond="!mp.time"]
			[else]
				[trace exp="'play'"]
				[updatebgm * sflag storage=&SystemConfig.titleBGM]
			[endif]
		[endif]
			[endmacro]
;	[macro name=show_title_effect]
;		[bg_effect file=ef_maga2 cond=!sf.fullcomp]
;			[endmacro]
	[set name="tf.extraDefaultBGM" value=&SystemConfig.extraBGM]

	[syscover visible color=0xFFFFFF]
	[return]



*logo
	;ロゴ表示
	[title_bgm paused]
	[stoptrans]
	[clearlayers]
	[backlay]
	[begintrans]
	[白 notrans]
	;[ev file=brandlogo_base]
	[endtrans notrans sync]
	[syscover visible=false]

	[clickskip enabled=true]

	[eval exp="kag.hideMouseCursor()"]
	[beginskip]
	[wait time=300]
	;[brandlogo_anim notrans show sync]
	[ev file=brandlogo show fade=300 sync]
	[rndvoice tag="brand"]
	[wait time=3000]
	[endskip]
	[beginskip]
	[ev file=warn show fade=300 sync]
	[wait time=10000]
	[endskip]

	[begintrans]
	[allimage hide delete]
	[endtrans normal time=300]

	[sysupdate]
	[return]


*title_bgm_from_title
	[return cond="!Current.propget('fromTitle')"]
*title_bgm
;;	[call target=*vcoll_leave]
	[title_bgm]
	[return]

*extra
	[bgmflag file="bgm03-4-3"]
	[set name="tf.extraLastBGM" value="&tf.extraDefaultBGM" cond='tf.extraLastBGM==""']
	;[call target=*extra_bgm]
	[updatebgm storage="&((string)tf.extraLastBGM).toUpperCase()" exchange time=500 cond='tf.extraLastBGM!=""']
	[jump target=*compchk cond="tf.lastExtraMode == 'compchk'"]
	[sysjump from=title to=&tf.lastExtraMode cond="tf.lastExtraMode != ''"]
	[sysjump from=title to=cgmode]

*extra_bgm
	[updatebgm storage="&((string)tf.extraLastBGM).toUpperCase()" cond='tf.extraLastBGM!=""']
	[return]

*title_restore_extra
			[set name="tf.lastExtraMode" value="compchk"  ][jump target=*title_restore]
*title_restore_cgmode
			[set name="tf.lastExtraMode" value="cgmode"   ][jump target=*title_restore]
*title_restore_soundmode
			[set name="tf.lastExtraMode" value="soundmode"][jump target=*title_restore]
*title_restore_scenemode
			[set name="tf.lastExtraMode" value="scenemode"][jump target=*title_restore]
*title_restore_voice
			[set name="tf.lastExtraMode" value="voice"    ][jump target=*title_restore]

*title_restore
	[quickmenu init]
	[stoptrans]
	[title_bgm exchange time=500]
	[rclick enabled=false]
	[clickskip enabled=true]

	[dialog name=title]
	[call storage=flagcheck.ks target=*before_title]

	[begintrans]
	[allimage hide delete]
	;[title_bg file=&Current.action("getTitleBgFile")]
	;[title_bg zoom=79 ypos=52]
	;[title_effect show]
	;[show_title_effect]
	[clearlayers page=back]
	[syspage uiload page=back]
	[systrans env name="title.show" method=crossfade time=500]

;;	[dialog action=startTimer]
	[jump target=*title_wait]

*title
	[eval exp="delete tf.lastExtraMode"]
	[eval exp="delete tf.extraLastBGM"]
	[quickmenu init]
	[stoptrans]
	[rclick enabled=false]
	[clickskip enabled=true]

	[dialog name=title]
	[call storage=flagcheck.ks target=*before_title]

	[title_bgm]

	[beginskip]
	[begintrans]
	[syspage uiload page=back visible=false]
	[clearlayers page=back]
	[allimage hide delete]
	[ev file=title_bg]
	[cutin1 file=title_ch1 opacity=0 xpos=-500]
	[cutin2 file=title_ch2 opacity=0 xpos=500]
	[cutin3 file=title_ch3 opacity=0 level=6]
	[endtrans fade=300 sync]

	[stopaction]
	[cutin1 xpos=0 opacity=255 accel=-1 time=600 nosync]
	[cutin2 xpos=0 opacity=255 accel=-1 time=600 nosync]
	[cutin1 sync]
	[cutin2 sync]
	[cutin3 zoom=100:130 opacity=255 accel=-1 time=300 sync]
	[stopaction]

	[begintrans]
	[allimage hide delete]
	[clearlayers page=back]
	[syspage uiload page=back]
	[endtrans fade=500 sync]
	[endskip]

	[rndvoice tag="title"]

;;	[dialog action=startTimer]
	[jump target=*title_wait]

*title_wait
	[syspage current page=fore]
	[dialog action="onWait"]
	[call storage=flagcheck.ks target=*on_title]
	[jump storage="title.ks" target=*wait]

*title_game
	[rndvoice tag="game" cond="tf.substory==''"]
	[dialog done]
	[title_bgm stop time=1000]
	[bgm stop=1000]
	[begintrans]
	[allimage hide]
	[clearlayers page=back]
	[systrans env name="title.done" method=crossfade time=1000]
	[rndvoice wait cond="tf.substory==''"]
	[allimage delete sync]
	[return]

*commentedit
	[panel class="CommentEditPanel"]
	[sysupdate]
	[dialog action="onEditComment"]
	[s]

*commentsave
	[panel class="CommentEditPanel"]
	[sysupdate]
	[dialog action="onSaveComment"]
	[s]

*vopgcomment
	[panel class="VoiceCommentEditPanel"]
	[sysupdate]
	[dialog action="onEditPageComment"]
	[s]

*voicemode
	[sysjump from=title to=voice]
	[s]

*compchk
	[dialog name="compchk"]
	[begintrans]
	[syspage uiload page=back]
	[endtrans fade=500]
	[rclick enabled jump storage=custom.ks target=*compchk_done]
	[s]
*compchk_done
	[sysjump from=extra to=title]


*substory_input
	[call target=*name_common]
	[panel class="SubstoryNameInputDialog" storage="nameinput" func="substinput.func" partremove=remove bgopacity=128]
	[jump target=*name_done]
*name_input
	[call target=*name_common]
	[panel class="CustomNameInputDialog" storage="nameinput" bgopacity=128]
*name_done
	[jump target=*name_cancel cond=tf.nameInputCanceled]

	[backlay]
	[syspage free page=back]
	[position page=back layer=message0 left=0 top=0 width=&kag.scWidth height=&kag.scHeight frame="" color=0 opacity=255 visible=true]
	[systrans name="nameinput.done" method=crossfade time=500]
	[wt]
	[dialog done]
	[locklink]
	[jump storage="title.ks" target=*game]
*name_cancel
	[sysse name="name.back"]
	[syspage free layer=message1 page=fore]
	[syspage current page=fore]
	[unlocklink]
	[jump storage="title.ks" target=*wait]
*name_common
	[eval exp='delete tf.substory']
	[call target=*title_bgm]
	[locklink]
	[stoptrans]
	[position page=fore layer=message1 left=0 top=0 width=&kag.scWidth height=&kag.scHeight color=0 opacity=0 visible=true]
	[return]


*qload
	[dialog action="onQLoad"]
	[locklink]
	[eval exp=SystemAction._qload_()]
	[s]
	[gotostart]

*replay_start
	[set name="tf.extraLastBGM" value=&kag.bgm.playingStorage]
	[rclick enabled=false jump=false]
	[locklink]
	[title_bgm stop time=1000]
	[bgm stop=1000]

	[begintrans]
	[allimage hide delete]
	[clearlayers page=back]
	[endtrans normal]

	[historyopt uiload]
	[clearhistory]
	[sysinit]
	[initscene nostopbgm]
	[jump storage="scenemode.ks" target=*view_start]

*replay_end
	[cancelskip]
	[linemode]
	[quickmenu fadeout wait]
	[clickskip enabled=false]
	[wait time=100]

	[quickmenu init]
	[rclick enabled=false jump=false]
	[locklink]

	[begintrans]
	[allimage hide delete]
	[clearlayers page=back]
	[endtrans normal time=500 sync]
	[call storage=flagcheck.ks target=*on_endreplay]
	[return]


