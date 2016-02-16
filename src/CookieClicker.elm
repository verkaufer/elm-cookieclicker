module CookieClicker where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Signal exposing (Signal, Address, map)
import String
import Time exposing (second, every)
import Effects exposing (..)
import Number.Format exposing (..)

---- MODEL

{- Simple model to track our clicks, the level, exp needed to advance 1 level, 
   and the click multiplier value -}
type alias Game =
    { clicks : Float -- aka Cookies
    , level : Int
    , level_total_exp : Int -- Experience needed to level up
    , cps_multiplier : Float -- Each click gets a slight boost after each level up
    } 

{- Let's setup the game! -}
initGame : Game
initGame = 
    { clicks = 0
    , level = 1
    , level_total_exp = 100
    , cps_multiplier = 1.0
    }

---- UPDATE

{- TimeTick action exists so users have to actually interact with the game to level up ;) -}
type Action = Increment | TimeTick

ticker : Signal Action
ticker = Signal.map (always TimeTick) (Time.every Time.second)

update : Action -> Game -> (Game, Effects.Effects Action)
update action game =
    case action of
        Increment -> let 
                        clicks' = game.clicks + (1 * game.cps_multiplier)
                        level' = 
                            if floor(game.clicks) >= game.level_total_exp then
                                game.level + 1
                            else
                                game.level
                        total_xp = 
                            if level' > game.level then
                                {- Gets ridiculous in later levels. Find another formula to set exp needed to level up -}
                                game.level_total_exp + ((level' ^ 2) * 100)
                            else
                                game.level_total_exp
                        cps_multiplier' = 
                            if level' > game.level then
                                level' * (level' ^ 0.1)
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

---- VIEW

{- HTML component that renders the progress bar by 
   dividing the number of clicks by the exp needed for the next level -}
progressBar : Game -> Html
progressBar game =
    div [class "progress-bar", style[("width", toString ( (game.clicks / toFloat game.level_total_exp)*100 ) ++ "%")]]
        [p []
            [ text (toString (round game.clicks) ++ "/" ++ toString (game.level_total_exp))]
        ]

{- Base view function -}
view : Signal.Address Action -> Game -> Html
view address game = 
    div [ class "row" ] 
    [ div [class "one-half column cookie-column"] 
        [ h4 [] [text "Click on the cookie!"]
        , img [class "cookie", src "assets/cookie.jpeg", onClick address Increment] []
        , h3 [] [text (toString(round game.clicks) ++ " Clicks")]
        ]
    , div [class "one-half column"]
        [ div [] [text ("Level: " ++ toString game.level)]
        , div [] [text ("Cookies to Next Level: " ++ toString game.level_total_exp)]
        , div [] [text ("Cookie Multiplier: " ++ pretty 2 ',' ( game.cps_multiplier - 1))]
        , div [class "level-progress"] [ text "Level Progress"
                                       , div [class "progress-graph"] [ progressBar game ]
                                       ]
        
        ]
    ]