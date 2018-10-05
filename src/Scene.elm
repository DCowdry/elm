module Scene exposing (main)

import GraphicSVG as G exposing (..)

-- check out Racket functional graphics tutorial

-- mid-level premade stuff that they can mess with



type Msg
    = Tick Float GetKeyState

type alias Model =
    { angle : Float, speed : Float }

init =
    { angle = 0, speed = 1 }

update msg model =
    case msg of
        Tick _ ( keys, _, _ ) ->
            case keys (Key "r") of
                JustDown ->
                    { model
                        | angle = model.angle - model.speed
                        , speed = -model.speed
                    }

                _ ->
                    { model | angle = model.angle + model.speed }


main =
    gameApp Tick {model = init
                 , update = update
                 , view = view
                 }

viewW = 1000
viewH = 500

view model =
    collage viewW viewH [sky blue viewW viewH
                        ,earth veryDarkGreen viewW (viewH/4)
                        ,star white 7 |> move (-70, 120) |> rotate (model.angle/ -30)
                        ,star white 8 |> move (243, -28) |> rotate (model.angle/31)
                        ,star white 5 |> move (189, 89) |> rotate (model.angle/ -19)
                        ,star white 6 |> move (-184, 42)  |> rotate (model.angle/26)
                        ,star white 9 |> move (350, 100) |> rotate (model.angle/29)
                        ,moon paleYellow 60 |> move (-370, 178)
                        ,house 100 150 |> move (-50,-100)
                        ]

house width height =
    group [filled (rgb 60 50 40) (isosceles width (height/2)) |> move (-width/2, height/4)
          ,filled (rgb 50 40 30) (rectangle (0.9 * width) (height/2))
          ,filled yellow (rectangle (width/10) (width/10)) |> move (width/5, 0)
          ,filled yellow (rectangle (width/10) (width/10)) |> move (1.6*width/5, width/5 * 0.6)
          ,filled yellow (rectangle (width/10) (width/10)) |> move (width/5, width/5 *0.6)
          ,filled yellow (rectangle (width/10) (width/10)) |> move (1.6*width/5, 0)
          ,filled yellow (rectangle (width/10) (width/10)) |> move (-width/5, 0)
          ,filled yellow (rectangle (width/10) (width/10)) |> move (-1.6*width/5, width/5 * 0.6)
          ,filled yellow (rectangle (width/10) (width/10)) |> move (-width/5, width/5 *0.6)
          ,filled yellow (rectangle (width/10) (width/10)) |> move (-1.6*width/5, 0)
          ]

paleYellow = rgb 255 255 210
veryDarkGreen = rgb 0 80 0

moon color radius =
    circle radius |> filled color

star color radius =
    let
        points =
            5 -- 3..8 work ok
        rotation =
            degrees 360 / points
        starPoint i =
            isosceles isoBase radius |> filled color |> rotate (rotation * toFloat i)
        isosceles base height =
            polygon [(0,height)
                    ,(base / 2, 0)
                    ,(-base / 2, 0)
                    ]
        isoBase =
            2 * radius / tan rotation
        glimmer i =
            line (0,radius) (0,2*radius) |> outlined (solid 1) color |> rotate ((toFloat i + 0.5) * rotation)
    in
        group (List.map starPoint (List.range 0 (points-1))
              ++
              (List.map glimmer (List.range 0 (points-1))))

sky color w h =
    rectangle w h |> filled color

earth color w h =
    rectangle w h |> filled color |> move (0,-3*h/2)

