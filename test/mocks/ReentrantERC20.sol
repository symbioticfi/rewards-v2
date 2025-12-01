// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Minimal ERC20 with a reentrancy hook for testing.
contract ReentrantERC20 {
    string public constant name = "Reentrant";
    string public constant symbol = "REENTRANT";
    uint8 public constant decimals = 18;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address public hookTarget;
    bytes public hookData;

    function setHook(address target, bytes calldata data) external {
        hookTarget = target;
        hookData = data;
    }

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }

    function totalSupply() external view returns (uint256) {
        return 0;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        _maybeReenter();
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        uint256 allowed = allowance[from][msg.sender];
        require(allowed >= amount, "insufficient allowance");
        allowance[from][msg.sender] = allowed - amount;

        _maybeReenter();

        _transfer(from, to, amount);
        return true;
    }

    function _maybeReenter() internal {
        if (hookTarget != address(0)) {
            (bool ok, bytes memory ret) = hookTarget.call(hookData);
            if (!ok) {
                assembly {
                    revert(add(ret, 0x20), mload(ret))
                }
            }
        }
    }

    function _transfer(address from, address to, uint256 amount) internal {
        uint256 bal = balanceOf[from];
        require(bal >= amount, "insufficient balance");
        unchecked {
            balanceOf[from] = bal - amount;
            balanceOf[to] += amount;
        }
    }
}
