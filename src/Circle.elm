module Circle exposing (main)

import GraphicSVG as G exposing (..)

-- check out Racket functional graphics tutorial

-- mid-level premade stuff that they can mess with



main =
    graphicsApp { view = view }

view =
    collage 500 500
        -- (List.range 1 18 |> List.reverse |> List.map circleizer)
        star4
        -- [ circle 50 |> filled red,
        --   circle 40 |> filled white,
        --   circle 30 |> filled blue,
        --   circle 20 |> filled green,
        --   circle 10 |> filled yellow,
        --   text "Hello" |> size 20 |> filled green |> move (-30,30)
        -- ]

star4 =
    [ isosceles2 40 100 |> filled red |> rotate (degrees 0)
    , isosceles2 40 100 |> filled red |> rotate (degrees 72)
    , isosceles2 40 100 |> filled red |> rotate (degrees 72*2)
    , isosceles2 40 100 |> filled red |> rotate (degrees 72*3)
    , isosceles2 40 100 |> filled red |> rotate (degrees 72*4)
    ]

isosceles2 base height =
    polygon [(0,height), (base/2,0), ((0-1) * base / 2,0)]


star3 =
    List.map triangleAtAngle (List.range 1 5)

triangleAtAngle angle =
    isosceles 40 100 |> filled (rainbow_pick angle) |> rotate (toFloat angle * (degrees 72))


redCircle radius =
    circle radius |> filled red

star =
    ngon 10 100.0 |> filled red

star2 =
    polygon [(0,100),
                 (40 * sin (0.5*2*pi/5),40*cos (0.5*2*pi/5)),
                 (100 * sin (1*2*pi/5),100*cos (1*2*pi/5)),
                 (100*sin (2*2*pi/5),100*cos (2*2*pi/5)),
                 (100*sin (3*2*pi/5),100*cos (3*2*pi/5)),
                 (100*sin (4*2*pi/5),100*cos (4*2*pi/5))
            ] |> filled red

rainbow_pick i =
    case i of
        0 -> red
        1 -> orange
        2 -> yellow
        3 -> green
        4 -> blue
        5 -> purple
        _ -> red
