// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BelgePaylasim {
    struct Document {
        string ipfsHash;
        string title;
        address owner;
        address authorizedUser;
        bool isSigned;
    }

    mapping(uint => Document) public documents;
    uint public documentCount;

    event DocumentUploaded(uint docId, string title, address owner);
    event AccessGranted(uint docId, address authorizedUser);

    // Belge Yükleme
    function uploadDocument(string memory _ipfsHash, string memory _title) public {
        documentCount++;
        documents[documentCount] = Document(_ipfsHash, _title, msg.sender, address(0), false);
        emit DocumentUploaded(documentCount, _title, msg.sender);
    }

    // Yetkilendirme
    function grantAccess(uint _docId, address _user) public {
        require(msg.sender == documents[_docId].owner, "Yetkiniz yok");
        documents[_docId].authorizedUser = _user;
        emit AccessGranted(_docId, _user);
    }

    // Belgeye Erişim
    function viewDocument(uint _docId) public view returns (string memory) {
        require(msg.sender == documents[_docId].authorizedUser || msg.sender == documents[_docId].owner, "Erişim izniniz yok");
        return documents[_docId].ipfsHash;
    }

    // Belge İmzalama
    function signDocument(uint _docId) public {
        require(msg.sender == documents[_docId].authorizedUser, "Yetkiniz yok");
        documents[_docId].isSigned = true;
    }
}
