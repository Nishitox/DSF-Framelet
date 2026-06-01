# /function dsf:frame/handle/issue_with_run {path:"dsf:sample", arg:{route: "init", elem:""}}
# /function dsf:sample {path:"dsf:sample", handle:n, route:"init/root"/"branch", elem:"", }
$data modify storage dsf:frame "$(handle)".arg.path set value "$(path)"
$data modify storage dsf:frame "$(handle)".arg.handle set value "$(handle)"
$data modify storage dsf:frame "$(handle)".prm.route set value "$(route)"


### init ###
# 任意処理：listを作成してarg.elemにlist[0]を設定する
$execute if data storage dsf:frame "$(handle)".prm{route: "init"} run data modify storage dsf:frame "$(handle)".prm.list set value [1,2,3,4,5,6]
$execute if data storage dsf:frame "$(handle)".prm{route: "init"} run data modify storage dsf:frame "$(handle)".arg.elem set from storage dsf:frame "$(handle)".prm.list[0]
# 固定処理：arg.routeをrootに設定し、実行を終了して再実行する
$execute if data storage dsf:frame "$(handle)".prm{route: "init"} run return run function dsf:frame/route/goto_root {path:"$(path)", handle:$(handle)}


### root/branch: loop ###
# 固定処理：arg.routeをbranchに設定する
$data modify storage dsf:frame "$(handle)".arg.route set value "branch"
# 任意処理：elemを出力する
$say @a $(elem)
# 固定処理：prm.listを次に進め、再実行する
$function dsf:frame/route/goto_next {path:"$(path)", handle:$(handle), name:"list"}


### root: done ###
# 固定処理：prm.routeを復元し、branchの場合実行を終了する
$data modify storage dsf:frame "$(handle)".prm.route set value "$(route)"
$execute if data storage dsf:frame "$(handle)".prm{route: "branch"} run return 0
# 任意処理：終了メッセージを出力する
say @a done
# 固定処理：$(handle)と対象のframeを解放する。
$function dsf:frame/release {handle: $(handle)}
