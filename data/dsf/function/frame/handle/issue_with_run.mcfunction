# /function dsf:frame/handle/issue_with_run {path:"namespace:path", arg:{}}

# callを初期化する
data remove storage dsf:frame call

# $(arg)と$(path)をcallに格納する
$data modify storage dsf:frame call set value $(arg)
$data modify storage dsf:frame call.path set value "$(path)"
# 発行したhandleをcall.handleに格納する
execute store result storage dsf:frame call.handle int 1 run function dsf:frame/handle/issue with storage dsf:handle

# 関数を実行する
$return run function $(path) with storage dsf:frame call
