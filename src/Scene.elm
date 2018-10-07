module Scene exposing (main)

import GraphicSVG as G exposing (..)

-- check out Racket functional graphics tutorial

-- mid-level premade stuff that they can mess with



type Msg
    = Tick Float GetKeyState

type alias V2 = {x : Float, y : Float}

v2zero = { x = 0, y = 0 }

type alias Model =
    { position : V2, velocity : V2, angle : Float }

-- angle = 0, speed = 1 }
init =
    { position = v2zero, velocity = v2zero, angle = 0 }


gravityUpdate model =
    let
        modelVelocity = model.velocity
    in
    { model | velocity = { modelVelocity | y = modelVelocity.y - 0.0625}}

velocityUpdate model =
    let
        s = model.position
        v = model.velocity
    in
    { model | position = {x = s.x + v.x, y = s.y + v.y}}

update msg model =
    case msg of
        Tick _ (keys, _, _) ->
            let
                keyUpdater string model =
                    case keys (Key string) of
                        Down ->
                            case string of
                                "a" ->
                                    {   model | angle = model.angle + 0.0625}
                                "s" ->
                                    let modelVelocity = model.velocity in
                                    { model | velocity = { modelVelocity
                                                             | x = model.velocity.x + 0.125 * cos (model.angle + degrees 90)
                                                             , y = model.velocity.y + 0.125 * sin (model.angle + degrees 90)
                                                         }}
                                "d" ->
                                    {   model | angle = model.angle - 0.0625}
                                _ ->
                                    model

                        _ ->
                            model
            in
            gravityUpdate <| velocityUpdate <| List.foldl keyUpdater model ["a", "s", "d", "f"]


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
                        ,star white 7 |> move (-70, 120)
                        ,star white 8 |> move (243, -28)
                        ,star white 5 |> move (189, 89)
                        ,star white 6 |> move (-184, 42)
                        ,star white 9 |> move (350, 100)
                        ,moon paleYellow 60 |> move (-370, 178)
                        ,house 100 150 |> move (-50,-100)
                        ,rocket 10 30 |> move (model.position.x, model.position.y) |> rotate (model.angle)
                        ]

rocket base height = isosceles2 base height |> filled red

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
            isosceles2 isoBase radius |> filled color |> rotate (rotation * toFloat i)
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

isosceles2 base height =
    polygon [(0,height)
            ,(base / 2, 0)
            ,(-base / 2, 0)
            ]
