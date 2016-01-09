module CookieClicker where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Signal exposing (Signal, Address)
import String

-- Model

type State = Play | Pause

type alias Game =
    { points : Int -- aka Cookies Clicked
    , level : Int
    } 

type alias Award = 
    { id : Int
    , title : String
    }

initGame : Game
initGame = 
    { points = 0
    , level = 1
    }

-- Update

type Action = Increment

clickCookie action game =
    case action of
        Increment -> { game | points = game.points + 1 }

-- View

view : Signal.Address Action -> Game -> Html
view address game = 

    div []
        [ img [ src "assets/cookie.jpeg", onClick address Increment ] []
        , div [] [text (toString game.points)]
        ]
