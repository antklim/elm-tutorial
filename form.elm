import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main =
  Html.beginnerProgram { model = model , view = view , update = update }


-- MODEL

type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  }

model : Model
model =
  Model "" "" ""

-- UPDATE

type Msg
  = Name String
  | Password String
  | PasswordAgain String


update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ label [ for "name" ] [ text "Name" ]
    , input [ type' "text", id "name", placeholder "Name", onInput Name ] []
    , br [] []
    , label [ for "password" ] [ text "Password" ]
    , input [ type' "password", id "password", placeholder "Password", onInput Password ] []
    , br [] []
    , label [ for "passwordAgain" ] [ text "Repeat Password" ]
    , input [ type' "password", id "passwordAgain", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , br [] []
    , viewValidation model
    ]

viewValidation : Model -> Html Msg
viewValidation model =
  let
    (color, message) =
      if model.password == model.passwordAgain then
        ("green", "OK")
      else
        ("red", "Passwords do not match!")

  in
    div [ style [("color", color)] ] [ text message ]
