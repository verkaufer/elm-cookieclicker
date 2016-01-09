module Main where

import CookieClicker exposing (initGame, view, clickCookie)
import Html exposing (..)
import Signal exposing (Signal, Address)
import StartApp.Simple as StartApp


-- wire the entire application together
main =
    StartApp.start { model = initGame, view = view, update = clickCookie}