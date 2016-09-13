import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode as Json
import Task


main =
  App.program
    { init = init "cats"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { topic : String
  , gifUrl : String
  , error : String
  }

init : String -> (Model, Cmd Msg)
init topic =
  ( Model topic "waiting.gif" ""
  , getRandomGif topic
  )


-- UPDATE

type Msg
  = MorePlease
  | FetchSuccess String
  | FetchFail Http.Error
  | NewTopic String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      ({ model | error = "" }, getRandomGif model.topic)

    FetchSuccess newUrl ->
      (Model model.topic newUrl "", Cmd.none)

    FetchFail error ->
      let errorMessage =
        case error of
          Timeout -> "Timeout error"
          NetworkError -> "Network error"
          UnexpectedPayload _ -> "Unexpected payload"
          _ -> "Bad response"

      in ({ model | error = errorMessage }, Cmd.none)

    NewTopic newTopic ->
      ({ model | topic = newTopic }, Cmd.none)

getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic

  in
    Task.perform FetchFail FetchSuccess (Http.get decodeGifUrl url)

decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at [ "data", "image_url" ] Json.string

topicChangeDecoder : Json.Decoder String
topicChangeDecoder =
  Json.at [ "target", "value" ] Json.string


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ label [ for "topic" ] [ text "Topic" ]
    , input [ type' "text", id "topic", placeholder "Topic", onInput NewTopic, value model.topic ] []
    , label [ for "topics" ] [ text "Topics" ]
    , select [ id "topics", on "change" (Json.map NewTopic topicChangeDecoder) ]
      [ option [ value "cats", selected True ] [ text "Cats" ]
      ,  option [ value "dogs", selected False ] [ text "Dogs" ]
      ]
    , br [] []
    , button [ onClick MorePlease ] [ text "More Please!" ]
    , br [] []
    , img [ src model.gifUrl ] []
    , br [] []
    , span [] [ text model.error ]
    ]
