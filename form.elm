import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String
import Regex


main =
  Html.beginnerProgram { model = model , view = view , update = update }


-- MODEL

type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  , age : Int
  , validationError : String
  }

model : Model
model =
  Model "" "" "" 0 ""

-- UPDATE

type Msg
  = Name String
  | Password String
  | PasswordAgain String
  | Age String
  | Validate


update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

    Age age ->
      { model | age = Result.withDefault 0 (String.toInt age) }

    Validate ->
      if String.isEmpty model.name == True then
        { model | validationError = "Name required" }
      else if Regex.contains (Regex.regex "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$") model.password /= True then
        { model | validationError = "Password should be longer than 8 characters, contain 1 upper case symbol, 1 lower case symbol and number" }
      else if model.password /= model.passwordAgain then
        { model | validationError = "Passwords do not match!" }
      else
        { model | validationError = "OK" }

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
    , label [ for "age" ] [ text "Age" ]
    , input [ type' "number", id "age", onInput Age ] []
    , br [] []
    , button [ onClick Validate ] [ text "Submit" ]
    , viewValidation model
    ]

viewValidation : Model -> Html Msg
viewValidation model =
  let
    color =
      if model.validationError == "OK" then
        "green"
      else
        "red"

  in
    div [ style [("color", color)] ] [ text model.validationError ]
