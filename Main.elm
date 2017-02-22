import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, millisecond)

main = Html.program { init = init
                    , view = view
                    , update = update
                    , subscriptions = subscriptions
                    }

-- MODEL

type alias Model = { x : Float
                   , y : Float
                   , dx : Float
                   , dy : Float
                   , radius : Float
                   , screenWidth : Float
                   , screenHeight : Float
                   }

init : (Model, Cmd Msg)
init = ({ x = 60.0
        , y = 60.0
        , dx = 2.0
        , dy = 2.0
        , radius = 10.0
        , screenWidth = 400
        , screenHeight = 300
        }, Cmd.none)

-- UPDATE

type Msg = Tick Time

moveBall : Model -> Model
moveBall model = { model | x = model.x + model.dx
                         , y = model.y + model.dy }

bounceBall : Model -> Model
bounceBall model = { model | dx = if model.x - model.radius <= 0 || model.x + model.radius >= model.screenWidth
                                  then -model.dx
                                  else model.dx
                           , dy = if model.y - model.radius <= 0 || model.y + model.radius >= model.screenHeight
                                  then -model.dy
                                  else model.dy }

update : Msg -> Model -> (Model, Cmd Msg)
update _ model =
    (model |> moveBall |> bounceBall, Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model = Time.every (33 * millisecond) Tick

-- VIEW

view : Model -> Html Msg
view model =
    svg [ width (toString model.screenWidth), height (toString model.screenHeight)]
        [ circle [ cx (toString model.x)
                 , cy (toString model.y)
                 , r (toString model.radius), Svg.Attributes.style "fill:red" ]
              []]
