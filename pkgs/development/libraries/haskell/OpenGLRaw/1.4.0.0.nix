# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, mesa }:

cabal.mkDerivation (self: {
  pname = "OpenGLRaw";
  version = "1.4.0.0";
  sha256 = "112xaz01950pyjaw3cv9yvw4w3gqbf79idyyh05ain7x29m7bxkh";
  extraLibraries = [ mesa ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Opengl";
    description = "A raw binding for the OpenGL graphics system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
