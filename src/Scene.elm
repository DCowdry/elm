module Scene exposing (main)

import GraphicSVG as G exposing (..)

-- check out Racket functional graphics tutorial

-- mid-level premade stuff that they can mess with



main =
    graphicsApp { view = view }

viewW = 1000
viewH = 500

view =
    collage viewW viewH [sky blue viewW viewH
                        ,earth darkGreen viewW (viewH/4)
                        ,star white 7 |> move (-70, 150)
                        ,star white 8 |> move (243, -28)
                        ,star white 5 |> move (150, 59)
                        ,star white 6 |> move (-184, 42)
                        ,star white 9 |> move (350, 100)
                        ,moon paleYellow 60 |> move (-370, 178)
                        ]

paleYellow = rgb 255 255 210

moon color radius =
    circle radius |> filled color

star color radius =
    let
        starShard i =
            isosceles (0.62 * radius) radius |> filled color |> rotate (degrees 72 * toFloat i)
        isosceles base height =
            polygon [(0,height)
                    ,(base / 2, 0)
                    ,(-base / 2, 0)
                    ]
    in
        group (List.map starShard (List.range 0 4))

sky color w h =
    rectangle w h |> filled color

earth color w h =
    rectangle w h |> filled color |> move (0,-3*h/2)


star3 =
    List.map triangleAtAngle (List.range 1 5)

triangleAtAngle angle =
    isosceles 40 100 |> filled (rainbow_pick angle) |> rotate (toFloat angle * (degrees 72))


redCircle radius =
    circle radius |> filled red

rainbow_pick i =
    case i of
        0 -> red
        1 -> orange
        2 -> yellow
        3 -> green
        4 -> blue
        5 -> purple
        _ -> red
