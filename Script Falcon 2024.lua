instrument {
    name = 'Script Falcon 2024 U1',
    short_name = 'super',
    
    overlay = true
}

MaFast_period = input(7,"Ma Fast period",input.integer,1,100,1)
MaValue = input(5,"Ma Value", input.string_selection,inputs.titles)

MaSlow_period = input(25,"Ma Slow period",input.integer,1,100,1)

Signal_period = input(5,"Signal period",input.integer,1,100,1)

input_group {
    "Compra",
    colorBuy = input { default = "Green", type = input.color }, 
    visibleBuy = input { default = true, type = input.plot_visibility }
}

input_group {
    "Venda",
    colorSell = input { default = "Red", type = input.color },
    visibleSell = input { default = true, type = input.plot_visibility }
}


local titleValue = inputs[MaValue]

-- mdia mvel linear rpida
smaFast = ema(titleValue, MaFast_period)

-- mdia mvel linear devagar
smaSlow = ema(titleValue, MaSlow_period)

-- calculo diferencial - serie
buffer1 = smaFast - smaSlow 

-- clculo da mdia mvel ponderada - serie
buffer2 = wma(buffer1, Signal_period)

buyCondition = conditional(buffer1 > buffer2 and buffer1[1] < buffer2[1] and not (buffer1 < buffer2 and buffer1[1] > buffer2[1]))
buyCondition = conditional(buffer1 > buffer2 and buffer1[1] < buffer2[1])

sellCondition = conditional(buffer1 < buffer2 and buffer1[1] > buffer2[1] and not (buffer1 > buffer2 and buffer1[1] < buffer2[1]))
sellCondition = conditional(buffer1 < buffer2 and buffer1[1] > buffer2[1] )

print("buyCondition", buyCondition)
print("sellCondition", sellCondition)

plot_shape(
(buyCondition),
"2nd Candle Buy",
shape_style.triangleup,
shape_size.huge,
colorBuy,
shape_location.belowbar,
-1,
"2nd Candle Buy",
"white"
) 

plot_shape(
(sellCondition),
"2nd Candle SELL",
shape_style.triangledown,
shape_size.huge,
colorSell,
shape_location.abovebar,
-1,
"2nd Candle SELL",
"white"
)