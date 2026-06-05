# /function dsf:frame/handle/issue_with_run {path:"dsfsample:sample", arg:{route: "init", elem:0}}
# /function dsfsample:sample {path:"dsfsample:sample", handle:n, route:"init/root"/"branch", elem:0}

# 固定処理：必要な引数をarg及びprmに格納する
$data merge storage dsf:frame {"$(handle)":{arg:{path:"$(path)", handle:"$(handle)"}}}
$data merge storage dsf:frame {"$(handle)":{prm:{route:"$(route)"}}}


### init ###
# 任意処理：初期化処理を記述する（配列の設定など）

# 固定処理：arg.routeをrootに設定し、実行を終了して再実行する
$execute if data storage dsf:frame "$(handle)".prm{route: "init"} run return run function dsf:frame/route/goto_root {path:"$(path)", handle:$(handle)}


### root/branch: loop ###
# 任意処理：ループ処理を記述する（配列要素の処理など）

# 固定処理：prm.listを次に進め、再実行する
$function dsf:frame/route/goto_next {path:"$(path)", handle:$(handle), name:"list"}


### root: done ###
# 固定処理：prm.routeを復元し、branchの場合実行を終了する
$data modify storage dsf:frame "$(handle)".prm.route set value "$(route)"
$execute if data storage dsf:frame "$(handle)".prm{route: "branch"} run return 0
# 任意処理：終了処理を記述する

# 固定処理：$(handle)と対象のframeを解放する。
$function dsf:frame/release {handle: $(handle)}
