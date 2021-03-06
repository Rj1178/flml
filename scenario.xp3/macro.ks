;状態初期化用
;syscn から呼ばれるのでラインモード命令は含まない
[macro name=initbase]
[clearlayers]
[stopquake]
@stopbgm        cond=!mp.nostopbgm
@stopse buf=all cond=!mp.nostopse
[stopvideo]
[sysmovie state=end]
[history enabled=true]
[sysrclick]
[noeffect  enabled=true]
[clickskip enabled=true]
[current layer=message0]
[init nostopbgm=%nostopbgm]
[endmacro]

; ムービー再生のsflagはコンバートモード時のみ有効
[macro name=movieflag][endmacro]

; parsemacro.ks から呼ばれるポイント
*common_macro

;ラインモード指定とメッセージ初期化まで含む状態初期化用
[macro name=initscene]
[initbase]
[linemode mode=free craftername=true erafterpage=true]
[autoindent mode=true]
;[meswinload page=both]
[endmacro]

; 
[macro name="ゲーム開始"][set name="tf.start_storage" value=%storage][set name="tf.start_target" value=%target][exit storage="start.ks" target="*jump"][endmacro]
[macro name="ゲーム終了：タイトル"][exit storage="start.ks" target="*gameend_title"][endmacro]
[macro name="ゲーム終了：ロゴ画面"][exit storage="start.ks" target="*gameend_logo" ][endmacro]
[macro name="タイトル画面へ"][ゲーム終了：タイトル][endmacro]
[macro name="ゲームクリア"][sflag name=clear][sflag name=%flag][call storage=mgstaffroll.ks target=*mgstaffroll][endmacro]

; ■バックログのみに書き出すモード
[macro name=ログのみ開始][historyopt fontname=&MessageDefaultFontFace][nowaitmode wait=0 text=false][delay speed=0][endmacro]
[macro name=ログのみ終了][r eol=true][delay speed=%speed|user][cancelnowaitmode][historyopt fontname=""][endmacro]

; 名前置換
[macro name="名前変更"][emb exp=&@'!f.chg_name?"${mp.normal}":"${mp.change}"'][endmacro]
[macro name="苗字変更"][emb exp=&@'!f.chg_family?"${mp.normal}":"${mp.change}"'][endmacro]

[macro name=エマ名前][名前変更 normal="エマ" change=&f.name][endmacro]
[macro name=絵磨名前][emb exp=f.name  ][endmacro]
[macro name=橘花    ][emb exp=f.family][endmacro]

[macro name=絵磨ボイス顔タイプ][set name="f.emaface" value=%type][endmacro]


; 動画
[macro name="ムービー再生"][cancelskip][sysmovie *][cancelskip][sysupdate][endmacro]

[macro name="cgflag"   ][set name='&"sf.cg_"+((string)mp.file).toUpperCase()' value=1][endmacro]
[macro name="bgmflag"  ][set name='&"sf.bgm_"+((string)mp.file).toUpperCase()' value=1][endmacro]
[macro name="voiceflag"][set name='&"sf.voiceplay_"+((string)mp.file).toLowerCase()' value=1][endmacro]


; シーン回想
[macro name="回想始まり"][save_replay *][endmacro]
[macro name="回想終わり"][endrecollection][eval exp="&@'sf.${mp.tag}=true'" cond='mp.tag!=""'][endmacro]


; Ｈシーン有効無効
[pmacro name=Ｈシーン有効時 eval='!sf.disableH && global.hasAdultPatch()']
[pmacro name=Ｈシーン無効時  eval='sf.disableH || !global.hasAdultPatch()']

; シーン回想中かチェック
[pmacro name=回想プレイ時    eval="kag.isRecollection"]
[pmacro name=ゲームプレイ時 eval="!kag.isRecollection"]


; スタッフロール用
[call storage=staffroll_macro.ks cond='Storages.isExistentStorage("staffroll_macro.ks")']

;■画面を暗転する共通処理
	[macro name=暗転共通]
	[env resetcolor]
	[allimage hide]
	[endmacro]

