module CookieClicker where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Signal exposing (Signal, Address, map)
import String
import Time exposing (second, every)
import Effects exposing (..)
-- Model

type State = Play | Pause

type alias Game =
    { clicks : Int -- aka Cookies Clicked
    , level : Int
    , cps_multiplier : Float
    } 

initGame : Game
initGame = 
    { clicks = 0
    , level = 1
    , cps_multiplier = 1.7
    }

-- Update

type Action = Increment

ticker : Signal Action
ticker = Signal.map (always Increment) (Time.every Time.second)

update : Action -> Game -> (Game, Effects.Effects Action)
update action game =
    case action of
        Increment -> ( {game | clicks = game.clicks + round (1 * game.cps_multiplier)}, Effects.none )
        -- TODO: Consider changing `round` to floor or ceiling

-- View

view : Signal.Address Action -> Game -> Html
view address game = 

    div []
        [ img [ src "assets/cookie.jpeg", onClick address Increment ] []
        , div [] [text (toString game.clicks)]
        ]
