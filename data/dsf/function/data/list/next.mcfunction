# /function dsf:data/list/next {handle:n, name:"list"}

# prm.$(name)[0]を削除する
$data remove storage dsf:frame $(handle).prm."$(name)"[0]
# arg.elemにprm.$(name)[0]を設定する
$data modify storage dsf:frame $(handle).arg.elem set from storage dsf:frame $(handle).prm."$(name)"[0]

# prm.$(name)[0]が存在する場合1を返す
$execute if data storage dsf:frame $(handle).prm."$(name)"[0] run return 1
# prm.$(name)[0]が存在しない場合0を返す
return 0
