module Hal9.Backend (main) where

import Control.Apply ((*>))
import Control.Monad.Eff (Eff())
import Data.Generic (Generic)
import Hal9.Common
import qualified Hal9.Common.Endpoints as E
import Prelude
import qualified Node.HTTP as Node
import REST.Endpoint
import REST.Server (serve)
import Data.Tuple

data User = User { name :: String, age :: Int }
derive instance genericUser :: Generic User

defaultUser :: User
defaultUser =
  User
  { name: "Dan"
  , age: 29
  }

type EndpointImpl = forall e eff. (Endpoint e) => e (Eff (http :: Node.HTTP | eff) Unit)

home :: EndpointImpl
home = worker <$> (get *> response)
  where
  worker res = sendResponse res 200 "text/plain" "Hello, world!"

users :: EndpointImpl
users = worker <$> E.users <*> response
  where
  worker x res = sendResponse res 200 "application/json" (toJSONGeneric [1, 2, 3])

userById :: EndpointImpl
userById = worker <$> E.userById <*> response
  where
  worker userId res = sendResponse res 200 "application/json" (toJSONGeneric userId)

userCharById :: EndpointImpl
userCharById = worker <$> E.userCharById <*> response
  where
  worker (Tuple userId charId) res = sendResponse res 200 "application/json" (toJSONGeneric [userId, charId])

endpoints :: forall e eff. (Endpoint e) => Array (e (Eff (http :: Node.HTTP | eff) Unit))
endpoints = [ home, users, userById, userCharById ]

main :: forall e. Eff (http :: Node.HTTP | e) Unit
main = do
  serve endpoints 8080 do return unit
