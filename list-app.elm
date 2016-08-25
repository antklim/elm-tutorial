import Html exposing (..)
import Html.App as CounterListApp
import Html.Events exposing (onClick)

import Counter


main =
  CounterListApp.beginnerProgram
    { model = init
    , view = view
    , update = update
    }


-- MODEL

type alias Model =
  { counters : List IndexedCounter
  , uid : Int
  }

type alias IndexedCounter =
  { id : Int
  , counter: Counter.Model
  }

init : Model
init =
  { counters = []
  , uid = 0
  }

-- UPDATE

type Msg
  = Insert
  | Remove
  | Modify Int Counter.Msg

update : Msg -> Model -> Model
update msg ({counters, uid} as model) =
  case msg of
    Insert ->
      { model
        | counters = counters ++ [ IndexedCounter uid (Counter.init 0) ]
        , uid = uid + 1
      }

    Remove ->
      { model | counters = List.drop 1 counters }

    Modify id msg ->
      { model | counters = List.map (updateHelper id msg) counters }


updateHelper : Int -> Counter.Msg -> IndexedCounter -> IndexedCounter
updateHelper targetId msg { id, counter } =
  IndexedCounter id (if targetId == id then Counter.update msg counter else counter)

-- VIEW

view : Model -> Html Msg
view model =
  let
    remove =
      button [ onClick Remove ] [ text "Remove" ]

    insert =
      button [ onClick Insert ] [ text "Add" ]

    counters =
      List.map viewIndexedCounter model.counters

  in
    div [] ([remove, insert] ++ counters)

viewIndexedCounter : IndexedCounter -> Html Msg
viewIndexedCounter {id, counter} =
  CounterListApp.map (Modify id) (Counter.view counter)