;■メッセージ窓と画面を暗転する。音は変化無し。
	[macro name=窓消暗転]
	[begintrans][暗転共通][endtrans trans=%trans|normal wait=%wait|500 msgoff]
	[endmacro]

	[macro name=走る暗転]
	[msgoff]
	[黒 universal rule=map505b time=300]
	[endmacro]


;■画面を白転する共通処理
	[macro name=白転共通]
	[ev resetcolor]
	[env resetcolor]
	[allimage hide]
	[白]
	[endmacro]

;■画面を白転する。キャラを消して画面が黒くなりますが、メッセージ窓や音は変化無し
	[macro name=白転]
	[begintrans][白転共通][endtrans trans=%trans|normal wait=%wait=|500]
	[endmacro]

;■白転のメッセージ窓同時フェード版。スピード感ある演出用
	[macro name=白転quick]
	[begintrans][白転共通][endtrans trans=%trans|quickfade wait=%wait=|200]
	[endmacro]

;■白転のユニバーサルトランジション版。音は変化無し
	[macro name=白転univ]
	[begintrans][白転共通][endtrans univ rule=%rule|map18 vague=%vague|100 time=%time|1000 wait=%wait=|500]
	[endmacro]

;■メッセージ窓と画面を白転する。音は変化無し
	[macro name=窓消白転]
	[begintrans][白転共通][endtrans trans=%trans|normal wait=%wait=|500 msgoff]
	[endmacro]

;■窓消白転のメッセージ窓同時フェード版。ほぼ瞬時に切り替わる演出用に特設
	[macro name=窓消白転sq]
	[begintrans][白転共通][msgoff][endtrans trans=%trans|superquick wait=%wait=|0]
	[endmacro]

;■窓消白転のメッセージ窓同時フェード版。スピード感ある演出用に特設
	[macro name=窓消白転quick]
	[begintrans][白転共通][msgoff][endtrans trans=%trans|quickfade wait=%wait=|200]
	[endmacro]

;■窓消白転のmidfade版。音は変化無し
	[macro name=窓消白転mid]
	[begintrans][白転共通][endtrans trans=%trans|midfade wait=%wait|1000 msgoff]
	[endmacro]

;■窓消白転のlongfade版。音は変化無し
	[macro name=窓消白転long]
	[begintrans][白転共通][endtrans trans=%trans|longfade wait=%wait|1000 msgoff]
	[endmacro]

;■窓消白転のユニバーサルトランジション版。音は変化無し
	[macro name=窓消白転univ]
	[begintrans][白転共通][endtrans univ rule=%rule|map18 time=%time|1000 vague=%vague|100 wait=%wait|500 msgoff]
	[endmacro]


;■グラフィック、音、メッセージ窓をすべてフェードアウト。主に各スクリプトの最後やゆっくりとした場面転換に使用
	[macro name=終端]
	[msgoff normal]
	[bgm stop time=4000]
	[allse stop time=4000]
	[begintrans]
	[暗転共通]
	[endtrans trans=%trans|longfade wait=%wait|2000]
	[bgm wait]
	[endmacro]

	[macro name=終端quick]
	[msgoff normal]
	[bgm stop time=3000]
	[allse stop time=3000]
	[begintrans]
	[暗転共通]
	[endtrans trans=%trans|midfade wait=%wait|1000]
	[bgm wait]
	[endmacro]

	[macro name=白終端]
	[msgoff normal]
	[bgm stop time=4000]
	[allse stop time=4000]
	[begintrans]
	[白転共通]
	[endtrans trans=%trans|longfade wait=%wait|2000]
	[bgm wait]
	[endmacro]

	[macro name=白終端quick]
	[msgoff normal]
	[bgm stop time=3000]
	[allse stop time=3000]
	[begintrans]
	[白転共通]
	[endtrans trans=%trans|midfade wait=%wait|1000]
	[bgm wait]
	[endmacro]


