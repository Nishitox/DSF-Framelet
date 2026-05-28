# /function dsf:data/handle/release {target:n}

# $(target)を解放する。
# issueの未使用アドレス探索の回数を減らすため、cursorはリセットしない
$data remove storage dsf:handle used."$(target)"
