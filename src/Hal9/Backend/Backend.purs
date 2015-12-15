module Hal9.Backend (main) where

import Control.Apply ((*>))
import Control.Monad.Eff (Eff())
import Data.Generic (Generic)
import Hal9.Common
import Prelude
import qualified Node.HTTP as Node
import REST.Endpoint
import REST.Server (serve)

data User = User { name :: String, age :: Int }
derive instance genericUser :: Generic User

defaultUser :: User
defaultUser =
  User
  { name: "Dan"
  , age: 29
  }

home :: forall e eff. (Endpoint e) => e (Eff (http :: Node.HTTP | eff) Unit)
home = worker <$> (get *> response)
  where
  worker res = sendResponse res 200 "text/plain" "Hello, world!"

userById :: forall e eff. (Endpoint e) => e (Eff (http :: Node.HTTP | eff) Unit)
userById = worker <$> (get *> lit "users" *> match "id" "User identifier") <*> response
  where
  worker userId res = sendResponse res 200 "text/plain" (toJSONGeneric userId)

endpoints :: forall e eff. (Endpoint e) => Array (e (Eff (http :: Node.HTTP | eff) Unit))
endpoints = [ home, userById ]

main :: forall e. Eff (http :: Node.HTTP | e) Unit
main = do
  serve endpoints 8080 do return unit
