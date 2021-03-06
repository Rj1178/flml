;// [ゲームクリア flag=フラグ名] にて設定されたフラグをチェックして各種通知を表示します
;// フラグ名についてはdata/main/flagedit.iniについても参照のこと

;---------------------------------------------------------------
;// 複数条件フラグ更新処理
*flag_update
[iscript]

// 同時ルートフラグ
sf.PED01a_b = sf.PED01a && sf.PED01b;

// エンディングコンプ
sf.endcomp = 
	sf.ed01 &&
	sf.ed02 &&
	sf.ed03 &&
	sf.ed04 &&
	sf.ed05 &&
	sf.ed06 &&
	sf.ed07 &&
	sf.ed08 &&
	sf.ed09 &&
	sf.ed10 &&
	sf.ed11 &&
	sf.ed12 &&
	sf.ed13 &&
	sf.EDab1 &&
	sf.EDab2 &&
	sf.EDab3 &&
	sf.PED01a &&
	sf.PED01b &&
	sf.PED02a &&
	sf.PED02b;

// ボイスフルコンプ
sf.fullcomp = CheckFullComp() if (!sf.fullcomp);

[endscript]
	[return]

;---------------------------------------------------------------
;// タイトルが表示される前に呼び出されます
*before_title
	[call target=*flag_update]
	[steamachieve cond="sf.endcomp" id="NEW_ACHIEVEMENT_1_28"]
	; コンプ前もしくは既に表示済みなら何もしない
	[return cond="!sf.fullcomp || sf.notify_fullcomp"]
	; フルコン画像表示
	[ev file=ev_comp normal]
	[wait time=5000]
	[notify_inf flag="fullcomp" tag=fullcomp]
	[ev hide sync]
	[return]


;---------------------------------------------------------------
;// タイトル画面が表示された時に呼び出されます
*on_title
	; 1. extraがオープンした(sf.clearは[ゲームクリア]にて暗黙でtrueが設定されます)
	[notify_inf flag="clear" tag=extra]

	; 2. 巳紀トゥルーエンドクリア
	[notify_inf flag="PED01a" tag=巳紀after]

	; 3. 才人トゥルーエンドクリア
	[notify_inf flag="PED01b" tag=才人after]

	; 4. 巳紀、才人二人のトゥルーエンドクリア
	[notify_inf flag="PED01a_b" tag=同時ルート]

	; 5. 全エンドコンプリート
	[notify_inf flag="endcomp" tag=endcomp present]

	[return]

;---------------------------------------------------------------
;// シーン回想（後日談含む）を最後まで再生して一覧選択に戻る前に呼ばれます
*on_endreplay
	[call target=*before_title]
	[call target=*on_title]
	[return]
