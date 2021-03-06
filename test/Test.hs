import Data.MediaWiki.Markup
import Test.Tasty hiding (defaultMain)
import Test.Tasty.Silver
import Test.Tasty.Silver.Interactive
import System.FilePath
import Text.Show.Pretty
import qualified Data.Text as T

main :: IO ()
main = do
    files <- findByExtension [".wiki"] "test/tests"
    defaultMain $ testGroup "Golden" $ map fileTest files

fileTest :: FilePath -> TestTree
fileTest path = goldenVsAction testName golden (parseIt <$> readFile path) T.pack
  where
    testName = takeBaseName path
    golden = replaceExtension path "ast"
    parseIt = either ("fail: "++) ppShow . parse
