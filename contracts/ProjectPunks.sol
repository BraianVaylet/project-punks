//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Base64.sol";

contract ProjectPunks is ERC721, ERC721Enumerable {
    using Counters for Counters.Counter;

    // vars
    Counters.Counter private _idCounter; // Contador utilizando libreria de openzeppelin.
    uint256 public maxSupply; // Para limitar el numero de nfts que puedo crear.

    // constructor
    constructor(uint256 _maxSupply) ERC721("ProjectPunks", "PPKS") {
        // mi maxSupply va a tener el valor del que se ejecute desde el constructor.
        maxSupply = _maxSupply;
    }

    // functions
    // Funcion para mintear los tokens
    function mint() public {
        uint256 current = _idCounter.current();
        require(current < maxSupply, "Sorry, no Punks left :("); // Agrego validacion para que no se supere el max de nfts.
        _safeMint((msg.sender), current); // Genera el token y se lo asigna a la direccion (funcion del ERC721).
        _idCounter.increment(); // Incremento el current.
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
                '"// TODO"',
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
