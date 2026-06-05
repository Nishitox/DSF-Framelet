# /function dsf:frame/route/goto_next {path:"namespace:path", handle:n, name:"list"}

# arg.routeをbranchに設定する
$data modify storage dsf:frame "$(handle)".arg.route set value "branch"
# prm.$(name)[0]を削除し、次のprm.$(name)[0]が存在する場合、再実行する
$execute store result score #return dsf.control run function dsf:data/list/next {handle: $(handle), name:$(name)}
$execute if score #return dsf.control matches 1 run function $(path) with storage dsf:frame "$(handle)".arg
