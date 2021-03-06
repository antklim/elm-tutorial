import Html exposing (..)
import Html.App as CounterApp
import Html.Events exposing (onClick)

import Counter

main =
  CounterApp.beginnerProgram
    { model = init 0 0
    , view = view
    , update = update
    }


-- MODEL

type alias Model =
  { topCounter : Counter.Model
  , bottomCounter : Counter.Model
  }

init : Int -> Int -> Model
init top bottom =
  { topCounter = Counter.init top
  , bottomCounter = Counter.init bottom
  }


-- UPDATE

type Msg
  = Reset
  | Swap
  | Top Counter.Msg
  | Bottom Counter.Msg


update : Msg -> Model -> Model
update msg model =
  case msg of
    Reset ->
      init 0 0

    Swap ->
      { model
        | topCounter = model.bottomCounter
        , bottomCounter = model.topCounter
      }

    Top msg ->
      { model | topCounter = Counter.update msg model.topCounter }

    Bottom msg ->
      { model | bottomCounter = Counter.update msg model.bottomCounter }


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ CounterApp.map Top (Counter.view model.topCounter)
    , CounterApp.map Bottom (Counter.view model.bottomCounter)
    , button [ onClick Reset ] [ text "Reset" ]
    , button [ onClick Swap ] [ text "Swap" ]
    ]
