# /function dsf:frame/handle/issue with storage dsf:handle

# $(cursor)を#tempに格納する
$scoreboard players set #temp dsf.control $(cursor)

# #tempを「0~2147483646」の範囲でインクリメントしてcursorに格納する
# #tempが「2147483647」の場合、#tempを0に設定する
scoreboard players add #temp dsf.control 1
execute if score #temp dsf.control matches 2147483647.. run scoreboard players set #temp dsf.control 0
execute store result storage dsf:handle cursor int 1 run scoreboard players get #temp dsf.control

# $(cursor)がusedに存在する場合、実行を終了して再実行する
$execute if data storage dsf:handle used."$(cursor)" run return run function dsf:frame/handle/issue with storage dsf:handle

# $(cursor)がusedに存在しない場合、$(cursor)をusedに登録する
$data modify storage dsf:handle used."$(cursor)" set value 1b

# $(cursor)を返す
$return $(cursor)
