# /function dsf:frame/handle/issue_with_run {path:"dsf:frame/format", arg:{route: "init", elem:0}}
# /function dsf:frame/format {path:"dsf:frame/format", handle:n, route:"init/root"/"branch", elem:0}

# 固定処理：必要な引数をarg及びprmに格納する
$data merge storage dsf:frame {"$(handle)":{arg:{path:"$(path)", handle:"$(handle)"}}}
$data merge storage dsf:frame {"$(handle)":{prm:{route:"$(route)"}}}


### init ###
# 任意処理：listを作成してarg.elemにlist[0]を設定する
$execute if data storage dsf:frame "$(handle)".prm{route: "init"} run data modify storage dsf:frame "$(handle)".prm.list set from storage dsf:handle cache
$execute if data storage dsf:frame "$(handle)".prm{route: "init"} run data modify storage dsf:frame "$(handle)".arg.elem set from storage dsf:frame "$(handle)".prm.list[0]
# 固定処理：arg.routeをrootに設定し、実行を終了して再実行する
$execute if data storage dsf:frame "$(handle)".prm{route: "init"} run return run function dsf:frame/route/goto_root {path:"$(path)", handle:$(handle)}


### root/branch: loop ###
# 任意処理：frameを削除する
$execute unless data storage dsf:frame "$(handle)".arg{handle: "$(elem)"} run data remove storage dsf:frame $(elem)
$execute unless data storage dsf:frame "$(handle)".arg{handle: "$(elem)"} run say frame.$(elem)を削除しました
# 固定処理：prm.listを次に進め、再実行する
$function dsf:frame/route/goto_next {path:"$(path)", handle:$(handle), name:"list"}


### root: done ###
# 固定処理：prm.routeを復元し、branchの場合実行を終了する
$data modify storage dsf:frame "$(handle)".prm.route set value "$(route)"
$execute if data storage dsf:frame "$(handle)".prm{route: "branch"} run return 0
# 任意処理：cursorとusedを初期化し、cacheを削除する
data modify storage dsf:handle cursor set value 0
data modify storage dsf:handle used set value {}
data remove storage dsf:handle cache
# 固定処理：$(handle)と対象のframeを解放する。
$function dsf:frame/release {handle: $(handle)}
