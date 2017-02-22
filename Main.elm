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
                   , screenWidth : Int
                   , screenHeight : Int
                   }

init : (Model, Cmd Msg)
init = ({ x = 60.0
        , y = 60.0
        , screenWidth = 800
        , screenHeight = 600
        }, Cmd.none)

-- UPDATE

type Msg = Tick Time

update : Msg -> Model -> (Model, Cmd Msg)
update _ model =
    let velocity = 1.0
    in 
    ({ model | x = model.x + velocity, y = model.y + velocity}, Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model = Time.every (33 * millisecond) Tick

-- VIEW

view : Model -> Html Msg
view model =
    svg [ width (toString model.screenWidth), height (toString model.screenHeight)]
        [ circle [ cx (toString model.x)
                 , cy (toString model.y)
                 , r "50", Svg.Attributes.style "fill:red" ]
              []]
