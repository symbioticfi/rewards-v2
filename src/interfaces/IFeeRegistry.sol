// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IFeeRegistry
 * @notice Interface for the FeeRegistry contract.
 */
interface IFeeRegistry {
    /* ERRORS */

    /**
     * @notice Raised when a supplied fee exceeds the configured limit.
     */
    error FeeTooHigh();

    /**
     * @notice Raised when the caller is not the curator authorized for a vault.
     */
    error NotCurator();

    /**
     * @notice Hints for `getOperatorsFeeAt`.
     * @param operatorsNetworkFeeHint Hint for the operators network fee checkpoint.
     * @param operatorsDefaultFeeHint Hint for the operators default fee checkpoint.
     */
    struct OperatorsFeeAtHints {
        bytes operatorsNetworkFeeHint;
        bytes operatorsDefaultFeeHint;
    }

    /**
     * @notice Hints for `getCuratorFeeAt`.
     * @param curatorNetworkFeeHint Hint for the curator network fee checkpoint.
     * @param curatorDefaultFeeHint Hint for the curator default fee checkpoint.
     */
    struct CuratorFeeAtHints {
        bytes curatorNetworkFeeHint;
        bytes curatorDefaultFeeHint;
    }

    /* EVENTS */

    /**
     * @notice Emitted when the operator fee is set for a vault.
     * @param vault The vault address.
     * @param fee The fee amount.
     */
    event SetOperatorsFee(address indexed vault, uint256 fee);

    /**
     * @notice Emitted when an operator network fee is set for a vault.
     * @param vault The vault address.
     * @param network The network address.
     * @param enable Whether the fee is enabled.
     * @param fee The fee amount.
     */
    event SetOperatorsNetworkFee(address indexed vault, address indexed network, bool enable, uint256 fee);

    /**
     * @notice Emitted when the curator fee is set for a vault.
     * @param vault The vault address.
     * @param fee The fee amount.
     */
    event SetCuratorFee(address indexed vault, uint256 fee);

    /**
     * @notice Emitted when a curator network fee is set for a vault.
     * @param vault The vault address.
     * @param network The network address.
     * @param enable Whether the fee is enabled.
     * @param fee The fee amount.
     */
    event SetCuratorNetworkFee(address indexed vault, address indexed network, bool enable, uint256 fee);

    /**
     * @notice Emitted when the protocol fee is set.
     * @param id The id of the protocol.
     * @param enable Whether the fee is enabled.
     * @param fee The fee amount.
     */
    event SetProtocolFee(bytes32 indexed id, bool enable, uint256 fee);

    /* FUNCTIONS */

    /**
     * @notice Returns the maximum fee value (100%).
     * @return The maximum fee value.
     */
    function MAX_FEE() external view returns (uint256);

    /**
     * @notice Returns the maximum fee value for operators and curators.
     * @return The maximum fee value.
     * @dev Set to 50%, so operators' and curator's fees collectively cannot exceed 100%.
     */
    function MAX_PARTICIPANT_FEE() external view returns (uint256);

    /**
     * @notice Returns the curator registry address.
     * @return The curator registry address.
     */
    function CURATOR_REGISTRY() external view returns (address);

    /**
     * @notice Returns the operator fee for a vault and network at a specific timestamp.
     * @param vault The vault address.
     * @param network The network address.
     * @param timestamp The timestamp to query.
     * @param hints Optional encoded `OperatorsFeeAtHints` for optimization.
     * @return fee The fee amount.
     */
    function getOperatorsFeeAt(address vault, address network, uint48 timestamp, bytes memory hints)
        external
        view
        returns (uint256 fee);

    /**
     * @notice Returns the operator fee for a vault and network.
     * @param vault The vault address.
     * @param network The network address.
     * @return fee The fee amount.
     */
    function getOperatorsFee(address vault, address network) external view returns (uint256 fee);

    /**
     * @notice Returns the operator network fee at a specific timestamp.
     * @param vault The vault address.
     * @param network The network address.
     * @param timestamp The timestamp to query.
     * @param hint Optional hint for optimization.
     * @return isEnabled Whether the fee is enabled.
     * @return fee The fee amount.
     */
    function getOperatorsNetworkFeeAt(address vault, address network, uint48 timestamp, bytes memory hint)
        external
        view
        returns (bool isEnabled, uint256 fee);

