# add objectives
scoreboard objectives add dsf.control dummy

# set dsf.control 
scoreboard players reset * dsf.control
scoreboard players set #temp dsf.control 0
scoreboard players set #return dsf.control 0

# remove storage
data remove storage dsf:handle cursor
data remove storage dsf:handle used
data remove storage dsf:frame call


# set storage
data modify storage dsf:handle cursor set value 0
data modify storage dsf:handle used set value {}
