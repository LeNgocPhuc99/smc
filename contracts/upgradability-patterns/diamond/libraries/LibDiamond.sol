// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDiamondCut} from "../interfaces/IDiamondCut.sol";

/**
 * Implemnet for IDiamondCut interface && helper function
 * hash({contract}.storage.{Name}): assign separate storage slots to each facet. ==> diamond storage pattern
 */
library LibDiamond {

    struct FacetAddressToSelectorPosition {
        address facetAddress; // facet address
        uint16 selectorIndex; // selector index
    }

    // the storage structure: contains the state variable
    struct DiamondStorage {
        // function selector => facet address and selector position in selectors array
        mapping(bytes4 => FacetAddressToSelectorPosition) selectorTofacet; 
        // owner of the contract
        address owner;
        bytes4[] selectors;
    }

    event DiamondCut(
        IDiamondCut.FacetCut _diamondCut,
        bytes _calldata,
        address _init
    );

    event AddedSelector(
        bytes4 selector,
        address _facetAddress,
        bytes4[] selectors,
        address _facetAddressForSelector,
        uint16 selectorIndex
    );

    // returns a storage pointer to a struct which can contain any number of values.
    function getDiamondStorage()
        internal
        pure
        returns (DiamondStorage storage ds)
    {
        // Diamon storage position
        bytes32 storageLocation = keccak256("diamond.storage.LibDiamond");
        assembly {
            ds.slot := storageLocation // set slot pointer of diamond storage structure
        }
    }

    function setOwner(address _owner) internal {
        DiamondStorage storage ds = getDiamondStorage();
        ds.owner = _owner;
    }

    /**
     * _facet:
     * _calldata:
     * _init:
     */
    function diamondCut(
        IDiamondCut.FacetCut memory _facet,
        bytes calldata _calldata,
        address _init
    ) internal {
        // require(_facet.selectors.length > 0, "No functions provided to add");
        // require(_facet.facetAddress != address(0), "No functions provided to add");
        emit DiamondCut(_facet, _calldata, _init);

        for (uint256 i; i < _facet.selectors.length; i++) {
            if (_facet.action == IDiamondCut.FacetAction.ADD) {
                addSelector(_facet.facetAddress, _facet.selectors[i]);
            } else if (_facet.action == IDiamondCut.FacetAction.REMOVE) {
                removeSelector(_facet.selectors[i]);
            } else if (_facet.action == IDiamondCut.FacetAction.REPLACE) {
                replaceSelector(_facet.facetAddress, _facet.selectors[i]);
            } else {
                revert("Incorrect Facet action");
            }
        }

        initializeDiamondCut(_init, _calldata);
    }

    function initializeDiamondCut(address _init, bytes calldata _calldata)
        internal
    {
        if (_init == address(0)) {
            require(
                _calldata.length == 0,
                "LibDiamondCut: _init is address(0) but_calldata is not empty"
            );
        } else {
            require(
                _calldata.length > 0,
                "LibDiamondCut: _calldata is empty but _init is not address(0)"
            );
            if (_init != address(this)) {
                enforceHasContractCode(
                    _init,
                    "LibDiamondCut: _init address has no code"
                );
            }
            (bool success, bytes memory error) = _init.delegatecall(_calldata);
            if (!success) {
                if (error.length > 0) {
                    // bubble up the error
                    revert(string(error));
                } else {
                    revert("LibDiamondCut: _init function reverted");
                }
            }
        }
    }

    function enforceIsContractOwner() internal view {
        DiamondStorage storage ds = getDiamondStorage();
        require(msg.sender == ds.owner, "Must be owner");
    }

    /*
     * Adds the selector to the _facetAddress
     * Restrictions: The _facetAddress must not be address(0)
     *               The mapping of selector => _facetAddress must not exists
                     Check if the _facetAddress has some code. EOA addresses are not allowed. 
                     Don't know if only owner is allowed to add an address
     */
    function addSelector(address _facetAddress, bytes4 selector) internal {
        DiamondStorage storage ds = getDiamondStorage();
        require(_facetAddress != address(0), "Facet address can't be 0");
        // _faceAddress is a smart contract
        enforceHasContractCode(_facetAddress, "Contract doesn't have code");
        // Get the selector position: Elements are added at the end of the array. Therefore, arrayLength becomes the next position. If the item is not present already.
        // So it makes sense to check if the item is added already
        require(
            ds.selectorTofacet[selector].facetAddress == address(0),
            "Can't add method already added. Use update selector"
        );
        uint16 selectorPosition = uint16(ds.selectors.length); // lastest

        ds.selectors.push(selector);
        ds.selectorTofacet[selector].facetAddress = _facetAddress;
        ds.selectorTofacet[selector].selectorIndex = selectorPosition;
        emit AddedSelector(
            selector,
            _facetAddress,
            ds.selectors,
            ds.selectorTofacet[selector].facetAddress,
            ds.selectorTofacet[selector].selectorIndex
        );
    }

    // This function will add the selectors to the address and update the mapping
    function replaceSelector(address _facetAddress, bytes4 selector) internal {
        /***
        In order to replace a selector. The selector must exists 
        The current _facetAddress must not be address(0)
        The new address must have some code. 
    */

        DiamondStorage storage ds = getDiamondStorage();
        require(_facetAddress != address(0), "Facet address can't be 0");
        require(
            ds.selectorTofacet[selector].facetAddress != address(0),
            "The selector doesn't exists"
        );
        require(
            ds.selectorTofacet[selector].facetAddress != _facetAddress,
            "Can't be the same address"
        );
        enforceHasContractCode(_facetAddress, "Contract doesn't have code");

        uint16 selectorPosition = uint16(
            ds.selectorTofacet[selector].selectorIndex
        );
        ds.selectors.push(selector);
        ds.selectorTofacet[selector].facetAddress = _facetAddress;
        ds.selectorTofacet[selector].selectorIndex = selectorPosition;
    }

    // This function remove add the selectors to the address and update the mapping
    function removeSelector(bytes4 _selector) internal {
        // required conditions.
        DiamondStorage storage ds = getDiamondStorage();
        require(
            ds.selectorTofacet[_selector].facetAddress != address(0),
            "Can't remove a function that doesn't exist"
        );
        // If the function exists, we simply remove. Find the selector by utilising the position in the selectors array. get the last element. and swap them. and pop the item out.
        uint16 selectorPosition = ds.selectorTofacet[_selector].selectorIndex;
        uint16 lastElementIndex = uint16(ds.selectors.length - 1);

        if (lastElementIndex != selectorPosition) {
            bytes4 lastElement = ds.selectors[lastElementIndex];
            ds.selectors[selectorPosition] = lastElement;
            ds
                .selectorTofacet[ds.selectors[selectorPosition]]
                .selectorIndex = selectorPosition;
        }
        ds.selectors.pop();
        delete ds.selectorTofacet[_selector];
    }

    // check a address is a contract and not an EOA accounts ???
    function enforceHasContractCode(
        address _contract,
        string memory _errorMessage
    ) internal view {
        uint256 contractSize;
        assembly {
            contractSize := extcodesize(_contract)
        }
        require(contractSize > 0, _errorMessage);
    }
}
