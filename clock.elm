import Html exposing (Html, div, button, text, br)
import Html.App as ClockApp
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)


main =
  ClockApp.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }


-- MODEL

type alias Model =
  { time : Time
  , isPause : Bool
  }

init : (Model, Cmd Msg)
init =
  (Model 0 False, Cmd.none)


-- UPDATE

type Msg
  = Tick Time
  | Toggle

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ( { model | time = newTime }, Cmd.none)

    Toggle ->
      ( { model | isPause = not model.isPause }, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  if model.isPause then Sub.none else Time.every second Tick


-- VIEW

hourPosition : Int -> (Float, Float)
hourPosition hr =
  let
    twelve = -pi / 2
    step = pi / 6
    angle = twelve + step * toFloat hr

  in
    (46 + 40 * cos angle, 53 + 40 * sin angle)

hoursToText : Int -> Html Msg
hoursToText hr =
  let
    (xPos, yPos) = hourPosition hr

  in
    text' [ x (toString xPos), y (toString yPos), fontSize "9" ] [ Svg.text (toString hr) ]

viewClock : Model -> Html Msg
viewClock model =
  let
    sAngle = negate (degrees (90 - 6 * Time.inSeconds model.time))
    sHandX = toString (50 + 40 * cos sAngle)
    sHandY = toString (50 + 40 * sin sAngle)

    mAngle = negate (degrees (90 - 6 * Time.inSeconds (model.time / 60)))
    mHandX = toString (50 + 40 * cos mAngle)
    mHandY = toString (50 + 40 * sin mAngle)

    hAngle = negate (degrees (90 - 6 * Time.inSeconds (model.time / 720))) - pi / 3
    hHandX = toString (50 + 40 * cos hAngle)
    hHandY = toString (50 + 40 * sin hAngle)

    secondsHand =
      line [ x1 "50", y1 "50", x2 sHandX, y2 sHandY, stroke "yellow" ] []

    minutesHand =
      line [ x1 "50", y1 "50", x2 mHandX, y2 mHandY, stroke "#023963" ] []

    hoursHand =
      line [ x1 "50", y1 "50", x2 hHandX, y2 hHandY, stroke "red" ] []

    clock =
      [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
      , secondsHand
      , minutesHand
      , hoursHand
      ]

    hours = List.map hoursToText [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]

  in
    svg [ viewBox "0 0 100 100", width "300px" ]
      (clock ++ hours)

view : Model -> Html Msg
view model =
  let
    btnText = if model.isPause then "Start" else "Pause"

  in
    div [] [
      button [ onClick Toggle ] [ Html.text btnText ]
      , br [] []
      , viewClock model
    ]
