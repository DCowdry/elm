module Scene exposing (main)

import GraphicSVG as G exposing (..)

-- check out Racket functional graphics tutorial

-- mid-level premade stuff that they can mess with



main : NotificationsProgram Color Msg
main =
    notificationsApp {  model = red -- causes circle to start red
                     , update = update -- function which changes the model
                     , view = view }

type Msg
    = Change
    | RedAgain

update msg model =
    case msg of
        Change ->
            green
        RedAgain ->
            red

viewW = 1000
viewH = 500

view model =
    collage viewW viewH [sky blue viewW viewH
                        ,earth darkGreen viewW (viewH/4)
                        ,star white 7 |> move (-70, 120)
                        ,star white 8 |> move (243, -28)
                        ,star white 5 |> move (189, 89)
                        ,star white 6 |> move (-184, 42)
                        ,star white 9 |> move (350, 100)
                        ,moon model 60 |> move (-370, 178)
                        ,house 100 150 |> move (-50,-100)
                        ]

house width height =
    group [filled orange (rectangle (0.9 * width) (height/2))
          ,filled orange (isosceles width (height/2)) |> move (-width/2, height/4)]

paleYellow = rgb 255 255 210

moon color radius =
    circle radius |> filled color

star color radius =
    let
        points = 5 -- 3..8 work ok
        rotation = degrees 360 / points
        starPoint i =
            isosceles isoBase radius |> filled color |> rotate (rotation * toFloat i)
        isosceles base height =
            polygon [(0,height)
                    ,(base / 2, 0)
                    ,(-base / 2, 0)
                    ]
        isoBase =
            2 * radius / tan rotation
    in
        group (List.map starPoint (List.range 0 (points-1)))

sky color w h =
    rectangle w h |> filled color

earth color w h =
    rectangle w h |> filled color |> move (0,-3*h/2)

