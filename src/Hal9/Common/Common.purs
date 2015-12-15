module Hal9.Common (readJSONGeneric, toJSONGeneric) where

import Data.Either (Either(..))
import Data.Generic (Generic)
import Data.Maybe.Unsafe (unsafeThrow)
import Prelude
import qualified Data.Foreign.Generic as FG

options :: FG.Options
options = FG.defaultOptions { unwrapNewtypes = true }

readJSONGeneric :: forall a. (Generic a) => String -> a
readJSONGeneric = FG.readJSONGeneric options >>> fromRight

toJSONGeneric :: forall a. (Generic a) => a -> String
toJSONGeneric = FG.toJSONGeneric options

fromRight :: forall a b. Either a b -> b
fromRight (Left _) = unsafeThrow "fromRight called on Left"
fromRight (Right x) = x
