# /function dsf:frame/route/goto_root {path:"namespace:path", handle:n}

# arg.routeをrootに設定し、再実行する
$data modify storage dsf:frame "$(handle)".arg.route set value "root"
$function $(path) with storage dsf:frame "$(handle)".arg
