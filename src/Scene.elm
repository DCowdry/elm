module Scene exposing (main)

import GraphicSVG as G exposing (..)
-- documented at: https://package.elm-lang.org/packages/MacCASOutreach/graphicsvg/2.1.0/GraphicSVG


-- x=0, y=0 is at the center of the screen
viewW = 1000 -- x from -500 to 500
viewH = 500 -- y from -250 to 250
groundY = 0 - viewH/4

-- build the scene, one object at a time
view model =
    collage viewW viewH
        [ sky blue viewW viewH
        , earth veryDarkGreen viewW (viewH/4)
        , star white 7 |> move (-70, 120)
        , star white 8 |> move (43, -28)
        , star white 5 |> move (189, 89)
        , star white 6 |> move (-184, -42)
        , star white 7 |> move (350, 100)
        , moon paleYellow 60 |> move (-370, 178)
        , rocket model.state 40 |> move (model.position.x, model.position.y) |> rotate (model.angle)
        , tree 16 40 |> move (-360, groundY - 14)
        , tree 24 60 |> move (-340, groundY - 20)
        , tree 18 45 |> move (-300, groundY - 18)
        , house 100 150 |> move (410,-150)
        ]

-- the rocket can be launched and steered
-- a: turn left
-- s: thrust!
-- d: turn right
update msg model =
    case msg of
        Tick _ (keys, _, _) ->
            let
                ifHeldThen key thenFunc =
                    ifHeldThenElse key thenFunc identity
                ifHeldThenElse key thenFunc elseFunc =
                    case keys (Key key) of
                        Down -> thenFunc
                        JustDown -> thenFunc
                        _ -> elseFunc
                ifPressedThen key func =
                    case keys (Key key) of
                        JustDown -> func
                        _ -> identity
            in
            model
                |> ifHeldThenElse "s" thrustUpdate noThrustUpdate
                |> ifHeldThen "a" (turnUpdate 0.0625)
                |> ifHeldThen "d" (turnUpdate -0.0625)
                |> gravityUpdate
                |> dragUpdate
                |> velocityUpdate

init =
    { position = { x = 0, y = groundY}
    , velocity = { x = 0, y = 0 }
    , angle = 0
    , state = Landed }


moon color radius =
    circle radius |> filled color

tree width height =
    group [ isosceles2 width (height * 3/4) |> filled darkGreen  |> move (0, height/4)
          , rectangle (width/4) (height/4) |> filled darkBrown |> move (0, height/8)
          ]

rocket state height =
    let
        width = height/5
        finScale = 1.5
        nosecone = isosceles2 width (height/2+0.25) |> filled lightGray |> move (0, (height/2)-0.25) 
        fins = isosceles2 (finScale * width) (finScale * (height/2+1)) |> filled lightGray
        trunk = rectangle width (height/2) |> filled gray |> move (0, height/4)
        afterburner = isosceles2 (width/2) (height/2) |> filled transparentRed |> rotate (degrees 180)
        rocket = [ nosecone
                 , fins
                 , trunk
                 ]
    in
    group <| rocket ++ if state == Thrusting then [afterburner] else []

house width height =
    group [filled (rgb 60 50 40) (isosceles width (height/2)) |> move (-width/2, height/4)
          ,filled (rgb 50 40 30) (rectangle (0.9 * width) (height/2))
          -- in retrospect, it would have been easier to make windowpanes with a single rectangle and a '+' drawn over them.
          ,filled yellow (rectangle (width/10) (width/10)) |> move (width/5, 0)
          ,filled yellow (rectangle (width/10) (width/10)) |> move (1.6*width/5, width/5 * 0.6)
          ,filled yellow (rectangle (width/10) (width/10)) |> move (width/5, width/5 *0.6)
          ,filled yellow (rectangle (width/10) (width/10)) |> move (1.6*width/5, 0)
          ,filled yellow (rectangle (width/10) (width/10)) |> move (-width/5, 0)
          ,filled yellow (rectangle (width/10) (width/10)) |> move (-1.6*width/5, width/5 * 0.6)
          ,filled yellow (rectangle (width/10) (width/10)) |> move (-width/5, width/5 *0.6)
          ,filled yellow (rectangle (width/10) (width/10)) |> move (-1.6*width/5, 0)
          ]

star color radius =
    let
        points =
            5
        rotation =
            degrees 360 / points
        starPoint i =
            isosceles2 isoBase radius |> filled color |> rotate (rotation * toFloat i)
        isoBase =
            2 * radius / tan rotation
    in
    group (List.map starPoint (List.range 1 points))

sky color w h =
    rectangle w h |> filled color

earth color w h =
    rectangle w h |> filled color |> move (0,-3*h/2)




type Msg
    = Tick Float GetKeyState

type RocketState = Landed
                 | Thrusting
                 | Falling

type alias Point = {x : Float, y : Float}

type alias Model = Rocket

type alias Rocket =
    { position : Point, velocity : Point, angle : Float, state : RocketState }


gravityUpdate rocket =
    let
        gravityRocket =
            { rocket | velocity = { x = rocket.velocity.x, y = rocket.velocity.y - 0.0625}}
    in
    case rocket.state of
      Landed -> rocket
      Falling -> gravityRocket
      Thrusting -> gravityRocket

dragUpdate rocket =
    let
        v = rocket.velocity
        drag = 0.99
    in
    { rocket | velocity = {x = v.x * drag, y = v.y * drag}}

velocityUpdate rocket =
    let
        pos = rocket.position
        velo = rocket.velocity
    in
    { rocket | position = {x = pos.x + velo.x, y = pos.y + velo.y}}

thrustUpdate rocket =
    let
        modelVelocity = rocket.velocity
    in
    { rocket
        | state = Thrusting
        , velocity = { modelVelocity
                         | x = rocket.velocity.x + 0.125 * cos (rocket.angle + degrees 90)
                         , y = rocket.velocity.y + 0.125 * sin (rocket.angle + degrees 90)
                     }}

noThrustUpdate rocket =
    case rocket.state of
        Landed ->
            rocket
        Falling ->
            rocket
        Thrusting ->
            { rocket | state = Falling}


turnUpdate delta rocket =
    let
        turnedRocket =
            { rocket | angle = rocket.angle + delta }
    in
    case rocket.state of
        Landed ->
            rocket
        Falling ->
            turnedRocket
        Thrusting ->
            turnedRocket



main =
    gameApp Tick {model = init
                 , update = update
                 , view = view
                 }

-- there's a GraphicSVG isocolese function too, but that annyoingly
-- has the origin at one of the legs.  this one has it's origin in the
-- middle of the base, and is a good demo of how to draw arbitrary
-- polygons
isosceles2 base height =
    polygon [(0,height)
            ,(base / 2, 0)
            ,(-base / 2, 0)
            ]

paleYellow = rgb 255 255 210
veryDarkGreen = rgb 0 80 0
transparentRed = rgba 255 63 63 0.7