;■画面をセピア色に変化

	[macro name=セピア色]
	[env grayscale=true rgamma=1.3 ggamma=1.1 trans=%trans|normal]
	[endmacro]

	[macro name=色戻し]
	[env resetcolor trans=%trans|normal]
	[endmacro]

	[macro name=セピア・背景]
	[bg grayscale=true rgamma=1.3 ggamma=1.1 trans=%trans|normal]
	[endmacro]

	[macro name=セピア・イベント]
	[ev grayscale=true rgamma=1.3 ggamma=1.1 trans=%trans|normal]
	[endmacro]

	[macro name=セピア・キャラ]
	[allchar grayscale=true rgamma=1.3 ggamma=1.1 trans=%trans|normal]
	[endmacro]

	[macro name=セピア]
	[env grayscale=true rgamma=1.3 ggamma=1.1 trans=%trans|normal]
	[endmacro]

	[macro name=セピア戻し]
	[begintrans]
	[env resetcolor]
	[lay_yosumi delete]
	[endtrans trans=%trans|normal]
	[endmacro]

;■画面をセピア色に変化

	[macro name=セピア四隅白]
	[env grayscale=true rgamma=1.3 ggamma=1.1 trans=%trans|normal]
	[lay_yosumi file=yosumi_sample level=5 show]
	[endmacro]


;■汎用振動
;quakeベースの振動（振動時四隅に黒枠がでます）

	[macro name=振動]
	;@meswinloud
	[quake time=%time|500 hmax=%x|5 vmax=%y|5]
;	[ev ガクガク振動用 vibration=5 time=%time|300]
;	[bg ガクガク振動用 vibration=12 time=%time|300]
;	[allchar ガクガク振動用 vibration=3 time=%time|300]
	[endmacro]

	[macro name=振動横]
	;@meswinloud
	[quake time=%time|500 hmax=%x|5 vmax=%y|0]
	[endmacro]

	[macro name=振動縦]
	;@meswinloud
	[quake time=%time|500 hmax=%x|0 vmax=%y|5]
	[endmacro]

;	追加（山元）

	[macro name=振動短]
	;@meswinloud
	[quake time=%time|100 hmax=%x|0 vmax=%y|5]
	[endmacro]

;	追加（山元）

	[macro name=振動短大]
	;@meswinloud
	[quake time=%time|100 hmax=%x|0 vmax=%y|50]
	[endmacro]


;■一回だけスパーク（フラッシュ）
	[macro name=フラッシュ]
	[begintrans]
	[msgoff]
	[endtrans notrans]
	[f_white hide level=7 front]
	[beginskip]
	[f_white show notrans sync]
	[wait time=50]
	[f_white delete normal sync]
	[endskip]
	[endmacro]

;■一回だけスパーク（フラッシュ）長いver
	[macro name=フラッシュ長]
	[begintrans]
	[msgoff]
	[endtrans notrans]
	[f_white level=7 front]
	[beginskip]
	[f_white show notrans sync]
	[wait time=50]
	[f_white delete longfade sync]
	[endskip]
	[endmacro]

;■一回だけスパーク（フラッシュ）短いver
	[macro name=フラッシュ短]
	[begintrans]
	[msgoff]
	[endtrans notrans]
	[f_white hide level=7 front]
	[beginskip]
	[f_white show notrans sync]
	[wait time=50]
	[f_white delete quickfade sync]
	[endskip]
	[endmacro]

;フラッシュの黒バージョン（山元）

	[macro name=フラッシュ黒]
	[begintrans]
	[msgoff]
	[endtrans notrans]
	[f_black hide level=7 front]
	[beginskip]
	[f_black show notrans sync]
	[wait time=50]
	[f_black delete quickfade sync]
	[endskip]
	[endmacro]

;■一回だけスパーク（血）
	[macro name=フラッシュ赤]
	[begintrans]
	[msgoff]
	[endtrans notrans]
	[f_red hide level=7 front]
	[beginskip]
	[f_red show notrans sync]
	[wait time=50]
	[f_red delete quickfade sync]
	[endskip]
	[endmacro]


