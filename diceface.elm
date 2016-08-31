module DiceFace exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)


-- MODEL

type alias Model =
  { diceFace : Int
  }

init : Int -> Model
init diceFace =
  Model diceFace


-- UPDATE

type Msg
  = UpdateFace Int

update : Msg -> Model -> Model
update msg model =
  case msg of
    UpdateFace newFace ->
      { model | diceFace = newFace }


-- VIEW

view : Model -> Html Msg
view model =
  Svg.svg [ viewBox "0 0 60 60", width "300", height "300" ]
    (viewDots model.diceFace)

viewDots : Int -> List (Svg Msg)
viewDots dots =
  let
    rects =
      [ rect [ x "10", y "10", width "20", height "20", fill "#0B79CE" ] [] ]

    circles =
      case dots of
        1 ->
          [ circle [ cx "20", cy "20", r "1", fill "#FFFF33" ] [] ]

        2 ->
          [ circle [ cx "15", cy "15", r "1", fill "#FFFF33" ] []
          , circle [ cx "25", cy "25", r "1", fill "#FFFF33" ] []
          ]

        3 ->
          [ circle [ cx "25", cy "15", r "1", fill "#FFFF33" ] []
          , circle [ cx "20", cy "20", r "1", fill "#FFFF33" ] []
          , circle [ cx "15", cy "25", r "1", fill "#FFFF33" ] []
          ]

        4 ->
          [ circle [ cx "15", cy "15", r "1", fill "#FFFF33" ] []
          , circle [ cx "25", cy "15", r "1", fill "#FFFF33" ] []
          , circle [ cx "15", cy "25", r "1", fill "#FFFF33" ] []
          , circle [ cx "25", cy "25", r "1", fill "#FFFF33" ] []
          ]

        5 ->
          [ circle [ cx "15", cy "15", r "1", fill "#FFFF33" ] []
          , circle [ cx "25", cy "15", r "1", fill "#FFFF33" ] []
          , circle [ cx "20", cy "20", r "1", fill "#FFFF33" ] []
          , circle [ cx "15", cy "25", r "1", fill "#FFFF33" ] []
          , circle [ cx "25", cy "25", r "1", fill "#FFFF33" ] []
          ]

        6 ->
          [ circle [ cx "15", cy "15", r "1", fill "#FFFF33" ] []
          , circle [ cx "25", cy "15", r "1", fill "#FFFF33" ] []
          , circle [ cx "15", cy "20", r "1", fill "#FFFF33" ] []
          , circle [ cx "25", cy "20", r "1", fill "#FFFF33" ] []
          , circle [ cx "15", cy "25", r "1", fill "#FFFF33" ] []
          , circle [ cx "25", cy "25", r "1", fill "#FFFF33" ] []
          ]

        _ ->
          []
  in
    rects ++ circles
