{-# LANGUAGE OverloadedStrings #-}
 {-# DeriveGeneric #-}
module Main (main) where

import Lib
import Data.Aeson
import Data.Text as T
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString.Lazy as L
import qualified Data.ByteString.Lazy.Char8 as LC
import Network.HTTP.Simple
import GHC.Generics


myToken :: BC.ByteString
myToken = "<VwwnZcBBxuCunRHpXQtdDgLUGzjhNjQw>"

noaaHost :: BC.ByteString
noaaHost = "https://www.ncei.noaa.gov/cdo-web"

apiPath :: BC.ByteString
apiPath = "/cdo-web/api/v2/datasets"

buildRequest :: BC.ByteString -> BC.ByteString
                -> BC.ByteString -> BC.ByteString
                -> Request
buildRequest host token method path =
        setRequestMethod method
    $ setRequestHost host
    $ setRequestHeader "token" [token]
    $ setRequestPath path
    $ setRequestSecure True
    $ setRequestPort 443
    $ defaultRequest
request :: Request
request = buildRequest myToken noaaHost "GET" apiPath

main :: IO ()
main = do
    response <- httpLBS request
    let status = getResponseStatusCode response
    if status == 200
        then do
            putStrLn "Результаты запроса были сохранены в файл"
            let jsonBody = getResponseBody response
            L.writeFile "data.json" jsonBody
        else
            putStrLn "Запрос не удалось совершить из-за ошибки"


-- 565 страница