module Hal9.Common (readGeneric, toForeignGeneric) where

import Data.Either (Either(..))
import Data.Foreign (Foreign())
import Data.Generic (Generic)
import Data.Maybe.Unsafe (unsafeThrow)
import Prelude
import qualified Data.Foreign.Generic as FG

readGeneric :: forall a. (Generic a) => Foreign -> a
readGeneric = FG.readGeneric FG.defaultOptions >>> fromRight

toForeignGeneric :: forall a. (Generic a) => a -> Foreign
toForeignGeneric = FG.toForeignGeneric FG.defaultOptions

fromRight :: forall a b. Either a b -> b
fromRight (Left _) = unsafeThrow "fromRight called on Left"
fromRight (Right x) = x
