# Metadata del ERC721

Es una extension al estandar ERC721 para NFT que agrega 3 funciones:

- name: nombre del token.

- symbol: simbolo con el que se identifica en el mercado.

- tokenURI: URL que debre regresar un archivo JSON con las propiedades del NFT. (El JSON debe respetar un esquema previamente definido por la fundacion de ethereum). Esta url se genera como base64 para que pueda ser almacenada dentro de la blockchain.
Lo mismo sucede con las imagenes, crear metadata es uno de los factores principales para no depender de 3ros.
Usamos **NFTs on-chain** para guardar los JSON de la metadata en el contrato inteligente. (usamos el estandar de **DATA URL**)

Viene implementado en OpenZeppelin (necesita ser extendido).
