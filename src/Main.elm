module Main exposing (..)

import Browser
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time as Time exposing (Posix)
import List exposing (map)

main = Browser.element { init = init
                       , view = view
                       , update = update
                       , subscriptions = subscriptions
                       }

-- MODEL

type alias Ball = { x : Float
                  , y : Float
                  , dx : Float
                  , dy : Float
                  , radius : Float
                  }

makeBall : Float -> Float -> Ball
makeBall x y = { x = x
               , y = y
               , dx = 2.0
               , dy = 2.0
               , radius = 10.0}

type alias Model = { balls : List Ball
                   , screenWidth : Float
                   , screenHeight : Float
                   }

init : () -> (Model, Cmd Msg)
init _ = ({ balls = [ makeBall 60.0 60.0
                  , makeBall 160.0 160.0]
        , screenWidth = 400
        , screenHeight = 300
        }, Cmd.none)

-- UPDATE

type Msg = Tick Posix

moveBall : Ball -> Ball
moveBall ball = { ball | x = ball.x + ball.dx
                       , y = ball.y + ball.dy }

bounceBall : (Float, Float) -> Ball -> Ball
bounceBall (screenWidth, screenHeight) ball =
    { ball | dx = if ball.x - ball.radius <= 0 || ball.x + ball.radius >= screenWidth
                  then -ball.dx
                  else ball.dx
           , dy = if ball.y - ball.radius <= 0 || ball.y + ball.radius >= screenHeight
                  then -ball.dy
                  else ball.dy }

update : Msg -> Model -> (Model, Cmd Msg)
update _ model =
    ({model | balls = List.map (moveBall >> bounceBall (model.screenWidth, model.screenHeight)) model.balls }, Cmd.none)

-- SUBSCRIPTIONS

millisecond : Float
millisecond = 1 / 1000

subscriptions : Model -> Sub Msg
subscriptions model = Time.every (33 * millisecond) Tick

-- VIEW

viewBall : Ball -> Svg Msg
viewBall ball =
    circle [ cx (String.fromFloat ball.x)
           , cy (String.fromFloat ball.y)
           , r (String.fromFloat ball.radius), Svg.Attributes.style "fill:red" ]
           []

view : Model -> Html Msg
view model =
    svg [ width (String.fromFloat model.screenWidth), height (String.fromFloat model.screenHeight)]
        (List.map viewBall model.balls)
