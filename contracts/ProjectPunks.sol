//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Base64.sol";
import "./PunksDNA.sol";

contract ProjectPunks is ERC721, ERC721Enumerable, PunksDNA {
    using Counters for Counters.Counter;

    // vars
    Counters.Counter private _idCounter; // Contador utilizando libreria de openzeppelin.
    uint256 public maxSupply; // Para limitar el numero de nfts que puedo crear.
    mapping(uint256 => uint256) public tokenDNA;

    // constructor
    constructor(uint256 _maxSupply) ERC721("ProjectPunks", "PPKS") {
        // mi maxSupply va a tener el valor del que se ejecute desde el constructor.
        maxSupply = _maxSupply;
    }

    // functions
    // Funcion para mintear los tokens (ERC721)
    function mint() public {
        uint256 current = _idCounter.current();
        require(current < maxSupply, "Sorry, no Punks left :("); // Agrego validacion para que no se supere el max de nfts.
        tokenDNA[current] = deterministicPseudoRandomDNA(current, msg.sender); // generamos un numero seudo-aleatorio que depende del ruido entre la combinacion del tokenid y la direccion.
        _safeMint((msg.sender), current); // Genera el token y se lo asigna a la direccion (funcion del ERC721).
        _idCounter.increment(); // Incremento el current.
    }

    // Funcion retorna lugar o dominio del NFT (ERC721)
    function _baseURI() internal pure override returns (string memory) {
        return "https://avataaars.io/";
    }

    // Funcion para contruir los parametros extra a la url.
    function _paramsURI(uint256 _dna) internal view returns (string memory) {
        string memory params;
        // creamos un bloque para no excedernos en memoria (el compilador hace reseva de memoria en cada bloque)
        {
            params = string(
                abi.encodePacked(
                    "accessoriesType=",
                    getAccesoriesType(_dna),
                    "&clotheColor=",
                    getClotheColor(_dna),
                    "&clotheType=",
                    getClotheType(_dna),
                    "&eyeType=",
                    getEyeType(_dna),
                    "&eyebrowType=",
                    getEyeBrowType(_dna),
                    "&facialHairColor=",
                    getFacialHairColor(_dna),
                    "&facialHairType=",
                    getFacialHairType(_dna),
                    "&hairColor=",
                    getHairColor(_dna),
                    "&hatColor=",
                    getHatColor(_dna),
                    "&graphicType=",
                    getGraphicType(_dna),
                    "&mouthType=",
                    getMouthType(_dna),
                    "&skinColor=",
                    getSkinColor(_dna)
                )
            );
        }
        // quitamos topType del bloque de params y lo concatenamos en el return (para evitar sobrepasar el limite de memoria del compilador para el bloque).
        return string(abi.encodePacked(params, "&topType=", getTopType(_dna)));
    }

    // Funcion que nos permite obtener la preview de la imagen.
    function imageByDNA(uint256 _dna) public view returns (string memory) {
        string memory baseURI = _baseURI();
        string memory paramsURI = _paramsURI(_dna);
        return string(abi.encodePacked(baseURI, "?", paramsURI));
    }

    // Funcion que genera una JSON con la Metadata como Base64.
    // La funcion debe ser de tipo 'view' para que los usuarios no deban tener que pagar gas para utilizarla. Ya que no es necesario ninguna mutacion de estado en la blockchain.
    // La funcion debe ser de tipo 'override' ya la estamos modificando dentro de la cadena de herencias.
    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(tokenId), // funcion del ERC721
            "ERC721 Metadata: URI query for nonexistent token."
        );
        uint256 dna = tokenDNA[tokenId];
        string memory image = imageByDNA(dna);
        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                "{",
                '"name": "ProjectPunks #"',
                tokenId,
                '"',
                ",",
                '"description": "Project Punks NFTs generator"',
                ",",
                '"image":',
                image,
                ","
                '"}"'
            ) // abi.encodePacked() es una funcionalidad de solidity para concatenar strings.
        );
        return
            string(abi.encodePacked("data:application/json;base64,", jsonURI));
    }

    // This function is overrides required by Solidity.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // This function is overrides required by Solidity.
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
