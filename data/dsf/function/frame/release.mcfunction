# /function dsf:frame/release {handle:"n"}

# $(handle)と対象のframeを解放する。
# issueの未使用アドレス探索の回数を減らすため、cursorはリセットしない
$data remove storage dsf:frame "$(handle)"
$data remove storage dsf:handle used."$(handle)"
