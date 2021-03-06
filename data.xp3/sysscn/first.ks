[linemode]

@loadplugin module=extrans.dll   cond=KAGConfigEnabled("extransEnabled",true)
@loadplugin module=extNagano.dll cond=KAGConfigEnabled("extNaganoEnabled")

@call storage="version.ks"
@if    exp="typeof tf.__origDebugLevel == 'undefined'"
	; マクロ読み込み時はデバッグログを無効に（長いと起動が遅くなるので）
	@eval exp="tf.__origDebugLevel = tkdlNone, tf.__origDebugLevel <-> kag.debugLevel" 
	@call storage="macro.ks"
	@eval exp="tf.__origDebugLevel <-> kag.debugLevel"
@else
	@call storage="macro.ks"
@endif
@call storage="custom.ks"

*first
[syshook name="first.init"]
[syshook name="first.logo" cond=!SystemConfig.stopSkipOnMessageReceived]
[sysjump from="first" to="title"]
[s]

*reset
[clearallmacro]
[call storage="macro.ks"]
[jump target=*first]
