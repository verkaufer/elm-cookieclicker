module Main where

import CookieClicker exposing (initGame, view, update, ticker)
import Html exposing (..)
import StartApp
import Effects exposing (..)

-- wire the entire application together
app = 
    StartApp.start { init = (initGame, Effects.none)
                   , update = update, 
                   , view = view, 
                   , inputs = [ticker]
                   }

main =
    app.html