;■戦闘系マクロ

	[macro name=殴る]
	[beginskip]
	[quake time=%time|400 hmax=%x|8 vmax=%y|8]
	[f_white hide]
	[bg zoom=110 time=%speed|150 accel=-1]
	[f_white show level=5 time=100]
	[wait time=%wait|100]
	[f_white delete]
	[wait time=50]
	[bg zoom=100 time=%speed|150 accel=-1 sync]
	[endskip]
	[endmacro]

	[macro name=蹴る]
	[beginskip]
	[quake time=%time|400 hmax=%x|8 vmax=%y|8]
	[f_white hide]
	[bg zoom=110 time=%speed|150 accel=-1]
	[f_white show level=5 time=100]
	[wait time=%wait|100]
	[f_white delete]
	[wait time=50]
	[bg zoom=100 time=%speed|150 accel=-1 sync]
	[endskip]
	[endmacro]

;■汎用カットイン

	[macro name=カットイン]
	[msgoff]
	[cutin01 file=%file xpos=%xpos|0 ypos=%ypos|0 zoom=%zoom|100 show opacity=0 notrans level=%level|7]
	[cutin01 opacity=255 time=500 show accel=2 sync]
	[wact wait=%wait|0]
	[endmacro]

;追加（山元）

	[macro name=カットイン下]
	[msgoff]
	[cutin01 file=%file xpos=%xpos|0 ypos=%ypos|-500 zoom=%zoom|100 show opacity=0 notrans level=%level|7]
	[cutin01 opacity=255 ypos=@+500 time=500 show accel=2 sync]
	[wact wait=%wait|0]
	[endmacro]


	[macro name=カットイン横]
	[msgoff]
	[cutin01 file=%file show xpos=%xpos|1300 ypos=%ypos|0 time=0 level=%level|6 front opacity=%opacity|0 zoom=%zoom|100]
	[cutin01 opacity=%opacity|255 time=%opatime|500]
	[cutin01 xpos=@-1300 time=%time|500 accel=1 sync]
	[wact wait=%wait|0]
	[endmacro]

;追加（山元）

	[macro name=カットインじわ]
	[msgoff]
	[cutin01 file=%file xpos=%xpos|0 ypos=%ypos|0 zoom=%zoom|100 show opacity=0 crossfade level=%level|7]
	[cutin01 opacity=255 time=5000 sync]
	[wact wait=%wait|0]
	[endmacro]

	[macro name=カットインじわ下]
	[msgoff]
	[cutin01 file=%file xpos=%xpos|300 ypos=%ypos|-300 zoom=%zoom|100 show opacity=0 crossfade level=%level|7]
	[cutin01 opacity=255 time=5000 sync]
	[wact wait=%wait|0]
	[endmacro]

	[macro name=カットイン差し替え]
	[msgoff]
;	[se storage=%storage|se_w_rk06_09c]
	[cutin01 zoomx=0 time=150 accel=1 sync]
	[cutin01 zoomx=-100 time=150 accel=-1 sync]

	[cutin01 zoomx=0 time=150 accel=1 sync]
	[cutin01b file=%file xpos=0 ypos=0 show notrans zoomy=%zoom|100 zoomx=0 level=7]
	[cutin01b zoomx=%zoom|100 time=500 accel=-1 sync]
	[cutin01 delete]

	[begintrans]
	[cutin01 file=%file xpos=0 ypos=0 zoom=%zoom|100 show level=7]
	[cutin01b delete]
	[endtrans notrans]
	[endmacro]

	[macro name=カットイン差し替え・単純]
	[begintrans]
	[cutin01 hide ]
	[cutin01b file=%file show xpos=%xpos|0 ypos=%ypos|0 level=%level|6 front zoom=%zoom|100]
	[endtrans trans=%trans|normal]
	[begintrans]
	[cutin01b hide delete]
	[cutin01 file=%file show xpos=%xpos|0 ypos=%ypos|0 level=%level|6 front zoom=%zoom|100]
	[endtrans notrans]

	[endmacro]

	[macro name=カットイン消]
	[msgoff]
	[cutin01 time=%time|700 accel=%accel|-1 opacity=0 ]
	[cutin01 ypos=@+800 time=%time|500 accel=%accel|-1 sync]
	[カットイン削除]
	[endmacro]

