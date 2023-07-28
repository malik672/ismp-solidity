// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./interfaces/IIsmpDispatcher.sol";
import "./interfaces/IIsmpModule.sol";

library SubstrateHost {
    // addresses of the precompiles
    address public POST_REQUEST_DISPATCHER = 0x222A98a2832ae77E72a768bF5be1F82D8959f4Ec;
    address public POST_RESPONSE_DISPATCHER = 0xEB928e2de75Cb5ab60aBE75f539C5312aeb46f38;
    address public GET_REQUEST_DISPATCHER = 0xf2D8DC5239DdC053BA5151302483fc48D7E24e60;

    /**
     * @dev Dispatch a POST request to the ISMP host.
     * @param request - post request
     */
    function dispatch(DispatchPost memory request) internal {
        bytes memory input =
            abi.encode(request.destChain, request.to, request.body, request.timeoutTimestamp, request.gaslimit);

        (bool ok, bytes memory out) = address(POST_REQUEST_DISPATCHER).staticcall(input);

        if (!ok) {
            revert("DispatchPost failed");
        }
    }

    /**
     * @dev Dispatch a GET request to the ISMP host.
     * @param request - get request
     */
    function dispatch(DispatchGet memory request) internal {
        bytes memory input =
            abi.encode(request.destChain, request.height, request.keys, request.timeoutTimestamp, request.gaslimit);

        (bool ok, bytes memory out) = address(GET_REQUEST_DISPATCHER).staticcall(input);

        if (!ok) {
            revert("DispatchGet failed");
        }
    }

    /**
     * @dev Provide a response to a previously received request.
     * @param response - post response
     */
    function dispatch(PostResponse memory response) internal {
        bytes memory input = abi.encode(
            response.request.dest, response.request.to, response.request.body, response.request.timeoutTimestamp
        );

        (bool ok, bytes memory out) = address(POST_RESPONSE_DISPATCHER).staticcall(input);

        if (!ok) {
            revert("DispatchPost failed");
        }
    }
}
