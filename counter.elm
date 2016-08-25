module Counter exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import String exposing (..)

-- MODEL

type alias Model =
  { counter : Int
  , maximum : Int
  , minimum : Int
  , incrementClicks : Int
  , decrementClicks : Int
  }

init : Int -> Model
init count =
  Model count 0 0 0 0


-- UPDATE

type Msg
  = Increment
  | Decrement


update : Msg -> Model -> Model
update msg ({counter, maximum, minimum, incrementClicks, decrementClicks} as model) =
  case msg of
    Increment ->
      { model
        | counter = counter + 1
        , maximum = (if maximum < counter + 1 then counter + 1 else maximum)
        , minimum = minimum
        , incrementClicks = incrementClicks + 1
        , decrementClicks = decrementClicks
      }

    Decrement ->
      { model
        | counter = counter - 1
        , maximum = maximum
        , minimum = (if minimum > counter - 1 then counter - 1 else minimum)
        , incrementClicks = incrementClicks
        , decrementClicks = decrementClicks + 1
      }


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Increment ] [ text "+" ]
    , div [ countStyle ] [ text (toString model.counter) ]
    , button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (append "Maximum: " (toString model.maximum)) ]
    , div [] [ text (append "Minimum: " (toString model.minimum)) ]
    , div [] [ text (append "+ clicks: " (toString model.incrementClicks)) ]
    , div [] [ text (append "- clicks: " (toString model.decrementClicks)) ]
    , hr [] []
    ]


countStyle : Attribute msg
countStyle =
  style
  [ ("font-size", "20px")
  , ("font-family", "monospace")
  , ("display", "inline-block")
  , ("width", "50px")
  , ("text-align", "center")
  ]
