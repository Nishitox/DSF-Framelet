# /function dsf:data/handle/issue_with_run {run:"namespace:path", arg:{}}

# callを初期化する
data remove storage dsf:frame call
# argをcallに格納する
$data modify storage dsf:frame call set value $(arg)
# handleをcall.handleに格納する
execute store result storage dsf:frame call.handle int 1 run function dsf:data/handle/issue with storage dsf:handle

# 関数を実行する
$return run function $(run) with storage dsf:frame call
