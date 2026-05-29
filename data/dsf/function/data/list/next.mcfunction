# prm.list[0]を削除し、次のprm.list[0]が空かを判定する関数

# この関数は「execute if function」によってのみ実行される想定の関数であり、
# 「execute if function」は、/returnコマンドによって戻り値が当たられたコマンドが一つもない場合はif構文は失敗、unless構文は通過する。
# よって「return 1」が実行されない限り、処理は必然的にreturn 0相当となる。そのため「return 0」を明示的に省略している。

# /function dsf:data/list/next {handle: $(handle)}
$data remove storage dsf:frame "$(handle)".prm.list[0]
$execute if data storage dsf:frame "$(handle)".prm.list[0] run return 1
