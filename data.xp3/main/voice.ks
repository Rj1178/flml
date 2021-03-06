;
; ボイス画面
;

; ロード画面からの遷移
*start_title
	[dialog name=voice load fromTitle]
	[jump target=*start]

*start_load
	[history enabled=false]
	[dialog name=voice load]
	[jump target=*start]

*start_save
	[history enabled=false]
	[dialog name=voice save]
	[jump target=*start]

*start
	[syscurrent name="voice"]
	[syshook name="voice.start"]

; UI読み込み
*page
	[stoptrans]
	[backlay]

	[syshook name="voice.page.init"]
	[syspage uiload page=back]

	[systrans name="voice.page" method=crossfade time=300]
	[wt]

	[syspage current page=fore]
	[rclick enabled jump storage="" target=*back_rclick]

	[syshook name="voice.page.done"]
*wait
	[s]


*back_rclick
	; 右クリック効果音
	[sysse name="voice.rclick"]
*back
	[eval exp=kag.historyLayer.stopAllVoice()]
	[syshook name="voice.back"]
	[sysjump from="voice" to="title" back cond=&Current.propget("fromTitle")]

; ゲームに戻る
*game
	[sysjump from="voice" to="game" back]

*return
	[backlay]
	[syspage free page=back]
	[syshook name="voice.close.init"]

	[systrans name="voice.close" method=crossfade time=300]
	[wt]

	[syshook name="voice.close.done"]
	[sysrestore]

	[return]
