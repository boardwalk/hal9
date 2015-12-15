module Hal9.Frontend (main) where

import Control.Monad.Eff
import Data.Maybe.Unsafe
import Data.Nullable
import Prelude
import qualified DOM as DOM
import qualified DOM.HTML as DOM
import qualified DOM.HTML.Types as DOM
import qualified DOM.HTML.Window as DOM
import qualified DOM.Node.ParentNode as DOM
import qualified React as R
import qualified React.DOM as R
import qualified React.DOM.Props as RP
import qualified Thermite as T

data Action = Increment | Decrement

type State = { counter :: Int }

initialState :: State
initialState = { counter: 0 }

render :: forall a. T.Render State a Action
render dispatch _ state _ =
  [ R.p' [ R.text "Value: "
         , R.text $ show state.counter
         ]
  , R.p' [ R.button [ RP.onClick \_ -> dispatch Increment ]
                    [ R.text "Increment" ]
         , R.button [ RP.onClick \_ -> dispatch Decrement ]
                    [ R.text "Decrement" ]
         ]
  ]

performAction :: forall a b. T.PerformAction a State b Action
performAction Increment _ state update = update $ state { counter = state.counter + 1 }
performAction Decrement _ state update = update $ state { counter = state.counter - 1 }

spec :: forall a b. T.Spec a State b Action
spec = T.simpleSpec performAction render

main :: Eff (dom :: DOM.DOM) Unit
main = void do
  let component = T.createClass spec initialState
  document <- DOM.window >>= DOM.document
  container <- fromJust <<< toMaybe <$> DOM.querySelector "#container" (DOM.htmlDocumentToParentNode document)
  R.render (R.createFactory component {}) container
