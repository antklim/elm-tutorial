import Html exposing (..)
import Html.App as DiceApp
import Html.Events exposing (onClick)
import Random exposing (..)


import DiceFace

main =
  DiceApp.program
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


-- MODEL

type alias Model =
  { diceOne : DiceFace.Model
  , diceTwo : DiceFace.Model
  }

init : (Model, Cmd Msg)
init =
  ( { diceOne = DiceFace.init 1
    , diceTwo = DiceFace.init 1
    }
  , Cmd.none
  )


-- UPDATE

type Msg
  = Roll
  | NewFace (Int, Int)
  | DiceOne DiceFace.Msg
  | DiceTwo DiceFace.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model
      , Random.generate NewFace (Random.pair (Random.int 1 6) (Random.int 1 6))
      )

    NewFace (newFaceOne, newFaceTwo) ->
      ({ model
         | diceOne = DiceFace.init newFaceOne
         , diceTwo = DiceFace.init newFaceTwo
       }
      , Cmd.none)

    DiceOne msg ->
      ({ model | diceOne = DiceFace.update msg model.diceOne }, Cmd.none)

    DiceTwo msg ->
      ({ model | diceTwo = DiceFace.update msg model.diceTwo }, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ DiceApp.map DiceOne (DiceFace.view model.diceOne)
    , DiceApp.map DiceTwo (DiceFace.view model.diceTwo)
    , br [] []
    , button [ onClick Roll ] [ text "Roll" ]
    ]
