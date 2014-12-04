{-# LANGUAGE OverloadedStrings, NoImplicitPrelude #-}
module Stackage2.PackageIndexSpec (spec) where

import Stackage2.PackageIndex
import Stackage2.Prelude
import Test.Hspec
import Distribution.Package (packageId, pkgVersion)

spec :: Spec
spec = do
    it "works" $ (runResourceT $ sourcePackageIndex $$ sinkNull :: IO ())
    it "getLatestDescriptions gives reasonable results" $ do
        let f x y = (display x, display y) `member` asSet (setFromList
                [ (asText "base", asText "4.5.0.0")
                , ("does-not-exist", "9999999999999999999")
                ])
        m <- getLatestDescriptions f return
        length m `shouldBe` 1
        p <- simpleParse $ asText "base"
        v <- simpleParse $ asText "4.5.0.0"
        (pkgVersion . packageId <$> m) `shouldBe` singletonMap p v
