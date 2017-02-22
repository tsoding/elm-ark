import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, millisecond)
import List exposing (map)

main = Html.program { init = init
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

init : (Model, Cmd Msg)
init = ({ balls = [ makeBall 60.0 60.0
                  , makeBall 160.0 160.0]
        , screenWidth = 400
        , screenHeight = 300
        }, Cmd.none)

-- UPDATE

type Msg = Tick Time

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

subscriptions : Model -> Sub Msg
subscriptions model = Time.every (33 * millisecond) Tick

-- VIEW

viewBall : Ball -> Svg Msg
viewBall ball =
    circle [ cx (toString ball.x)
           , cy (toString ball.y)
           , r (toString ball.radius), Svg.Attributes.style "fill:red" ]
           []

view : Model -> Html Msg
view model =
    svg [ width (toString model.screenWidth), height (toString model.screenHeight)]
        (List.map viewBall model.balls)