;追加（山元）

	[macro name=カットインじわ消]
	[msgoff]
;	[cutin01 blur=10 normal time=500 wait=500 sync]
	[cutin01 blur=10 normal wait=500 sync]
	[cutin01 time=%time|500 blurfade hide opacity=0 level=%level|7 sync]
	[endmacro]

	[macro name=カットインじわ消ロング]
	[msgoff]
;	[cutin01 blur=10 normal time=500 wait=500 sync]
	[cutin01 blur=10 normal wait=1000 sync]
	[cutin01 time=%time|1000 blurfade hide opacity=0 level=%level|7 sync]
	[endmacro]


	[macro name=カットイン横消]
	[msgoff]
	[cutin01 xpos=@-1300 time=%time|500 accel=%accel|-1 sync]
	[カットイン削除]
	[endmacro]


;削除（消去共通で使用）
	[macro name=カットイン削除]
	[cutin01 hide notrans sync]
	[cutin00 delete]
	[cutin01 delete]
	[endmacro]

;血しぶきマクロ

	[macro name=血しぶき１]

	[blood1 file=blood1 hide xpos=%xpos1|300  ypos=%ypos1|200]
	[blood2 file=blood2 hide xpos=%xpos2|-200 ypos=%ypos2|100]
	[blood3 file=blood3 hide xpos=%xpos3|0    ypos=%ypos3|-200]

	[blood1 show trans=univ rule=map503b time=%time1|200 wait=%wait1|450 sync]
	[blood2 show trans=univ rule=map503b time=%time1|200 wait=%wait1|350 sync]
	[blood3 show trans=univ rule=map503b time=%time1|150 sync]

	[endmacro]

	[macro name=血しぶき２]

	[blood1 file=blood4 hide]
	[blood1 show trans=univ rule=map03b time=%time|150 accel=-1]
	[endmacro]

	[macro name=血しぶき消]
	[blood1 delete]
	[blood2 delete]
	[blood3 delete]
	[endmacro]

	[macro name=血しぶき消２]
	[blood1 delete]
	[endmacro]

;ガラス割れ

	[macro name=ガラス割れ]
	[begintrans]
	[msgoff]
	[endtrans notrans]
	[f_white hide level=7 front]
	[object class=layer name=glass_b file=glass_b_free1 hide level=6 front]
	[beginskip]
	[quake time=300 hmax=5 vmax=5]
	[f_white show notrans]
	[glass_b class=effect show trans=univ rule=map503b notrans sync]
	[wait time=50]
	[f_white delete quickfade sync]
	[endskip]
	[endmacro]

	[macro name=ガラス割れ消]
	[glass_b delete]
	[endmacro]

;霧
;イベントCGで使用すること
	;追加（山元）
	[macro name=霧]
	[msgoff]
	[kiri file=kiri3 xpos=%xpos|0 ypos=%ypos|0 zoom=%zoom|100 show opacity=0 crossfade level=%level|7]
	[kiri opacity=255 time=2000 sync]
	[wact wait=%wait|0]
	[endmacro]

	[macro name=霧消]
	[msgoff]
	[kiri time=%time|2000 blurfade delete opacity=0 level=%level|7]
	[endmacro]

;朦朧

[macro name=朦朧]
[msgoff]
[bg zoom=82 time=100 accel=-1]
[bg blur=10 normal time=600 wait=300 sync]
[wait time=150]
[bg blur=0 zoom=80 time=100 accel=1 sync]
[endmacro]

;追加（山元）

[macro name=朦朧イベント]
[msgoff]
[ev blur=10 normal time=100 wait=500 sync]
[ev blur=0 zoom=100 time=100 sync]
[endmacro]


@return
