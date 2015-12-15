module Hal9.Common.Endpoints where

import Control.Apply ((*>))
import Data.Tuple
import Prelude
import REST.Endpoint

users :: forall e. (Endpoint e) => e Unit
users = get *> lit "users"

userById :: forall e. (Endpoint e) => e String
userById = get *> lit "users" *> match "userId" "User identifier"

userCharById :: forall e. (Endpoint e) => e (Tuple String String)
userCharById = Tuple
    <$> (lit "users" *> match "userId" "User identifier")
    <*> (lit "chars" *> match "charId" "Character identifier")
