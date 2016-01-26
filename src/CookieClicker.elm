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
    { clicks : Float -- aka Cookies Clicked
    , level : Int
    , level_total_exp : Int
    , cps_multiplier : Float
    } 

initGame : Game
initGame = 
    { clicks = 0
    , level = 1
    , level_total_exp = 100
    , cps_multiplier = 1.0
    }

-- Update

type Action = Increment | TimeTick

ticker : Signal Action
ticker = Signal.map (always TimeTick) (Time.every Time.second)

update : Action -> Game -> (Game, Effects.Effects Action)
update action game =
    case action of
        Increment -> let 
                        clicks' = game.clicks + (1 * game.cps_multiplier)
                        level' = 
                            if round(game.clicks) >= game.level_total_exp then
                                game.level + 1
                            else
                                game.level
                        total_xp = 
                            if level' > game.level then
                                game.level_total_exp + ((level' ^ 2) * 100)
                            else
                                game.level_total_exp
                        cps_multiplier' = 
                            if level' > game.level then
                                --level' ^ 1.1
                                level' * (level' ^ 0.1) -- the 0 will eventually be modified by purchased items
                            else
                                game.cps_multiplier
                    in
                    ( { game | clicks = clicks'
                             , level = level'  
                             , level_total_exp = total_xp
                             , cps_multiplier = cps_multiplier'
                      }, 
                    Effects.none )
        TimeTick  -> 
                    ( {game | clicks = game.clicks + (1 * game.cps_multiplier)}, Effects.none )
        -- TODO: Consider changing `round` to floor or ceiling

-- View

view : Signal.Address Action -> Game -> Html
view address game = 
    div []
        [ img [ src "assets/cookie.jpeg", onClick address Increment ] []
        , div [] [text ("Clicks: " ++toString (round game.clicks))]
        , div [] [text ("Level: " ++ toString game.level)]
        , div [] [text ("Level EXP: " ++ toString game.level_total_exp)]
        , div [] [text ("CPS: " ++ toString (game.cps_multiplier - 1))]
        ]
