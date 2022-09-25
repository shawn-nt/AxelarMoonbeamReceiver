//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import {AxelarExecutable} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/executables/AxelarExecutable.sol";
import {IAxelarGateway} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";
import {IAxelarGasService} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";
import {IERC20} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IERC20.sol";

//import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface ILetterboxV3 {
    event StampCreated(uint256 indexed tokenId);
    event LetterboxCreated(uint256 indexed tokenId);
    event LetterboxStamped();
    event LetterboxCollected();

    function mintStamp(address to_, string memory uri_) external payable;

    function mintLetterbox(address to_, string memory uri_) external;

    function stampToLetterbox(
        address stampUser,
        uint256 letterboxTokenId,
        bool accepted
    ) external;

    function letterboxToStamp(address stampUser, uint256 letterboxTokenId)
        external;
}

contract MoonbeamReceiver is AxelarExecutable {
    string public functionSent;
    string public parametersSent;
    string public sourceChain;
    string public sourceAddress;
    IAxelarGasService public immutable gasReceiver;
    address public letterboxV3Addr;

    constructor(address gateway_, address gasReceiver_)
        AxelarExecutable(gateway_)
    {
        gasReceiver = IAxelarGasService(gasReceiver_);
    }

    function setLetterboxV3Address(address letterboxV3Addr_) public {
        letterboxV3Addr = letterboxV3Addr_;
    }

    // Handles calls created by setAndSend. Updates this contract's value
    function _execute(
        string calldata sourceChain_,
        string calldata sourceAddress_,
        bytes calldata payload_
    ) internal override {
        (functionSent, parametersSent) = abi.decode(payload_, (string, string));
        sourceChain = sourceChain_;
        sourceAddress = sourceAddress_;
        if (
            keccak256(bytes(functionSent)) ==
            keccak256(bytes("stampToLetterbox(address, uint256, bool)"))
        ) {
            address(letterboxV3Addr).call(
                abi.encodeWithSignature(
                    "stampToLetterbox(address, uint256, bool)",
                    sourceAddress,
                    parametersSent,
                    true
                )
            );
        } else {
            address(letterboxV3Addr).call(
                abi.encodeWithSignature(
                    functionSent,
                    sourceAddress,
                    parametersSent
                )
            );
        }
    }
}
