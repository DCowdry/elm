module Circle exposing (main)

import GraphicSVG as G exposing (..)

-- check out Racket functional graphics tutorial

-- mid-level premade stuff that they can mess with



main =
    graphicsApp { view = view }

view =
    collage 500 500
        (List.range 1 18 |> List.reverse |> List.map circleizer)
        -- [ circle 50 |> filled red,
        --   circle 40 |> filled white,
        --   circle 30 |> filled blue,
        --   circle 20 |> filled green,
        --   circle 10 |> filled yellow
        -- ]

circleizer : Int -> Shape a
circleizer i =
     move (toFloat i * 20 - 200, (toFloat (i-9))^2*5 - 100) <| filled (rainbow_pick i) <| circle <| toFloat i * 10

rainbow_pick i =
    case ((i-1)%6) of
        0 -> red
        1 -> orange
        2 -> yellow
        3 -> green
        4 -> blue
        5 -> purple
        _ -> red
