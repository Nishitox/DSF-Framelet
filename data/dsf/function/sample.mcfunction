# /function dsf:frame/handle/issue_with_run {run:"dsf:sample", arg:{route: "init", elem:""}}
# /function dsf:sample {run:"dsf:sample", route:"init/root"/"branch", elem:"", handle:n}
$data modify storage dsf:frame "$(handle)".arg.handle set value $(handle)
$data modify storage dsf:frame "$(run)".arg.handle set value $(run)
$data modify storage dsf:frame "$(handle)".prm.route set value "$(route)"


### init ###
# 任意の処理：listを作成してarg.elemにlist[0]を設定する
$execute if data storage dsf:frame "$(handle)".prm{route: "init"} run data modify storage dsf:frame "$(handle)".prm.list set value [1,2,3,4,5,6]
$execute if data storage dsf:frame "$(handle)".prm{route: "init"} run data modify storage dsf:frame "$(handle)".arg.elem set from storage dsf:frame "$(handle)".prm.list[0]
# arg.routeをrootに設定し、実行を終了して再実行する
$execute if data storage dsf:frame "$(handle)".prm{route: "init"} run data modify storage dsf:frame "$(handle)".arg.route set value "root"
$execute if data storage dsf:frame "$(handle)".prm{route: "init"} run return run function dsf:sample with storage dsf:frame "$(handle)".arg
# return runにより、route:initの処理はここで必ず終了する


### root/branch: loop ###
# arg.routeをbranchに設定する
$data modify storage dsf:frame "$(handle)".arg.route set value "branch"
# 任意の処理：elemを出力する
$say @a $(elem)
# prm.list[0]を削除し、prm.list[0]が存在する場合、再実行する
$execute store result score #return dsf.control run function dsf:data/list/next {handle: $(handle), name: "list"}
$execute if score #return dsf.control matches 1 run function dsf:sample with storage dsf:frame "$(handle)".arg


### root: done ###
# prm.routeを復元し、branchの場合実行を終了する
$data modify storage dsf:frame "$(handle)".prm.route set value "$(route)"
$execute if data storage dsf:frame "$(handle)".prm{route: "branch"} run return 0
# 任意の処理：終了メッセージを出力する
say @a done
# $(handle)と対象のframeを解放する。
$function dsf:frame/release {handle: $(handle)}
