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
  , validationErrors : List String
  }

model : Model
model =
  Model "" "" "" 0 []


type alias ValidationRule =
  { predicate : Bool
  , errorMessage : String
  }

validateModel : Model -> List String
validateModel model =
  let
    passwordRegex =
      Regex.regex "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]+$"

    valdationRules =
      [ ValidationRule
          (String.isEmpty model.name == True)
          "Name required"
      , ValidationRule
          (String.length model.password < 8)
          "Password too short"
      , ValidationRule
          (Regex.contains (passwordRegex) model.password /= True)
          "Password should contain upper and lower case symbols and number"
      , ValidationRule
          (model.password /= model.passwordAgain)
          "Passwords do not match"
      ]

    validationsErrorMessages =
      valdationRules
        |> List.filter .predicate
        |> List.map .errorMessage

  in
    validationsErrorMessages


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
      { model | validationErrors = validateModel model }


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ label [ for "name" ] [ text "Name" ]
    , input [ type' "text", id "name", placeholder "Name", onInput Name ] []
    , br [] []
    , label [ for "password" ] [ text "Password" ]
    , input
      [ type' "password"
      , id "password"
      , placeholder "Password"
      , onInput Password
      ] []
    , br [] []
    , label [ for "passwordAgain" ] [ text "Repeat Password" ]
    , input
      [ type' "password"
      , id "passwordAgain"
      , placeholder "Re-enter Password"
      , onInput PasswordAgain
      ] []
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
    errorListItems =
      List.map
        (\errorMessage -> li [ style [("color", "red")] ] [ text errorMessage ])
        model.validationErrors

  in
    ul [] errorListItems
