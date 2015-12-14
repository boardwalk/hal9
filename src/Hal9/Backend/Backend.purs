module Hal9.Backend (main) where

import Control.Monad.Eff
import Control.Monad.Eff.Console
import Data.Foldable
import Node.Encoding
import Node.HTTP
import Node.Stream
import Prelude
import qualified Hal9.Common as Common

foreign import stdout :: forall eff r a. Writable r eff a

main :: Eff (console :: CONSOLE, http :: HTTP) Unit
main = do
  server <- createServer respond
  listen server 8080 $ void do
    log "Listening on port 8080."
    req <- Node.HTTP.Client.requestFromURI "http://localhost:8080/" \response -> void do
      log "Response from GET /:"
      let responseStream = Node.HTTP.Client.responseAsStream response
      pipe responseStream stdout
    end (Node.HTTP.Client.requestAsStream req) (return unit)
  where
  respond req res = do
    let inputStream  = requestAsStream req
        outputStream = responseAsStream res
    log (requestMethod req <> " " <> requestURL req)
    case requestMethod req of
      "GET" -> do
        let html = foldMap (<> "\n")
              [ "<form method='POST' action='/'>"
              , "  <input name='text' type='text'>"
              , "  <input type='submit'>"
              , "</form>"
              ]
        setStatusCode res 200
        setHeader res "Content-Type" "text/html"
        writeString outputStream UTF8 html (return unit)
        end outputStream (return unit)
      "POST" -> do
        setStatusCode res 200
        void $ pipe inputStream outputStream
      _ -> do
        setStatusCode res 405
        end outputStream (return unit)