    /**
     * @notice Returns the operator network fee.
     * @param vault The vault address.
     * @param network The network address.
     * @return isEnabled Whether the fee is enabled.
     * @return fee The fee amount.
     */
    function getOperatorsNetworkFee(address vault, address network) external view returns (bool isEnabled, uint256 fee);

    /**
     * @notice Returns the default operator fee at a specific timestamp.
     * @param vault The vault address.
     * @param timestamp The timestamp to query.
     * @param hint Optional hint for optimization.
     * @return fee The fee amount.
     */
    function getOperatorsDefaultFeeAt(address vault, uint48 timestamp, bytes memory hint)
        external
        view
        returns (uint256 fee);

    /**
     * @notice Returns the default operator fee.
     * @param vault The vault address.
     * @return fee The fee amount.
     */
    function getOperatorsDefaultFee(address vault) external view returns (uint256 fee);

    /**
     * @notice Returns the curator fee at a specific timestamp.
     * @param vault The vault address.
     * @param network The network address.
     * @param timestamp The timestamp to query.
     * @param hints Optional encoded `CuratorFeeAtHints` for optimization.
     * @return fee The fee amount.
     */
    function getCuratorFeeAt(address vault, address network, uint48 timestamp, bytes memory hints)
        external
        view
        returns (uint256 fee);

    /**
     * @notice Returns the curator fee.
     * @param vault The vault address.
     * @return fee The fee amount.
     */
    function getCuratorFee(address vault, address network) external view returns (uint256 fee);

    /**
     * @notice Returns the curator network fee at a specific timestamp.
     * @param vault The vault address.
     * @param network The network address.
     * @param timestamp The timestamp to query.
     * @param hint Optional hint for optimization.
     * @return isEnabled Whether the fee is enabled.
     * @return fee The fee amount.
     */
    function getCuratorNetworkFeeAt(address vault, address network, uint48 timestamp, bytes memory hint)
        external
        view
        returns (bool isEnabled, uint256 fee);

    /**
     * @notice Returns the curator network fee.
     * @param vault The vault address.
     * @param network The network address.
     * @return isEnabled Whether the fee is enabled.
     * @return fee The fee amount.
     */
    function getCuratorNetworkFee(address vault, address network) external view returns (bool isEnabled, uint256 fee);

    /**
     * @notice Returns the default curator fee at a specific timestamp.
     * @param vault The vault address.
     * @param timestamp The timestamp to query.
     * @param hint Optional hint for optimization.
     * @return fee The fee amount.
     */
    function getCuratorDefaultFeeAt(address vault, uint48 timestamp, bytes memory hint)
        external
        view
        returns (uint256 fee);

    /**
     * @notice Returns the default curator fee.
     * @param vault The vault address.
     * @return fee The fee amount.
     */
    function getCuratorDefaultFee(address vault) external view returns (uint256 fee);

    /**
     * @notice Returns the protocol fee.
     * @param id The id of the protocol.
     * @return isEnabled Whether the fee is enabled.
     * @return fee The fee amount.
     */
    function getProtocolFee(bytes32 id) external view returns (bool isEnabled, uint256 fee);

    /**
     * @notice Sets the operator fee for a vault (only curator).
     * @param vault The vault address.
     * @param fee The fee amount.
     */
    function setOperatorsFee(address vault, uint256 fee) external;

    /**
     * @notice Sets the operator network fee for a vault (only curator).
     * @param vault The vault address.
     * @param network The network address.
     * @param enable Whether the fee is enabled.
     * @param fee The fee amount.
     */
    function setOperatorsNetworkFee(address vault, address network, bool enable, uint256 fee) external;

    /**
     * @notice Sets the curator fee for a vault (only curator).
     * @param vault The vault address.
     * @param fee The fee amount.
     */
    function setCuratorFee(address vault, uint256 fee) external;

    /**
     * @notice Sets the curator network fee for a vault (only curator).
     * @param vault The vault address.
     * @param network The network address.
     * @param enable Whether the fee is enabled.
     * @param fee The fee amount.
     */
    function setCuratorNetworkFee(address vault, address network, bool enable, uint256 fee) external;

    /**
     * @notice Sets the protocol fee.
     * @param id The id of the protocol.
     * @param enable Whether the fee is enabled.
     * @param fee The fee amount.
     */
    function setProtocolFee(bytes32 id, bool enable, uint256 fee) external;
}
