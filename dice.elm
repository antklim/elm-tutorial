import Html exposing (..)
import Html.App as App
import Html.Events exposing (onClick)
import Random exposing (..)


main =
  App.program
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


-- MODEL

type alias Model =
  { diceFace : Int
  }

init : (Model, Cmd Msg)
init =
  (Model 1, Cmd.none)


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text (toString model.diceFace) ]
    , button [ onClick Roll ] [ text "Roll" ]
    ]


-- UPDATE

type Msg
  = Roll
  | NewFace Int

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate NewFace (Random.int 1 6))

    NewFace newFace ->
      (Model newFace, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
