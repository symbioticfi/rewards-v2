// SPDX-License-Identifier: BUSL-1.1
pragma solidity =0.8.28 >=0.4.16 >=0.6.2 >=0.8.4 ^0.8.0 ^0.8.20 ^0.8.25 ^0.8.28 ^0.8.4;

// lib/openzeppelin-contracts/contracts/utils/Calldata.sol

// OpenZeppelin Contracts (last updated v5.3.0) (utils/Calldata.sol)

/**
 * @dev Helper library for manipulating objects in calldata.
 */
library Calldata {
    // slither-disable-next-line write-after-write
    function emptyBytes() internal pure returns (bytes calldata result) {
        assembly ("memory-safe") {
            result.offset := 0
            result.length := 0
        }
    }

    // slither-disable-next-line write-after-write
    function emptyString() internal pure returns (string calldata result) {
        assembly ("memory-safe") {
            result.offset := 0
            result.length := 0
        }
    }
}

// lib/openzeppelin-contracts/contracts/utils/Comparators.sol

// OpenZeppelin Contracts (last updated v5.1.0) (utils/Comparators.sol)

/**
 * @dev Provides a set of functions to compare values.
 *
 * _Available since v5.1._
 */
library Comparators {
    function lt(uint256 a, uint256 b) internal pure returns (bool) {
        return a < b;
    }

    function gt(uint256 a, uint256 b) internal pure returns (bool) {
        return a > b;
    }
}

// lib/openzeppelin-contracts/contracts/utils/Context.sol

// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// lib/openzeppelin-contracts/contracts/utils/Errors.sol

// OpenZeppelin Contracts (last updated v5.1.0) (utils/Errors.sol)

/**
 * @dev Collection of common custom errors used in multiple contracts
 *
 * IMPORTANT: Backwards compatibility is not guaranteed in future versions of the library.
 * It is recommended to avoid relying on the error API for critical functionality.
 *
 * _Available since v5.1._
 */
library Errors {
    /**
     * @dev The ETH balance of the account is not enough to perform the operation.
     */
    error InsufficientBalance(uint256 balance, uint256 needed);

    /**
     * @dev A call to an address target failed. The target may have reverted.
     */
    error FailedCall();

    /**
     * @dev The deployment failed.
     */
    error FailedDeployment();

    /**
     * @dev A necessary precompile is missing.
     */
    error MissingPrecompile(address);
}

// lib/solady/src/utils/FixedPointMathLib.sol

/// @notice Arithmetic library with operations for fixed-point numbers.
/// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/FixedPointMathLib.sol)
/// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/FixedPointMathLib.sol)
library FixedPointMathLib {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev The operation failed, as the output exceeds the maximum value of uint256.
    error ExpOverflow();

    /// @dev The operation failed, as the output exceeds the maximum value of uint256.
    error FactorialOverflow();

    /// @dev The operation failed, due to an overflow.
    error RPowOverflow();

    /// @dev The mantissa is too big to fit.
    error MantissaOverflow();

    /// @dev The operation failed, due to an multiplication overflow.
    error MulWadFailed();

    /// @dev The operation failed, due to an multiplication overflow.
    error SMulWadFailed();

    /// @dev The operation failed, either due to a multiplication overflow, or a division by a zero.
    error DivWadFailed();

    /// @dev The operation failed, either due to a multiplication overflow, or a division by a zero.
    error SDivWadFailed();

    /// @dev The operation failed, either due to a multiplication overflow, or a division by a zero.
    error MulDivFailed();

    /// @dev The division failed, as the denominator is zero.
    error DivFailed();

    /// @dev The full precision multiply-divide operation failed, either due
    /// to the result being larger than 256 bits, or a division by a zero.
    error FullMulDivFailed();

    /// @dev The output is undefined, as the input is less-than-or-equal to zero.
    error LnWadUndefined();

    /// @dev The input outside the acceptable domain.
    error OutOfDomain();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev The scalar of ETH and most ERC20s.
    uint256 internal constant WAD = 1e18;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*              SIMPLIFIED FIXED POINT OPERATIONS             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Equivalent to `(x * y) / WAD` rounded down.
    function mulWad(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Equivalent to `require(y == 0 || x <= type(uint256).max / y)`.
            if gt(x, div(not(0), y)) {
                if y {
                    mstore(0x00, 0xbac65e5b) // `MulWadFailed()`.
                    revert(0x1c, 0x04)
                }
            }
            z := div(mul(x, y), WAD)
        }
    }

    /// @dev Equivalent to `(x * y) / WAD` rounded down.
    function sMulWad(int256 x, int256 y) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mul(x, y)
            // Equivalent to `require((x == 0 || z / x == y) && !(x == -1 && y == type(int256).min))`.
            if iszero(gt(or(iszero(x), eq(sdiv(z, x), y)), lt(not(x), eq(y, shl(255, 1))))) {
                mstore(0x00, 0xedcd4dd4) // `SMulWadFailed()`.
                revert(0x1c, 0x04)
            }
            z := sdiv(z, WAD)
        }
    }

    /// @dev Equivalent to `(x * y) / WAD` rounded down, but without overflow checks.
    function rawMulWad(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := div(mul(x, y), WAD)
        }
    }

    /// @dev Equivalent to `(x * y) / WAD` rounded down, but without overflow checks.
    function rawSMulWad(int256 x, int256 y) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := sdiv(mul(x, y), WAD)
        }
    }

    /// @dev Equivalent to `(x * y) / WAD` rounded up.
    function mulWadUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mul(x, y)
            // Equivalent to `require(y == 0 || x <= type(uint256).max / y)`.
            if iszero(eq(div(z, y), x)) {
                if y {
                    mstore(0x00, 0xbac65e5b) // `MulWadFailed()`.
                    revert(0x1c, 0x04)
                }
            }
            z := add(iszero(iszero(mod(z, WAD))), div(z, WAD))
        }
    }

    /// @dev Equivalent to `(x * y) / WAD` rounded up, but without overflow checks.
    function rawMulWadUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := add(iszero(iszero(mod(mul(x, y), WAD))), div(mul(x, y), WAD))
        }
    }

    /// @dev Equivalent to `(x * WAD) / y` rounded down.
    function divWad(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Equivalent to `require(y != 0 && x <= type(uint256).max / WAD)`.
            if iszero(mul(y, lt(x, add(1, div(not(0), WAD))))) {
                mstore(0x00, 0x7c5f487d) // `DivWadFailed()`.
                revert(0x1c, 0x04)
            }
            z := div(mul(x, WAD), y)
        }
    }

    /// @dev Equivalent to `(x * WAD) / y` rounded down.
    function sDivWad(int256 x, int256 y) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mul(x, WAD)
            // Equivalent to `require(y != 0 && ((x * WAD) / WAD == x))`.
            if iszero(mul(y, eq(sdiv(z, WAD), x))) {
                mstore(0x00, 0x5c43740d) // `SDivWadFailed()`.
                revert(0x1c, 0x04)
            }
            z := sdiv(z, y)
        }
    }

    /// @dev Equivalent to `(x * WAD) / y` rounded down, but without overflow and divide by zero checks.
    function rawDivWad(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := div(mul(x, WAD), y)
        }
    }

    /// @dev Equivalent to `(x * WAD) / y` rounded down, but without overflow and divide by zero checks.
    function rawSDivWad(int256 x, int256 y) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := sdiv(mul(x, WAD), y)
        }
    }

    /// @dev Equivalent to `(x * WAD) / y` rounded up.
    function divWadUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Equivalent to `require(y != 0 && x <= type(uint256).max / WAD)`.
            if iszero(mul(y, lt(x, add(1, div(not(0), WAD))))) {
                mstore(0x00, 0x7c5f487d) // `DivWadFailed()`.
                revert(0x1c, 0x04)
            }
            z := add(iszero(iszero(mod(mul(x, WAD), y))), div(mul(x, WAD), y))
        }
    }

    /// @dev Equivalent to `(x * WAD) / y` rounded up, but without overflow and divide by zero checks.
    function rawDivWadUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := add(iszero(iszero(mod(mul(x, WAD), y))), div(mul(x, WAD), y))
        }
    }

    /// @dev Equivalent to `x` to the power of `y`.
    /// because `x ** y = (e ** ln(x)) ** y = e ** (ln(x) * y)`.
    /// Note: This function is an approximation.
    function powWad(int256 x, int256 y) internal pure returns (int256) {
        // Using `ln(x)` means `x` must be greater than 0.
        return expWad((lnWad(x) * y) / int256(WAD));
    }

    /// @dev Returns `exp(x)`, denominated in `WAD`.
    /// Credit to Remco Bloemen under MIT license: https://2π.com/22/exp-ln
    /// Note: This function is an approximation. Monotonically increasing.
    function expWad(int256 x) internal pure returns (int256 r) {
        unchecked {
            // When the result is less than 0.5 we return zero.
            // This happens when `x <= (log(1e-18) * 1e18) ~ -4.15e19`.
            if (x <= -41_446_531_673_892_822_313) return r;

            /// @solidity memory-safe-assembly
            assembly {
                // When the result is greater than `(2**255 - 1) / 1e18` we can not represent it as
                // an int. This happens when `x >= floor(log((2**255 - 1) / 1e18) * 1e18) ≈ 135`.
                if iszero(slt(x, 135305999368893231589)) {
                    mstore(0x00, 0xa37bfec9) // `ExpOverflow()`.
                    revert(0x1c, 0x04)
                }
            }

            // `x` is now in the range `(-42, 136) * 1e18`. Convert to `(-42, 136) * 2**96`
            // for more intermediate precision and a binary basis. This base conversion
            // is a multiplication by 1e18 / 2**96 = 5**18 / 2**78.
            x = (x << 78) / 5 ** 18;

            // Reduce range of x to (-½ ln 2, ½ ln 2) * 2**96 by factoring out powers
            // of two such that exp(x) = exp(x') * 2**k, where k is an integer.
            // Solving this gives k = round(x / log(2)) and x' = x - k * log(2).
            int256 k = ((x << 96) / 54_916_777_467_707_473_351_141_471_128 + 2 ** 95) >> 96;
            x = x - k * 54_916_777_467_707_473_351_141_471_128;

            // `k` is in the range `[-61, 195]`.

            // Evaluate using a (6, 7)-term rational approximation.
            // `p` is made monic, we'll multiply by a scale factor later.
            int256 y = x + 1_346_386_616_545_796_478_920_950_773_328;
            y = ((y * x) >> 96) + 57_155_421_227_552_351_082_224_309_758_442;
            int256 p = y + x - 94_201_549_194_550_492_254_356_042_504_812;
            p = ((p * y) >> 96) + 28_719_021_644_029_726_153_956_944_680_412_240;
            p = p * x + (4_385_272_521_454_847_904_659_076_985_693_276 << 96);

            // We leave `p` in `2**192` basis so we don't need to scale it back up for the division.
            int256 q = x - 2_855_989_394_907_223_263_936_484_059_900;
            q = ((q * x) >> 96) + 50_020_603_652_535_783_019_961_831_881_945;
            q = ((q * x) >> 96) - 533_845_033_583_426_703_283_633_433_725_380;
            q = ((q * x) >> 96) + 3_604_857_256_930_695_427_073_651_918_091_429;
            q = ((q * x) >> 96) - 14_423_608_567_350_463_180_887_372_962_807_573;
            q = ((q * x) >> 96) + 26_449_188_498_355_588_339_934_803_723_976_023;

            /// @solidity memory-safe-assembly
            assembly {
                // Div in assembly because solidity adds a zero check despite the unchecked.
                // The q polynomial won't have zeros in the domain as all its roots are complex.
                // No scaling is necessary because p is already `2**96` too large.
                r := sdiv(p, q)
            }

            // r should be in the range `(0.09, 0.25) * 2**96`.

            // We now need to multiply r by:
            // - The scale factor `s ≈ 6.031367120`.
            // - The `2**k` factor from the range reduction.
            // - The `1e18 / 2**96` factor for base conversion.
            // We do this all at once, with an intermediate result in `2**213`
            // basis, so the final right shift is always by a positive amount.
            r = int256(
                (uint256(r) * 3_822_833_074_963_236_453_042_738_258_902_158_003_155_416_615_667) >> uint256(195 - k)
            );
        }
    }

    /// @dev Returns `ln(x)`, denominated in `WAD`.
    /// Credit to Remco Bloemen under MIT license: https://2π.com/22/exp-ln
    /// Note: This function is an approximation. Monotonically increasing.
    function lnWad(int256 x) internal pure returns (int256 r) {
        /// @solidity memory-safe-assembly
        assembly {
            // We want to convert `x` from `10**18` fixed point to `2**96` fixed point.
            // We do this by multiplying by `2**96 / 10**18`. But since
            // `ln(x * C) = ln(x) + ln(C)`, we can simply do nothing here
            // and add `ln(2**96 / 10**18)` at the end.

            // Compute `k = log2(x) - 96`, `r = 159 - k = 255 - log2(x) = 255 ^ log2(x)`.
            r := shl(7, lt(0xffffffffffffffffffffffffffffffff, x))
            r := or(r, shl(6, lt(0xffffffffffffffff, shr(r, x))))
            r := or(r, shl(5, lt(0xffffffff, shr(r, x))))
            r := or(r, shl(4, lt(0xffff, shr(r, x))))
            r := or(r, shl(3, lt(0xff, shr(r, x))))
            // We place the check here for more optimal stack operations.
            if iszero(sgt(x, 0)) {
                mstore(0x00, 0x1615e638) // `LnWadUndefined()`.
                revert(0x1c, 0x04)
            }
            // forgefmt: disable-next-item
            r := xor(r, byte(and(0x1f, shr(shr(r, x), 0x8421084210842108cc6318c6db6d54be)),
                0xf8f9f9faf9fdfafbf9fdfcfdfafbfcfef9fafdfafcfcfbfefafafcfbffffffff))

            // Reduce range of x to (1, 2) * 2**96
            // ln(2^k * x) = k * ln(2) + ln(x)
            x := shr(159, shl(r, x))

            // Evaluate using a (8, 8)-term rational approximation.
            // `p` is made monic, we will multiply by a scale factor later.
            // forgefmt: disable-next-item
            let p := sub( // This heavily nested expression is to avoid stack-too-deep for via-ir.
                sar(96, mul(add(43456485725739037958740375743393,
                sar(96, mul(add(24828157081833163892658089445524,
                sar(96, mul(add(3273285459638523848632254066296,
                    x), x))), x))), x)), 11111509109440967052023855526967)
            p := sub(sar(96, mul(p, x)), 45023709667254063763336534515857)
            p := sub(sar(96, mul(p, x)), 14706773417378608786704636184526)
            p := sub(mul(p, x), shl(96, 795164235651350426258249787498))
            // We leave `p` in `2**192` basis so we don't need to scale it back up for the division.

            // `q` is monic by convention.
            let q := add(5573035233440673466300451813936, x)
            q := add(71694874799317883764090561454958, sar(96, mul(x, q)))
            q := add(283447036172924575727196451306956, sar(96, mul(x, q)))
            q := add(401686690394027663651624208769553, sar(96, mul(x, q)))
            q := add(204048457590392012362485061816622, sar(96, mul(x, q)))
            q := add(31853899698501571402653359427138, sar(96, mul(x, q)))
            q := add(909429971244387300277376558375, sar(96, mul(x, q)))

            // `p / q` is in the range `(0, 0.125) * 2**96`.

            // Finalization, we need to:
            // - Multiply by the scale factor `s = 5.549…`.
            // - Add `ln(2**96 / 10**18)`.
            // - Add `k * ln(2)`.
            // - Multiply by `10**18 / 2**96 = 5**18 >> 78`.

            // The q polynomial is known not to have zeros in the domain.
            // No scaling required because p is already `2**96` too large.
            p := sdiv(p, q)
            // Multiply by the scaling factor: `s * 5**18 * 2**96`, base is now `5**18 * 2**192`.
            p := mul(1677202110996718588342820967067443963516166, p)
            // Add `ln(2) * k * 5**18 * 2**192`.
            // forgefmt: disable-next-item
            p := add(mul(16597577552685614221487285958193947469193820559219878177908093499208371, sub(159, r)), p)
            // Add `ln(2**96 / 10**18) * 5**18 * 2**192`.
            p := add(600920179829731861736702779321621459595472258049074101567377883020018308, p)
            // Base conversion: mul `2**18 / 2**192`.
            r := sar(174, p)
        }
    }

    /// @dev Returns `W_0(x)`, denominated in `WAD`.
    /// See: https://en.wikipedia.org/wiki/Lambert_W_function
    /// a.k.a. Product log function. This is an approximation of the principal branch.
    /// Note: This function is an approximation. Monotonically increasing.
    function lambertW0Wad(int256 x) internal pure returns (int256 w) {
        // forgefmt: disable-next-item
        unchecked {
            if ((w = x) <= -367879441171442322) revert OutOfDomain(); // `x` less than `-1/e`.
            (int256 wad, int256 p) = (int256(WAD), x);
            uint256 c; // Whether we need to avoid catastrophic cancellation.
            uint256 i = 4; // Number of iterations.
            if (w <= 0x1ffffffffffff) {
                if (-0x4000000000000 <= w) {
                    i = 1; // Inputs near zero only take one step to converge.
                } else if (w <= -0x3ffffffffffffff) {
                    i = 32; // Inputs near `-1/e` take very long to converge.
                }
            } else if (uint256(w >> 63) == uint256(0)) {
                /// @solidity memory-safe-assembly
                assembly {
                    // Inline log2 for more performance, since the range is small.
                    let v := shr(49, w)
                    let l := shl(3, lt(0xff, v))
                    l := add(or(l, byte(and(0x1f, shr(shr(l, v), 0x8421084210842108cc6318c6db6d54be)),
                        0x0706060506020504060203020504030106050205030304010505030400000000)), 49)
                    w := sdiv(shl(l, 7), byte(sub(l, 31), 0x0303030303030303040506080c13))
                    c := gt(l, 60)
                    i := add(2, add(gt(l, 53), c))
                }
            } else {
                int256 ll = lnWad(w = lnWad(w));
                /// @solidity memory-safe-assembly
                assembly {
                    // `w = ln(x) - ln(ln(x)) + b * ln(ln(x)) / ln(x)`.
                    w := add(sdiv(mul(ll, 1023715080943847266), w), sub(w, ll))
                    i := add(3, iszero(shr(68, x)))
                    c := iszero(shr(143, x))
                }
                if (c == uint256(0)) {
                    do { // If `x` is big, use Newton's so that intermediate values won't overflow.
                        int256 e = expWad(w);
                        /// @solidity memory-safe-assembly
                        assembly {
                            let t := mul(w, div(e, wad))
                            w := sub(w, sdiv(sub(t, x), div(add(e, t), wad)))
                        }
                        if (p <= w) break;
                        p = w;
                    } while (--i != uint256(0));
                    /// @solidity memory-safe-assembly
                    assembly {
                        w := sub(w, sgt(w, 2))
                    }
                    return w;
                }
            }
            do { // Otherwise, use Halley's for faster convergence.
                int256 e = expWad(w);
                /// @solidity memory-safe-assembly
                assembly {
                    let t := add(w, wad)
                    let s := sub(mul(w, e), mul(x, wad))
                    w := sub(w, sdiv(mul(s, wad), sub(mul(e, t), sdiv(mul(add(t, wad), s), add(t, t)))))
                }
                if (p <= w) break;
                p = w;
            } while (--i != c);
            /// @solidity memory-safe-assembly
            assembly {
                w := sub(w, sgt(w, 2))
            }
            // For certain ranges of `x`, we'll use the quadratic-rate recursive formula of
            // R. Iacono and J.P. Boyd for the last iteration, to avoid catastrophic cancellation.
            if (c == uint256(0)) return w;
            int256 t = w | 1;
            /// @solidity memory-safe-assembly
            assembly {
                x := sdiv(mul(x, wad), t)
            }
            x = (t * (wad + lnWad(x)));
            /// @solidity memory-safe-assembly
            assembly {
                w := sdiv(x, add(wad, t))
            }
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  GENERAL NUMBER UTILITIES                  */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Returns `a * b == x * y`, with full precision.
    function fullMulEq(uint256 a, uint256 b, uint256 x, uint256 y) internal pure returns (bool result) {
        /// @solidity memory-safe-assembly
        assembly {
            result := and(eq(mul(a, b), mul(x, y)), eq(mulmod(x, y, not(0)), mulmod(a, b, not(0))))
        }
    }

    /// @dev Calculates `floor(x * y / d)` with full precision.
    /// Throws if result overflows a uint256 or when `d` is zero.
    /// Credit to Remco Bloemen under MIT license: https://2π.com/21/muldiv
    function fullMulDiv(uint256 x, uint256 y, uint256 d) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // 512-bit multiply `[p1 p0] = x * y`.
            // Compute the product mod `2**256` and mod `2**256 - 1`
            // then use the Chinese Remainder Theorem to reconstruct
            // the 512 bit result. The result is stored in two 256
            // variables such that `product = p1 * 2**256 + p0`.

            // Temporarily use `z` as `p0` to save gas.
            z := mul(x, y) // Lower 256 bits of `x * y`.
            for {} 1 {} {
                // If overflows.
                if iszero(mul(or(iszero(x), eq(div(z, x), y)), d)) {
                    let mm := mulmod(x, y, not(0))
                    let p1 := sub(mm, add(z, lt(mm, z))) // Upper 256 bits of `x * y`.

                    /*------------------- 512 by 256 division --------------------*/

                    // Make division exact by subtracting the remainder from `[p1 p0]`.
                    let r := mulmod(x, y, d) // Compute remainder using mulmod.
                    let t := and(d, sub(0, d)) // The least significant bit of `d`. `t >= 1`.
                    // Make sure `z` is less than `2**256`. Also prevents `d == 0`.
                    // Placing the check here seems to give more optimal stack operations.
                    if iszero(gt(d, p1)) {
                        mstore(0x00, 0xae47f702) // `FullMulDivFailed()`.
                        revert(0x1c, 0x04)
                    }
                    d := div(d, t) // Divide `d` by `t`, which is a power of two.
                    // Invert `d mod 2**256`
                    // Now that `d` is an odd number, it has an inverse
                    // modulo `2**256` such that `d * inv = 1 mod 2**256`.
                    // Compute the inverse by starting with a seed that is correct
                    // correct for four bits. That is, `d * inv = 1 mod 2**4`.
                    let inv := xor(2, mul(3, d))
                    // Now use Newton-Raphson iteration to improve the precision.
                    // Thanks to Hensel's lifting lemma, this also works in modular
                    // arithmetic, doubling the correct bits in each step.
                    inv := mul(inv, sub(2, mul(d, inv))) // inverse mod 2**8
                    inv := mul(inv, sub(2, mul(d, inv))) // inverse mod 2**16
                    inv := mul(inv, sub(2, mul(d, inv))) // inverse mod 2**32
                    inv := mul(inv, sub(2, mul(d, inv))) // inverse mod 2**64
                    inv := mul(inv, sub(2, mul(d, inv))) // inverse mod 2**128
                    z := mul(
                        // Divide [p1 p0] by the factors of two.
                        // Shift in bits from `p1` into `p0`. For this we need
                        // to flip `t` such that it is `2**256 / t`.
                        or(mul(sub(p1, gt(r, z)), add(div(sub(0, t), t), 1)), div(sub(z, r), t)),
                        mul(sub(2, mul(d, inv)), inv) // inverse mod 2**256
                    )
                    break
                }
                z := div(z, d)
                break
            }
        }
    }

    /// @dev Calculates `floor(x * y / d)` with full precision.
    /// Behavior is undefined if `d` is zero or the final result cannot fit in 256 bits.
    /// Performs the full 512 bit calculation regardless.
    function fullMulDivUnchecked(uint256 x, uint256 y, uint256 d) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mul(x, y)
            let mm := mulmod(x, y, not(0))
            let p1 := sub(mm, add(z, lt(mm, z)))
            let t := and(d, sub(0, d))
            let r := mulmod(x, y, d)
            d := div(d, t)
            let inv := xor(2, mul(3, d))
            inv := mul(inv, sub(2, mul(d, inv)))
            inv := mul(inv, sub(2, mul(d, inv)))
            inv := mul(inv, sub(2, mul(d, inv)))
            inv := mul(inv, sub(2, mul(d, inv)))
            inv := mul(inv, sub(2, mul(d, inv)))
            z := mul(
                or(mul(sub(p1, gt(r, z)), add(div(sub(0, t), t), 1)), div(sub(z, r), t)),
                mul(sub(2, mul(d, inv)), inv)
            )
        }
    }

    /// @dev Calculates `floor(x * y / d)` with full precision, rounded up.
    /// Throws if result overflows a uint256 or when `d` is zero.
    /// Credit to Uniswap-v3-core under MIT license:
    /// https://github.com/Uniswap/v3-core/blob/main/contracts/libraries/FullMath.sol
    function fullMulDivUp(uint256 x, uint256 y, uint256 d) internal pure returns (uint256 z) {
        z = fullMulDiv(x, y, d);
        /// @solidity memory-safe-assembly
        assembly {
            if mulmod(x, y, d) {
                z := add(z, 1)
                if iszero(z) {
                    mstore(0x00, 0xae47f702) // `FullMulDivFailed()`.
                    revert(0x1c, 0x04)
                }
            }
        }
    }

    /// @dev Calculates `floor(x * y / 2 ** n)` with full precision.
    /// Throws if result overflows a uint256.
    /// Credit to Philogy under MIT license:
    /// https://github.com/SorellaLabs/angstrom/blob/main/contracts/src/libraries/X128MathLib.sol
    function fullMulDivN(uint256 x, uint256 y, uint8 n) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Temporarily use `z` as `p0` to save gas.
            z := mul(x, y) // Lower 256 bits of `x * y`. We'll call this `z`.
            for {} 1 {} {
                if iszero(or(iszero(x), eq(div(z, x), y))) {
                    let k := and(n, 0xff) // `n`, cleaned.
                    let mm := mulmod(x, y, not(0))
                    let p1 := sub(mm, add(z, lt(mm, z))) // Upper 256 bits of `x * y`.
                    //         |      p1     |      z     |
                    // Before: | p1_0 ¦ p1_1 | z_0  ¦ z_1 |
                    // Final:  |   0  ¦ p1_0 | p1_1 ¦ z_0 |
                    // Check that final `z` doesn't overflow by checking that p1_0 = 0.
                    if iszero(shr(k, p1)) {
                        z := add(shl(sub(256, k), p1), shr(k, z))
                        break
                    }
                    mstore(0x00, 0xae47f702) // `FullMulDivFailed()`.
                    revert(0x1c, 0x04)
                }
                z := shr(and(n, 0xff), z)
                break
            }
        }
    }

    /// @dev Returns `floor(x * y / d)`.
    /// Reverts if `x * y` overflows, or `d` is zero.
    function mulDiv(uint256 x, uint256 y, uint256 d) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mul(x, y)
            // Equivalent to `require(d != 0 && (y == 0 || x <= type(uint256).max / y))`.
            if iszero(mul(or(iszero(x), eq(div(z, x), y)), d)) {
                mstore(0x00, 0xad251c27) // `MulDivFailed()`.
                revert(0x1c, 0x04)
            }
            z := div(z, d)
        }
    }

    /// @dev Returns `ceil(x * y / d)`.
    /// Reverts if `x * y` overflows, or `d` is zero.
    function mulDivUp(uint256 x, uint256 y, uint256 d) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mul(x, y)
            // Equivalent to `require(d != 0 && (y == 0 || x <= type(uint256).max / y))`.
            if iszero(mul(or(iszero(x), eq(div(z, x), y)), d)) {
                mstore(0x00, 0xad251c27) // `MulDivFailed()`.
                revert(0x1c, 0x04)
            }
            z := add(iszero(iszero(mod(z, d))), div(z, d))
        }
    }

    /// @dev Returns `x`, the modular multiplicative inverse of `a`, such that `(a * x) % n == 1`.
    function invMod(uint256 a, uint256 n) internal pure returns (uint256 x) {
        /// @solidity memory-safe-assembly
        assembly {
            let g := n
            let r := mod(a, n)
            for { let y := 1 } 1 {} {
                let q := div(g, r)
                let t := g
                g := r
                r := sub(t, mul(r, q))
                let u := x
                x := y
                y := sub(u, mul(y, q))
                if iszero(r) { break }
            }
            x := mul(eq(g, 1), add(x, mul(slt(x, 0), n)))
        }
    }

    /// @dev Returns `ceil(x / d)`.
    /// Reverts if `d` is zero.
    function divUp(uint256 x, uint256 d) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            if iszero(d) {
                mstore(0x00, 0x65244e4e) // `DivFailed()`.
                revert(0x1c, 0x04)
            }
            z := add(iszero(iszero(mod(x, d))), div(x, d))
        }
    }

    /// @dev Returns `max(0, x - y)`. Alias for `saturatingSub`.
    function zeroFloorSub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mul(gt(x, y), sub(x, y))
        }
    }

    /// @dev Returns `max(0, x - y)`.
    function saturatingSub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mul(gt(x, y), sub(x, y))
        }
    }

    /// @dev Returns `min(2 ** 256 - 1, x + y)`.
    function saturatingAdd(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := or(sub(0, lt(add(x, y), x)), add(x, y))
        }
    }

    /// @dev Returns `min(2 ** 256 - 1, x * y)`.
    function saturatingMul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := or(sub(or(iszero(x), eq(div(mul(x, y), x), y)), 1), mul(x, y))
        }
    }

    /// @dev Returns `condition ? x : y`, without branching.
    function ternary(bool condition, uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(x, mul(xor(x, y), iszero(condition)))
        }
    }

    /// @dev Returns `condition ? x : y`, without branching.
    function ternary(bool condition, bytes32 x, bytes32 y) internal pure returns (bytes32 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(x, mul(xor(x, y), iszero(condition)))
        }
    }

    /// @dev Returns `condition ? x : y`, without branching.
    function ternary(bool condition, address x, address y) internal pure returns (address z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(x, mul(xor(x, y), iszero(condition)))
        }
    }

    /// @dev Returns `x != 0 ? x : y`, without branching.
    function coalesce(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := or(x, mul(y, iszero(x)))
        }
    }

    /// @dev Returns `x != bytes32(0) ? x : y`, without branching.
    function coalesce(bytes32 x, bytes32 y) internal pure returns (bytes32 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := or(x, mul(y, iszero(x)))
        }
    }

    /// @dev Returns `x != address(0) ? x : y`, without branching.
    function coalesce(address x, address y) internal pure returns (address z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := or(x, mul(y, iszero(shl(96, x))))
        }
    }

    /// @dev Exponentiate `x` to `y` by squaring, denominated in base `b`.
    /// Reverts if the computation overflows.
    function rpow(uint256 x, uint256 y, uint256 b) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mul(b, iszero(y)) // `0 ** 0 = 1`. Otherwise, `0 ** n = 0`.
            if x {
                z := xor(b, mul(xor(b, x), and(y, 1))) // `z = isEven(y) ? scale : x`
                let half := shr(1, b) // Divide `b` by 2.
                // Divide `y` by 2 every iteration.
                for { y := shr(1, y) } y { y := shr(1, y) } {
                    let xx := mul(x, x) // Store x squared.
                    let xxRound := add(xx, half) // Round to the nearest number.
                    // Revert if `xx + half` overflowed, or if `x ** 2` overflows.
                    if or(lt(xxRound, xx), shr(128, x)) {
                        mstore(0x00, 0x49f7642b) // `RPowOverflow()`.
                        revert(0x1c, 0x04)
                    }
                    x := div(xxRound, b) // Set `x` to scaled `xxRound`.
                    // If `y` is odd:
                    if and(y, 1) {
                        let zx := mul(z, x) // Compute `z * x`.
                        let zxRound := add(zx, half) // Round to the nearest number.
                        // If `z * x` overflowed or `zx + half` overflowed:
                        if or(xor(div(zx, x), z), lt(zxRound, zx)) {
                            // Revert if `x` is non-zero.
                            if x {
                                mstore(0x00, 0x49f7642b) // `RPowOverflow()`.
                                revert(0x1c, 0x04)
                            }
                        }
                        z := div(zxRound, b) // Return properly scaled `zxRound`.
                    }
                }
            }
        }
    }

    /// @dev Returns the square root of `x`, rounded down.
    function sqrt(uint256 x) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // `floor(sqrt(2**15)) = 181`. `sqrt(2**15) - 181 = 2.84`.
            z := 181 // The "correct" value is 1, but this saves a multiplication later.

            // This segment is to get a reasonable initial estimate for the Babylonian method. With a bad
            // start, the correct # of bits increases ~linearly each iteration instead of ~quadratically.

            // Let `y = x / 2**r`. We check `y >= 2**(k + 8)`
            // but shift right by `k` bits to ensure that if `x >= 256`, then `y >= 256`.
            let r := shl(7, lt(0xffffffffffffffffffffffffffffffffff, x))
            r := or(r, shl(6, lt(0xffffffffffffffffff, shr(r, x))))
            r := or(r, shl(5, lt(0xffffffffff, shr(r, x))))
            r := or(r, shl(4, lt(0xffffff, shr(r, x))))
            z := shl(shr(1, r), z)

            // Goal was to get `z*z*y` within a small factor of `x`. More iterations could
            // get y in a tighter range. Currently, we will have y in `[256, 256*(2**16))`.
            // We ensured `y >= 256` so that the relative difference between `y` and `y+1` is small.
            // That's not possible if `x < 256` but we can just verify those cases exhaustively.

            // Now, `z*z*y <= x < z*z*(y+1)`, and `y <= 2**(16+8)`, and either `y >= 256`, or `x < 256`.
            // Correctness can be checked exhaustively for `x < 256`, so we assume `y >= 256`.
            // Then `z*sqrt(y)` is within `sqrt(257)/sqrt(256)` of `sqrt(x)`, or about 20bps.

            // For `s` in the range `[1/256, 256]`, the estimate `f(s) = (181/1024) * (s+1)`
            // is in the range `(1/2.84 * sqrt(s), 2.84 * sqrt(s))`,
            // with largest error when `s = 1` and when `s = 256` or `1/256`.

            // Since `y` is in `[256, 256*(2**16))`, let `a = y/65536`, so that `a` is in `[1/256, 256)`.
            // Then we can estimate `sqrt(y)` using
            // `sqrt(65536) * 181/1024 * (a + 1) = 181/4 * (y + 65536)/65536 = 181 * (y + 65536)/2**18`.

            // There is no overflow risk here since `y < 2**136` after the first branch above.
            z := shr(18, mul(z, add(shr(r, x), 65536))) // A `mul()` is saved from starting `z` at 181.

            // Given the worst case multiplicative error of 2.84 above, 7 iterations should be enough.
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))

            // If `x+1` is a perfect square, the Babylonian method cycles between
            // `floor(sqrt(x))` and `ceil(sqrt(x))`. This statement ensures we return floor.
            // See: https://en.wikipedia.org/wiki/Integer_square_root#Using_only_integer_division
            z := sub(z, lt(div(x, z), z))
        }
    }

    /// @dev Returns the cube root of `x`, rounded down.
    /// Credit to bout3fiddy and pcaversaccio under AGPLv3 license:
    /// https://github.com/pcaversaccio/snekmate/blob/main/src/snekmate/utils/math.vy
    /// Formally verified by xuwinnie:
    /// https://github.com/vectorized/solady/blob/main/audits/xuwinnie-solady-cbrt-proof.pdf
    function cbrt(uint256 x) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            let r := shl(7, lt(0xffffffffffffffffffffffffffffffff, x))
            r := or(r, shl(6, lt(0xffffffffffffffff, shr(r, x))))
            r := or(r, shl(5, lt(0xffffffff, shr(r, x))))
            r := or(r, shl(4, lt(0xffff, shr(r, x))))
            r := or(r, shl(3, lt(0xff, shr(r, x))))
            // Makeshift lookup table to nudge the approximate log2 result.
            z := div(shl(div(r, 3), shl(lt(0xf, shr(r, x)), 0xf)), xor(7, mod(r, 3)))
            // Newton-Raphson's.
            z := div(add(add(div(x, mul(z, z)), z), z), 3)
            z := div(add(add(div(x, mul(z, z)), z), z), 3)
            z := div(add(add(div(x, mul(z, z)), z), z), 3)
            z := div(add(add(div(x, mul(z, z)), z), z), 3)
            z := div(add(add(div(x, mul(z, z)), z), z), 3)
            z := div(add(add(div(x, mul(z, z)), z), z), 3)
            z := div(add(add(div(x, mul(z, z)), z), z), 3)
            // Round down.
            z := sub(z, lt(div(x, mul(z, z)), z))
        }
    }

    /// @dev Returns the square root of `x`, denominated in `WAD`, rounded down.
    function sqrtWad(uint256 x) internal pure returns (uint256 z) {
        unchecked {
            if (x <= type(uint256).max / 10 ** 18) return sqrt(x * 10 ** 18);
            z = (1 + sqrt(x)) * 10 ** 9;
            z = (fullMulDivUnchecked(x, 10 ** 18, z) + z) >> 1;
        }
        /// @solidity memory-safe-assembly
        assembly {
            z := sub(z, gt(999999999999999999, sub(mulmod(z, z, x), 1))) // Round down.
        }
    }

    /// @dev Returns the cube root of `x`, denominated in `WAD`, rounded down.
    /// Formally verified by xuwinnie:
    /// https://github.com/vectorized/solady/blob/main/audits/xuwinnie-solady-cbrt-proof.pdf
    function cbrtWad(uint256 x) internal pure returns (uint256 z) {
        unchecked {
            if (x <= type(uint256).max / 10 ** 36) return cbrt(x * 10 ** 36);
            z = (1 + cbrt(x)) * 10 ** 12;
            z = (fullMulDivUnchecked(x, 10 ** 36, z * z) + z + z) / 3;
        }
        /// @solidity memory-safe-assembly
        assembly {
            let p := x
            for {} 1 {} {
                if iszero(shr(229, p)) {
                    if iszero(shr(199, p)) {
                        p := mul(p, 100000000000000000) // 10 ** 17.
                        break
                    }
                    p := mul(p, 100000000) // 10 ** 8.
                    break
                }
                if iszero(shr(249, p)) { p := mul(p, 100) }
                break
            }
            let t := mulmod(mul(z, z), z, p)
            z := sub(z, gt(lt(t, shr(1, p)), iszero(t))) // Round down.
        }
    }

    /// @dev Returns `sqrt(x * y)`. Also called the geometric mean.
    function mulSqrt(uint256 x, uint256 y) internal pure returns (uint256 z) {
        if (x == y) return x;
        uint256 p = rawMul(x, y);
        if (y == rawDiv(p, x)) return sqrt(p);
        for (z = saturatingMul(rawAdd(sqrt(x), 1), rawAdd(sqrt(y), 1));; z = avg(z, p)) {
            if ((p = fullMulDivUnchecked(x, y, z)) >= z) break;
        }
    }

    /// @dev Returns the factorial of `x`.
    function factorial(uint256 x) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := 1
            if iszero(lt(x, 58)) {
                mstore(0x00, 0xaba0f2a2) // `FactorialOverflow()`.
                revert(0x1c, 0x04)
            }
            for {} x { x := sub(x, 1) } { z := mul(z, x) }
        }
    }

    /// @dev Returns the log2 of `x`.
    /// Equivalent to computing the index of the most significant bit (MSB) of `x`.
    /// Returns 0 if `x` is zero.
    function log2(uint256 x) internal pure returns (uint256 r) {
        /// @solidity memory-safe-assembly
        assembly {
            r := shl(7, lt(0xffffffffffffffffffffffffffffffff, x))
            r := or(r, shl(6, lt(0xffffffffffffffff, shr(r, x))))
            r := or(r, shl(5, lt(0xffffffff, shr(r, x))))
            r := or(r, shl(4, lt(0xffff, shr(r, x))))
            r := or(r, shl(3, lt(0xff, shr(r, x))))
            // forgefmt: disable-next-item
            r := or(r, byte(and(0x1f, shr(shr(r, x), 0x8421084210842108cc6318c6db6d54be)),
                0x0706060506020504060203020504030106050205030304010505030400000000))
        }
    }

    /// @dev Returns the log2 of `x`, rounded up.
    /// Returns 0 if `x` is zero.
    function log2Up(uint256 x) internal pure returns (uint256 r) {
        r = log2(x);
        /// @solidity memory-safe-assembly
        assembly {
            r := add(r, lt(shl(r, 1), x))
        }
    }

    /// @dev Returns the log10 of `x`.
    /// Returns 0 if `x` is zero.
    function log10(uint256 x) internal pure returns (uint256 r) {
        /// @solidity memory-safe-assembly
        assembly {
            if iszero(lt(x, 100000000000000000000000000000000000000)) {
                x := div(x, 100000000000000000000000000000000000000)
                r := 38
            }
            if iszero(lt(x, 100000000000000000000)) {
                x := div(x, 100000000000000000000)
                r := add(r, 20)
            }
            if iszero(lt(x, 10000000000)) {
                x := div(x, 10000000000)
                r := add(r, 10)
            }
            if iszero(lt(x, 100000)) {
                x := div(x, 100000)
                r := add(r, 5)
            }
            r := add(r, add(gt(x, 9), add(gt(x, 99), add(gt(x, 999), gt(x, 9999)))))
        }
    }

    /// @dev Returns the log10 of `x`, rounded up.
    /// Returns 0 if `x` is zero.
    function log10Up(uint256 x) internal pure returns (uint256 r) {
        r = log10(x);
        /// @solidity memory-safe-assembly
        assembly {
            r := add(r, lt(exp(10, r), x))
        }
    }

    /// @dev Returns the log256 of `x`.
    /// Returns 0 if `x` is zero.
    function log256(uint256 x) internal pure returns (uint256 r) {
        /// @solidity memory-safe-assembly
        assembly {
            r := shl(7, lt(0xffffffffffffffffffffffffffffffff, x))
            r := or(r, shl(6, lt(0xffffffffffffffff, shr(r, x))))
            r := or(r, shl(5, lt(0xffffffff, shr(r, x))))
            r := or(r, shl(4, lt(0xffff, shr(r, x))))
            r := or(shr(3, r), lt(0xff, shr(r, x)))
        }
    }

    /// @dev Returns the log256 of `x`, rounded up.
    /// Returns 0 if `x` is zero.
    function log256Up(uint256 x) internal pure returns (uint256 r) {
        r = log256(x);
        /// @solidity memory-safe-assembly
        assembly {
            r := add(r, lt(shl(shl(3, r), 1), x))
        }
    }

    /// @dev Returns the scientific notation format `mantissa * 10 ** exponent` of `x`.
    /// Useful for compressing prices (e.g. using 25 bit mantissa and 7 bit exponent).
    function sci(uint256 x) internal pure returns (uint256 mantissa, uint256 exponent) {
        /// @solidity memory-safe-assembly
        assembly {
            mantissa := x
            if mantissa {
                if iszero(mod(mantissa, 1000000000000000000000000000000000)) {
                    mantissa := div(mantissa, 1000000000000000000000000000000000)
                    exponent := 33
                }
                if iszero(mod(mantissa, 10000000000000000000)) {
                    mantissa := div(mantissa, 10000000000000000000)
                    exponent := add(exponent, 19)
                }
                if iszero(mod(mantissa, 1000000000000)) {
                    mantissa := div(mantissa, 1000000000000)
                    exponent := add(exponent, 12)
                }
                if iszero(mod(mantissa, 1000000)) {
                    mantissa := div(mantissa, 1000000)
                    exponent := add(exponent, 6)
                }
                if iszero(mod(mantissa, 10000)) {
                    mantissa := div(mantissa, 10000)
                    exponent := add(exponent, 4)
                }
                if iszero(mod(mantissa, 100)) {
                    mantissa := div(mantissa, 100)
                    exponent := add(exponent, 2)
                }
                if iszero(mod(mantissa, 10)) {
                    mantissa := div(mantissa, 10)
                    exponent := add(exponent, 1)
                }
            }
        }
    }

    /// @dev Convenience function for packing `x` into a smaller number using `sci`.
    /// The `mantissa` will be in bits [7..255] (the upper 249 bits).
    /// The `exponent` will be in bits [0..6] (the lower 7 bits).
    /// Use `SafeCastLib` to safely ensure that the `packed` number is small
    /// enough to fit in the desired unsigned integer type:
    /// ```
    ///     uint32 packed = SafeCastLib.toUint32(FixedPointMathLib.packSci(777 ether));
    /// ```
    function packSci(uint256 x) internal pure returns (uint256 packed) {
        (x, packed) = sci(x); // Reuse for `mantissa` and `exponent`.
        /// @solidity memory-safe-assembly
        assembly {
            if shr(249, x) {
                mstore(0x00, 0xce30380c) // `MantissaOverflow()`.
                revert(0x1c, 0x04)
            }
            packed := or(shl(7, x), packed)
        }
    }

    /// @dev Convenience function for unpacking a packed number from `packSci`.
    function unpackSci(uint256 packed) internal pure returns (uint256 unpacked) {
        unchecked {
            unpacked = (packed >> 7) * 10 ** (packed & 0x7f);
        }
    }

    /// @dev Returns the average of `x` and `y`. Rounds towards zero.
    function avg(uint256 x, uint256 y) internal pure returns (uint256 z) {
        unchecked {
            z = (x & y) + ((x ^ y) >> 1);
        }
    }

    /// @dev Returns the average of `x` and `y`. Rounds towards negative infinity.
    function avg(int256 x, int256 y) internal pure returns (int256 z) {
        unchecked {
            z = (x >> 1) + (y >> 1) + (x & y & 1);
        }
    }

    /// @dev Returns the absolute value of `x`.
    function abs(int256 x) internal pure returns (uint256 z) {
        unchecked {
            z = (uint256(x) + uint256(x >> 255)) ^ uint256(x >> 255);
        }
    }

    /// @dev Returns the absolute distance between `x` and `y`.
    function dist(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := add(xor(sub(0, gt(x, y)), sub(y, x)), gt(x, y))
        }
    }

    /// @dev Returns the absolute distance between `x` and `y`.
    function dist(int256 x, int256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := add(xor(sub(0, sgt(x, y)), sub(y, x)), sgt(x, y))
        }
    }

    /// @dev Returns the minimum of `x` and `y`.
    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(x, mul(xor(x, y), lt(y, x)))
        }
    }

    /// @dev Returns the minimum of `x` and `y`.
    function min(int256 x, int256 y) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(x, mul(xor(x, y), slt(y, x)))
        }
    }

    /// @dev Returns the maximum of `x` and `y`.
    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(x, mul(xor(x, y), gt(y, x)))
        }
    }

    /// @dev Returns the maximum of `x` and `y`.
    function max(int256 x, int256 y) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(x, mul(xor(x, y), sgt(y, x)))
        }
    }

    /// @dev Returns `x`, bounded to `minValue` and `maxValue`.
    function clamp(uint256 x, uint256 minValue, uint256 maxValue) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(x, mul(xor(x, minValue), gt(minValue, x)))
            z := xor(z, mul(xor(z, maxValue), lt(maxValue, z)))
        }
    }

    /// @dev Returns `x`, bounded to `minValue` and `maxValue`.
    function clamp(int256 x, int256 minValue, int256 maxValue) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(x, mul(xor(x, minValue), sgt(minValue, x)))
            z := xor(z, mul(xor(z, maxValue), slt(maxValue, z)))
        }
    }

    /// @dev Returns greatest common divisor of `x` and `y`.
    function gcd(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            for { z := x } y {} {
                let t := y
                y := mod(z, y)
                z := t
            }
        }
    }

    /// @dev Returns `a + (b - a) * (t - begin) / (end - begin)`,
    /// with `t` clamped between `begin` and `end` (inclusive).
    /// Agnostic to the order of (`a`, `b`) and (`end`, `begin`).
    /// If `begins == end`, returns `t <= begin ? a : b`.
    function lerp(uint256 a, uint256 b, uint256 t, uint256 begin, uint256 end) internal pure returns (uint256) {
        if (begin > end) (t, begin, end) = (~t, ~begin, ~end);
        if (t <= begin) return a;
        if (t >= end) return b;
        unchecked {
            if (b >= a) return a + fullMulDiv(b - a, t - begin, end - begin);
            return a - fullMulDiv(a - b, t - begin, end - begin);
        }
    }

    /// @dev Returns `a + (b - a) * (t - begin) / (end - begin)`.
    /// with `t` clamped between `begin` and `end` (inclusive).
    /// Agnostic to the order of (`a`, `b`) and (`end`, `begin`).
    /// If `begins == end`, returns `t <= begin ? a : b`.
    function lerp(int256 a, int256 b, int256 t, int256 begin, int256 end) internal pure returns (int256) {
        if (begin > end) (t, begin, end) = (~t, ~begin, ~end);
        if (t <= begin) return a;
        if (t >= end) return b;
        // forgefmt: disable-next-item
        unchecked {
            if (b >= a) return int256(uint256(a) + fullMulDiv(uint256(b - a),
                uint256(t - begin), uint256(end - begin)));
            return int256(uint256(a) - fullMulDiv(uint256(a - b),
                uint256(t - begin), uint256(end - begin)));
        }
    }

    /// @dev Returns if `x` is an even number. Some people may need this.
    function isEven(uint256 x) internal pure returns (bool) {
        return x & uint256(1) == uint256(0);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   RAW NUMBER OPERATIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Returns `x + y`, without checking for overflow.
    function rawAdd(uint256 x, uint256 y) internal pure returns (uint256 z) {
        unchecked {
            z = x + y;
        }
    }

    /// @dev Returns `x + y`, without checking for overflow.
    function rawAdd(int256 x, int256 y) internal pure returns (int256 z) {
        unchecked {
            z = x + y;
        }
    }

    /// @dev Returns `x - y`, without checking for underflow.
    function rawSub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        unchecked {
            z = x - y;
        }
    }

    /// @dev Returns `x - y`, without checking for underflow.
    function rawSub(int256 x, int256 y) internal pure returns (int256 z) {
        unchecked {
            z = x - y;
        }
    }

    /// @dev Returns `x * y`, without checking for overflow.
    function rawMul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        unchecked {
            z = x * y;
        }
    }

    /// @dev Returns `x * y`, without checking for overflow.
    function rawMul(int256 x, int256 y) internal pure returns (int256 z) {
        unchecked {
            z = x * y;
        }
    }

    /// @dev Returns `x / y`, returning 0 if `y` is zero.
    function rawDiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := div(x, y)
        }
    }

    /// @dev Returns `x / y`, returning 0 if `y` is zero.
    function rawSDiv(int256 x, int256 y) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := sdiv(x, y)
        }
    }

    /// @dev Returns `x % y`, returning 0 if `y` is zero.
    function rawMod(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mod(x, y)
        }
    }

    /// @dev Returns `x % y`, returning 0 if `y` is zero.
    function rawSMod(int256 x, int256 y) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := smod(x, y)
        }
    }

    /// @dev Returns `(x + y) % d`, return 0 if `d` if zero.
    function rawAddMod(uint256 x, uint256 y, uint256 d) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := addmod(x, y, d)
        }
    }

    /// @dev Returns `(x * y) % d`, return 0 if `d` if zero.
    function rawMulMod(uint256 x, uint256 y, uint256 d) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mulmod(x, y, d)
        }
    }
}

// lib/openzeppelin-contracts/contracts/access/IAccessControl.sol

// OpenZeppelin Contracts (last updated v5.4.0) (access/IAccessControl.sol)

/**
 * @dev External interface of AccessControl declared to support ERC-165 detection.
 */
interface IAccessControl {
    /**
     * @dev The `account` is missing a role.
     */
    error AccessControlUnauthorizedAccount(address account, bytes32 neededRole);

    /**
     * @dev The caller of a function is not the expected one.
     *
     * NOTE: Don't confuse with {AccessControlUnauthorizedAccount}.
     */
    error AccessControlBadConfirmation();

    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted to signal this.
     */
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call. This account bears the admin role (for the granted role).
     * Expected in cases where the role was granted using the internal {AccessControl-_grantRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) external view returns (bool);

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {AccessControl-_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `callerConfirmation`.
     */
    function renounceRole(bytes32 role, address callerConfirmation) external;
}

// src/interfaces/slasher/IBurner.sol

/**
 * @title IBurner
 * @notice Interface for the Burner contract.
 */
interface IBurner {
    /**
     * @notice Called when a slash happens.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param operator Address of the operator.
     * @param amount Virtual amount of the collateral slashed.
     * @param captureTimestamp Time point when the stake was captured.
     */
    function onSlash(bytes32 subnetwork, address operator, uint256 amount, uint48 captureTimestamp) external;
}

// src/interfaces/delegator/IDelegatorHookV2.sol

/**
 * @title IDelegatorHook
 * @notice Interface for the DelegatorHook contract.
 */
interface IDelegatorHook {
    /**
     * @notice Called when a slash happens.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param operator Address of the operator.
     * @param amount Amount of the collateral to be slashed.
     * @param data Some additional data.
     */
    function onSlash(bytes32 subnetwork, address operator, uint256 amount, bytes calldata data) external;
}

// lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol

// OpenZeppelin Contracts (last updated v5.4.0) (utils/introspection/IERC165.sol)

/**
 * @dev Interface of the ERC-165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[ERC].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[ERC section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol

// OpenZeppelin Contracts (last updated v5.4.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// src/interfaces/common/IEntity.sol

/**
 * @title IEntity
 * @notice Interface for the Entity contract.
 */
interface IEntity {
    error NotInitialized();

    /**
     * @notice Get the factory's address.
     * @return Address Of the factory.
     */
    function FACTORY() external view returns (address);

    /**
     * @notice Get the entity's type.
     * @return Type Of the entity.
     */
    function TYPE() external view returns (uint64);

    /**
     * @notice Initialize this entity contract by using a given data.
     * @param data Some data to use.
     */
    function initialize(bytes calldata data) external;
}

// src/interfaces/vault/IFeeRegistry.sol

uint256 constant MAX_FEE = 1_000_000;

interface IFeeRegistry {
    function getInstantWithdrawFee(address vault) external view returns (uint256 fee);
}

// src/interfaces/common/IMigratableEntity.sol

/**
 * @title IMigratableEntity
 * @notice Interface for the MigratableEntity contract.
 */
interface IMigratableEntity {
    error AlreadyInitialized();
    error NotFactory();
    error NotInitialized();

    /**
     * @notice Get the factory's address.
     * @return Address Of the factory.
     */
    function FACTORY() external view returns (address);

    /**
     * @notice Get the entity's version.
     * @return Version Of the entity.
     * @dev Starts from 1.
     */
    function version() external view returns (uint64);

    /**
     * @notice Initialize this entity contract by using a given data and setting a particular version and owner.
     * @param initialVersion Initial version of the entity.
     * @param owner Initial owner of the entity.
     * @param data Some data to use.
     */
    function initialize(uint64 initialVersion, address owner, bytes calldata data) external;

    /**
     * @notice Migrate this entity to a particular newer version using a given data.
     * @param newVersion New version of the entity.
     * @param data Some data to use.
     */
    function migrate(uint64 newVersion, bytes calldata data) external;
}

// src/interfaces/service/INetworkMiddlewareService.sol

/**
 * @title INetworkMiddlewareService
 * @notice Interface for the NetworkMiddlewareService contract.
 */
interface INetworkMiddlewareService {
    error AlreadySet();
    error NotNetwork();

    /**
     * @notice Emitted when a middleware is set for a network.
     * @param network Address of the network.
     * @param middleware New middleware of the network.
     */
    event SetMiddleware(address indexed network, address middleware);

    /**
     * @notice Get the network registry's address.
     * @return Address Of the network registry.
     */
    function NETWORK_REGISTRY() external view returns (address);

    /**
     * @notice Get a given network's middleware.
     * @param network Address of the network.
     * @return Middleware Of the network.
     */
    function middleware(address network) external view returns (address);

    /**
     * @notice Set a new middleware for a calling network.
     * @param middleware New middleware of the network.
     */
    function setMiddleware(address middleware) external;
}

// src/interfaces/vault/IPluginBase.sol

/**
 * @title IPluginBase
 * @notice Interface for the PluginBase contract.
 */
interface IPluginBase {
    /**
     * @notice Get the current skimmable balance of the vault.
     * @param vault Address of the vault.
     */
    function skimmable(address vault) external view returns (uint256);

    /**
     * @notice Get the amount of collateral that can be allocated to the plugin.
     * @param vault Address of the vault.
     * @return Amount Of collateral that can be allocated to the plugin.
     */
    function allocatable(address vault) external view returns (uint256);

    /**
     * @notice Get the amount of collateral that can be deallocated from the plugin instantly.
     * @return Amount Of collateral that can be deallocated from the plugin.
     */
    function deallocatable(address vault) external view returns (uint256);

    /**
     * @notice Allocate collateral to the plugin.
     * @param amount Amount of the collateral to allocate.
     * @dev Must not revert.
     */
    function allocate(uint256 amount) external;

    /**
     * @notice Deallocate collateral from the plugin instantly.
     * @param amount Amount of the collateral to deallocate.
     * @return Amount Of the collateral deallocated.
     * @dev Must not revert.
     */
    function deallocate(uint256 amount) external returns (uint256);

    /**
     * @notice Skim the collateral from the plugin.
     * @param vault Address of the vault.
     * @return Amount Of the collateral skimmed.
     * @dev Must not revert.
     */
    function skim(address vault) external returns (uint256);
}

// src/interfaces/common/IRegistry.sol

/**
 * @title IRegistry
 * @notice Interface for the Registry contract.
 */
interface IRegistry {
    error EntityNotExist();

    /**
     * @notice Emitted when an entity is added.
     * @param entity Address of the added entity.
     */
    event AddEntity(address indexed entity);

    /**
     * @notice Get if a given address is an entity.
     * @param account Address to check.
     * @return If The given address is an entity.
     */
    function isEntity(address account) external view returns (bool);

    /**
     * @notice Get a total number of entities.
     * @return Total Number of entities added.
     */
    function totalEntities() external view returns (uint256);

    /**
     * @notice Get an entity given its index.
     * @param index Index of the entity to get.
     * @return Address Of the entity.
     */
    function entity(uint256 index) external view returns (address);
}

// src/interfaces/vault/IRewards.sol

/**
 * @title IRewards
 * @notice Interface for the Rewards contract.
 */
interface IRewards {
    function distributeDonationRewards(address vault, uint256 amount) external;
}

// src/interfaces/common/IStaticDelegateCallable.sol

/**
 * @title IStaticDelegateCallable
 * @notice Interface for the StaticDelegateCallable contract.
 */
interface IStaticDelegateCallable {
    /**
     * @notice Make a delegatecall from this contract to a given target contract with a particular data (always reverts with a return data).
     * @param target Address of the contract to make a delegatecall to.
     * @param data Data to make a delegatecall with.
     * @dev It allows to use this contract's storage on-chain.
     */
    function staticDelegateCall(address target, bytes calldata data) external;
}

// src/interfaces/delegator/IUniversalDelegator.sol

uint64 constant UNIVERSAL_DELEGATOR_TYPE = 4;

uint32 constant WITHDRAWAL_BUFFER_CHILD_INDEX = 0xFFFFFFFF;
uint96 constant WITHDRAWAL_BUFFER_INDEX = 0xFFFFFFFF0000000000000000;

// Keccak256("HOOK_SET_ROLE").
bytes32 constant HOOK_SET_ROLE = 0xd1c1f6fa6bf27d54c5e54c7c1dc6e5004d3c027ea1994fe68b29c1b51b69c36c;

uint256 constant HOOK_GAS_LIMIT = 250_000;
uint256 constant HOOK_RESERVE = 20_000;

// Keccak256("CREATE_SLOT_ROLE").
bytes32 constant CREATE_SLOT_ROLE = 0x8aef711962d032b5812b71f6f4353b179696ada38e16233a26a539c32c729007;
// Keccak256("SET_SIZE_ROLE").
bytes32 constant SET_SIZE_ROLE = 0xc9c130a1412d72f4d79081ca47a83fb21e212d7ff57949aadd2c1356e17ee837;
// Keccak256("SWAP_SLOTS_ROLE").
bytes32 constant SWAP_SLOTS_ROLE = 0xffd98ac79bb60993f79efa77ec34b3f446950a5c284ae3036fc0fb810a00af60;
// Keccak256("REMOVE_SLOT_ROLE").
bytes32 constant REMOVE_SLOT_ROLE = 0x1cbee842b8b18f1dea4a0fb8117bb405b26bede02a0f7f47acb5d727ef90e6f4;
// Keccak256("SET_WITHDRAWAL_BUFFER_SIZE_ROLE").
bytes32 constant SET_WITHDRAWAL_BUFFER_SIZE_ROLE = 0x6f48b129515ad8dd335666ffdfdf6533e7a5a9a9cd01b8a62f938f739fc9a4ce;

uint256 constant MAX_SUBVAULTS = 10;
uint256 constant MAX_NETWORKS = 15;
uint256 constant MAX_OPERATORS = 20;

/**
 * @title IUniversalDelegator
 * @notice Interface for the UniversalDelegator contract.
 */
interface IUniversalDelegator {
    /* ERRORS */

    /**
     * @notice Raised when a network or operator is already assigned to a slot.
     */
    error AlreadyAssigned();

    /**
     * @notice Raised when a maximum network limit is already set.
     */
    error AlreadySet();

    /**
     * @notice Raised when there is not enough gas for the hook call.
     */
    error InsufficientHookGas();

    /**
     * @notice Raised when an operation is incompatible with shared mode.
     */
    error IsShared();

    /**
     * @notice Raised when the provided maximum network limit is not 2^256-1.
     */
    error LimitNotUint256Max();

    /**
     * @notice Raised when no slot is assigned for the requested subject.
     */
    error NotAssigned();

    /**
     * @notice Raised when there is not enough balance for the operation.
     */
    error NotEnoughBalance();

    /**
     * @notice Raised when requested no-plugins capacity exceeds available amount.
     */
    error NotEnoughNoPlugins();

    /**
     * @notice Raised when migration functions are called outside migration mode.
     */
    error NotMigrating();

    /**
     * @notice Raised when the caller is not a registered network.
     */
    error NotNetwork();

    /**
     * @notice Raised when the caller is neither a network nor its middleware.
     */
    error NotNetworkOrMiddleware();

    /**
     * @notice Raised when two slots are not in the same allocation state.
     */
    error NotSameAllocated();

    /**
     * @notice Raised when two slots do not have the same parent.
     */
    error NotSameParent();

    /**
     * @notice Raised when the caller is not the vault slasher.
     */
    error NotSlasher();

    /**
     * @notice Raised when the provided vault is invalid.
     */
    error NotVault();

    /**
     * @notice Raised when the connected vault version is older than required.
     */
    error OldVault();

    /**
     * @notice Raised when a slot is only partially allocated and cannot be moved.
     */
    error PartiallyAllocated();

    /**
     * @notice Raised when trying to remove a slot that still has allocation.
     */
    error SlotAllocated();

    /**
     * @notice Raised when the requested slot does not exist.
     */
    error SlotNotExists();

    /**
     * @notice Raised when the maximum number of children for a slot is exceeded.
     */
    error TooManyChildren();

    /**
     * @notice Raised when a slot operation is attempted at an invalid hierarchy depth.
     */
    error WrongDepth();

    /**
     * @notice Raised when slot ordering constraints are violated.
     */
    error WrongOrder();

    /* STRUCTS */

    /**
     * @notice Slot snapshot data.
     * @param exists Whether the slot exists.
     * @param nextSlot Next sibling child index.
     * @param prevSlot Previous sibling child index.
     * @param totalChildren Total number of children ever created.
     * @param existChildren Number of currently existing children.
     * @param firstChild First child index.
     * @param lastChild Last child index.
     * @param isShared Whether slot allocation is shared among children.
     * @param noPlugins Whether slot stake must stay outside plugins.
     * @param size Slot size value.
     * @param prevSizeSum Prefix sum of previous sibling sizes.
     * @param subnetworkOrOperator Subnetwork or operator identifier or zero if not assigned.
     */
    struct Slot {
        bool exists;
        uint32 nextSlot;
        uint32 prevSlot;
        uint32 totalChildren;
        uint32 existChildren;
        uint32 firstChild;
        uint32 lastChild;
        bool isShared;
        bool noPlugins;
        uint128 size;
        uint208 prevSizeSum;
        bytes32 subnetworkOrOperator;
    }

    /**
     * @notice Initialization parameters for the universal delegator.
     * @param defaultAdminRoleHolder Address of the initial DEFAULT_ADMIN_ROLE holder.
     * @param hook Address of the hook contract.
     * @param hookSetRoleHolder Address of the initial HOOK_SET_ROLE holder.
     * @param createSlotRoleHolder Address of the initial CREATE_SLOT_ROLE holder.
     * @param setSizeRoleHolder Address of the initial SET_SIZE_ROLE holder.
     * @param swapSlotsRoleHolder Address of the initial SWAP_SLOTS_ROLE holder.
     * @param withdrawalBufferSize Initial withdrawal buffer size.
     */
    struct InitParams {
        address defaultAdminRoleHolder;
        address hook;
        address hookSetRoleHolder;
        address createSlotRoleHolder;
        address setSizeRoleHolder;
        address swapSlotsRoleHolder;
        uint128 withdrawalBufferSize;
    }

    /**
     * @notice Base parameters needed for delegators' deployment.
     * @param defaultAdminRoleHolder Address of the initial DEFAULT_ADMIN_ROLE holder.
     * @param hook Address of the hook contract.
     * @param hookSetRoleHolder Address of the initial HOOK_SET_ROLE holder.
     */
    struct BaseParams {
        address defaultAdminRoleHolder;
        address hook;
        address hookSetRoleHolder;
    }

    /* EVENTS */

    /**
     * @notice Emitted when a slot is created.
     * @param index Index of the created slot.
     * @param isShared Whether the slot is shared.
     * @param noPlugins Whether the slot is marked as no-plugins.
     * @param size Initial slot size.
     */
    event CreateSlot(uint96 indexed index, bool isShared, bool noPlugins, uint128 size);

    /**
     * @notice Emitted when a slot size is updated.
     * @param index Slot index.
     * @param size New slot size.
     */
    event SetSize(uint96 indexed index, uint128 size);

    /**
     * @notice Emitted when two sibling slots are swapped.
     * @param index1 First slot index.
     * @param index2 Second slot index.
     */
    event SwapSlots(uint96 indexed index1, uint96 indexed index2);

    /**
     * @notice Emitted when a slot is removed.
     * @param index Removed slot index.
     */
    event RemoveSlot(uint96 indexed index);

    /**
     * @notice Emitted when a subnetwork allocation is reset.
     * @param index Slot index that was removed.
     * @param subnetwork Full subnetwork identifier.
     */
    event ResetAllocation(uint96 indexed index, bytes32 indexed subnetwork);

    /**
     * @notice Emitted when withdrawal buffer size is updated.
     * @param newWithdrawalBufferSize New withdrawal buffer size.
     */
    event SetWithdrawalBufferSize(uint128 newWithdrawalBufferSize);

    /**
     * @notice Emitted when a subnetwork's maximum limit is set.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param amount New maximum subnetwork's limit (how much stake the subnetwork is ready to get).
     */
    event SetMaxNetworkLimit(bytes32 indexed subnetwork, uint256 amount);

    /**
     * @notice Emitted when a hook is set.
     * @param hook Address of the hook.
     */
    event SetHook(address indexed hook);

    /**
     * @notice Emitted when a slash is applied.
     * @param subnetwork Full identifier of the subnetwork.
     * @param operator Address of the operator.
     * @param amount Slashed amount.
     */
    event OnSlash(bytes32 indexed subnetwork, address indexed operator, uint256 amount);

    /**
     * @notice Emitted when the delegator is initialized.
     * @param params Initialization parameters.
     */
    event Initialize(InitParams params);

    /* FUNCTIONS */

    /**
     * @notice Execute a batch of delegatecalls on the delegator.
     * @param data Calldata items to execute.
     */
    function multicall(bytes[] calldata data) external;

    /**
     * @notice Get the delegator implementation version.
     * @return version Delegator version.
     */
    function VERSION() external view returns (uint64 version);

    /**
     * @notice Get the associated vault address.
     * @return vaultAddress Address of the vault.
     */
    function vault() external view returns (address vaultAddress);

    /**
     * @notice Get the hook contract address.
     * @return hookAddress Address of the hook contract.
     */
    function hook() external view returns (address hookAddress);

    /**
     * @notice Get slashable stake for a subnetwork/operator at a timestamp and duration.
     * @param subnetwork Full identifier of the subnetwork.
     * @param operator Address of the operator.
     * @param duration Duration window.
     * @param timestamp Capture timestamp.
     * @return amount Slashable amount.
     */
    function stakeForAt(bytes32 subnetwork, address operator, uint48 duration, uint48 timestamp)
        external
        view
        returns (uint256 amount);

    /**
     * @notice Get slashable stake for a subnetwork/operator for the current timestamp and duration.
     * @param subnetwork Full identifier of the subnetwork.
     * @param operator Address of the operator.
     * @param duration Duration window.
     * @return amount Slashable amount.
     */
    function stakeFor(bytes32 subnetwork, address operator, uint48 duration) external view returns (uint256 amount);

    /**
     * @notice Get slashable stake for a subnetwork/operator at a specific timestamp.
     * @param subnetwork Full identifier of the subnetwork.
     * @param operator Address of the operator.
     * @param timestamp Capture timestamp.
     * @return amount Slashable amount.
     */
    function stakeAt(bytes32 subnetwork, address operator, uint48 timestamp, bytes calldata)
        external
        view
        returns (uint256 amount);

    /**
     * @notice Get slashable stake for a subnetwork/operator for the current epoch context.
     * @param subnetwork Full identifier of the subnetwork.
     * @param operator Address of the operator.
     * @return amount Slashable amount.
     */
    function stake(bytes32 subnetwork, address operator) external view returns (uint256 amount);

    /**
     * @notice Get slot metadata for an index.
     * @param index Slot index.
     * @return slot Slot data snapshot.
     */
    function getSlot(uint96 index) external view returns (Slot memory slot);

    /**
     * @notice Get slot pending amount at a timestamp.
     * @param index Slot index.
     * @param duration Duration window.
     * @param timestamp Lookup timestamp.
     * @return pending Slot pending amount.
     */
    function getPendingAt(uint96 index, uint48 duration, uint48 timestamp) external view returns (uint208 pending);

    /**
     * @notice Get current slot pending amount.
     * @param index Slot index.
     * @param duration Duration window.
     * @return pending Slot pending amount.
     */
    function getPending(uint96 index, uint48 duration) external view returns (uint208 pending);

    /**
     * @notice Get slot balance at a timestamp.
     * @param index Slot index.
     * @param duration Duration window.
     * @param timestamp Lookup timestamp.
     * @return balance Slot balance.
     */
    function getBalanceAt(uint96 index, uint48 duration, uint48 timestamp) external view returns (uint256 balance);

    /**
     * @notice Get current slot balance.
     * @param index Slot index.
     * @param duration Duration window.
     * @return balance Slot balance.
     */
    function getBalance(uint96 index, uint48 duration) external view returns (uint256 balance);

    /**
     * @notice Get allocated amount for a slot index at a timestamp.
     * @param index Slot index.
     * @param duration Duration window.
     * @param timestamp Lookup timestamp.
     * @return allocated Allocated amount.
     */
    function getAllocatedAt(uint96 index, uint48 duration, uint48 timestamp) external view returns (uint256 allocated);

    /**
     * @notice Get current allocated amount for a slot index.
     * @param index Slot index.
     * @param duration Duration window.
     * @return allocated Allocated amount.
     */
    function getAllocated(uint96 index, uint48 duration) external view returns (uint256 allocated);

    /**
     * @notice Get allocated amount for a subnetwork/operator at a timestamp.
     * @param subnetwork Full identifier of the subnetwork.
     * @param operator Address of the operator.
     * @param duration Duration window.
     * @param timestamp Lookup timestamp.
     * @return allocated Allocated amount.
     */
    function getAllocatedAt(bytes32 subnetwork, address operator, uint48 duration, uint48 timestamp)
        external
        view
        returns (uint256 allocated);

    /**
     * @notice Get current allocated amount for a subnetwork/operator.
     * @param subnetwork Full identifier of the subnetwork.
     * @param operator Address of the operator.
     * @param duration Duration window.
     * @return allocated Allocated amount.
     */
    function getAllocated(bytes32 subnetwork, address operator, uint48 duration)
        external
        view
        returns (uint256 allocated);

    /**
     * @notice Get filled amount at a timestamp.
     * @param index Slot index.
     * @param duration Duration window.
     * @param timestamp Lookup timestamp.
     * @return filled Filled amount.
     */
    function getFilledAt(uint96 index, uint48 duration, uint48 timestamp) external view returns (uint256 filled);

    /**
     * @notice Get current filled amount.
     * @param index Slot index.
     * @param duration Duration window.
     * @return filled Filled amount.
     */
    function getFilled(uint96 index, uint48 duration) external view returns (uint256 filled);

    /**
     * @notice Get assigned slot of a network at a timestamp.
     * @param subnetwork Full identifier of the subnetwork.
     * @param timestamp Lookup timestamp.
     * @return index Slot index.
     */
    function getSlotOfNetworkAt(bytes32 subnetwork, uint48 timestamp) external view returns (uint96 index);

    /**
     * @notice Get current assigned slot of a network.
     * @param subnetwork Full identifier of the subnetwork.
     * @return index Slot index.
     */
    function getSlotOfNetwork(bytes32 subnetwork) external view returns (uint96 index);

    /**
     * @notice Get assigned operator slot at a timestamp.
     * @param parentIndex Parent slot index.
     * @param operator Address of the operator.
     * @param timestamp Lookup timestamp.
     * @return index Slot index.
     */
    function getSlotOfOperatorAt(uint96 parentIndex, address operator, uint48 timestamp)
        external
        view
        returns (uint96 index);

    /**
     * @notice Get current assigned operator slot.
     * @param parentIndex Parent slot index.
     * @param operator Address of the operator.
     * @return index Slot index.
     */
    function getSlotOfOperator(uint96 parentIndex, address operator) external view returns (uint96 index);

    /**
     * @notice Get assigned slot for a subnetwork/operator at a timestamp.
     * @param subnetwork Full identifier of the subnetwork.
     * @param operator Address of the operator.
     * @param timestamp Lookup timestamp.
     * @return index Slot index.
     */
    function getSlotOfAt(bytes32 subnetwork, address operator, uint48 timestamp) external view returns (uint96 index);

    /**
     * @notice Get current assigned slot for a subnetwork/operator.
     * @param subnetwork Full identifier of the subnetwork.
     * @param operator Address of the operator.
     * @return index Slot index.
     */
    function getSlotOf(bytes32 subnetwork, address operator) external view returns (uint96 index);

    /**
     * @notice Get the legacy maximum limit value for a subnetwork.
     * @param subnetwork Full identifier of the subnetwork.
     * @return limit Maximum possible uint256 value.
     * @dev The function changed its behavior:
     *      - it is nullified once the subnetwork is removed/reset,
     *      - it returns either 0 or 2^208-1 if set.
     */
    function maxNetworkLimit(bytes32 subnetwork) external view returns (uint256 limit);

    /**
     * @notice Check whether a subnetwork is assigned to a shared slot.
     * @param subnetwork Full identifier of the subnetwork.
     * @return isShared Whether the slot is shared.
     */
    function getIsShared(bytes32 subnetwork) external view returns (bool isShared);

    /**
     * @notice Check whether a subnetwork is assigned to a no-plugins slot.
     * @param subnetwork Full identifier of the subnetwork.
     * @return isNoPlugins Whether the slot is marked as no-plugins.
     */
    function getIsNoPlugins(bytes32 subnetwork) external view returns (bool isNoPlugins);

    /**
     * @notice Get total no-plugins size across root slots.
     * @return noPluginsSize Total no-plugins size.
     */
    function getNoPluginsSize() external view returns (uint256 noPluginsSize);

    /**
     * @notice Get configured withdrawal buffer size.
     * @return withdrawalBuffer Current withdrawal buffer size.
     */
    function getWithdrawalBuffer() external view returns (uint256 withdrawalBuffer);

    /**
     * @notice Get the timestamp when migration occurred.
     * @return migrateTimestamp Timestamp when migration occurred.
     */
    function migrateTimestamp() external view returns (uint48 migrateTimestamp);

    /**
     * @notice Get the address of the previous delegator before migration.
     * @return oldDelegator Address of the previous delegator before migration.
     */
    function oldDelegator() external view returns (address oldDelegator);

    /**
     * @notice Create a new slot under a parent.
     * @param subnetworkOrOperator Encoded subnetwork or operator identifier.
     * @param parentIndex Parent slot index.
     * @param isShared Whether the new slot is shared.
     * @param noPlugins Whether the new slot is no-plugins.
     * @param size Initial slot size.
     * @return index Created slot index.
     * @dev Only a CREATE_SLOT_ROLE holder can call this function.
     */
    function createSlot(bytes32 subnetworkOrOperator, uint96 parentIndex, bool isShared, bool noPlugins, uint128 size)
        external
        returns (uint96 index);

    /**
     * @notice Update slot size.
     * @param index Slot index.
     * @param size New slot size.
     * @dev Only a SET_SIZE_ROLE holder can call this function.
     */
    function setSize(uint96 index, uint128 size) external;

    /**
     * @notice Swap two sibling slots.
     * @param index1 First slot index.
     * @param index2 Second slot index.
     * @dev Only a SWAP_SLOTS_ROLE holder can call this function.
     */
    function swapSlots(uint96 index1, uint96 index2) external;

    /**
     * @notice Remove a slot.
     * @param index Slot index.
     * @dev Only a REMOVE_SLOT_ROLE holder can call this function.
     */
    function removeSlot(uint96 index) external;

    /**
     * @notice Update withdrawal buffer size.
     * @param newWithdrawalBufferSize New withdrawal buffer size.
     * @dev Only a SET_WITHDRAWAL_BUFFER_SIZE_ROLE holder can call this function.
     */
    function setWithdrawalBufferSize(uint128 newWithdrawalBufferSize) external;

    /**
     * @notice Set a new hook.
     * @param hook Address of the hook.
     * @dev Only a HOOK_SET_ROLE holder can call this function.
     */
    function setHook(address hook) external;

    /**
     * @notice Reset allocation for a subnetwork.
     * @param subnetwork Full identifier of the subnetwork.
     * @dev Only a network or its middleware can call this function.
     */
    function resetAllocation(bytes32 subnetwork) external;

    /**
     * @notice Set the maximum limit for a subnetwork.
     * @param identifier Subnetwork identifier.
     * @param amount New maximum limit.
     * @dev This function changed its behavior:
     *      - it accepts only 2^256-1 once setting the maximum limit,
     *      - the max network limit can be reset only via `resetAllocation()`.
     */
    function setMaxNetworkLimit(uint96 identifier, uint256 amount) external;
}

// src/interfaces/slasher/IUniversalSlasher.sol

uint64 constant UNIVERSAL_SLASHER_TYPE = 2;

uint256 constant BURNER_GAS_LIMIT = 150_000;
uint256 constant BURNER_RESERVE = 20_000;

/**
 * @title IUniversalSlasher
 * @notice Interface for the UniversalSlasher contract.
 */
interface IUniversalSlasher {
    /* ERRORS */

    /**
     * @notice Raised when trying to set a value that is already set.
     */
    error AlreadySet();

    /**
     * @notice Raised when there is not enough gas left for the burner hook call.
     */
    error InsufficientBurnerGas();

    /**
     * @notice Raised when the requested slash amount is zero after validation.
     */
    error InsufficientSlash();

    /**
     * @notice Raised when the provided capture timestamp is invalid.
     */
    error InvalidCaptureTimestamp();

    /**
     * @notice Raised when the resolver set delay is outside allowed bounds.
     */
    error InvalidResolverSetEpochsDelay();

    /**
     * @notice Raised when the veto duration is outside allowed bounds.
     */
    error InvalidVetoDuration();

    /**
     * @notice Raised when burner-hook mode is enabled but the vault has no burner.
     */
    error NoBurner();

    /**
     * @notice Raised when an operation requires a resolver but none is configured.
     */
    error NoResolver();

    /**
     * @notice Raised when migration functions are called outside migration mode.
     */
    error NotMigrating();

    /**
     * @notice Raised when the caller is not a registered network.
     */
    error NotNetwork();

    /**
     * @notice Raised when the caller is not the network middleware for the subnetwork.
     */
    error NotNetworkMiddleware();

    /**
     * @notice Raised when the caller is not the configured resolver.
     */
    error NotResolver();

    /**
     * @notice Raised when the provided vault is invalid.
     */
    error NotVault();

    /**
     * @notice Raised when the connected vault version is older than required.
     */
    error OldVault();

    /**
     * @notice Raised when the slash request has already been completed.
     */
    error SlashRequestCompleted();

    /**
     * @notice Raised when the slash request does not exist.
     */
    error SlashRequestNotExist();

    /**
     * @notice Raised when the veto period has already ended.
     */
    error VetoPeriodEnded();

    /**
     * @notice Raised when the veto period has not ended yet.
     */
    error VetoPeriodNotEnded();

    /* STRUCTS */

    /**
     * @notice Structure for a slash request.
     * @param subnetwork Subnetwork that requested the slash.
     * @param operator Operator that could be slashed (if the request is not vetoed).
     * @param amount Maximum amount of the collateral to be slashed.
     * @param createdAt Time point when the request was created (capture timestamp if legacy).
     * @param vetoDeadline Deadline for the resolver to veto the slash (exclusively).
     * @param completed If the slash was vetoed/executed.
     */
    struct SlashRequest {
        bytes32 subnetwork;
        address operator;
        uint48 createdAt;
        uint256 amount;
        address resolver;
        uint48 vetoDeadline;
        bool completed;
    }

    /**
     * @notice Initial parameters needed for a slasher deployment.
     * @param isBurnerHook If burner hook calls are enabled on slashes.
     * @param vetoDuration Duration of the veto period for a slash request.
     * @param resolverSetDelay Delay in seconds for a network to update a resolver.
     */
    struct InitParams {
        bool isBurnerHook;
        uint48 vetoDuration;
        uint48 resolverSetDelay;
    }

    /**
     * @notice Base parameters needed for slashers' deployment.
     * @param isBurnerHook If the burner is needed to be called on a slashing.
     */
    struct BaseParams {
        bool isBurnerHook;
    }

    /**
     * @notice General data for the delegator.
     * @param slasherType Type of the slasher.
     * @param data Slasher-dependent data for the delegator.
     */
    struct GeneralDelegatorData {
        uint64 slasherType;
        bytes data;
    }

    /* EVENTS */

    /**
     * @notice Emitted when a slash request is created.
     * @param slashIndex Index of the slash request.
     * @param subnetwork Subnetwork that requested the slash.
     * @param operator Operator that could be slashed (if the request is not vetoed).
     * @param slashAmount Maximum amount of the collateral to be slashed.
     * @param vetoDeadline Deadline for the resolver to veto the slash (exclusively).
     */
    event RequestSlash(
        uint256 indexed slashIndex,
        bytes32 indexed subnetwork,
        address indexed operator,
        uint256 slashAmount,
        uint48 vetoDeadline
    );

    /**
     * @notice Emitted when a slash request is executed.
     * @param slashIndex Index of the slash request.
     * @param slashedAmount Virtual amount of the collateral slashed.
     */
    event ExecuteSlash(uint256 indexed slashIndex, uint256 slashedAmount);

    /**
     * @notice Emitted when a slash request is vetoed.
     * @param slashIndex Index of the slash request.
     * @param resolver Address of the resolver that vetoed the slash.
     */
    event VetoSlash(uint256 indexed slashIndex, address indexed resolver);

    /**
     * @notice Emitted when a resolver is set.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param resolver Address of the resolver.
     */
    event SetResolver(bytes32 indexed subnetwork, address resolver);

    /**
     * @notice Emitted when owed slashing is synced for an operator.
     * @param subnetwork Full identifier of the subnetwork.
     * @param operator Address of the operator.
     * @param slashed Amount of collateral synced and burned.
     */
    event SyncOwedSlash(bytes32 indexed subnetwork, address indexed operator, uint256 slashed);

    /**
     * @notice Emitted when a vault is initialized.
     * @param params Initial parameters for the slasher.
     */
    event Initialize(InitParams params);

    /* FUNCTIONS */

    /**
     * @notice Get the vault's address.
     * @return Address of the vault to perform slashings on.
     */
    function vault() external view returns (address);

    /**
     * @notice Timestamp when migration from the previous slasher occurred.
     * @return migrateTimestamp Migration timestamp.
     */
    function migrateTimestamp() external view returns (uint48 migrateTimestamp);

    /**
     * @notice Address of the previous slasher used for legacy reads after migration.
     * @return oldSlasher Previous slasher address.
     */
    function oldSlasher() external view returns (address oldSlasher);

    /**
     * @notice Get if the burner is needed to be called on a slashing.
     * @return If the burner is a hook.
     */
    function isBurnerHook() external view returns (bool);

    /**
     * @notice Get a duration during which resolvers can veto slash requests.
     * @return Duration of the veto period.
     */
    function vetoDuration() external view returns (uint48);

    /**
     * @notice Get a delay for networks in seconds to update a resolver.
     * @return Updating resolver delay in seconds.
     */
    function resolverSetDelay() external view returns (uint48);

    /**
     * @notice Get pending resolver activation data for a subnetwork.
     * @param subnetwork Full identifier of the subnetwork.
     * @return data Encoded pending resolver address and activation timestamp.
     */
    function pendingResolverData(bytes32 subnetwork) external view returns (bytes32);

    /**
     * @notice Get a total amount of owed slashing.
     * @return Total amount of owed slashing.
     */
    function totalOwed() external view returns (uint256);

    /**
     * @notice Get owed slash amount for a subnetwork and operator.
     * @param subnetwork Full identifier of the subnetwork.
     * @param operator Address of the operator.
     * @return amount Outstanding slash amount not yet synced to burner.
     */
    function owed(bytes32 subnetwork, address operator) external view returns (uint256);

    /**
     * @notice Get a total number of slash requests.
     * @return Total number of slash requests.
     */
    function slashRequestsLength() external view returns (uint256);

    /**
     * @notice Get a particular slash request.
     * @param slashIndex Index of the slash request.
     * @return request Slash request.
     */
    function slashRequests(uint256 slashIndex) external view returns (SlashRequest memory request);

    /**
     * @notice Get a resolver for a given subnetwork.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @return Address of the resolver.
     */
    function resolver(bytes32 subnetwork) external view returns (address);

    /**
     * @notice Get a slashable amount of stake at a given capture timestamp.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param operator Address of the operator.
     * @param captureTimestamp Time point to get the stake amount at.
     * @return Slashable amount of the stake.
     * @dev Can use 0 as a capture timestamp to get the current stake amount.
     */
    function slashableStake(bytes32 subnetwork, address operator, uint48 captureTimestamp, bytes calldata)
        external
        view
        returns (uint256);

    /**
     * @notice Perform a slash using a subnetwork for a particular operator by a given amount.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param operator Address of the operator.
     * @param amount Maximum amount of the collateral to be slashed.
     * @return slashedAmount Virtual amount of the collateral slashed.
     */
    function slash(bytes32 subnetwork, address operator, uint256 amount) external returns (uint256 slashedAmount);

    /**
     * @notice Request a slash using a subnetwork for a particular operator by a given amount.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param operator Address of the operator.
     * @param amount Maximum amount of the collateral to be slashed.
     * @param captureTimestamp Legacy parameter reserved for compatibility (can just use 0 instead).
     * @return slashIndex Index of the slash request.
     * @dev Only a network middleware can call this function.
     */
    function requestSlash(bytes32 subnetwork, address operator, uint256 amount, uint48 captureTimestamp, bytes calldata)
        external
        returns (uint256 slashIndex);

    /**
     * @notice Execute a slash with a given slash index.
     * @param slashIndex Index of the slash request.
     * @return slashedAmount Virtual amount of collateral slashed.
     * @dev Only a network middleware can call this function.
     */
    function executeSlash(uint256 slashIndex, bytes calldata) external returns (uint256 slashedAmount);

    /**
     * @notice Veto a slash with a given slash index.
     * @param slashIndex Index of the slash request.
     * @dev Only a resolver can call this function.
     */
    function vetoSlash(uint256 slashIndex) external;

    /**
     * @notice Set a resolver for a subnetwork.
     * @param identifier Identifier of the subnetwork.
     * @param resolver Address of the resolver.
     * @dev Only a network can call this function.
     */
    function setResolver(uint96 identifier, address resolver) external;

    /**
     * @notice Sync owed slashing.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param operator Address of the operator.
     * @return slashed Amount of the collateral slashed.
     */
    function syncOwedSlash(bytes32 subnetwork, address operator) external returns (uint256 slashed);
}

// src/interfaces/vault/IVaultStorage.sol

/**
 * @title IVaultStorage
 * @notice Interface for the VaultStorage contract.
 */
interface IVaultStorage {
    error InvalidTimestamp();
    error NoPreviousEpoch();

    /**
     * @notice Get a deposit whitelist enabler/disabler's role.
     * @return Identifier Of the whitelist enabler/disabler role.
     */
    function DEPOSIT_WHITELIST_SET_ROLE() external view returns (bytes32);

    /**
     * @notice Get a depositor whitelist status setter's role.
     * @return Identifier Of the depositor whitelist status setter role.
     */
    function DEPOSITOR_WHITELIST_ROLE() external view returns (bytes32);

    /**
     * @notice Get a deposit limit enabler/disabler's role.
     * @return Identifier Of the deposit limit enabler/disabler role.
     */
    function IS_DEPOSIT_LIMIT_SET_ROLE() external view returns (bytes32);

    /**
     * @notice Get a deposit limit setter's role.
     * @return Identifier Of the deposit limit setter role.
     */
    function DEPOSIT_LIMIT_SET_ROLE() external view returns (bytes32);

    /**
     * @notice Get the delegator factory's address.
     * @return Address Of the delegator factory.
     */
    function DELEGATOR_FACTORY() external view returns (address);

    /**
     * @notice Get the slasher factory's address.
     * @return Address Of the slasher factory.
     */
    function SLASHER_FACTORY() external view returns (address);

    /**
     * @notice Get a vault collateral.
     * @return Address Of the underlying collateral.
     */
    function collateral() external view returns (address);

    /**
     * @notice Get a burner to issue debt to (e.g., 0xdEaD or some unwrapper contract).
     * @return Address Of the burner.
     */
    function burner() external view returns (address);

    /**
     * @notice Get a delegator (it delegates the vault's stake to networks and operators).
     * @return Address Of the delegator.
     */
    function delegator() external view returns (address);

    /**
     * @notice Get if the delegator is initialized.
     * @return If The delegator is initialized.
     */
    function isDelegatorInitialized() external view returns (bool);

    /**
     * @notice Get a slasher (it provides networks a slashing mechanism).
     * @return Address Of the slasher.
     */
    function slasher() external view returns (address);

    /**
     * @notice Get if the slasher is initialized.
     * @return If The slasher is initialized.
     */
    function isSlasherInitialized() external view returns (bool);

    /**
     * @notice Get a time point of the epoch duration set.
     * @return Time Point of the epoch duration set.
     */
    function epochDurationInit() external view returns (uint48);

    /**
     * @notice Get a duration of the vault epoch.
     * @return Duration Of the epoch.
     */
    function epochDuration() external view returns (uint48);

    /**
     * @notice Get an epoch at a given timestamp.
     * @param timestamp Time point to get the epoch at.
     * @return Epoch At the timestamp.
     * @dev Reverts if the timestamp is less than the start of the epoch 0.
     */
    function epochAt(uint48 timestamp) external view returns (uint256);

    /**
     * @notice Get a current vault epoch.
     * @return Current Epoch.
     */
    function currentEpoch() external view returns (uint256);

    /**
     * @notice Get a start of the current vault epoch.
     * @return Start Of the current epoch.
     */
    function currentEpochStart() external view returns (uint48);

    /**
     * @notice Get a start of the previous vault epoch.
     * @return Start Of the previous epoch.
     * @dev Reverts if the current epoch is 0.
     */
    function previousEpochStart() external view returns (uint48);

    /**
     * @notice Get a start of the next vault epoch.
     * @return Start Of the next epoch.
     */
    function nextEpochStart() external view returns (uint48);

    /**
     * @notice Get if the deposit whitelist is enabled.
     * @return If The deposit whitelist is enabled.
     */
    function depositWhitelist() external view returns (bool);

    /**
     * @notice Get if a given account is whitelisted as a depositor.
     * @param account Address to check.
     * @return If The account is whitelisted as a depositor.
     */
    function isDepositorWhitelisted(address account) external view returns (bool);

    /**
     * @notice Get if the deposit limit is set.
     * @return If The deposit limit is set.
     */
    function isDepositLimit() external view returns (bool);

    /**
     * @notice Get a deposit limit (maximum amount of the active stake that can be in the vault simultaneously).
     * @return Deposit Limit.
     */
    function depositLimit() external view returns (uint256);

    /**
     * @notice Get a total number of active shares in the vault at a given timestamp using a hint.
     * @param timestamp Time point to get the total number of active shares at.
     * @param hint Hint for the checkpoint index.
     * @return Total Number of active shares at the timestamp.
     */
    function activeSharesAt(uint48 timestamp, bytes memory hint) external view returns (uint256);

    /**
     * @notice Get a total number of active shares in the vault.
     * @return Total Number of active shares.
     */
    function activeShares() external view returns (uint256);

    /**
     * @notice Get a total amount of active stake in the vault at a given timestamp using a hint.
     * @param timestamp Time point to get the total active stake at.
     * @param hint Hint for the checkpoint index.
     * @return Total Amount of active stake at the timestamp.
     */
    function activeStakeAt(uint48 timestamp, bytes memory hint) external view returns (uint256);

    /**
     * @notice Get a total amount of active stake in the vault.
     * @return Total Amount of active stake.
     */
    function activeStake() external view returns (uint256);

    /**
     * @notice Get a total number of active shares for a particular account at a given timestamp using a hint.
     * @param account Account to get the number of active shares for.
     * @param timestamp Time point to get the number of active shares for the account at.
     * @param hint Hint for the checkpoint index.
     * @return Number Of active shares for the account at the timestamp.
     */
    function activeSharesOfAt(address account, uint48 timestamp, bytes memory hint) external view returns (uint256);

    /**
     * @notice Get a number of active shares for a particular account.
     * @param account Account to get the number of active shares for.
     * @return Number Of active shares for the account.
     */
    function activeSharesOf(address account) external view returns (uint256);

    /**
     * @notice Get a total amount of the withdrawals at a given epoch.
     * @param epoch Epoch to get the total amount of the withdrawals at.
     * @return Total Amount of the withdrawals at the epoch.
     */
    function withdrawals(uint256 epoch) external view returns (uint256);

    /**
     * @notice Get a total number of withdrawal shares at a given epoch.
     * @param epoch Epoch to get the total number of withdrawal shares at.
     * @return Total Number of withdrawal shares at the epoch.
     */
    function withdrawalShares(uint256 epoch) external view returns (uint256);

    /**
     * @notice Get a number of withdrawal shares for a particular account at a given epoch (zero if claimed).
     * @param epoch Epoch to get the number of withdrawal shares for the account at.
     * @param account Account to get the number of withdrawal shares for.
     * @return Number Of withdrawal shares for the account at the epoch.
     */
    function withdrawalSharesOf(uint256 epoch, address account) external view returns (uint256);

    /**
     * @notice Get if the withdrawals are claimed for a particular account at a given epoch.
     * @param epoch Epoch to check the withdrawals for the account at.
     * @param account Account to check the withdrawals for.
     * @return If The withdrawals are claimed for the account at the epoch.
     */
    function isWithdrawalsClaimed(uint256 epoch, address account) external view returns (bool);
}

// src/interfaces/vault/IVaultV2Storage.sol

/**
 * @title IVaultV2Storage
 * @notice Interface for the VaultV2Storage contract.
 */
interface IVaultV2Storage {
    /* ERRORS */

    /**
     * @notice Raised when a timestamp argument is invalid for a checkpoint lookup.
     */
    error InvalidTimestamp();

    /**
     * @notice Raised when there is no previous epoch for the requested operation.
     */
    error NoPreviousEpoch();

    /* FUNCTIONS */

    /**
     * @notice Get if the deposit whitelist is enabled.
     * @return If The deposit whitelist is enabled.
     */
    function depositWhitelist() external view returns (bool);

    /**
     * @notice Timestamp when migration to VaultV2 occurred.
     * @return migrateTimestamp Migration timestamp.
     */
    function migrateTimestamp() external view returns (uint48 migrateTimestamp);

    /**
     * @notice Get if the deposit limit is set.
     * @return If The deposit limit is set.
     */
    function isDepositLimit() external view returns (bool);

    /**
     * @notice Get a vault collateral.
     * @return Address Of the underlying collateral.
     */
    function collateral() external view returns (address);

    /**
     * @notice Get a burner to issue debt to (e.g., 0xdEaD or some unwrapper contract).
     * @return Address Of the burner.
     */
    function burner() external view returns (address);

    /**
     * @notice Get a duration of the vault withdrawal delay.
     * @return Duration Of the withdrawal delay.
     */
    function epochDuration() external view returns (uint48);

    /**
     * @notice Get a delegator (it delegates the vault's stake to networks and operators).
     * @return Address Of the delegator.
     */
    function delegator() external view returns (address);

    /**
     * @notice Get a slasher (it provides networks a slashing mechanism).
     * @return Address Of the slasher.
     */
    function slasher() external view returns (address);

    /**
     * @notice Get a deposit limit (maximum amount of the active stake that can be in the vault simultaneously).
     * @return Deposit Limit.
     */
    function depositLimit() external view returns (uint256);

    /**
     * @notice Get if a given account is whitelisted as a depositor.
     * @param account Address to check.
     * @return If The account is whitelisted as a depositor.
     */
    function isDepositorWhitelisted(address account) external view returns (bool);

    /**
     * @notice Get if the withdrawal is claimed for a particular account at a given index.
     * @param index Index to check the withdrawal for the account at.
     * @param account Account to check the withdrawal for.
     * @return If The withdrawal is claimed for the account at the index.
     */
    function isWithdrawalsClaimed(uint256 index, address account) external view returns (bool);

    /**
     * @notice Get a plugin address by index.
     * @param index Index of the plugin in the plugins array.
     * @return Plugin Address at the requested index.
     */
    function plugins(uint256 index) external view returns (address);

    /**
     * @notice Get a plugin allocation limit.
     * @param plugin Address of the plugin.
     * @return Limit Maximum collateral amount allocatable to the plugin.
     */
    function pluginLimit(address plugin) external view returns (uint208);

    /**
     * @notice Get the total amount allocated across all plugins.
     * @return Allocated Total collateral amount allocated to plugins.
     */
    function pluginsAllocated() external view returns (uint256);

    /**
     * @notice Get the currently allocated amount for a plugin.
     * @param plugin Address of the plugin.
     * @return Allocated Collateral amount allocated to the plugin.
     */
    function pluginAllocated(address plugin) external view returns (uint256);

    /**
     * @notice Get a total number of active shares in the vault at a given timestamp using a hint.
     * @param timestamp Time point to get the total number of active shares at.
     * @param hint Hint for the checkpoint index.
     * @return Total Number of active shares at the timestamp.
     */
    function activeSharesAt(uint48 timestamp, bytes calldata hint) external view returns (uint256);

    /**
     * @notice Get a total number of active shares in the vault.
     * @return Total Number of active shares.
     */
    function activeShares() external view returns (uint256);

    /**
     * @notice Get a total amount of active stake in the vault at a given timestamp using a hint.
     * @param timestamp Time point to get the total active stake at.
     * @param hint Hint for the checkpoint index.
     * @return Total Amount of active stake at the timestamp.
     */
    function activeStakeAt(uint48 timestamp, bytes calldata hint) external view returns (uint256);

    /**
     * @notice Get a total amount of active stake in the vault.
     * @return Total Amount of active stake.
     */
    function activeStake() external view returns (uint256);

    /**
     * @notice Get a total number of active shares for a particular account at a given timestamp using a hint.
     * @param account Account to get the number of active shares for.
     * @param timestamp Time point to get the number of active shares for the account at.
     * @param hint Hint for the checkpoint index.
     * @return Number Of active shares for the account at the timestamp.
     */
    function activeSharesOfAt(address account, uint48 timestamp, bytes calldata hint) external view returns (uint256);

    /**
     * @notice Get a number of active shares for a particular account.
     * @param account Account to get the number of active shares for.
     * @return Number Of active shares for the account.
     */
    function activeSharesOf(address account) external view returns (uint256);

    /**
     * @notice Get the index of the last withdrawal bucket.
     * @return Index Of the last withdrawal bucket.
     */
    function withdrawalBucket() external view returns (uint208);

    /**
     * @notice Get a total number of withdrawal shares at a given bucket index.
     * @param index Index to get the total number of withdrawal shares at.
     * @return Total Number of withdrawal shares at the bucket index.
     * @dev Warning: doesn't provide legacy epoch data before.
     */
    function withdrawalShares(uint256 index) external view returns (uint256);

    /**
     * @notice Get a total amount of the withdrawals at a given bucket index.
     * @param index Index to get the total amount of the withdrawals at.
     * @return Total Amount of the withdrawals at the bucket index.
     * @dev Warning: doesn't provide legacy epoch data before.
     */
    function withdrawals(uint256 index) external view returns (uint256);

    /**
     * @notice Get the number of configured plugins.
     * @return Length Number of plugins.
     */
    function pluginsLength() external view returns (uint256);
}

// lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol

// OpenZeppelin Contracts (last updated v5.3.0) (proxy/utils/Initializable.sol)

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 * case an upgrade adds a module that needs to be initialized.
 *
 * For example:
 *
 * [.hljs-theme-light.nopadding]
 * ```solidity
 * contract MyToken is ERC20Upgradeable {
 *     function initialize() initializer public {
 *         __ERC20_init("MyToken", "MTK");
 *     }
 * }
 *
 * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
 *     function initializeV2() reinitializer(2) public {
 *         __ERC20Permit_init("MyToken");
 *     }
 * }
 * ```
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() {
 *     _disableInitializers();
 * }
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Storage of the initializable contract.
     *
     * It's implemented on a custom ERC-7201 namespace to reduce the risk of storage collisions
     * when using with upgradeable contracts.
     *
     * @custom:storage-location erc7201:openzeppelin.storage.Initializable
     */
    struct InitializableStorage {
        /**
         * @dev Indicates that the contract has been initialized.
         */
        uint64 _initialized;
        /**
         * @dev Indicates that the contract is in the process of being initialized.
         */
        bool _initializing;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.Initializable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant INITIALIZABLE_STORAGE = 0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00;

    /**
     * @dev The contract is already initialized.
     */
    error InvalidInitialization();

    /**
     * @dev The contract is not initializing.
     */
    error NotInitializing();

    /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint64 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts.
     *
     * Similar to `reinitializer(1)`, except that in the context of a constructor an `initializer` may be invoked any
     * number of times. This behavior in the constructor can be useful during testing and is not expected to be used in
     * production.
     *
     * Emits an {Initialized} event.
     */
    modifier initializer() {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        // Cache values to avoid duplicated sloads
        bool isTopLevelCall = !$._initializing;
        uint64 initialized = $._initialized;

        // Allowed calls:
        // - initialSetup: the contract is not in the initializing state and no previous version was
        //                 initialized
        // - construction: the contract is initialized at version 1 (no reinitialization) and the
        //                 current contract is just being deployed
        bool initialSetup = initialized == 0 && isTopLevelCall;
        bool construction = initialized == 1 && address(this).code.length == 0;

        if (!initialSetup && !construction) {
            revert InvalidInitialization();
        }
        $._initialized = 1;
        if (isTopLevelCall) {
            $._initializing = true;
        }
        _;
        if (isTopLevelCall) {
            $._initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * A reinitializer may be used after the original initialization step. This is essential to configure modules that
     * are added through upgrades and that require initialization.
     *
     * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
     * cannot be nested. If one is invoked in the context of another, execution will revert.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     *
     * WARNING: Setting the version to 2**64 - 1 will prevent any future reinitialization.
     *
     * Emits an {Initialized} event.
     */
    modifier reinitializer(uint64 version) {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        if ($._initializing || $._initialized >= version) {
            revert InvalidInitialization();
        }
        $._initialized = version;
        $._initializing = true;
        _;
        $._initializing = false;
        emit Initialized(version);
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        _checkInitializing();
        _;
    }

    /**
     * @dev Reverts if the contract is not in an initializing state. See {onlyInitializing}.
     */
    function _checkInitializing() internal view virtual {
        if (!_isInitializing()) {
            revert NotInitializing();
        }
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     *
     * Emits an {Initialized} event the first time it is successfully executed.
     */
    function _disableInitializers() internal virtual {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        if ($._initializing) {
            revert InvalidInitialization();
        }
        if ($._initialized != type(uint64).max) {
            $._initialized = type(uint64).max;
            emit Initialized(type(uint64).max);
        }
    }

    /**
     * @dev Returns the highest version that has been initialized. See {reinitializer}.
     */
    function _getInitializedVersion() internal view returns (uint64) {
        return _getInitializableStorage()._initialized;
    }

    /**
     * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
     */
    function _isInitializing() internal view returns (bool) {
        return _getInitializableStorage()._initializing;
    }

    /**
     * @dev Pointer to storage slot. Allows integrators to override it with a custom storage location.
     *
     * NOTE: Consider following the ERC-7201 formula to derive storage locations.
     */
    function _initializableStorageSlot() internal pure virtual returns (bytes32) {
        return INITIALIZABLE_STORAGE;
    }

    /**
     * @dev Returns a pointer to the storage namespace.
     */
    // solhint-disable-next-line var-name-mixedcase
    function _getInitializableStorage() private pure returns (InitializableStorage storage $) {
        bytes32 slot = _initializableStorageSlot();
        assembly {
            $.slot := slot
        }
    }
}

// lib/openzeppelin-contracts/contracts/utils/Panic.sol

// OpenZeppelin Contracts (last updated v5.1.0) (utils/Panic.sol)

/**
 * @dev Helper library for emitting standardized panic codes.
 *
 * ```solidity
 * contract Example {
 *      using Panic for uint256;
 *
 *      // Use any of the declared internal constants
 *      function foo() { Panic.GENERIC.panic(); }
 *
 *      // Alternatively
 *      function foo() { Panic.panic(Panic.GENERIC); }
 * }
 * ```
 *
 * Follows the list from https://github.com/ethereum/solidity/blob/v0.8.24/libsolutil/ErrorCodes.h[libsolutil].
 *
 * _Available since v5.1._
 */
// slither-disable-next-line unused-state
library Panic {
    /// @dev generic / unspecified error
    uint256 internal constant GENERIC = 0x00;
    /// @dev used by the assert() builtin
    uint256 internal constant ASSERT = 0x01;
    /// @dev arithmetic underflow or overflow
    uint256 internal constant UNDER_OVERFLOW = 0x11;
    /// @dev division or modulo by zero
    uint256 internal constant DIVISION_BY_ZERO = 0x12;
    /// @dev enum conversion error
    uint256 internal constant ENUM_CONVERSION_ERROR = 0x21;
    /// @dev invalid encoding in storage
    uint256 internal constant STORAGE_ENCODING_ERROR = 0x22;
    /// @dev empty array pop
    uint256 internal constant EMPTY_ARRAY_POP = 0x31;
    /// @dev array out of bounds access
    uint256 internal constant ARRAY_OUT_OF_BOUNDS = 0x32;
    /// @dev resource error (too large allocation or too large array)
    uint256 internal constant RESOURCE_ERROR = 0x41;
    /// @dev calling invalid internal function
    uint256 internal constant INVALID_INTERNAL_FUNCTION = 0x51;

    /// @dev Reverts with a panic code. Recommended to use with
    /// the internal constants with predefined codes.
    function panic(uint256 code) internal pure {
        assembly ("memory-safe") {
            mstore(0x00, 0x4e487b71)
            mstore(0x20, code)
            revert(0x1c, 0x24)
        }
    }
}

// lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol

// OpenZeppelin Contracts (last updated v5.1.0) (utils/math/SafeCast.sol)
// This file was procedurally generated from scripts/generate/templates/SafeCast.js.

/**
 * @dev Wrappers over Solidity's uintXX/intXX/bool casting operators with added overflow
 * checks.
 *
 * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
 * easily result in undesired exploitation or bugs, since developers usually
 * assume that overflows raise errors. `SafeCast` restores this intuition by
 * reverting the transaction when such an operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeCast {
    /**
     * @dev Value doesn't fit in an uint of `bits` size.
     */
    error SafeCastOverflowedUintDowncast(uint8 bits, uint256 value);

    /**
     * @dev An int value doesn't fit in an uint of `bits` size.
     */
    error SafeCastOverflowedIntToUint(int256 value);

    /**
     * @dev Value doesn't fit in an int of `bits` size.
     */
    error SafeCastOverflowedIntDowncast(uint8 bits, int256 value);

    /**
     * @dev An uint value doesn't fit in an int of `bits` size.
     */
    error SafeCastOverflowedUintToInt(uint256 value);

    /**
     * @dev Returns the downcasted uint248 from uint256, reverting on
     * overflow (when the input is greater than largest uint248).
     *
     * Counterpart to Solidity's `uint248` operator.
     *
     * Requirements:
     *
     * - input must fit into 248 bits
     */
    function toUint248(uint256 value) internal pure returns (uint248) {
        if (value > type(uint248).max) {
            revert SafeCastOverflowedUintDowncast(248, value);
        }
        return uint248(value);
    }

    /**
     * @dev Returns the downcasted uint240 from uint256, reverting on
     * overflow (when the input is greater than largest uint240).
     *
     * Counterpart to Solidity's `uint240` operator.
     *
     * Requirements:
     *
     * - input must fit into 240 bits
     */
    function toUint240(uint256 value) internal pure returns (uint240) {
        if (value > type(uint240).max) {
            revert SafeCastOverflowedUintDowncast(240, value);
        }
        return uint240(value);
    }

    /**
     * @dev Returns the downcasted uint232 from uint256, reverting on
     * overflow (when the input is greater than largest uint232).
     *
     * Counterpart to Solidity's `uint232` operator.
     *
     * Requirements:
     *
     * - input must fit into 232 bits
     */
    function toUint232(uint256 value) internal pure returns (uint232) {
        if (value > type(uint232).max) {
            revert SafeCastOverflowedUintDowncast(232, value);
        }
        return uint232(value);
    }

    /**
     * @dev Returns the downcasted uint224 from uint256, reverting on
     * overflow (when the input is greater than largest uint224).
     *
     * Counterpart to Solidity's `uint224` operator.
     *
     * Requirements:
     *
     * - input must fit into 224 bits
     */
    function toUint224(uint256 value) internal pure returns (uint224) {
        if (value > type(uint224).max) {
            revert SafeCastOverflowedUintDowncast(224, value);
        }
        return uint224(value);
    }

    /**
     * @dev Returns the downcasted uint216 from uint256, reverting on
     * overflow (when the input is greater than largest uint216).
     *
     * Counterpart to Solidity's `uint216` operator.
     *
     * Requirements:
     *
     * - input must fit into 216 bits
     */
    function toUint216(uint256 value) internal pure returns (uint216) {
        if (value > type(uint216).max) {
            revert SafeCastOverflowedUintDowncast(216, value);
        }
        return uint216(value);
    }

    /**
     * @dev Returns the downcasted uint208 from uint256, reverting on
     * overflow (when the input is greater than largest uint208).
     *
     * Counterpart to Solidity's `uint208` operator.
     *
     * Requirements:
     *
     * - input must fit into 208 bits
     */
    function toUint208(uint256 value) internal pure returns (uint208) {
        if (value > type(uint208).max) {
            revert SafeCastOverflowedUintDowncast(208, value);
        }
        return uint208(value);
    }

    /**
     * @dev Returns the downcasted uint200 from uint256, reverting on
     * overflow (when the input is greater than largest uint200).
     *
     * Counterpart to Solidity's `uint200` operator.
     *
     * Requirements:
     *
     * - input must fit into 200 bits
     */
    function toUint200(uint256 value) internal pure returns (uint200) {
        if (value > type(uint200).max) {
            revert SafeCastOverflowedUintDowncast(200, value);
        }
        return uint200(value);
    }

    /**
     * @dev Returns the downcasted uint192 from uint256, reverting on
     * overflow (when the input is greater than largest uint192).
     *
     * Counterpart to Solidity's `uint192` operator.
     *
     * Requirements:
     *
     * - input must fit into 192 bits
     */
    function toUint192(uint256 value) internal pure returns (uint192) {
        if (value > type(uint192).max) {
            revert SafeCastOverflowedUintDowncast(192, value);
        }
        return uint192(value);
    }

    /**
     * @dev Returns the downcasted uint184 from uint256, reverting on
     * overflow (when the input is greater than largest uint184).
     *
     * Counterpart to Solidity's `uint184` operator.
     *
     * Requirements:
     *
     * - input must fit into 184 bits
     */
    function toUint184(uint256 value) internal pure returns (uint184) {
        if (value > type(uint184).max) {
            revert SafeCastOverflowedUintDowncast(184, value);
        }
        return uint184(value);
    }

    /**
     * @dev Returns the downcasted uint176 from uint256, reverting on
     * overflow (when the input is greater than largest uint176).
     *
     * Counterpart to Solidity's `uint176` operator.
     *
     * Requirements:
     *
     * - input must fit into 176 bits
     */
    function toUint176(uint256 value) internal pure returns (uint176) {
        if (value > type(uint176).max) {
            revert SafeCastOverflowedUintDowncast(176, value);
        }
        return uint176(value);
    }

    /**
     * @dev Returns the downcasted uint168 from uint256, reverting on
     * overflow (when the input is greater than largest uint168).
     *
     * Counterpart to Solidity's `uint168` operator.
     *
     * Requirements:
     *
     * - input must fit into 168 bits
     */
    function toUint168(uint256 value) internal pure returns (uint168) {
        if (value > type(uint168).max) {
            revert SafeCastOverflowedUintDowncast(168, value);
        }
        return uint168(value);
    }

    /**
     * @dev Returns the downcasted uint160 from uint256, reverting on
     * overflow (when the input is greater than largest uint160).
     *
     * Counterpart to Solidity's `uint160` operator.
     *
     * Requirements:
     *
     * - input must fit into 160 bits
     */
    function toUint160(uint256 value) internal pure returns (uint160) {
        if (value > type(uint160).max) {
            revert SafeCastOverflowedUintDowncast(160, value);
        }
        return uint160(value);
    }

    /**
     * @dev Returns the downcasted uint152 from uint256, reverting on
     * overflow (when the input is greater than largest uint152).
     *
     * Counterpart to Solidity's `uint152` operator.
     *
     * Requirements:
     *
     * - input must fit into 152 bits
     */
    function toUint152(uint256 value) internal pure returns (uint152) {
        if (value > type(uint152).max) {
            revert SafeCastOverflowedUintDowncast(152, value);
        }
        return uint152(value);
    }

    /**
     * @dev Returns the downcasted uint144 from uint256, reverting on
     * overflow (when the input is greater than largest uint144).
     *
     * Counterpart to Solidity's `uint144` operator.
     *
     * Requirements:
     *
     * - input must fit into 144 bits
     */
    function toUint144(uint256 value) internal pure returns (uint144) {
        if (value > type(uint144).max) {
            revert SafeCastOverflowedUintDowncast(144, value);
        }
        return uint144(value);
    }

    /**
     * @dev Returns the downcasted uint136 from uint256, reverting on
     * overflow (when the input is greater than largest uint136).
     *
     * Counterpart to Solidity's `uint136` operator.
     *
     * Requirements:
     *
     * - input must fit into 136 bits
     */
    function toUint136(uint256 value) internal pure returns (uint136) {
        if (value > type(uint136).max) {
            revert SafeCastOverflowedUintDowncast(136, value);
        }
        return uint136(value);
    }

    /**
     * @dev Returns the downcasted uint128 from uint256, reverting on
     * overflow (when the input is greater than largest uint128).
     *
     * Counterpart to Solidity's `uint128` operator.
     *
     * Requirements:
     *
     * - input must fit into 128 bits
     */
    function toUint128(uint256 value) internal pure returns (uint128) {
        if (value > type(uint128).max) {
            revert SafeCastOverflowedUintDowncast(128, value);
        }
        return uint128(value);
    }

    /**
     * @dev Returns the downcasted uint120 from uint256, reverting on
     * overflow (when the input is greater than largest uint120).
     *
     * Counterpart to Solidity's `uint120` operator.
     *
     * Requirements:
     *
     * - input must fit into 120 bits
     */
    function toUint120(uint256 value) internal pure returns (uint120) {
        if (value > type(uint120).max) {
            revert SafeCastOverflowedUintDowncast(120, value);
        }
        return uint120(value);
    }

    /**
     * @dev Returns the downcasted uint112 from uint256, reverting on
     * overflow (when the input is greater than largest uint112).
     *
     * Counterpart to Solidity's `uint112` operator.
     *
     * Requirements:
     *
     * - input must fit into 112 bits
     */
    function toUint112(uint256 value) internal pure returns (uint112) {
        if (value > type(uint112).max) {
            revert SafeCastOverflowedUintDowncast(112, value);
        }
        return uint112(value);
    }

    /**
     * @dev Returns the downcasted uint104 from uint256, reverting on
     * overflow (when the input is greater than largest uint104).
     *
     * Counterpart to Solidity's `uint104` operator.
     *
     * Requirements:
     *
     * - input must fit into 104 bits
     */
    function toUint104(uint256 value) internal pure returns (uint104) {
        if (value > type(uint104).max) {
            revert SafeCastOverflowedUintDowncast(104, value);
        }
        return uint104(value);
    }

    /**
     * @dev Returns the downcasted uint96 from uint256, reverting on
     * overflow (when the input is greater than largest uint96).
     *
     * Counterpart to Solidity's `uint96` operator.
     *
     * Requirements:
     *
     * - input must fit into 96 bits
     */
    function toUint96(uint256 value) internal pure returns (uint96) {
        if (value > type(uint96).max) {
            revert SafeCastOverflowedUintDowncast(96, value);
        }
        return uint96(value);
    }

    /**
     * @dev Returns the downcasted uint88 from uint256, reverting on
     * overflow (when the input is greater than largest uint88).
     *
     * Counterpart to Solidity's `uint88` operator.
     *
     * Requirements:
     *
     * - input must fit into 88 bits
     */
    function toUint88(uint256 value) internal pure returns (uint88) {
        if (value > type(uint88).max) {
            revert SafeCastOverflowedUintDowncast(88, value);
        }
        return uint88(value);
    }

    /**
     * @dev Returns the downcasted uint80 from uint256, reverting on
     * overflow (when the input is greater than largest uint80).
     *
     * Counterpart to Solidity's `uint80` operator.
     *
     * Requirements:
     *
     * - input must fit into 80 bits
     */
    function toUint80(uint256 value) internal pure returns (uint80) {
        if (value > type(uint80).max) {
            revert SafeCastOverflowedUintDowncast(80, value);
        }
        return uint80(value);
    }

    /**
     * @dev Returns the downcasted uint72 from uint256, reverting on
     * overflow (when the input is greater than largest uint72).
     *
     * Counterpart to Solidity's `uint72` operator.
     *
     * Requirements:
     *
     * - input must fit into 72 bits
     */
    function toUint72(uint256 value) internal pure returns (uint72) {
        if (value > type(uint72).max) {
            revert SafeCastOverflowedUintDowncast(72, value);
        }
        return uint72(value);
    }

    /**
     * @dev Returns the downcasted uint64 from uint256, reverting on
     * overflow (when the input is greater than largest uint64).
     *
     * Counterpart to Solidity's `uint64` operator.
     *
     * Requirements:
     *
     * - input must fit into 64 bits
     */
    function toUint64(uint256 value) internal pure returns (uint64) {
        if (value > type(uint64).max) {
            revert SafeCastOverflowedUintDowncast(64, value);
        }
        return uint64(value);
    }

    /**
     * @dev Returns the downcasted uint56 from uint256, reverting on
     * overflow (when the input is greater than largest uint56).
     *
     * Counterpart to Solidity's `uint56` operator.
     *
     * Requirements:
     *
     * - input must fit into 56 bits
     */
    function toUint56(uint256 value) internal pure returns (uint56) {
        if (value > type(uint56).max) {
            revert SafeCastOverflowedUintDowncast(56, value);
        }
        return uint56(value);
    }

    /**
     * @dev Returns the downcasted uint48 from uint256, reverting on
     * overflow (when the input is greater than largest uint48).
     *
     * Counterpart to Solidity's `uint48` operator.
     *
     * Requirements:
     *
     * - input must fit into 48 bits
     */
    function toUint48(uint256 value) internal pure returns (uint48) {
        if (value > type(uint48).max) {
            revert SafeCastOverflowedUintDowncast(48, value);
        }
        return uint48(value);
    }

    /**
     * @dev Returns the downcasted uint40 from uint256, reverting on
     * overflow (when the input is greater than largest uint40).
     *
     * Counterpart to Solidity's `uint40` operator.
     *
     * Requirements:
     *
     * - input must fit into 40 bits
     */
    function toUint40(uint256 value) internal pure returns (uint40) {
        if (value > type(uint40).max) {
            revert SafeCastOverflowedUintDowncast(40, value);
        }
        return uint40(value);
    }

    /**
     * @dev Returns the downcasted uint32 from uint256, reverting on
     * overflow (when the input is greater than largest uint32).
     *
     * Counterpart to Solidity's `uint32` operator.
     *
     * Requirements:
     *
     * - input must fit into 32 bits
     */
    function toUint32(uint256 value) internal pure returns (uint32) {
        if (value > type(uint32).max) {
            revert SafeCastOverflowedUintDowncast(32, value);
        }
        return uint32(value);
    }

    /**
     * @dev Returns the downcasted uint24 from uint256, reverting on
     * overflow (when the input is greater than largest uint24).
     *
     * Counterpart to Solidity's `uint24` operator.
     *
     * Requirements:
     *
     * - input must fit into 24 bits
     */
    function toUint24(uint256 value) internal pure returns (uint24) {
        if (value > type(uint24).max) {
            revert SafeCastOverflowedUintDowncast(24, value);
        }
        return uint24(value);
    }

    /**
     * @dev Returns the downcasted uint16 from uint256, reverting on
     * overflow (when the input is greater than largest uint16).
     *
     * Counterpart to Solidity's `uint16` operator.
     *
     * Requirements:
     *
     * - input must fit into 16 bits
     */
    function toUint16(uint256 value) internal pure returns (uint16) {
        if (value > type(uint16).max) {
            revert SafeCastOverflowedUintDowncast(16, value);
        }
        return uint16(value);
    }

    /**
     * @dev Returns the downcasted uint8 from uint256, reverting on
     * overflow (when the input is greater than largest uint8).
     *
     * Counterpart to Solidity's `uint8` operator.
     *
     * Requirements:
     *
     * - input must fit into 8 bits
     */
    function toUint8(uint256 value) internal pure returns (uint8) {
        if (value > type(uint8).max) {
            revert SafeCastOverflowedUintDowncast(8, value);
        }
        return uint8(value);
    }

    /**
     * @dev Converts a signed int256 into an unsigned uint256.
     *
     * Requirements:
     *
     * - input must be greater than or equal to 0.
     */
    function toUint256(int256 value) internal pure returns (uint256) {
        if (value < 0) {
            revert SafeCastOverflowedIntToUint(value);
        }
        return uint256(value);
    }

    /**
     * @dev Returns the downcasted int248 from int256, reverting on
     * overflow (when the input is less than smallest int248 or
     * greater than largest int248).
     *
     * Counterpart to Solidity's `int248` operator.
     *
     * Requirements:
     *
     * - input must fit into 248 bits
     */
    function toInt248(int256 value) internal pure returns (int248 downcasted) {
        downcasted = int248(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(248, value);
        }
    }

    /**
     * @dev Returns the downcasted int240 from int256, reverting on
     * overflow (when the input is less than smallest int240 or
     * greater than largest int240).
     *
     * Counterpart to Solidity's `int240` operator.
     *
     * Requirements:
     *
     * - input must fit into 240 bits
     */
    function toInt240(int256 value) internal pure returns (int240 downcasted) {
        downcasted = int240(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(240, value);
        }
    }

    /**
     * @dev Returns the downcasted int232 from int256, reverting on
     * overflow (when the input is less than smallest int232 or
     * greater than largest int232).
     *
     * Counterpart to Solidity's `int232` operator.
     *
     * Requirements:
     *
     * - input must fit into 232 bits
     */
    function toInt232(int256 value) internal pure returns (int232 downcasted) {
        downcasted = int232(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(232, value);
        }
    }

    /**
     * @dev Returns the downcasted int224 from int256, reverting on
     * overflow (when the input is less than smallest int224 or
     * greater than largest int224).
     *
     * Counterpart to Solidity's `int224` operator.
     *
     * Requirements:
     *
     * - input must fit into 224 bits
     */
    function toInt224(int256 value) internal pure returns (int224 downcasted) {
        downcasted = int224(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(224, value);
        }
    }

    /**
     * @dev Returns the downcasted int216 from int256, reverting on
     * overflow (when the input is less than smallest int216 or
     * greater than largest int216).
     *
     * Counterpart to Solidity's `int216` operator.
     *
     * Requirements:
     *
     * - input must fit into 216 bits
     */
    function toInt216(int256 value) internal pure returns (int216 downcasted) {
        downcasted = int216(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(216, value);
        }
    }

    /**
     * @dev Returns the downcasted int208 from int256, reverting on
     * overflow (when the input is less than smallest int208 or
     * greater than largest int208).
     *
     * Counterpart to Solidity's `int208` operator.
     *
     * Requirements:
     *
     * - input must fit into 208 bits
     */
    function toInt208(int256 value) internal pure returns (int208 downcasted) {
        downcasted = int208(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(208, value);
        }
    }

    /**
     * @dev Returns the downcasted int200 from int256, reverting on
     * overflow (when the input is less than smallest int200 or
     * greater than largest int200).
     *
     * Counterpart to Solidity's `int200` operator.
     *
     * Requirements:
     *
     * - input must fit into 200 bits
     */
    function toInt200(int256 value) internal pure returns (int200 downcasted) {
        downcasted = int200(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(200, value);
        }
    }

    /**
     * @dev Returns the downcasted int192 from int256, reverting on
     * overflow (when the input is less than smallest int192 or
     * greater than largest int192).
     *
     * Counterpart to Solidity's `int192` operator.
     *
     * Requirements:
     *
     * - input must fit into 192 bits
     */
    function toInt192(int256 value) internal pure returns (int192 downcasted) {
        downcasted = int192(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(192, value);
        }
    }

    /**
     * @dev Returns the downcasted int184 from int256, reverting on
     * overflow (when the input is less than smallest int184 or
     * greater than largest int184).
     *
     * Counterpart to Solidity's `int184` operator.
     *
     * Requirements:
     *
     * - input must fit into 184 bits
     */
    function toInt184(int256 value) internal pure returns (int184 downcasted) {
        downcasted = int184(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(184, value);
        }
    }

    /**
     * @dev Returns the downcasted int176 from int256, reverting on
     * overflow (when the input is less than smallest int176 or
     * greater than largest int176).
     *
     * Counterpart to Solidity's `int176` operator.
     *
     * Requirements:
     *
     * - input must fit into 176 bits
     */
    function toInt176(int256 value) internal pure returns (int176 downcasted) {
        downcasted = int176(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(176, value);
        }
    }

    /**
     * @dev Returns the downcasted int168 from int256, reverting on
     * overflow (when the input is less than smallest int168 or
     * greater than largest int168).
     *
     * Counterpart to Solidity's `int168` operator.
     *
     * Requirements:
     *
     * - input must fit into 168 bits
     */
    function toInt168(int256 value) internal pure returns (int168 downcasted) {
        downcasted = int168(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(168, value);
        }
    }

    /**
     * @dev Returns the downcasted int160 from int256, reverting on
     * overflow (when the input is less than smallest int160 or
     * greater than largest int160).
     *
     * Counterpart to Solidity's `int160` operator.
     *
     * Requirements:
     *
     * - input must fit into 160 bits
     */
    function toInt160(int256 value) internal pure returns (int160 downcasted) {
        downcasted = int160(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(160, value);
        }
    }

    /**
     * @dev Returns the downcasted int152 from int256, reverting on
     * overflow (when the input is less than smallest int152 or
     * greater than largest int152).
     *
     * Counterpart to Solidity's `int152` operator.
     *
     * Requirements:
     *
     * - input must fit into 152 bits
     */
    function toInt152(int256 value) internal pure returns (int152 downcasted) {
        downcasted = int152(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(152, value);
        }
    }

    /**
     * @dev Returns the downcasted int144 from int256, reverting on
     * overflow (when the input is less than smallest int144 or
     * greater than largest int144).
     *
     * Counterpart to Solidity's `int144` operator.
     *
     * Requirements:
     *
     * - input must fit into 144 bits
     */
    function toInt144(int256 value) internal pure returns (int144 downcasted) {
        downcasted = int144(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(144, value);
        }
    }

    /**
     * @dev Returns the downcasted int136 from int256, reverting on
     * overflow (when the input is less than smallest int136 or
     * greater than largest int136).
     *
     * Counterpart to Solidity's `int136` operator.
     *
     * Requirements:
     *
     * - input must fit into 136 bits
     */
    function toInt136(int256 value) internal pure returns (int136 downcasted) {
        downcasted = int136(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(136, value);
        }
    }

    /**
     * @dev Returns the downcasted int128 from int256, reverting on
     * overflow (when the input is less than smallest int128 or
     * greater than largest int128).
     *
     * Counterpart to Solidity's `int128` operator.
     *
     * Requirements:
     *
     * - input must fit into 128 bits
     */
    function toInt128(int256 value) internal pure returns (int128 downcasted) {
        downcasted = int128(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(128, value);
        }
    }

    /**
     * @dev Returns the downcasted int120 from int256, reverting on
     * overflow (when the input is less than smallest int120 or
     * greater than largest int120).
     *
     * Counterpart to Solidity's `int120` operator.
     *
     * Requirements:
     *
     * - input must fit into 120 bits
     */
    function toInt120(int256 value) internal pure returns (int120 downcasted) {
        downcasted = int120(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(120, value);
        }
    }

    /**
     * @dev Returns the downcasted int112 from int256, reverting on
     * overflow (when the input is less than smallest int112 or
     * greater than largest int112).
     *
     * Counterpart to Solidity's `int112` operator.
     *
     * Requirements:
     *
     * - input must fit into 112 bits
     */
    function toInt112(int256 value) internal pure returns (int112 downcasted) {
        downcasted = int112(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(112, value);
        }
    }

    /**
     * @dev Returns the downcasted int104 from int256, reverting on
     * overflow (when the input is less than smallest int104 or
     * greater than largest int104).
     *
     * Counterpart to Solidity's `int104` operator.
     *
     * Requirements:
     *
     * - input must fit into 104 bits
     */
    function toInt104(int256 value) internal pure returns (int104 downcasted) {
        downcasted = int104(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(104, value);
        }
    }

    /**
     * @dev Returns the downcasted int96 from int256, reverting on
     * overflow (when the input is less than smallest int96 or
     * greater than largest int96).
     *
     * Counterpart to Solidity's `int96` operator.
     *
     * Requirements:
     *
     * - input must fit into 96 bits
     */
    function toInt96(int256 value) internal pure returns (int96 downcasted) {
        downcasted = int96(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(96, value);
        }
    }

    /**
     * @dev Returns the downcasted int88 from int256, reverting on
     * overflow (when the input is less than smallest int88 or
     * greater than largest int88).
     *
     * Counterpart to Solidity's `int88` operator.
     *
     * Requirements:
     *
     * - input must fit into 88 bits
     */
    function toInt88(int256 value) internal pure returns (int88 downcasted) {
        downcasted = int88(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(88, value);
        }
    }

    /**
     * @dev Returns the downcasted int80 from int256, reverting on
     * overflow (when the input is less than smallest int80 or
     * greater than largest int80).
     *
     * Counterpart to Solidity's `int80` operator.
     *
     * Requirements:
     *
     * - input must fit into 80 bits
     */
    function toInt80(int256 value) internal pure returns (int80 downcasted) {
        downcasted = int80(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(80, value);
        }
    }

    /**
     * @dev Returns the downcasted int72 from int256, reverting on
     * overflow (when the input is less than smallest int72 or
     * greater than largest int72).
     *
     * Counterpart to Solidity's `int72` operator.
     *
     * Requirements:
     *
     * - input must fit into 72 bits
     */
    function toInt72(int256 value) internal pure returns (int72 downcasted) {
        downcasted = int72(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(72, value);
        }
    }

    /**
     * @dev Returns the downcasted int64 from int256, reverting on
     * overflow (when the input is less than smallest int64 or
     * greater than largest int64).
     *
     * Counterpart to Solidity's `int64` operator.
     *
     * Requirements:
     *
     * - input must fit into 64 bits
     */
    function toInt64(int256 value) internal pure returns (int64 downcasted) {
        downcasted = int64(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(64, value);
        }
    }

    /**
     * @dev Returns the downcasted int56 from int256, reverting on
     * overflow (when the input is less than smallest int56 or
     * greater than largest int56).
     *
     * Counterpart to Solidity's `int56` operator.
     *
     * Requirements:
     *
     * - input must fit into 56 bits
     */
    function toInt56(int256 value) internal pure returns (int56 downcasted) {
        downcasted = int56(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(56, value);
        }
    }

    /**
     * @dev Returns the downcasted int48 from int256, reverting on
     * overflow (when the input is less than smallest int48 or
     * greater than largest int48).
     *
     * Counterpart to Solidity's `int48` operator.
     *
     * Requirements:
     *
     * - input must fit into 48 bits
     */
    function toInt48(int256 value) internal pure returns (int48 downcasted) {
        downcasted = int48(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(48, value);
        }
    }

    /**
     * @dev Returns the downcasted int40 from int256, reverting on
     * overflow (when the input is less than smallest int40 or
     * greater than largest int40).
     *
     * Counterpart to Solidity's `int40` operator.
     *
     * Requirements:
     *
     * - input must fit into 40 bits
     */
    function toInt40(int256 value) internal pure returns (int40 downcasted) {
        downcasted = int40(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(40, value);
        }
    }

    /**
     * @dev Returns the downcasted int32 from int256, reverting on
     * overflow (when the input is less than smallest int32 or
     * greater than largest int32).
     *
     * Counterpart to Solidity's `int32` operator.
     *
     * Requirements:
     *
     * - input must fit into 32 bits
     */
    function toInt32(int256 value) internal pure returns (int32 downcasted) {
        downcasted = int32(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(32, value);
        }
    }

    /**
     * @dev Returns the downcasted int24 from int256, reverting on
     * overflow (when the input is less than smallest int24 or
     * greater than largest int24).
     *
     * Counterpart to Solidity's `int24` operator.
     *
     * Requirements:
     *
     * - input must fit into 24 bits
     */
    function toInt24(int256 value) internal pure returns (int24 downcasted) {
        downcasted = int24(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(24, value);
        }
    }

    /**
     * @dev Returns the downcasted int16 from int256, reverting on
     * overflow (when the input is less than smallest int16 or
     * greater than largest int16).
     *
     * Counterpart to Solidity's `int16` operator.
     *
     * Requirements:
     *
     * - input must fit into 16 bits
     */
    function toInt16(int256 value) internal pure returns (int16 downcasted) {
        downcasted = int16(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(16, value);
        }
    }

    /**
     * @dev Returns the downcasted int8 from int256, reverting on
     * overflow (when the input is less than smallest int8 or
     * greater than largest int8).
     *
     * Counterpart to Solidity's `int8` operator.
     *
     * Requirements:
     *
     * - input must fit into 8 bits
     */
    function toInt8(int256 value) internal pure returns (int8 downcasted) {
        downcasted = int8(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(8, value);
        }
    }

    /**
     * @dev Converts an unsigned uint256 into a signed int256.
     *
     * Requirements:
     *
     * - input must be less than or equal to maxInt256.
     */
    function toInt256(uint256 value) internal pure returns (int256) {
        // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
        if (value > uint256(type(int256).max)) {
            revert SafeCastOverflowedUintToInt(value);
        }
        return int256(value);
    }

    /**
     * @dev Cast a boolean (false or true) to a uint256 (0 or 1) with no jump.
     */
    function toUint(bool b) internal pure returns (uint256 u) {
        assembly ("memory-safe") {
            u := iszero(iszero(b))
        }
    }
}

// lib/solady/src/utils/SafeTransferLib.sol

/// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
/// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/SafeTransferLib.sol)
/// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/SafeTransferLib.sol)
/// @author Permit2 operations from (https://github.com/Uniswap/permit2/blob/main/src/libraries/Permit2Lib.sol)
///
/// @dev Note:
/// - For ETH transfers, please use `forceSafeTransferETH` for DoS protection.
library SafeTransferLib {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev The ETH transfer has failed.
    error ETHTransferFailed();

    /// @dev The ERC20 `transferFrom` has failed.
    error TransferFromFailed();

    /// @dev The ERC20 `transfer` has failed.
    error TransferFailed();

    /// @dev The ERC20 `approve` has failed.
    error ApproveFailed();

    /// @dev The ERC20 `totalSupply` query has failed.
    error TotalSupplyQueryFailed();

    /// @dev The Permit2 operation has failed.
    error Permit2Failed();

    /// @dev The Permit2 amount must be less than `2**160 - 1`.
    error Permit2AmountOverflow();

    /// @dev The Permit2 approve operation has failed.
    error Permit2ApproveFailed();

    /// @dev The Permit2 lockdown operation has failed.
    error Permit2LockdownFailed();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Suggested gas stipend for contract receiving ETH that disallows any storage writes.
    uint256 internal constant GAS_STIPEND_NO_STORAGE_WRITES = 2300;

    /// @dev Suggested gas stipend for contract receiving ETH to perform a few
    /// storage reads and writes, but low enough to prevent griefing.
    uint256 internal constant GAS_STIPEND_NO_GRIEF = 100_000;

    /// @dev The unique EIP-712 domain separator for the DAI token contract.
    bytes32 internal constant DAI_DOMAIN_SEPARATOR = 0xdbb8cf42e1ecb028be3f3dbc922e1d878b963f411dc388ced501601c60f7c6f7;

    /// @dev The address for the WETH9 contract on Ethereum mainnet.
    address internal constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    /// @dev The canonical Permit2 address.
    /// [Github](https://github.com/Uniswap/permit2)
    /// [Etherscan](https://etherscan.io/address/0x000000000022D473030F116dDEE9F6B43aC78BA3)
    address internal constant PERMIT2 = 0x000000000022D473030F116dDEE9F6B43aC78BA3;

    /// @dev The canonical address of the `SELFDESTRUCT` ETH mover.
    /// See: https://gist.github.com/Vectorized/1cb8ad4cf393b1378e08f23f79bd99fa
    /// [Etherscan](https://etherscan.io/address/0x00000000000073c48c8055bD43D1A53799176f0D)
    address internal constant ETH_MOVER = 0x00000000000073c48c8055bD43D1A53799176f0D;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       ETH OPERATIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    // If the ETH transfer MUST succeed with a reasonable gas budget, use the force variants.
    //
    // The regular variants:
    // - Forwards all remaining gas to the target.
    // - Reverts if the target reverts.
    // - Reverts if the current contract has insufficient balance.
    //
    // The force variants:
    // - Forwards with an optional gas stipend
    //   (defaults to `GAS_STIPEND_NO_GRIEF`, which is sufficient for most cases).
    // - If the target reverts, or if the gas stipend is exhausted,
    //   creates a temporary contract to force send the ETH via `SELFDESTRUCT`.
    //   Future compatible with `SENDALL`: https://eips.ethereum.org/EIPS/eip-4758.
    // - Reverts if the current contract has insufficient balance.
    //
    // The try variants:
    // - Forwards with a mandatory gas stipend.
    // - Instead of reverting, returns whether the transfer succeeded.

    /// @dev Sends `amount` (in wei) ETH to `to`.
    function safeTransferETH(address to, uint256 amount) internal {
        /// @solidity memory-safe-assembly
        assembly {
            if iszero(call(gas(), to, amount, codesize(), 0x00, codesize(), 0x00)) {
                mstore(0x00, 0xb12d13eb) // `ETHTransferFailed()`.
                revert(0x1c, 0x04)
            }
        }
    }

    /// @dev Sends all the ETH in the current contract to `to`.
    function safeTransferAllETH(address to) internal {
        /// @solidity memory-safe-assembly
        assembly {
            // Transfer all the ETH and check if it succeeded or not.
            if iszero(call(gas(), to, selfbalance(), codesize(), 0x00, codesize(), 0x00)) {
                mstore(0x00, 0xb12d13eb) // `ETHTransferFailed()`.
                revert(0x1c, 0x04)
            }
        }
    }

    /// @dev Force sends `amount` (in wei) ETH to `to`, with a `gasStipend`.
    function forceSafeTransferETH(address to, uint256 amount, uint256 gasStipend) internal {
        /// @solidity memory-safe-assembly
        assembly {
            if lt(selfbalance(), amount) {
                mstore(0x00, 0xb12d13eb) // `ETHTransferFailed()`.
                revert(0x1c, 0x04)
            }
            if iszero(call(gasStipend, to, amount, codesize(), 0x00, codesize(), 0x00)) {
                mstore(0x00, to) // Store the address in scratch space.
                mstore8(0x0b, 0x73) // Opcode `PUSH20`.
                mstore8(0x20, 0xff) // Opcode `SELFDESTRUCT`.
                if iszero(create(amount, 0x0b, 0x16)) { revert(codesize(), codesize()) } // For gas estimation.
            }
        }
    }

    /// @dev Force sends all the ETH in the current contract to `to`, with a `gasStipend`.
    function forceSafeTransferAllETH(address to, uint256 gasStipend) internal {
        /// @solidity memory-safe-assembly
        assembly {
            if iszero(call(gasStipend, to, selfbalance(), codesize(), 0x00, codesize(), 0x00)) {
                mstore(0x00, to) // Store the address in scratch space.
                mstore8(0x0b, 0x73) // Opcode `PUSH20`.
                mstore8(0x20, 0xff) // Opcode `SELFDESTRUCT`.
                if iszero(create(selfbalance(), 0x0b, 0x16)) { revert(codesize(), codesize()) } // For gas estimation.
            }
        }
    }

    /// @dev Force sends `amount` (in wei) ETH to `to`, with `GAS_STIPEND_NO_GRIEF`.
    function forceSafeTransferETH(address to, uint256 amount) internal {
        /// @solidity memory-safe-assembly
        assembly {
            if lt(selfbalance(), amount) {
                mstore(0x00, 0xb12d13eb) // `ETHTransferFailed()`.
                revert(0x1c, 0x04)
            }
            if iszero(call(GAS_STIPEND_NO_GRIEF, to, amount, codesize(), 0x00, codesize(), 0x00)) {
                mstore(0x00, to) // Store the address in scratch space.
                mstore8(0x0b, 0x73) // Opcode `PUSH20`.
                mstore8(0x20, 0xff) // Opcode `SELFDESTRUCT`.
                if iszero(create(amount, 0x0b, 0x16)) { revert(codesize(), codesize()) } // For gas estimation.
            }
        }
    }

    /// @dev Force sends all the ETH in the current contract to `to`, with `GAS_STIPEND_NO_GRIEF`.
    function forceSafeTransferAllETH(address to) internal {
        /// @solidity memory-safe-assembly
        assembly {
            // forgefmt: disable-next-item
            if iszero(call(GAS_STIPEND_NO_GRIEF, to, selfbalance(), codesize(), 0x00, codesize(), 0x00)) {
                mstore(0x00, to) // Store the address in scratch space.
                mstore8(0x0b, 0x73) // Opcode `PUSH20`.
                mstore8(0x20, 0xff) // Opcode `SELFDESTRUCT`.
                if iszero(create(selfbalance(), 0x0b, 0x16)) { revert(codesize(), codesize()) } // For gas estimation.
            }
        }
    }

    /// @dev Sends `amount` (in wei) ETH to `to`, with a `gasStipend`.
    function trySafeTransferETH(address to, uint256 amount, uint256 gasStipend) internal returns (bool success) {
        /// @solidity memory-safe-assembly
        assembly {
            success := call(gasStipend, to, amount, codesize(), 0x00, codesize(), 0x00)
        }
    }

    /// @dev Sends all the ETH in the current contract to `to`, with a `gasStipend`.
    function trySafeTransferAllETH(address to, uint256 gasStipend) internal returns (bool success) {
        /// @solidity memory-safe-assembly
        assembly {
            success := call(gasStipend, to, selfbalance(), codesize(), 0x00, codesize(), 0x00)
        }
    }

    /// @dev Force transfers ETH to `to`, without triggering the fallback (if any).
    /// This method attempts to use a separate contract to send via `SELFDESTRUCT`,
    /// and upon failure, deploys a minimal vault to accrue the ETH.
    function safeMoveETH(address to, uint256 amount) internal returns (address vault) {
        /// @solidity memory-safe-assembly
        assembly {
            to := shr(96, shl(96, to)) // Clean upper 96 bits.
            for { let mover := ETH_MOVER } iszero(eq(to, address())) {} {
                let selfBalanceBefore := selfbalance()
                if or(lt(selfBalanceBefore, amount), eq(to, mover)) {
                    mstore(0x00, 0xb12d13eb) // `ETHTransferFailed()`.
                    revert(0x1c, 0x04)
                }
                if extcodesize(mover) {
                    let balanceBefore := balance(to) // Check via delta, in case `SELFDESTRUCT` is bricked.
                    mstore(0x00, to)
                    pop(call(gas(), mover, amount, 0x00, 0x20, codesize(), 0x00))
                    // If `address(to).balance >= amount + balanceBefore`, skip vault workflow.
                    if iszero(lt(balance(to), add(amount, balanceBefore))) { break }
                    // Just in case `SELFDESTRUCT` is changed to not revert and do nothing.
                    if lt(selfBalanceBefore, selfbalance()) { invalid() }
                }
                let m := mload(0x40)
                // If the mover is missing or bricked, deploy a minimal vault
                // that withdraws all ETH to `to` when being called only by `to`.
                // forgefmt: disable-next-item
                mstore(add(m, 0x20), 0x33146025575b600160005260206000f35b3d3d3d3d47335af1601a5760003dfd)
                mstore(m, or(to, shl(160, 0x6035600b3d3960353df3fe73)))
                // Compute and store the bytecode hash.
                mstore8(0x00, 0xff) // Write the prefix.
                mstore(0x35, keccak256(m, 0x40))
                mstore(0x01, shl(96, address())) // Deployer.
                mstore(0x15, 0) // Salt.
                vault := keccak256(0x00, 0x55)
                pop(call(gas(), vault, amount, codesize(), 0x00, codesize(), 0x00))
                // The vault returns a single word on success. Failure reverts with empty data.
                if iszero(returndatasize()) {
                    if iszero(create2(0, m, 0x40, 0)) { revert(codesize(), codesize()) } // For gas estimation.
                }
                mstore(0x40, m) // Restore the free memory pointer.
                break
            }
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      ERC20 OPERATIONS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Sends `amount` of ERC20 `token` from `from` to `to`.
    /// Reverts upon failure.
    ///
    /// The `from` account must have at least `amount` approved for
    /// the current contract to manage.
    function safeTransferFrom(address token, address from, address to, uint256 amount) internal {
        /// @solidity memory-safe-assembly
        assembly {
            let m := mload(0x40) // Cache the free memory pointer.
            mstore(0x60, amount) // Store the `amount` argument.
            mstore(0x40, to) // Store the `to` argument.
            mstore(0x2c, shl(96, from)) // Store the `from` argument.
            mstore(0x0c, 0x23b872dd000000000000000000000000) // `transferFrom(address,address,uint256)`.
            let success := call(gas(), token, 0, 0x1c, 0x64, 0x00, 0x20)
            if iszero(and(eq(mload(0x00), 1), success)) {
                if iszero(lt(or(iszero(extcodesize(token)), returndatasize()), success)) {
                    mstore(0x00, 0x7939f424) // `TransferFromFailed()`.
                    revert(0x1c, 0x04)
                }
            }
            mstore(0x60, 0) // Restore the zero slot to zero.
            mstore(0x40, m) // Restore the free memory pointer.
        }
    }

    /// @dev Sends `amount` of ERC20 `token` from `from` to `to`.
    ///
    /// The `from` account must have at least `amount` approved for the current contract to manage.
    function trySafeTransferFrom(address token, address from, address to, uint256 amount)
        internal
        returns (bool success)
    {
        /// @solidity memory-safe-assembly
        assembly {
            let m := mload(0x40) // Cache the free memory pointer.
            mstore(0x60, amount) // Store the `amount` argument.
            mstore(0x40, to) // Store the `to` argument.
            mstore(0x2c, shl(96, from)) // Store the `from` argument.
            mstore(0x0c, 0x23b872dd000000000000000000000000) // `transferFrom(address,address,uint256)`.
            success := call(gas(), token, 0, 0x1c, 0x64, 0x00, 0x20)
            if iszero(and(eq(mload(0x00), 1), success)) {
                success := lt(or(iszero(extcodesize(token)), returndatasize()), success)
            }
            mstore(0x60, 0) // Restore the zero slot to zero.
            mstore(0x40, m) // Restore the free memory pointer.
        }
    }

    /// @dev Sends all of ERC20 `token` from `from` to `to`.
    /// Reverts upon failure.
    ///
    /// The `from` account must have their entire balance approved for the current contract to manage.
    function safeTransferAllFrom(address token, address from, address to) internal returns (uint256 amount) {
        /// @solidity memory-safe-assembly
        assembly {
            let m := mload(0x40) // Cache the free memory pointer.
            mstore(0x40, to) // Store the `to` argument.
            mstore(0x2c, shl(96, from)) // Store the `from` argument.
            mstore(0x0c, 0x70a08231000000000000000000000000) // `balanceOf(address)`.
            // Read the balance, reverting upon failure.
            if iszero(
                and( // The arguments of `and` are evaluated from right to left.
                    gt(returndatasize(), 0x1f), // At least 32 bytes returned.
                    staticcall(gas(), token, 0x1c, 0x24, 0x60, 0x20)
                )
            ) {
                mstore(0x00, 0x7939f424) // `TransferFromFailed()`.
                revert(0x1c, 0x04)
            }
            mstore(0x00, 0x23b872dd) // `transferFrom(address,address,uint256)`.
            amount := mload(0x60) // The `amount` is already at 0x60. We'll need to return it.
            // Perform the transfer, reverting upon failure.
            let success := call(gas(), token, 0, 0x1c, 0x64, 0x00, 0x20)
            if iszero(and(eq(mload(0x00), 1), success)) {
                if iszero(lt(or(iszero(extcodesize(token)), returndatasize()), success)) {
                    mstore(0x00, 0x7939f424) // `TransferFromFailed()`.
                    revert(0x1c, 0x04)
                }
            }
            mstore(0x60, 0) // Restore the zero slot to zero.
            mstore(0x40, m) // Restore the free memory pointer.
        }
    }

    /// @dev Sends `amount` of ERC20 `token` from the current contract to `to`.
    /// Reverts upon failure.
    function safeTransfer(address token, address to, uint256 amount) internal {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x14, to) // Store the `to` argument.
            mstore(0x34, amount) // Store the `amount` argument.
            mstore(0x00, 0xa9059cbb000000000000000000000000) // `transfer(address,uint256)`.
            // Perform the transfer, reverting upon failure.
            let success := call(gas(), token, 0, 0x10, 0x44, 0x00, 0x20)
            if iszero(and(eq(mload(0x00), 1), success)) {
                if iszero(lt(or(iszero(extcodesize(token)), returndatasize()), success)) {
                    mstore(0x00, 0x90b8ec18) // `TransferFailed()`.
                    revert(0x1c, 0x04)
                }
            }
            mstore(0x34, 0) // Restore the part of the free memory pointer that was overwritten.
        }
    }

    /// @dev Sends all of ERC20 `token` from the current contract to `to`.
    /// Reverts upon failure.
    function safeTransferAll(address token, address to) internal returns (uint256 amount) {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x00, 0x70a08231) // Store the function selector of `balanceOf(address)`.
            mstore(0x20, address()) // Store the address of the current contract.
            // Read the balance, reverting upon failure.
            if iszero(
                and( // The arguments of `and` are evaluated from right to left.
                    gt(returndatasize(), 0x1f), // At least 32 bytes returned.
                    staticcall(gas(), token, 0x1c, 0x24, 0x34, 0x20)
                )
            ) {
                mstore(0x00, 0x90b8ec18) // `TransferFailed()`.
                revert(0x1c, 0x04)
            }
            mstore(0x14, to) // Store the `to` argument.
            amount := mload(0x34) // The `amount` is already at 0x34. We'll need to return it.
            mstore(0x00, 0xa9059cbb000000000000000000000000) // `transfer(address,uint256)`.
            // Perform the transfer, reverting upon failure.
            let success := call(gas(), token, 0, 0x10, 0x44, 0x00, 0x20)
            if iszero(and(eq(mload(0x00), 1), success)) {
                if iszero(lt(or(iszero(extcodesize(token)), returndatasize()), success)) {
                    mstore(0x00, 0x90b8ec18) // `TransferFailed()`.
                    revert(0x1c, 0x04)
                }
            }
            mstore(0x34, 0) // Restore the part of the free memory pointer that was overwritten.
        }
    }

    /// @dev Sets `amount` of ERC20 `token` for `to` to manage on behalf of the current contract.
    /// Reverts upon failure.
    function safeApprove(address token, address to, uint256 amount) internal {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x14, to) // Store the `to` argument.
            mstore(0x34, amount) // Store the `amount` argument.
            mstore(0x00, 0x095ea7b3000000000000000000000000) // `approve(address,uint256)`.
            let success := call(gas(), token, 0, 0x10, 0x44, 0x00, 0x20)
            if iszero(and(eq(mload(0x00), 1), success)) {
                if iszero(lt(or(iszero(extcodesize(token)), returndatasize()), success)) {
                    mstore(0x00, 0x3e3f8f73) // `ApproveFailed()`.
                    revert(0x1c, 0x04)
                }
            }
            mstore(0x34, 0) // Restore the part of the free memory pointer that was overwritten.
        }
    }

    /// @dev Sets `amount` of ERC20 `token` for `to` to manage on behalf of the current contract.
    /// If the initial attempt to approve fails, attempts to reset the approved amount to zero,
    /// then retries the approval again (some tokens, e.g. USDT, requires this).
    /// Reverts upon failure.
    function safeApproveWithRetry(address token, address to, uint256 amount) internal {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x14, to) // Store the `to` argument.
            mstore(0x34, amount) // Store the `amount` argument.
            mstore(0x00, 0x095ea7b3000000000000000000000000) // `approve(address,uint256)`.
            // Perform the approval, retrying upon failure.
            let success := call(gas(), token, 0, 0x10, 0x44, 0x00, 0x20)
            if iszero(and(eq(mload(0x00), 1), success)) {
                if iszero(lt(or(iszero(extcodesize(token)), returndatasize()), success)) {
                    mstore(0x34, 0) // Store 0 for the `amount`.
                    mstore(0x00, 0x095ea7b3000000000000000000000000) // `approve(address,uint256)`.
                    pop(call(gas(), token, 0, 0x10, 0x44, codesize(), 0x00)) // Reset the approval.
                    mstore(0x34, amount) // Store back the original `amount`.
                    // Retry the approval, reverting upon failure.
                    success := call(gas(), token, 0, 0x10, 0x44, 0x00, 0x20)
                    if iszero(and(eq(mload(0x00), 1), success)) {
                        // Check the `extcodesize` again just in case the token selfdestructs lol.
                        if iszero(lt(or(iszero(extcodesize(token)), returndatasize()), success)) {
                            mstore(0x00, 0x3e3f8f73) // `ApproveFailed()`.
                            revert(0x1c, 0x04)
                        }
                    }
                }
            }
            mstore(0x34, 0) // Restore the part of the free memory pointer that was overwritten.
        }
    }

    /// @dev Returns the amount of ERC20 `token` owned by `account`.
    /// Returns zero if the `token` does not exist.
    function balanceOf(address token, address account) internal view returns (uint256 amount) {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x14, account) // Store the `account` argument.
            mstore(0x00, 0x70a08231000000000000000000000000) // `balanceOf(address)`.
            amount := mul( // The arguments of `mul` are evaluated from right to left.
                mload(0x20),
                and( // The arguments of `and` are evaluated from right to left.
                    gt(returndatasize(), 0x1f), // At least 32 bytes returned.
                    staticcall(gas(), token, 0x10, 0x24, 0x20, 0x20)
                )
            )
        }
    }

    /// @dev Performs a `token.balanceOf(account)` check.
    /// `implemented` denotes whether the `token` does not implement `balanceOf`.
    /// `amount` is zero if the `token` does not implement `balanceOf`.
    function checkBalanceOf(address token, address account) internal view returns (bool implemented, uint256 amount) {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x14, account) // Store the `account` argument.
            mstore(0x00, 0x70a08231000000000000000000000000) // `balanceOf(address)`.
            implemented := and( // The arguments of `and` are evaluated from right to left.
                gt(returndatasize(), 0x1f), // At least 32 bytes returned.
                staticcall(gas(), token, 0x10, 0x24, 0x20, 0x20)
            )
            amount := mul(mload(0x20), implemented)
        }
    }

    /// @dev Returns the total supply of the `token`.
    /// Reverts if the token does not exist or does not implement `totalSupply()`.
    function totalSupply(address token) internal view returns (uint256 result) {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x00, 0x18160ddd) // `totalSupply()`.
            if iszero(and(gt(returndatasize(), 0x1f), staticcall(gas(), token, 0x1c, 0x04, 0x00, 0x20))) {
                mstore(0x00, 0x54cd9435) // `TotalSupplyQueryFailed()`.
                revert(0x1c, 0x04)
            }
            result := mload(0x00)
        }
    }

    /// @dev Sends `amount` of ERC20 `token` from `from` to `to`.
    /// If the initial attempt fails, try to use Permit2 to transfer the token.
    /// Reverts upon failure.
    ///
    /// The `from` account must have at least `amount` approved for the current contract to manage.
    function safeTransferFrom2(address token, address from, address to, uint256 amount) internal {
        if (!trySafeTransferFrom(token, from, to, amount)) {
            permit2TransferFrom(token, from, to, amount);
        }
    }

    /// @dev Sends `amount` of ERC20 `token` from `from` to `to` via Permit2.
    /// Reverts upon failure.
    function permit2TransferFrom(address token, address from, address to, uint256 amount) internal {
        /// @solidity memory-safe-assembly
        assembly {
            let m := mload(0x40)
            mstore(add(m, 0x74), shr(96, shl(96, token)))
            mstore(add(m, 0x54), amount)
            mstore(add(m, 0x34), to)
            mstore(add(m, 0x20), shl(96, from))
            // `transferFrom(address,address,uint160,address)`.
            mstore(m, 0x36c78516000000000000000000000000)
            let p := PERMIT2
            let exists := eq(chainid(), 1)
            if iszero(exists) { exists := iszero(iszero(extcodesize(p))) }
            if iszero(
                and(
                    call(gas(), p, 0, add(m, 0x10), 0x84, codesize(), 0x00),
                    lt(iszero(extcodesize(token)), exists) // Token has code and Permit2 exists.
                )
            ) {
                mstore(0x00, 0x7939f4248757f0fd) // `TransferFromFailed()` or `Permit2AmountOverflow()`.
                revert(add(0x18, shl(2, iszero(iszero(shr(160, amount))))), 0x04)
            }
        }
    }

    /// @dev Permit a user to spend a given amount of
    /// another user's tokens via native EIP-2612 permit if possible, falling
    /// back to Permit2 if native permit fails or is not implemented on the token.
    function permit2(
        address token,
        address owner,
        address spender,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        bool success;
        /// @solidity memory-safe-assembly
        assembly {
            for {} shl(96, xor(token, WETH9)) {} {
                mstore(0x00, 0x3644e515) // `DOMAIN_SEPARATOR()`.
                if iszero(
                    and( // The arguments of `and` are evaluated from right to left.
                        lt(iszero(mload(0x00)), eq(returndatasize(), 0x20)), // Returns 1 non-zero word.
                        // Gas stipend to limit gas burn for tokens that don't refund gas when
                        // an non-existing function is called. 5K should be enough for a SLOAD.
                        staticcall(5000, token, 0x1c, 0x04, 0x00, 0x20)
                    )
                ) { break }
                // After here, we can be sure that token is a contract.
                let m := mload(0x40)
                mstore(add(m, 0x34), spender)
                mstore(add(m, 0x20), shl(96, owner))
                mstore(add(m, 0x74), deadline)
                if eq(mload(0x00), DAI_DOMAIN_SEPARATOR) {
                    mstore(0x14, owner)
                    mstore(0x00, 0x7ecebe00000000000000000000000000) // `nonces(address)`.
                    mstore(add(m, 0x94), lt(iszero(amount), staticcall(gas(), token, 0x10, 0x24, add(m, 0x54), 0x20)))
                    mstore(m, 0x8fcbaf0c000000000000000000000000) // `IDAIPermit.permit`.
                    // `nonces` is already at `add(m, 0x54)`.
                    // `amount != 0` is already stored at `add(m, 0x94)`.
                    mstore(add(m, 0xb4), and(0xff, v))
                    mstore(add(m, 0xd4), r)
                    mstore(add(m, 0xf4), s)
                    success := call(gas(), token, 0, add(m, 0x10), 0x104, codesize(), 0x00)
                    break
                }
                mstore(m, 0xd505accf000000000000000000000000) // `IERC20Permit.permit`.
                mstore(add(m, 0x54), amount)
                mstore(add(m, 0x94), and(0xff, v))
                mstore(add(m, 0xb4), r)
                mstore(add(m, 0xd4), s)
                success := call(gas(), token, 0, add(m, 0x10), 0xe4, codesize(), 0x00)
                break
            }
        }
        if (!success) simplePermit2(token, owner, spender, amount, deadline, v, r, s);
    }

    /// @dev Simple permit on the Permit2 contract.
    function simplePermit2(
        address token,
        address owner,
        address spender,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        /// @solidity memory-safe-assembly
        assembly {
            let m := mload(0x40)
            mstore(m, 0x927da105) // `allowance(address,address,address)`.
            {
                let addressMask := shr(96, not(0))
                mstore(add(m, 0x20), and(addressMask, owner))
                mstore(add(m, 0x40), and(addressMask, token))
                mstore(add(m, 0x60), and(addressMask, spender))
                mstore(add(m, 0xc0), and(addressMask, spender))
            }
            let p := mul(PERMIT2, iszero(shr(160, amount)))
            if iszero(
                and( // The arguments of `and` are evaluated from right to left.
                    gt(returndatasize(), 0x5f), // Returns 3 words: `amount`, `expiration`, `nonce`.
                    staticcall(gas(), p, add(m, 0x1c), 0x64, add(m, 0x60), 0x60)
                )
            ) {
                mstore(0x00, 0x6b836e6b8757f0fd) // `Permit2Failed()` or `Permit2AmountOverflow()`.
                revert(add(0x18, shl(2, iszero(p))), 0x04)
            }
            mstore(m, 0x2b67b570) // `Permit2.permit` (PermitSingle variant).
            // `owner` is already `add(m, 0x20)`.
            // `token` is already at `add(m, 0x40)`.
            mstore(add(m, 0x60), amount)
            mstore(add(m, 0x80), 0xffffffffffff) // `expiration = type(uint48).max`.
            // `nonce` is already at `add(m, 0xa0)`.
            // `spender` is already at `add(m, 0xc0)`.
            mstore(add(m, 0xe0), deadline)
            mstore(add(m, 0x100), 0x100) // `signature` offset.
            mstore(add(m, 0x120), 0x41) // `signature` length.
            mstore(add(m, 0x140), r)
            mstore(add(m, 0x160), s)
            mstore(add(m, 0x180), shl(248, v))
            if iszero( // Revert if token does not have code, or if the call fails.
                mul(extcodesize(token), call(gas(), p, 0, add(m, 0x1c), 0x184, codesize(), 0x00))
            ) {
                mstore(0x00, 0x6b836e6b) // `Permit2Failed()`.
                revert(0x1c, 0x04)
            }
        }
    }

    /// @dev Approves `spender` to spend `amount` of `token` for `address(this)`.
    function permit2Approve(address token, address spender, uint160 amount, uint48 expiration) internal {
        /// @solidity memory-safe-assembly
        assembly {
            let addressMask := shr(96, not(0))
            let m := mload(0x40)
            mstore(m, 0x87517c45) // `approve(address,address,uint160,uint48)`.
            mstore(add(m, 0x20), and(addressMask, token))
            mstore(add(m, 0x40), and(addressMask, spender))
            mstore(add(m, 0x60), and(addressMask, amount))
            mstore(add(m, 0x80), and(0xffffffffffff, expiration))
            if iszero(call(gas(), PERMIT2, 0, add(m, 0x1c), 0xa0, codesize(), 0x00)) {
                mstore(0x00, 0x324f14ae) // `Permit2ApproveFailed()`.
                revert(0x1c, 0x04)
            }
        }
    }

    /// @dev Revokes an approval for `token` and `spender` for `address(this)`.
    function permit2Lockdown(address token, address spender) internal {
        /// @solidity memory-safe-assembly
        assembly {
            let m := mload(0x40)
            mstore(m, 0xcc53287f) // `Permit2.lockdown`.
            mstore(add(m, 0x20), 0x20) // Offset of the `approvals`.
            mstore(add(m, 0x40), 1) // `approvals.length`.
            mstore(add(m, 0x60), shr(96, shl(96, token)))
            mstore(add(m, 0x80), shr(96, shl(96, spender)))
            if iszero(call(gas(), PERMIT2, 0, add(m, 0x1c), 0xa0, codesize(), 0x00)) {
                mstore(0x00, 0x96b3de23) // `Permit2LockdownFailed()`.
                revert(0x1c, 0x04)
            }
        }
    }
}

// lib/openzeppelin-contracts/contracts/utils/SlotDerivation.sol

// OpenZeppelin Contracts (last updated v5.3.0) (utils/SlotDerivation.sol)
// This file was procedurally generated from scripts/generate/templates/SlotDerivation.js.

/**
 * @dev Library for computing storage (and transient storage) locations from namespaces and deriving slots
 * corresponding to standard patterns. The derivation method for array and mapping matches the storage layout used by
 * the solidity language / compiler.
 *
 * See https://docs.soliditylang.org/en/v0.8.20/internals/layout_in_storage.html#mappings-and-dynamic-arrays[Solidity docs for mappings and dynamic arrays.].
 *
 * Example usage:
 * ```solidity
 * contract Example {
 *     // Add the library methods
 *     using StorageSlot for bytes32;
 *     using SlotDerivation for bytes32;
 *
 *     // Declare a namespace
 *     string private constant _NAMESPACE = "<namespace>"; // eg. OpenZeppelin.Slot
 *
 *     function setValueInNamespace(uint256 key, address newValue) internal {
 *         _NAMESPACE.erc7201Slot().deriveMapping(key).getAddressSlot().value = newValue;
 *     }
 *
 *     function getValueInNamespace(uint256 key) internal view returns (address) {
 *         return _NAMESPACE.erc7201Slot().deriveMapping(key).getAddressSlot().value;
 *     }
 * }
 * ```
 *
 * TIP: Consider using this library along with {StorageSlot}.
 *
 * NOTE: This library provides a way to manipulate storage locations in a non-standard way. Tooling for checking
 * upgrade safety will ignore the slots accessed through this library.
 *
 * _Available since v5.1._
 */
library SlotDerivation {
    /**
     * @dev Derive an ERC-7201 slot from a string (namespace).
     */
    function erc7201Slot(string memory namespace) internal pure returns (bytes32 slot) {
        assembly ("memory-safe") {
            mstore(0x00, sub(keccak256(add(namespace, 0x20), mload(namespace)), 1))
            slot := and(keccak256(0x00, 0x20), not(0xff))
        }
    }

    /**
     * @dev Add an offset to a slot to get the n-th element of a structure or an array.
     */
    function offset(bytes32 slot, uint256 pos) internal pure returns (bytes32 result) {
        unchecked {
            return bytes32(uint256(slot) + pos);
        }
    }

    /**
     * @dev Derive the location of the first element in an array from the slot where the length is stored.
     */
    function deriveArray(bytes32 slot) internal pure returns (bytes32 result) {
        assembly ("memory-safe") {
            mstore(0x00, slot)
            result := keccak256(0x00, 0x20)
        }
    }

    /**
     * @dev Derive the location of a mapping element from the key.
     */
    function deriveMapping(bytes32 slot, address key) internal pure returns (bytes32 result) {
        assembly ("memory-safe") {
            mstore(0x00, and(key, shr(96, not(0))))
            mstore(0x20, slot)
            result := keccak256(0x00, 0x40)
        }
    }

    /**
     * @dev Derive the location of a mapping element from the key.
     */
    function deriveMapping(bytes32 slot, bool key) internal pure returns (bytes32 result) {
        assembly ("memory-safe") {
            mstore(0x00, iszero(iszero(key)))
            mstore(0x20, slot)
            result := keccak256(0x00, 0x40)
        }
    }

    /**
     * @dev Derive the location of a mapping element from the key.
     */
    function deriveMapping(bytes32 slot, bytes32 key) internal pure returns (bytes32 result) {
        assembly ("memory-safe") {
            mstore(0x00, key)
            mstore(0x20, slot)
            result := keccak256(0x00, 0x40)
        }
    }

    /**
     * @dev Derive the location of a mapping element from the key.
     */
    function deriveMapping(bytes32 slot, uint256 key) internal pure returns (bytes32 result) {
        assembly ("memory-safe") {
            mstore(0x00, key)
            mstore(0x20, slot)
            result := keccak256(0x00, 0x40)
        }
    }

    /**
     * @dev Derive the location of a mapping element from the key.
     */
    function deriveMapping(bytes32 slot, int256 key) internal pure returns (bytes32 result) {
        assembly ("memory-safe") {
            mstore(0x00, key)
            mstore(0x20, slot)
            result := keccak256(0x00, 0x40)
        }
    }

    /**
     * @dev Derive the location of a mapping element from the key.
     */
    function deriveMapping(bytes32 slot, string memory key) internal pure returns (bytes32 result) {
        assembly ("memory-safe") {
            let length := mload(key)
            let begin := add(key, 0x20)
            let end := add(begin, length)
            let cache := mload(end)
            mstore(end, slot)
            result := keccak256(begin, add(length, 0x20))
            mstore(end, cache)
        }
    }

    /**
     * @dev Derive the location of a mapping element from the key.
     */
    function deriveMapping(bytes32 slot, bytes memory key) internal pure returns (bytes32 result) {
        assembly ("memory-safe") {
            let length := mload(key)
            let begin := add(key, 0x20)
            let end := add(begin, length)
            let cache := mload(end)
            mstore(end, slot)
            result := keccak256(begin, add(length, 0x20))
            mstore(end, cache)
        }
    }
}

// lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol

// OpenZeppelin Contracts (last updated v5.1.0) (utils/StorageSlot.sol)
// This file was procedurally generated from scripts/generate/templates/StorageSlot.js.

/**
 * @dev Library for reading and writing primitive types to specific storage slots.
 *
 * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
 * This library helps with reading and writing to such slots without the need for inline assembly.
 *
 * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
 *
 * Example usage to set ERC-1967 implementation slot:
 * ```solidity
 * contract ERC1967 {
 *     // Define the slot. Alternatively, use the SlotDerivation library to derive the slot.
 *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
 *
 *     function _getImplementation() internal view returns (address) {
 *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
 *     }
 *
 *     function _setImplementation(address newImplementation) internal {
 *         require(newImplementation.code.length > 0);
 *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
 *     }
 * }
 * ```
 *
 * TIP: Consider using this library along with {SlotDerivation}.
 */
library StorageSlot {
    struct AddressSlot {
        address value;
    }

    struct BooleanSlot {
        bool value;
    }

    struct Bytes32Slot {
        bytes32 value;
    }

    struct Uint256Slot {
        uint256 value;
    }

    struct Int256Slot {
        int256 value;
    }

    struct StringSlot {
        string value;
    }

    struct BytesSlot {
        bytes value;
    }

    /**
     * @dev Returns an `AddressSlot` with member `value` located at `slot`.
     */
    function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `BooleanSlot` with member `value` located at `slot`.
     */
    function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `Bytes32Slot` with member `value` located at `slot`.
     */
    function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `Uint256Slot` with member `value` located at `slot`.
     */
    function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `Int256Slot` with member `value` located at `slot`.
     */
    function getInt256Slot(bytes32 slot) internal pure returns (Int256Slot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `StringSlot` with member `value` located at `slot`.
     */
    function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
     */
    function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
        assembly ("memory-safe") {
            r.slot := store.slot
        }
    }

    /**
     * @dev Returns a `BytesSlot` with member `value` located at `slot`.
     */
    function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
     */
    function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
        assembly ("memory-safe") {
            r.slot := store.slot
        }
    }
}

// src/contracts/libraries/Subnetwork.sol

/**
 * @title Subnetwork
 * @notice Library implementing a subnetwork identifier encoding and parsing helper set.
 */
library Subnetwork {
    function subnetwork(address network_, uint96 identifier_) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(network_)) << 96 | identifier_);
    }

    function network(bytes32 subnetwork_) internal pure returns (address) {
        return address(uint160(uint256(subnetwork_ >> 96)));
    }

    function identifier(bytes32 subnetwork_) internal pure returns (uint96) {
        return uint96(uint256(subnetwork_));
    }
}

// src/contracts/libraries/UniversalDelegatorIndex.sol

/**
 * @title UniversalDelegatorIndex
 * @notice Library implementing a hierarchical slot index encoding and decoding helper set.
 */
library UniversalDelegatorIndex {
    error NotParentIndex();
    error ZeroIndex();

    function createIndex(uint96 parentIndex, uint32 localIndex) internal pure returns (uint96) {
        if (parentIndex == 0) {
            return uint96(localIndex) << 64;
        }
        if (parentIndex << 32 == 0) {
            return parentIndex | uint96(localIndex) << 32;
        }
        if (parentIndex << 64 == 0) {
            return parentIndex | uint96(localIndex);
        }
        revert NotParentIndex();
    }

    function getParentIndex(uint96 index) internal pure returns (uint96) {
        if (index == 0) {
            revert ZeroIndex();
        }
        if (index << 32 == 0) {
            return 0;
        }
        if (index << 64 == 0) {
            return index & 0xFFFFFFFF0000000000000000;
        }
        return index & 0xFFFFFFFFFFFFFFFF00000000;
    }

    function getChildIndex(uint96 index) internal pure returns (uint32) {
        if (index == 0) {
            revert ZeroIndex();
        }
        if (index << 32 == 0) {
            return uint32(index >> 64);
        }
        if (index << 64 == 0) {
            return uint32(index >> 32);
        }
        return uint32(index);
    }

    function getDepth(uint96 index) internal pure returns (uint256) {
        if (index == 0) {
            return 0;
        }
        if (index << 32 == 0) {
            return 1;
        }
        if (index << 64 == 0) {
            return 2;
        }
        return 3;
    }
}

// lib/openzeppelin-contracts/contracts/interfaces/draft-IERC6093.sol

// OpenZeppelin Contracts (last updated v5.4.0) (interfaces/draft-IERC6093.sol)

/**
 * @dev Standard ERC-20 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC-20 tokens.
 */
interface IERC20Errors {
    /**
     * @dev Indicates an error related to the current `balance` of a `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param balance Current balance for the interacting account.
     * @param needed Minimum amount required to perform a transfer.
     */
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC20InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC20InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `spender`’s `allowance`. Used in transfers.
     * @param spender Address that may be allowed to operate on tokens without being their owner.
     * @param allowance Amount of tokens a `spender` is allowed to operate with.
     * @param needed Minimum amount required to perform a transfer.
     */
    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);

    /**
     * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
    error ERC20InvalidApprover(address approver);

    /**
     * @dev Indicates a failure with the `spender` to be approved. Used in approvals.
     * @param spender Address that may be allowed to operate on tokens without being their owner.
     */
    error ERC20InvalidSpender(address spender);
}

/**
 * @dev Standard ERC-721 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC-721 tokens.
 */
interface IERC721Errors {
    /**
     * @dev Indicates that an address can't be an owner. For example, `address(0)` is a forbidden owner in ERC-20.
     * Used in balance queries.
     * @param owner Address of the current owner of a token.
     */
    error ERC721InvalidOwner(address owner);

    /**
     * @dev Indicates a `tokenId` whose `owner` is the zero address.
     * @param tokenId Identifier number of a token.
     */
    error ERC721NonexistentToken(uint256 tokenId);

    /**
     * @dev Indicates an error related to the ownership over a particular token. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param tokenId Identifier number of a token.
     * @param owner Address of the current owner of a token.
     */
    error ERC721IncorrectOwner(address sender, uint256 tokenId, address owner);

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC721InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC721InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `operator`’s approval. Used in transfers.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     * @param tokenId Identifier number of a token.
     */
    error ERC721InsufficientApproval(address operator, uint256 tokenId);

    /**
     * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
    error ERC721InvalidApprover(address approver);

    /**
     * @dev Indicates a failure with the `operator` to be approved. Used in approvals.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     */
    error ERC721InvalidOperator(address operator);
}

/**
 * @dev Standard ERC-1155 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC-1155 tokens.
 */
interface IERC1155Errors {
    /**
     * @dev Indicates an error related to the current `balance` of a `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param balance Current balance for the interacting account.
     * @param needed Minimum amount required to perform a transfer.
     * @param tokenId Identifier number of a token.
     */
    error ERC1155InsufficientBalance(address sender, uint256 balance, uint256 needed, uint256 tokenId);

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC1155InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC1155InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `operator`’s approval. Used in transfers.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     * @param owner Address of the current owner of a token.
     */
    error ERC1155MissingApprovalForAll(address operator, address owner);

    /**
     * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
    error ERC1155InvalidApprover(address approver);

    /**
     * @dev Indicates a failure with the `operator` to be approved. Used in approvals.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     */
    error ERC1155InvalidOperator(address operator);

    /**
     * @dev Indicates an array length mismatch between ids and values in a safeBatchTransferFrom operation.
     * Used in batch transfers.
     * @param idsLength Length of the array of token identifiers
     * @param valuesLength Length of the array of token amounts
     */
    error ERC1155InvalidArrayLength(uint256 idsLength, uint256 valuesLength);
}

// lib/openzeppelin-contracts-upgradeable/contracts/utils/ContextUpgradeable.sol

// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal onlyInitializing {}

    function __Context_init_unchained() internal onlyInitializing {}

    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// lib/openzeppelin-contracts/contracts/utils/Create2.sol

// OpenZeppelin Contracts (last updated v5.1.0) (utils/Create2.sol)

/**
 * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.
 * `CREATE2` can be used to compute in advance the address where a smart
 * contract will be deployed, which allows for interesting new mechanisms known
 * as 'counterfactual interactions'.
 *
 * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more
 * information.
 */
library Create2 {
    /**
     * @dev There's no code to deploy.
     */
    error Create2EmptyBytecode();

    /**
     * @dev Deploys a contract using `CREATE2`. The address where the contract
     * will be deployed can be known in advance via {computeAddress}.
     *
     * The bytecode for a contract can be obtained from Solidity with
     * `type(contractName).creationCode`.
     *
     * Requirements:
     *
     * - `bytecode` must not be empty.
     * - `salt` must have not been used for `bytecode` already.
     * - the factory must have a balance of at least `amount`.
     * - if `amount` is non-zero, `bytecode` must have a `payable` constructor.
     */
    function deploy(uint256 amount, bytes32 salt, bytes memory bytecode) internal returns (address addr) {
        if (address(this).balance < amount) {
            revert Errors.InsufficientBalance(address(this).balance, amount);
        }
        if (bytecode.length == 0) {
            revert Create2EmptyBytecode();
        }
        assembly ("memory-safe") {
            addr := create2(amount, add(bytecode, 0x20), mload(bytecode), salt)
            // if no address was created, and returndata is not empty, bubble revert
            if and(iszero(addr), not(iszero(returndatasize()))) {
                let p := mload(0x40)
                returndatacopy(p, 0, returndatasize())
                revert(p, returndatasize())
            }
        }
        if (addr == address(0)) {
            revert Errors.FailedDeployment();
        }
    }

    /**
     * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the
     * `bytecodeHash` or `salt` will result in a new destination address.
     */
    function computeAddress(bytes32 salt, bytes32 bytecodeHash) internal view returns (address) {
        return computeAddress(salt, bytecodeHash, address(this));
    }

    /**
     * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at
     * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.
     */
    function computeAddress(bytes32 salt, bytes32 bytecodeHash, address deployer) internal pure returns (address addr) {
        assembly ("memory-safe") {
            let ptr := mload(0x40) // Get free memory pointer

            // |                   | ↓ ptr ...  ↓ ptr + 0x0B (start) ...  ↓ ptr + 0x20 ...  ↓ ptr + 0x40 ...   |
            // |-------------------|---------------------------------------------------------------------------|
            // | bytecodeHash      |                                                        CCCCCCCCCCCCC...CC |
            // | salt              |                                      BBBBBBBBBBBBB...BB                   |
            // | deployer          | 000000...0000AAAAAAAAAAAAAAAAAAA...AA                                     |
            // | 0xFF              |            FF                                                             |
            // |-------------------|---------------------------------------------------------------------------|
            // | memory            | 000000...00FFAAAAAAAAAAAAAAAAAAA...AABBBBBBBBBBBBB...BBCCCCCCCCCCCCC...CC |
            // | keccak(start, 85) |            ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ |

            mstore(add(ptr, 0x40), bytecodeHash)
            mstore(add(ptr, 0x20), salt)
            mstore(ptr, deployer) // Right-aligned with 12 preceding garbage bytes
            let start := add(ptr, 0x0b) // The hashed data starts at the final garbage byte which we will set to 0xff
            mstore8(start, 0xff)
            addr := and(keccak256(start, 85), 0xffffffffffffffffffffffffffffffffffffffff)
        }
    }
}

// src/interfaces/delegator/IBaseDelegator.sol

/**
 * @title IBaseDelegator
 * @notice Interface for the BaseDelegator contract.
 */
interface IBaseDelegator is IEntity {
    error AlreadySet();
    error InsufficientHookGas();
    error NotNetwork();
    error NotSlasher();
    error NotVault();

    /**
     * @notice Base parameters needed for delegators' deployment.
     * @param defaultAdminRoleHolder Address of the initial DEFAULT_ADMIN_ROLE holder.
     * @param hook Address of the hook contract.
     * @param hookSetRoleHolder Address of the initial HOOK_SET_ROLE holder.
     */
    struct BaseParams {
        address defaultAdminRoleHolder;
        address hook;
        address hookSetRoleHolder;
    }

    /**
     * @notice Base hints for a stake.
     * @param operatorVaultOptInHint Hint for the operator-vault opt-in.
     * @param operatorNetworkOptInHint Hint for the operator-network opt-in.
     */
    struct StakeBaseHints {
        bytes operatorVaultOptInHint;
        bytes operatorNetworkOptInHint;
    }

    /**
     * @notice Emitted when a subnetwork's maximum limit is set.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param amount New maximum subnetwork's limit (how much stake the subnetwork is ready to get).
     */
    event SetMaxNetworkLimit(bytes32 indexed subnetwork, uint256 amount);

    /**
     * @notice Emitted when a slash happens.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param operator Address of the operator.
     * @param amount Amount of the collateral to be slashed.
     * @param captureTimestamp Time point when the stake was captured.
     */
    event OnSlash(bytes32 indexed subnetwork, address indexed operator, uint256 amount, uint48 captureTimestamp);

    /**
     * @notice Emitted when a hook is set.
     * @param hook Address of the hook.
     */
    event SetHook(address indexed hook);

    /**
     * @notice Get a version of the delegator (different versions mean different interfaces).
     * @return Version Of the delegator.
     * @dev Must return 1 for this one.
     */
    function VERSION() external view returns (uint64);

    /**
     * @notice Get the network registry's address.
     * @return Address Of the network registry.
     */
    function NETWORK_REGISTRY() external view returns (address);

    /**
     * @notice Get the vault factory's address.
     * @return Address Of the vault factory.
     */
    function VAULT_FACTORY() external view returns (address);

    /**
     * @notice Get the operator-vault opt-in service's address.
     * @return Address Of the operator-vault opt-in service.
     */
    function OPERATOR_VAULT_OPT_IN_SERVICE() external view returns (address);

    /**
     * @notice Get the operator-network opt-in service's address.
     * @return Address Of the operator-network opt-in service.
     */
    function OPERATOR_NETWORK_OPT_IN_SERVICE() external view returns (address);

    /**
     * @notice Get a gas limit for the hook.
     * @return Value Of the hook gas limit.
     */
    function HOOK_GAS_LIMIT() external view returns (uint256);

    /**
     * @notice Get a reserve gas between the gas limit check and the hook's execution.
     * @return Value Of the reserve gas.
     */
    function HOOK_RESERVE() external view returns (uint256);

    /**
     * @notice Get a hook setter's role.
     * @return Identifier Of the hook setter role.
     */
    function HOOK_SET_ROLE() external view returns (bytes32);

    /**
     * @notice Get the vault's address.
     * @return Address Of the vault.
     */
    function vault() external view returns (address);

    /**
     * @notice Get the hook's address.
     * @return Address Of the hook.
     * @dev The hook can have arbitrary logic under certain functions, however, it doesn't affect the stake guarantees.
     */
    function hook() external view returns (address);

    /**
     * @notice Get a particular subnetwork's maximum limit
     * (meaning the subnetwork is not ready to get more as a stake).
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @return Maximum Limit of the subnetwork.
     */
    function maxNetworkLimit(bytes32 subnetwork) external view returns (uint256);

    /**
     * @notice Get a stake that a given subnetwork could be able to slash for a certain operator at a given timestamp
     * until the end of the consequent epoch using hints (if no cross-slashing and no slashings by the subnetwork).
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param operator Address of the operator.
     * @param timestamp Time point to capture the stake at.
     * @param hints Hints for the checkpoints' indexes.
     * @return Slashable Stake at the given timestamp until the end of the consequent epoch.
     * @dev Warning: it is not safe to use timestamp >= current one for the stake capturing, as it can change later.
     */
    function stakeAt(bytes32 subnetwork, address operator, uint48 timestamp, bytes memory hints)
        external
        view
        returns (uint256);

    /**
     * @notice Get a stake that a given subnetwork will be able to slash
     * for a certain operator until the end of the next epoch (if no cross-slashing and no slashings by the subnetwork).
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param operator Address of the operator.
     * @return Slashable Stake until the end of the next epoch.
     * @dev Warning: this function is not safe to use for stake capturing, as it can change by the end of the block.
     */
    function stake(bytes32 subnetwork, address operator) external view returns (uint256);

    /**
     * @notice Set a maximum limit for a subnetwork (how much stake the subnetwork is ready to get).
     * @param identifier Identifier of the subnetwork.
     * @param amount New maximum subnetwork's limit.
     * @dev Only a network can call this function.
     */
    function setMaxNetworkLimit(uint96 identifier, uint256 amount) external;

    /**
     * @notice Set a new hook.
     * @param hook Address of the hook.
     * @dev Only a HOOK_SET_ROLE holder can call this function.
     * The hook can have arbitrary logic under certain functions, however, it doesn't affect the stake guarantees.
     */
    function setHook(address hook) external;

    /**
     * @notice Called when a slash happens.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param operator Address of the operator.
     * @param amount Amount of the collateral slashed.
     * @param captureTimestamp Time point when the stake was captured.
     * @param data Some additional data.
     * @dev Only the vault's slasher can call this function.
     */
    function onSlash(bytes32 subnetwork, address operator, uint256 amount, uint48 captureTimestamp, bytes calldata data)
        external;
}

// src/interfaces/slasher/IBaseSlasher.sol

/**
 * @title IBaseSlasher
 * @notice Interface for the BaseSlasher contract.
 */
interface IBaseSlasher is IEntity {
    error NoBurner();
    error InsufficientBurnerGas();
    error NotNetworkMiddleware();
    error NotVault();

    /**
     * @notice Base parameters needed for slashers' deployment.
     * @param isBurnerHook If the burner is needed to be called on a slashing.
     */
    struct BaseParams {
        bool isBurnerHook;
    }

    /**
     * @notice Hints for a slashable stake.
     * @param stakeHints Hints for the stake checkpoints.
     * @param cumulativeSlashFromHint Hint for the cumulative slash amount at a capture timestamp.
     */
    struct SlashableStakeHints {
        bytes stakeHints;
        bytes cumulativeSlashFromHint;
    }

    /**
     * @notice General data for the delegator.
     * @param slasherType Type of the slasher.
     * @param data Slasher-dependent data for the delegator.
     */
    struct GeneralDelegatorData {
        uint64 slasherType;
        bytes data;
    }

    /**
     * @notice Get a gas limit for the burner.
     * @return Value Of the burner gas limit.
     */
    function BURNER_GAS_LIMIT() external view returns (uint256);

    /**
     * @notice Get a reserve gas between the gas limit check and the burner's execution.
     * @return Value Of the reserve gas.
     */
    function BURNER_RESERVE() external view returns (uint256);

    /**
     * @notice Get the vault factory's address.
     * @return Address Of the vault factory.
     */
    function VAULT_FACTORY() external view returns (address);

    /**
     * @notice Get the network middleware service's address.
     * @return Address Of the network middleware service.
     */
    function NETWORK_MIDDLEWARE_SERVICE() external view returns (address);

    /**
     * @notice Get the vault's address.
     * @return Address Of the vault to perform slashings on.
     */
    function vault() external view returns (address);

    /**
     * @notice Get if the burner is needed to be called on a slashing.
     * @return If The burner is a hook.
     */
    function isBurnerHook() external view returns (bool);

    /**
     * @notice Get the latest capture timestamp that was slashed on a subnetwork.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param operator Address of the operator.
     * @return Latest Capture timestamp that was slashed.
     */
    function latestSlashedCaptureTimestamp(bytes32 subnetwork, address operator) external view returns (uint48);

    /**
     * @notice Get a cumulative slash amount for an operator on a subnetwork until a given timestamp (inclusively) using a hint.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param operator Address of the operator.
     * @param timestamp Time point to get the cumulative slash amount until (inclusively).
     * @param hint Hint for the checkpoint index.
     * @return Cumulative Slash amount until the given timestamp (inclusively).
     */
    function cumulativeSlashAt(bytes32 subnetwork, address operator, uint48 timestamp, bytes memory hint)
        external
        view
        returns (uint256);

    /**
     * @notice Get a cumulative slash amount for an operator on a subnetwork.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param operator Address of the operator.
     * @return Cumulative Slash amount.
     */
    function cumulativeSlash(bytes32 subnetwork, address operator) external view returns (uint256);

    /**
     * @notice Get a slashable amount of a stake got at a given capture timestamp using hints.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param operator Address of the operator.
     * @param captureTimestamp Time point to get the stake amount at.
     * @param hints Hints for the checkpoints' indexes.
     * @return Slashable Amount of the stake.
     */
    function slashableStake(bytes32 subnetwork, address operator, uint48 captureTimestamp, bytes memory hints)
        external
        view
        returns (uint256);
}

// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol

// OpenZeppelin Contracts (last updated v5.4.0) (token/ERC20/extensions/IERC20Metadata.sol)

/**
 * @dev Interface for the optional metadata functions from the ERC-20 standard.
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// src/interfaces/common/IFactory.sol

/**
 * @title IFactory
 * @notice Interface for the Factory contract.
 */
interface IFactory is IRegistry {
    error AlreadyBlacklisted();
    error AlreadyWhitelisted();
    error InvalidImplementation();
    error InvalidType();

    /**
     * @notice Emitted when a new type is whitelisted.
     * @param implementation Address of the new implementation.
     */
    event Whitelist(address indexed implementation);

    /**
     * @notice Emitted when a type is blacklisted (e.g., in case of invalid implementation).
     * @param type_ Type that was blacklisted.
     * @dev The given type is still deployable.
     */
    event Blacklist(uint64 indexed type_);

    /**
     * @notice Get the total number of whitelisted types.
     * @return Total Number of types.
     */
    function totalTypes() external view returns (uint64);

    /**
     * @notice Get the implementation for a given type.
     * @param type_ Position to get the implementation at.
     * @return Address Of the implementation.
     */
    function implementation(uint64 type_) external view returns (address);

    /**
     * @notice Get if a type is blacklisted (e.g., in case of invalid implementation).
     * @param type_ Type to check.
     * @return Whether The type is blacklisted.
     * @dev The given type is still deployable.
     */
    function blacklisted(uint64 type_) external view returns (bool);

    /**
     * @notice Whitelist a new type of entity.
     * @param implementation Address of the new implementation.
     */
    function whitelist(address implementation) external;

    /**
     * @notice Blacklist a type of entity.
     * @param type_ Type to blacklist.
     * @dev The given type will still be deployable.
     */
    function blacklist(uint64 type_) external;

    /**
     * @notice Create a new entity at the factory.
     * @param type_ Type's implementation to use.
     * @param data Initial data for the entity creation.
     * @return Address Of the entity.
     * @dev CREATE2 salt is constructed from the given parameters.
     */
    function create(uint64 type_, bytes calldata data) external returns (address);
}

// lib/openzeppelin-contracts/contracts/access/Ownable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// lib/openzeppelin-contracts-upgradeable/contracts/utils/ReentrancyGuardUpgradeable.sol

// OpenZeppelin Contracts (last updated v5.1.0) (utils/ReentrancyGuard.sol)

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If EIP-1153 (transient storage) is available on the chain you're deploying at,
 * consider using {ReentrancyGuardTransient} instead.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuardUpgradeable is Initializable {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    /// @custom:storage-location erc7201:openzeppelin.storage.ReentrancyGuard
    struct ReentrancyGuardStorage {
        uint256 _status;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.ReentrancyGuard")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant ReentrancyGuardStorageLocation =
        0x9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f00;

    function _getReentrancyGuardStorage() private pure returns (ReentrancyGuardStorage storage $) {
        assembly {
            $.slot := ReentrancyGuardStorageLocation
        }
    }

    /**
     * @dev Unauthorized reentrant call.
     */
    error ReentrancyGuardReentrantCall();

    function __ReentrancyGuard_init() internal onlyInitializing {
        __ReentrancyGuard_init_unchained();
    }

    function __ReentrancyGuard_init_unchained() internal onlyInitializing {
        ReentrancyGuardStorage storage $ = _getReentrancyGuardStorage();
        $._status = NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        ReentrancyGuardStorage storage $ = _getReentrancyGuardStorage();
        // On the first call to nonReentrant, _status will be NOT_ENTERED
        if ($._status == ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }

        // Any calls to nonReentrant after this point will fail
        $._status = ENTERED;
    }

    function _nonReentrantAfter() private {
        ReentrancyGuardStorage storage $ = _getReentrancyGuardStorage();
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        $._status = NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        ReentrancyGuardStorage storage $ = _getReentrancyGuardStorage();
        return $._status == ENTERED;
    }
}

// src/contracts/common/StaticDelegateCallable.sol

// Copyright (c) 2025 Symbiotic

/// @title StaticDelegateCallable
/// @notice Base contract for static delegate-call based state reads.
abstract contract StaticDelegateCallable is IStaticDelegateCallable {
    /// @inheritdoc IStaticDelegateCallable
    function staticDelegateCall(address target, bytes calldata data) external {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        bytes memory revertData = abi.encode(success, returndata);
        assembly {
            revert(add(32, revertData), mload(revertData))
        }
    }
}

// lib/openzeppelin-contracts/contracts/proxy/Clones.sol

// OpenZeppelin Contracts (last updated v5.4.0) (proxy/Clones.sol)

/**
 * @dev https://eips.ethereum.org/EIPS/eip-1167[ERC-1167] is a standard for
 * deploying minimal proxy contracts, also known as "clones".
 *
 * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
 * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
 *
 * The library includes functions to deploy a proxy using either `create` (traditional deployment) or `create2`
 * (salted deterministic deployment). It also includes functions to predict the addresses of clones deployed using the
 * deterministic method.
 */
library Clones {
    error CloneArgumentsTooLong();

    /**
     * @dev Deploys and returns the address of a clone that mimics the behavior of `implementation`.
     *
     * This function uses the create opcode, which should never revert.
     *
     * WARNING: This function does not check if `implementation` has code. A clone that points to an address
     * without code cannot be initialized. Initialization calls may appear to be successful when, in reality, they
     * have no effect and leave the clone uninitialized, allowing a third party to initialize it later.
     */
    function clone(address implementation) internal returns (address instance) {
        return clone(implementation, 0);
    }

    /**
     * @dev Same as {xref-Clones-clone-address-}[clone], but with a `value` parameter to send native currency
     * to the new contract.
     *
     * WARNING: This function does not check if `implementation` has code. A clone that points to an address
     * without code cannot be initialized. Initialization calls may appear to be successful when, in reality, they
     * have no effect and leave the clone uninitialized, allowing a third party to initialize it later.
     *
     * NOTE: Using a non-zero value at creation will require the contract using this function (e.g. a factory)
     * to always have enough balance for new deployments. Consider exposing this function under a payable method.
     */
    function clone(address implementation, uint256 value) internal returns (address instance) {
        if (address(this).balance < value) {
            revert Errors.InsufficientBalance(address(this).balance, value);
        }
        assembly ("memory-safe") {
            // Cleans the upper 96 bits of the `implementation` word, then packs the first 3 bytes
            // of the `implementation` address with the bytecode before the address.
            mstore(0x00, or(shr(0xe8, shl(0x60, implementation)), 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000))
            // Packs the remaining 17 bytes of `implementation` with the bytecode after the address.
            mstore(0x20, or(shl(0x78, implementation), 0x5af43d82803e903d91602b57fd5bf3))
            instance := create(value, 0x09, 0x37)
        }
        if (instance == address(0)) {
            revert Errors.FailedDeployment();
        }
    }

    /**
     * @dev Deploys and returns the address of a clone that mimics the behavior of `implementation`.
     *
     * This function uses the create2 opcode and a `salt` to deterministically deploy
     * the clone. Using the same `implementation` and `salt` multiple times will revert, since
     * the clones cannot be deployed twice at the same address.
     *
     * WARNING: This function does not check if `implementation` has code. A clone that points to an address
     * without code cannot be initialized. Initialization calls may appear to be successful when, in reality, they
     * have no effect and leave the clone uninitialized, allowing a third party to initialize it later.
     */
    function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
        return cloneDeterministic(implementation, salt, 0);
    }

    /**
     * @dev Same as {xref-Clones-cloneDeterministic-address-bytes32-}[cloneDeterministic], but with
     * a `value` parameter to send native currency to the new contract.
     *
     * WARNING: This function does not check if `implementation` has code. A clone that points to an address
     * without code cannot be initialized. Initialization calls may appear to be successful when, in reality, they
     * have no effect and leave the clone uninitialized, allowing a third party to initialize it later.
     *
     * NOTE: Using a non-zero value at creation will require the contract using this function (e.g. a factory)
     * to always have enough balance for new deployments. Consider exposing this function under a payable method.
     */
    function cloneDeterministic(address implementation, bytes32 salt, uint256 value)
        internal
        returns (address instance)
    {
        if (address(this).balance < value) {
            revert Errors.InsufficientBalance(address(this).balance, value);
        }
        assembly ("memory-safe") {
            // Cleans the upper 96 bits of the `implementation` word, then packs the first 3 bytes
            // of the `implementation` address with the bytecode before the address.
            mstore(0x00, or(shr(0xe8, shl(0x60, implementation)), 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000))
            // Packs the remaining 17 bytes of `implementation` with the bytecode after the address.
            mstore(0x20, or(shl(0x78, implementation), 0x5af43d82803e903d91602b57fd5bf3))
            instance := create2(value, 0x09, 0x37, salt)
        }
        if (instance == address(0)) {
            revert Errors.FailedDeployment();
        }
    }

    /**
     * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
     */
    function predictDeterministicAddress(address implementation, bytes32 salt, address deployer)
        internal
        pure
        returns (address predicted)
    {
        assembly ("memory-safe") {
            let ptr := mload(0x40)
            mstore(add(ptr, 0x38), deployer)
            mstore(add(ptr, 0x24), 0x5af43d82803e903d91602b57fd5bf3ff)
            mstore(add(ptr, 0x14), implementation)
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73)
            mstore(add(ptr, 0x58), salt)
            mstore(add(ptr, 0x78), keccak256(add(ptr, 0x0c), 0x37))
            predicted := and(keccak256(add(ptr, 0x43), 0x55), 0xffffffffffffffffffffffffffffffffffffffff)
        }
    }

    /**
     * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
     */
    function predictDeterministicAddress(address implementation, bytes32 salt)
        internal
        view
        returns (address predicted)
    {
        return predictDeterministicAddress(implementation, salt, address(this));
    }

    /**
     * @dev Deploys and returns the address of a clone that mimics the behavior of `implementation` with custom
     * immutable arguments. These are provided through `args` and cannot be changed after deployment. To
     * access the arguments within the implementation, use {fetchCloneArgs}.
     *
     * This function uses the create opcode, which should never revert.
     *
     * WARNING: This function does not check if `implementation` has code. A clone that points to an address
     * without code cannot be initialized. Initialization calls may appear to be successful when, in reality, they
     * have no effect and leave the clone uninitialized, allowing a third party to initialize it later.
     */
    function cloneWithImmutableArgs(address implementation, bytes memory args) internal returns (address instance) {
        return cloneWithImmutableArgs(implementation, args, 0);
    }

    /**
     * @dev Same as {xref-Clones-cloneWithImmutableArgs-address-bytes-}[cloneWithImmutableArgs], but with a `value`
     * parameter to send native currency to the new contract.
     *
     * WARNING: This function does not check if `implementation` has code. A clone that points to an address
     * without code cannot be initialized. Initialization calls may appear to be successful when, in reality, they
     * have no effect and leave the clone uninitialized, allowing a third party to initialize it later.
     *
     * NOTE: Using a non-zero value at creation will require the contract using this function (e.g. a factory)
     * to always have enough balance for new deployments. Consider exposing this function under a payable method.
     */
    function cloneWithImmutableArgs(address implementation, bytes memory args, uint256 value)
        internal
        returns (address instance)
    {
        if (address(this).balance < value) {
            revert Errors.InsufficientBalance(address(this).balance, value);
        }
        bytes memory bytecode = _cloneCodeWithImmutableArgs(implementation, args);
        assembly ("memory-safe") {
            instance := create(value, add(bytecode, 0x20), mload(bytecode))
        }
        if (instance == address(0)) {
            revert Errors.FailedDeployment();
        }
    }

    /**
     * @dev Deploys and returns the address of a clone that mimics the behavior of `implementation` with custom
     * immutable arguments. These are provided through `args` and cannot be changed after deployment. To
     * access the arguments within the implementation, use {fetchCloneArgs}.
     *
     * This function uses the create2 opcode and a `salt` to deterministically deploy the clone. Using the same
     * `implementation`, `args` and `salt` multiple times will revert, since the clones cannot be deployed twice
     * at the same address.
     *
     * WARNING: This function does not check if `implementation` has code. A clone that points to an address
     * without code cannot be initialized. Initialization calls may appear to be successful when, in reality, they
     * have no effect and leave the clone uninitialized, allowing a third party to initialize it later.
     */
    function cloneDeterministicWithImmutableArgs(address implementation, bytes memory args, bytes32 salt)
        internal
        returns (address instance)
    {
        return cloneDeterministicWithImmutableArgs(implementation, args, salt, 0);
    }

    /**
     * @dev Same as {xref-Clones-cloneDeterministicWithImmutableArgs-address-bytes-bytes32-}[cloneDeterministicWithImmutableArgs],
     * but with a `value` parameter to send native currency to the new contract.
     *
     * WARNING: This function does not check if `implementation` has code. A clone that points to an address
     * without code cannot be initialized. Initialization calls may appear to be successful when, in reality, they
     * have no effect and leave the clone uninitialized, allowing a third party to initialize it later.
     *
     * NOTE: Using a non-zero value at creation will require the contract using this function (e.g. a factory)
     * to always have enough balance for new deployments. Consider exposing this function under a payable method.
     */
    function cloneDeterministicWithImmutableArgs(address implementation, bytes memory args, bytes32 salt, uint256 value)
        internal
        returns (address instance)
    {
        bytes memory bytecode = _cloneCodeWithImmutableArgs(implementation, args);
        return Create2.deploy(value, salt, bytecode);
    }

    /**
     * @dev Computes the address of a clone deployed using {Clones-cloneDeterministicWithImmutableArgs}.
     */
    function predictDeterministicAddressWithImmutableArgs(
        address implementation,
        bytes memory args,
        bytes32 salt,
        address deployer
    ) internal pure returns (address predicted) {
        bytes memory bytecode = _cloneCodeWithImmutableArgs(implementation, args);
        return Create2.computeAddress(salt, keccak256(bytecode), deployer);
    }

    /**
     * @dev Computes the address of a clone deployed using {Clones-cloneDeterministicWithImmutableArgs}.
     */
    function predictDeterministicAddressWithImmutableArgs(address implementation, bytes memory args, bytes32 salt)
        internal
        view
        returns (address predicted)
    {
        return predictDeterministicAddressWithImmutableArgs(implementation, args, salt, address(this));
    }

    /**
     * @dev Get the immutable args attached to a clone.
     *
     * - If `instance` is a clone that was deployed using `clone` or `cloneDeterministic`, this
     *   function will return an empty array.
     * - If `instance` is a clone that was deployed using `cloneWithImmutableArgs` or
     *   `cloneDeterministicWithImmutableArgs`, this function will return the args array used at
     *   creation.
     * - If `instance` is NOT a clone deployed using this library, the behavior is undefined. This
     *   function should only be used to check addresses that are known to be clones.
     */
    function fetchCloneArgs(address instance) internal view returns (bytes memory) {
        bytes memory result = new bytes(instance.code.length - 45); // revert if length is too short
        assembly ("memory-safe") {
            extcodecopy(instance, add(result, 32), 45, mload(result))
        }
        return result;
    }

    /**
     * @dev Helper that prepares the initcode of the proxy with immutable args.
     *
     * An assembly variant of this function requires copying the `args` array, which can be efficiently done using
     * `mcopy`. Unfortunately, that opcode is not available before cancun. A pure solidity implementation using
     * abi.encodePacked is more expensive but also more portable and easier to review.
     *
     * NOTE: https://eips.ethereum.org/EIPS/eip-170[EIP-170] limits the length of the contract code to 24576 bytes.
     * With the proxy code taking 45 bytes, that limits the length of the immutable args to 24531 bytes.
     */
    function _cloneCodeWithImmutableArgs(address implementation, bytes memory args)
        private
        pure
        returns (bytes memory)
    {
        if (args.length > 24_531) revert CloneArgumentsTooLong();
        return abi.encodePacked(
            hex"61",
            uint16(args.length + 45),
            hex"3d81600a3d39f3363d3d373d3d3d363d73",
            implementation,
            hex"5af43d82803e903d91602b57fd5bf3",
            args
        );
    }
}

// lib/openzeppelin-contracts-upgradeable/contracts/utils/introspection/ERC165Upgradeable.sol

// OpenZeppelin Contracts (last updated v5.4.0) (utils/introspection/ERC165.sol)

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC-165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 */
abstract contract ERC165Upgradeable is Initializable, IERC165 {
    function __ERC165_init() internal onlyInitializing {}

    function __ERC165_init_unchained() internal onlyInitializing {}

    /// @inheritdoc IERC165
    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

// src/contracts/common/Entity.sol

// Copyright (c) 2025 Symbiotic

/// @title Entity
/// @notice Base contract for entity type and factory binding.
abstract contract Entity is Initializable, IEntity {
    /// @inheritdoc IEntity
    address public immutable FACTORY;

    /// @inheritdoc IEntity
    uint64 public immutable TYPE;

    constructor(address factory, uint64 type_) {
        _disableInitializers();

        FACTORY = factory;
        TYPE = type_;
    }

    /// @inheritdoc IEntity
    function initialize(bytes calldata data) external initializer {
        _initialize(data);
    }

    function _initialize(
        bytes calldata /* data */
    )
        internal
        virtual {}
}

// src/interfaces/IDelegatorFactory.sol

/**
 * @title IDelegatorFactory
 * @notice Interface for the DelegatorFactory contract.
 */
interface IDelegatorFactory is IFactory {}

// src/interfaces/delegator/IOperatorNetworkSpecificDelegator.sol

uint64 constant OPERATOR_NETWORK_SPECIFIC_DELEGATOR_TYPE = 3;

/**
 * @title IOperatorNetworkSpecificDelegator
 * @notice Interface for the OperatorNetworkSpecificDelegator contract.
 */
interface IOperatorNetworkSpecificDelegator is IBaseDelegator {
    error InvalidNetwork();
    error NotOperator();

    /**
     * @notice Hints for a stake.
     * @param baseHints Base hints.
     * @param activeStakeHint Hint for the active stake checkpoint.
     * @param maxNetworkLimitHint Hint for the maximum subnetwork limit checkpoint.
     */
    struct StakeHints {
        bytes baseHints;
        bytes activeStakeHint;
        bytes maxNetworkLimitHint;
    }

    /**
     * @notice Initial parameters needed for an operator-network-specific delegator deployment.
     * @param baseParams Base parameters for delegators' deployment.
     * @param network Address of the single network.
     * @param operator Address of the single operator.
     */
    struct InitParams {
        IBaseDelegator.BaseParams baseParams;
        address network;
        address operator;
    }

    /**
     * @notice Get the operator registry's address.
     * @return Address Of the operator registry.
     */
    function OPERATOR_REGISTRY() external view returns (address);

    /**
     * @notice Get a network the vault delegates funds to.
     * @return Address Of the network.
     */
    function network() external view returns (address);

    /**
     * @notice Get an operator managing the vault's funds.
     * @return Address Of the operator.
     */
    function operator() external view returns (address);

    /**
     * @notice Get a particular subnetwork's maximum limit at a given timestamp using a hint
     * (meaning the subnetwork is not ready to get more as a stake).
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param timestamp Time point to get the maximum subnetwork limit at.
     * @param hint Hint for checkpoint index.
     * @return Maximum Limit of the subnetwork.
     */
    function maxNetworkLimitAt(bytes32 subnetwork, uint48 timestamp, bytes memory hint) external view returns (uint256);
}

// src/interfaces/ISlasherFactory.sol

/**
 * @title ISlasherFactory
 * @notice Interface for the SlasherFactory contract.
 */
interface ISlasherFactory is IFactory {}

// src/interfaces/vault/IVault.sol

uint64 constant VAULT_VERSION = 1;

/**
 * @title IVault
 * @notice Interface for the Vault contract.
 */
interface IVault is IMigratableEntity, IVaultStorage {
    error AlreadyClaimed();
    error AlreadySet();
    error DelegatorAlreadyInitialized();
    error DepositLimitReached();
    error InsufficientClaim();
    error InsufficientDeposit();
    error InsufficientRedemption();
    error InsufficientWithdrawal();
    error InvalidAccount();
    error InvalidCaptureEpoch();
    error InvalidClaimer();
    error InvalidCollateral();
    error InvalidDelegator();
    error InvalidEpoch();
    error InvalidEpochDuration();
    error InvalidLengthEpochs();
    error InvalidOnBehalfOf();
    error InvalidRecipient();
    error InvalidSlasher();
    error MissingRoles();
    error NotDelegator();
    error NotSlasher();
    error NotWhitelistedDepositor();
    error SlasherAlreadyInitialized();
    error TooMuchRedeem();
    error TooMuchWithdraw();

    /**
     * @notice Initial parameters needed for a vault deployment.
     * @param collateral Vault's underlying collateral.
     * @param burner Vault's burner to issue debt to (e.g., 0xdEaD or some unwrapper contract).
     * @param epochDuration Duration of the vault epoch (it determines sync points for withdrawals).
     * @param depositWhitelist If enabling deposit whitelist.
     * @param isDepositLimit If enabling deposit limit.
     * @param depositLimit Deposit limit (maximum amount of the collateral that can be in the vault simultaneously).
     * @param defaultAdminRoleHolder Address of the initial DEFAULT_ADMIN_ROLE holder.
     * @param depositWhitelistSetRoleHolder Address of the initial DEPOSIT_WHITELIST_SET_ROLE holder.
     * @param depositorWhitelistRoleHolder Address of the initial DEPOSITOR_WHITELIST_ROLE holder.
     * @param isDepositLimitSetRoleHolder Address of the initial IS_DEPOSIT_LIMIT_SET_ROLE holder.
     * @param depositLimitSetRoleHolder Address of the initial DEPOSIT_LIMIT_SET_ROLE holder.
     */
    struct InitParams {
        address collateral;
        address burner;
        uint48 epochDuration;
        bool depositWhitelist;
        bool isDepositLimit;
        uint256 depositLimit;
        address defaultAdminRoleHolder;
        address depositWhitelistSetRoleHolder;
        address depositorWhitelistRoleHolder;
        address isDepositLimitSetRoleHolder;
        address depositLimitSetRoleHolder;
    }

    /**
     * @notice Hints for an active balance.
     * @param activeSharesOfHint Hint for the active shares of checkpoint.
     * @param activeStakeHint Hint for the active stake checkpoint.
     * @param activeSharesHint Hint for the active shares checkpoint.
     */
    struct ActiveBalanceOfHints {
        bytes activeSharesOfHint;
        bytes activeStakeHint;
        bytes activeSharesHint;
    }

    /**
     * @notice Emitted when a deposit is made.
     * @param depositor Account that made the deposit.
     * @param onBehalfOf Account the deposit was made on behalf of.
     * @param amount Amount of the collateral deposited.
     * @param shares Amount of the active shares minted.
     */
    event Deposit(address indexed depositor, address indexed onBehalfOf, uint256 amount, uint256 shares);

    /**
     * @notice Emitted when a withdrawal is made.
     * @param withdrawer Account that made the withdrawal.
     * @param claimer Account that needs to claim the withdrawal.
     * @param amount Amount of the collateral withdrawn.
     * @param burnedShares Amount of the active shares burned.
     * @param mintedShares Amount of the epoch withdrawal shares minted.
     */
    event Withdraw(
        address indexed withdrawer, address indexed claimer, uint256 amount, uint256 burnedShares, uint256 mintedShares
    );

    /**
     * @notice Emitted when a claim is made.
     * @param claimer Account that claimed.
     * @param recipient Account that received the collateral.
     * @param epoch Epoch the collateral was claimed for.
     * @param amount Amount of the collateral claimed.
     */
    event Claim(address indexed claimer, address indexed recipient, uint256 epoch, uint256 amount);

    /**
     * @notice Emitted when a batch claim is made.
     * @param claimer Account that claimed.
     * @param recipient Account that received the collateral.
     * @param epochs Epochs the collateral was claimed for.
     * @param amount Amount of the collateral claimed.
     */
    event ClaimBatch(address indexed claimer, address indexed recipient, uint256[] epochs, uint256 amount);

    /**
     * @notice Emitted when a slash happens.
     * @param amount Amount of the collateral to slash.
     * @param captureTimestamp Time point when the stake was captured.
     * @param slashedAmount Real amount of the collateral slashed.
     */
    event OnSlash(uint256 amount, uint48 captureTimestamp, uint256 slashedAmount);

    /**
     * @notice Emitted when a deposit whitelist status is enabled/disabled.
     * @param status If enabled deposit whitelist.
     */
    event SetDepositWhitelist(bool status);

    /**
     * @notice Emitted when a depositor whitelist status is set.
     * @param account Account for which the whitelist status is set.
     * @param status If whitelisted the account.
     */
    event SetDepositorWhitelistStatus(address indexed account, bool status);

    /**
     * @notice Emitted when a deposit limit status is enabled/disabled.
     * @param status If enabled deposit limit.
     */
    event SetIsDepositLimit(bool status);

    /**
     * @notice Emitted when a deposit limit is set.
     * @param limit Deposit limit (maximum amount of the collateral that can be in the vault simultaneously).
     */
    event SetDepositLimit(uint256 limit);

    /**
     * @notice Emitted when a delegator is set.
     * @param delegator Vault's delegator to delegate the stake to networks and operators.
     * @dev Can be set only once.
     */
    event SetDelegator(address indexed delegator);

    /**
     * @notice Emitted when a slasher is set.
     * @param slasher Vault's slasher to provide a slashing mechanism to networks.
     * @dev Can be set only once.
     */
    event SetSlasher(address indexed slasher);

    /**
     * @notice Check if the vault is fully initialized (a delegator and a slasher are set).
     * @return If The vault is fully initialized.
     */
    function isInitialized() external view returns (bool);

    /**
     * @notice Get a total amount of the collateral that can be slashed.
     * @return Total Amount of the slashable collateral.
     */
    function totalStake() external view returns (uint256);

    /**
     * @notice Get an active balance for a particular account at a given timestamp using hints.
     * @param account Account to get the active balance for.
     * @param timestamp Time point to get the active balance for the account at.
     * @param hints Hints for checkpoints' indexes.
     * @return Active Balance for the account at the timestamp.
     */
    function activeBalanceOfAt(address account, uint48 timestamp, bytes calldata hints) external view returns (uint256);

    /**
     * @notice Get an active balance for a particular account.
     * @param account Account to get the active balance for.
     * @return Active Balance for the account.
     */
    function activeBalanceOf(address account) external view returns (uint256);

    /**
     * @notice Get withdrawals for a particular account at a given epoch (zero if claimed).
     * @param epoch Epoch to get the withdrawals for the account at.
     * @param account Account to get the withdrawals for.
     * @return Withdrawals For the account at the epoch.
     */
    function withdrawalsOf(uint256 epoch, address account) external view returns (uint256);

    /**
     * @notice Get a total amount of the collateral that can be slashed for a given account.
     * @param account Account to get the slashable collateral for.
     * @return Total Amount of the account's slashable collateral.
     */
    function slashableBalanceOf(address account) external view returns (uint256);

    /**
     * @notice Deposit collateral into the vault.
     * @param onBehalfOf Account the deposit is made on behalf of.
     * @param amount Amount of the collateral to deposit.
     * @return depositedAmount Real amount of the collateral deposited.
     * @return mintedShares Amount of the active shares minted.
     */
    function deposit(address onBehalfOf, uint256 amount)
        external
        returns (uint256 depositedAmount, uint256 mintedShares);

    /**
     * @notice Withdraw collateral from the vault (it will be claimable after the next epoch).
     * @param claimer Account that needs to claim the withdrawal.
     * @param amount Amount of the collateral to withdraw.
     * @return burnedShares Amount of the active shares burned.
     * @return mintedShares Amount of the epoch withdrawal shares minted.
     */
    function withdraw(address claimer, uint256 amount) external returns (uint256 burnedShares, uint256 mintedShares);

    /**
     * @notice Redeem collateral from the vault (it will be claimable after the next epoch).
     * @param claimer Account that needs to claim the withdrawal.
     * @param shares Amount of the active shares to redeem.
     * @return withdrawnAssets Amount of the collateral withdrawn.
     * @return mintedShares Amount of the epoch withdrawal shares minted.
     */
    function redeem(address claimer, uint256 shares) external returns (uint256 withdrawnAssets, uint256 mintedShares);

    /**
     * @notice Claim collateral from the vault.
     * @param recipient Account that receives the collateral.
     * @param epoch Epoch to claim the collateral for.
     * @return amount Amount of the collateral claimed.
     */
    function claim(address recipient, uint256 epoch) external returns (uint256 amount);

    /**
     * @notice Claim collateral from the vault for multiple epochs.
     * @param recipient Account that receives the collateral.
     * @param epochs Epochs to claim the collateral for.
     * @return amount Amount of the collateral claimed.
     */
    function claimBatch(address recipient, uint256[] calldata epochs) external returns (uint256 amount);

    /**
     * @notice Slash callback for burning collateral.
     * @param amount Amount to slash.
     * @param captureTimestamp Time point when the stake was captured.
     * @return slashedAmount Real amount of the collateral slashed.
     * @dev Only the slasher can call this function.
     */
    function onSlash(uint256 amount, uint48 captureTimestamp) external returns (uint256 slashedAmount);

    /**
     * @notice Enable/disable deposit whitelist.
     * @param status If enabling deposit whitelist.
     * @dev Only a DEPOSIT_WHITELIST_SET_ROLE holder can call this function.
     */
    function setDepositWhitelist(bool status) external;

    /**
     * @notice Set a depositor whitelist status.
     * @param account Account for which the whitelist status is set.
     * @param status If whitelisting the account.
     * @dev Only a DEPOSITOR_WHITELIST_ROLE holder can call this function.
     */
    function setDepositorWhitelistStatus(address account, bool status) external;

    /**
     * @notice Enable/disable deposit limit.
     * @param status If enabling deposit limit.
     * @dev Only a IS_DEPOSIT_LIMIT_SET_ROLE holder can call this function.
     */
    function setIsDepositLimit(bool status) external;

    /**
     * @notice Set a deposit limit.
     * @param limit Deposit limit (maximum amount of the collateral that can be in the vault simultaneously).
     * @dev Only a DEPOSIT_LIMIT_SET_ROLE holder can call this function.
     */
    function setDepositLimit(uint256 limit) external;

    /**
     * @notice Set a delegator.
     * @param delegator Vault's delegator to delegate the stake to networks and operators.
     * @dev Can be set only once.
     */
    function setDelegator(address delegator) external;

    /**
     * @notice Set a slasher.
     * @param slasher Vault's slasher to provide a slashing mechanism to networks.
     * @dev Can be set only once.
     */
    function setSlasher(address slasher) external;
}

// src/interfaces/vault/IVaultV2.sol

uint64 constant VAULT_V2_VERSION = 3;

// Keccak256("DEPOSIT_WHITELIST_SET_ROLE").
bytes32 constant DEPOSIT_WHITELIST_SET_ROLE = 0xbae4ee3de6c709ff9a002e774c5b78cb381560b219213c88ae0f1e207c03c023;
// Keccak256("DEPOSITOR_WHITELIST_ROLE").
bytes32 constant DEPOSITOR_WHITELIST_ROLE = 0x9c56d972d63cbb4195b3c1484691dfc220fa96a4c47e7b6613bd82a022029e06;
// Keccak256("IS_DEPOSIT_LIMIT_SET_ROLE").
bytes32 constant IS_DEPOSIT_LIMIT_SET_ROLE = 0xc6aaadd7371d5e8f9ed6849dd66a66573a3ba37167d03f4352c9ba5693678fac;
// Keccak256("DEPOSIT_LIMIT_SET_ROLE").
bytes32 constant DEPOSIT_LIMIT_SET_ROLE = 0x4a634bc14d77baf979756509ef4298c6f6318af357828612545267ee2eb79233;
// Keccak256("SET_PLUGIN_LIMIT_ROLE").
bytes32 constant SET_PLUGIN_LIMIT_ROLE = 0xe0bdc9c1c8c2e75dc2012527eb0fa05a8dda38297bc81683ecb9055988877100;
// Keccak256("SWAP_PLUGINS_ROLE").
bytes32 constant SWAP_PLUGINS_ROLE = 0x1c31202be72d3888bec354d209184db36bf8c648652bec1ae036b3ade9fee62e;
// Keccak256("ALLOCATE_PLUGIN_ROLE").
bytes32 constant ALLOCATE_PLUGIN_ROLE = 0x519cc70d51fcfd11b60dc29f6c85e08207d46a64951561c68760c7dbedf611dc;
// Keccak256("DEALLOCATE_PLUGIN_ROLE").
bytes32 constant DEALLOCATE_PLUGIN_ROLE = 0x2228e59f6ee6ff4b08702cdeaa6118d05e883f4b7df19c7053169d4e74afd4be;

uint256 constant MAX_PLUGINS = 10;

uint48 constant MAX_DURATION = 1000 * 365 days;

/**
 * @title IVaultV2
 * @notice Interface for the VaultV2 contract.
 */
interface IVaultV2 is IMigratableEntity, IVaultV2Storage {
    /* ERRORS */

    /**
     * @notice Raised when a withdrawal is already claimed.
     */
    error AlreadyClaimed();

    /**
     * @notice Raised when trying to set a value that is already set.
     */
    error AlreadySet();

    /**
     * @notice Raised when delegator initialization is attempted more than once.
     */
    error DelegatorAlreadyInitialized();

    /**
     * @notice Raised when a deposit would exceed the configured deposit limit.
     */
    error DepositLimitReached();

    /**
     * @notice Raised when fee-on-transfer behavior is unsupported for the operation.
     */
    error FeeOnTransferNotSupported();

    /**
     * @notice Raised when the provided amount is zero or insufficient.
     */
    error InsufficientAmount();

    /**
     * @notice Raised when there is nothing claimable for the request.
     */
    error InsufficientClaim();

    /**
     * @notice Raised when redemption output is insufficient.
     */
    error InsufficientRedemption();

    /**
     * @notice Raised when withdrawal output is insufficient.
     */
    error InsufficientWithdrawal();

    /**
     * @notice Raised when an address argument is invalid.
     */
    error InvalidAddress();

    /**
     * @notice Raised when capture epoch input is invalid.
     */
    error InvalidCaptureEpoch();

    /**
     * @notice Raised when claimer address is invalid.
     */
    error InvalidClaimer();

    /**
     * @notice Raised when collateral address is invalid.
     */
    error InvalidCollateral();

    /**
     * @notice Raised when delegator address is invalid.
     */
    error InvalidDelegator();

    /**
     * @notice Raised when depositor address provided for whitelist initialization is invalid.
     */
    error InvalidDepositorToWhitelist();

    /**
     * @notice Raised when epochs-length input is invalid.
     */
    error InvalidLengthEpochs();

    /**
     * @notice Raised when on-behalf-of address is invalid.
     */
    error InvalidOnBehalfOf();

    /**
     * @notice Raised when recipient address is invalid.
     */
    error InvalidRecipient();

    /**
     * @notice Raised when slasher address is invalid.
     */
    error InvalidSlasher();

    /**
     * @notice Raised when required role holders are missing at initialization.
     */
    error MissingRoles();

    /**
     * @notice Raised when the provided plugin is not whitelisted in plugin registry.
     */
    error NotPlugin();

    /**
     * @notice Raised when the caller is not the configured rewards address.
     */
    error NotRewards();

    /**
     * @notice Raised when the provided slasher is not recognized.
     */
    error NotSlasher();

    /**
     * @notice Raised when depositor is not in the whitelist while whitelist is enabled.
     */
    error NotWhitelistedDepositor();

    /**
     * @notice Raised when plugin allocation exceeds or conflicts with limits.
     */
    error PluginAllocated();

    /**
     * @notice Raised when slasher initialization is attempted more than once.
     */
    error SlasherAlreadyInitialized();

    /**
     * @notice Raised when epoch duration is outside allowed bounds.
     */
    error TooLongDuration();

    /**
     * @notice Raised when plugin count exceeds the configured maximum.
     */
    error TooManyPlugins();

    /**
     * @notice Raised when redeeming more shares than available.
     */
    error TooMuchRedeem();

    /**
     * @notice Raised when withdrawing more assets than available.
     */
    error TooMuchWithdraw();

    /**
     * @notice Raised when withdrawal is not yet matured.
     */
    error WithdrawalNotMatured();

    /* STRUCTS */

    /**
     * @notice Initial parameters needed for a vault deployment.
     * @param name Name of the vault.
     * @param symbol Symbol of the vault.
     * @param collateral Vault's underlying collateral.
     * @param burner Vault's burner to issue debt to (e.g., 0xdEaD or some unwrapper contract).
     * @param epochDuration Duration of the vault epoch (it determines sync points for withdrawals).
     * @param depositWhitelist If enabling deposit whitelist.
     * @param depositorToWhitelist Initial depositor address to whitelist.
     * @param isDepositLimit If enabling deposit limit.
     * @param depositLimit Deposit limit (maximum amount of the collateral that can be in the vault simultaneously).
     * @param defaultAdminRoleHolder Address of the initial DEFAULT_ADMIN_ROLE holder.
     * @param depositWhitelistSetRoleHolder Address of the initial DEPOSIT_WHITELIST_SET_ROLE holder.
     * @param depositorWhitelistRoleHolder Address of the initial DEPOSITOR_WHITELIST_ROLE holder.
     * @param isDepositLimitSetRoleHolder Address of the initial IS_DEPOSIT_LIMIT_SET_ROLE holder.
     * @param depositLimitSetRoleHolder Address of the initial DEPOSIT_LIMIT_SET_ROLE holder.
     * @param setPluginLimitRoleHolder Address of the initial SET_PLUGIN_LIMIT_ROLE holder.
     * @param allocatePluginRoleHolder Address of the initial ALLOCATE_PLUGIN_ROLE holder..
     */
    struct InitParams {
        string name;
        string symbol;
        address collateral;
        address burner;
        uint48 epochDuration;
        bool depositWhitelist;
        address depositorToWhitelist;
        bool isDepositLimit;
        uint256 depositLimit;
        address defaultAdminRoleHolder;
        address depositWhitelistSetRoleHolder;
        address depositorWhitelistRoleHolder;
        address isDepositLimitSetRoleHolder;
        address depositLimitSetRoleHolder;
        address setPluginLimitRoleHolder;
        address allocatePluginRoleHolder;
    }

    /**
     * @notice Initial parameters needed for a vault migration.
     * @param name Name of the vault.
     * @param symbol Symbol of the vault.
     * @param delegatorParams Parameters for the delegator migration.
     * @param slasherParams Parameters for the slasher migration.
     */
    struct MigrateParams {
        string name;
        string symbol;
        bytes delegatorParams;
        bytes slasherParams;
    }

    /* EVENTS */

    /**
     * @notice Emitted when a deposit is made.
     * @param depositor Account that made the deposit.
     * @param onBehalfOf Account the deposit was made on behalf of.
     * @param amount Amount of the collateral deposited.
     * @param shares Amount of the active shares minted.
     */
    event Deposit(address indexed depositor, address indexed onBehalfOf, uint256 amount, uint256 shares);

    /**
     * @notice Emitted when a withdrawal is made.
     * @param withdrawer Account that made the withdrawal.
     * @param claimer Account that needs to claim the withdrawal.
     * @param amount Amount of the collateral withdrawn.
     * @param burnedShares Amount of the active shares burned.
     * @param mintedShares Amount of the epoch withdrawal shares minted.
     * @param index Index of the withdrawal.
     */
    event Withdraw(
        address indexed withdrawer,
        address indexed claimer,
        uint256 amount,
        uint256 burnedShares,
        uint256 mintedShares,
        uint256 index
    );

    /**
     * @notice Emitted when an instant withdrawal is made.
     * @param withdrawer Account that made the instant withdrawal.
     * @param amount Amount of the collateral withdrawn.
     * @param burnedShares Amount of the active shares burned.
     */
    event InstantWithdraw(address indexed withdrawer, uint256 amount, uint256 burnedShares);

    /**
     * @notice Emitted when a claim is made.
     * @param claimer Account that claimed.
     * @param recipient Account that received the collateral.
     * @param index Index the collateral was claimed for.
     * @param amount Amount of the collateral claimed.
     */
    event Claim(address indexed claimer, address indexed recipient, uint256 index, uint256 amount);

    /**
     * @notice Emitted when collateral is donated into vault accounting.
     * @param amount Donated collateral amount.
     */
    event Donate(uint256 amount);

    /**
     * @notice Emitted when a slash happens.
     * @param amount Amount of the collateral to slash.
     * @param slashedAmount Real amount of the collateral slashed.
     */
    event OnSlash(uint256 amount, uint256 slashedAmount);

    /**
     * @notice Emitted when a deposit whitelist status is enabled/disabled.
     * @param status If enabled deposit whitelist.
     */
    event SetDepositWhitelist(bool status);

    /**
     * @notice Emitted when a depositor whitelist status is set.
     * @param account Account for which the whitelist status is set.
     * @param status If whitelisted the account.
     */
    event SetDepositorWhitelistStatus(address indexed account, bool status);

    /**
     * @notice Emitted when a deposit limit status is enabled/disabled.
     * @param status If enabled deposit limit.
     */
    event SetIsDepositLimit(bool status);

    /**
     * @notice Emitted when a deposit limit is set.
     * @param limit Deposit limit (maximum amount of the collateral that can be in the vault simultaneously).
     */
    event SetDepositLimit(uint256 limit);

    /**
     * @notice Emitted when a limit is set.
     * @param plugin Address of the plugin.
     * @param limit Limit of the plugin.
     */
    event SetPluginLimit(address indexed plugin, uint208 limit);

    /**
     * @notice Emitted when a plugin is swapped.
     * @param plugin1 Address of the first plugin.
     * @param plugin2 Address of the second plugin.
     */
    event SwapPlugins(address indexed plugin1, address indexed plugin2);

    /**
     * @notice Emitted when collateral is allocated to a plugin.
     * @param plugin Address of the plugin.
     * @param amount Allocated amount.
     */
    event Allocate(address indexed plugin, uint256 amount);

    /**
     * @notice Emitted when collateral is deallocated from a plugin.
     * @param plugin Address of the plugin.
     * @param amount Deallocated amount.
     */
    event Deallocate(address indexed plugin, uint256 amount);

    /**
     * @notice Emitted when a slashing is synced.
     * @param amount Amount of the collateral to slash.
     */
    event SyncOwedSlash(uint256 amount);

    /**
     * @notice Emitted when a delegator is set.
     * @param delegator Vault's delegator to delegate the stake to networks and operators.
     * @dev Can be set only once.
     */
    event SetDelegator(address indexed delegator);

    /**
     * @notice Emitted when a slasher is set.
     * @param slasher Vault's slasher to provide a slashing mechanism to networks.
     * @dev Can be set only once.
     */
    event SetSlasher(address indexed slasher);

    /**
     * @notice Emitted when a vault is initialized.
     * @param params Initial parameters for the vault.
     */
    event Initialize(InitParams params);

    /**
     * @notice Emitted when a vault is migrated.
     * @param params Initial parameters for the vault.
     * @param newDelegator Address of the new delegator.
     * @param newSlasher Address of the new slasher.
     */
    event Migrate(MigrateParams params, address newDelegator, address newSlasher);

    /* FUNCTIONS */

    /**
     * @notice Execute a batch of delegatecalls on the vault.
     * @param data Calldata items to execute.
     */
    function multicall(bytes[] calldata data) external;

    /**
     * @notice Check if the vault is fully initialized (a delegator and a slasher are set).
     * @return If The vault is fully initialized.
     */
    function isInitialized() external view returns (bool);

    /**
     * @notice Get a total amount of the collateral that can be slashed.
     * @return Total Amount of the slashable collateral.
     */
    function totalStake() external view returns (uint256);

    /**
     * @notice Get a total amount of the active withdrawals for a given duration at a given timestamp.
     * @param duration Duration to get the active withdrawals for.
     * @param timestamp Time point to get the active withdrawals at.
     * @return Total Amount of the active withdrawals.
     */
    function activeWithdrawalsForAt(uint48 duration, uint48 timestamp) external view returns (uint256);

    /**
     * @notice Get a total amount of the active withdrawals for a given duration.
     * @param duration Duration to get the active withdrawals for.
     * @return Total Amount of the active withdrawals.
     */
    function activeWithdrawalsFor(uint48 duration) external view returns (uint256);

    /**
     * @notice Get a total amount of the active withdrawals at a given timestamp.
     * @param timestamp Time point to get the active withdrawals at.
     * @return Total Amount of the active withdrawals.
     */
    function activeWithdrawalsAt(uint48 timestamp) external view returns (uint256);

    /**
     * @notice Get the current amount of active withdrawals.
     * @return Total Amount of active withdrawals.
     */
    function activeWithdrawals() external view returns (uint256);

    /**
     * @notice Get an active balance for a particular account at a given timestamp.
     * @param account Account to get the active balance for.
     * @param timestamp Time point to get the active balance for the account at.
     * @return Active Balance for the account at the timestamp.
     */
    function activeBalanceOfAt(address account, uint48 timestamp, bytes calldata) external view returns (uint256);

    /**
     * @notice Get an active balance for a particular account.
     * @param account Account to get the active balance for.
     * @return Active Balance for the account.
     */
    function activeBalanceOf(address account) external view returns (uint256);

    /**
     * @notice Get how many withdrawals a particular account requested.
     * @param account Account to check the withdrawals for.
     * @return The Number of withdrawals requested by the account.
     * @dev Includes legacy epoch data with index equal to epoch number.
     */
    function withdrawalsOfLength(address account) external view returns (uint256);

    /**
     * @notice Get a number of withdrawal shares for a particular account at a given index (zero if claimed).
     * @param index Index to get the number of withdrawal shares for the account at.
     * @param account Account to get the number of withdrawal shares for.
     * @return Number Of withdrawal shares for the account at the index.
     * @dev Includes legacy epoch data with index equal to epoch number.
     */
    function withdrawalSharesOf(uint256 index, address account) external view returns (uint256);

    /**
     * @notice Get when the withdrawal becomes claimable for a particular account at a given index.
     * @param index Index to check the withdrawals for the account at.
     * @param account Account to check the withdrawal for.
     * @return When The withdrawal is claimable for the account at the index.
     * @dev Simplifies legacy epoch data by returning 0 for all epochs before migration.
     */
    function withdrawalUnlockAt(uint256 index, address account) external view returns (uint48);

    /**
     * @notice Get withdrawals for a particular account at a given index (zero if claimed).
     * @param index Index to get the withdrawals for the account at.
     * @param account Account to get the withdrawals for.
     * @return Withdrawals For the account at the index.
     * @dev Includes legacy epoch data with index equal to epoch number.
     */
    function withdrawalsOf(uint256 index, address account) external view returns (uint256);

    /**
     * @notice Get the amount that can still be allocated into plugins.
     * @return Allocatable Amount of collateral.
     */
    function allocatable() external view returns (uint256);

    /**
     * @notice Deposit collateral into the vault.
     * @param onBehalfOf Account the deposit is made on behalf of.
     * @param amount Amount of the collateral to deposit.
     * @return depositedAmount Real amount of the collateral deposited.
     * @return mintedShares Amount of the active shares minted.
     */
    function deposit(address onBehalfOf, uint256 amount)
        external
        returns (uint256 depositedAmount, uint256 mintedShares);

    /**
     * @notice Withdraw collateral from the vault (it will be claimable after the next epoch).
     * @param claimer Account that needs to claim the withdrawal.
     * @param amount Amount of the collateral to withdraw.
     * @return burnedShares Amount of the active shares burned.
     * @return mintedShares Amount of the epoch withdrawal shares minted.
     */
    function withdraw(address claimer, uint256 amount) external returns (uint256 burnedShares, uint256 mintedShares);

    /**
     * @notice Redeem collateral from the vault (it will be claimable after the next epoch).
     * @param claimer Account that needs to claim the withdrawal.
     * @param shares Amount of the active shares to redeem.
     * @return withdrawnAssets Amount of the collateral withdrawn.
     * @return mintedShares Amount of the epoch withdrawal shares minted.
     */
    function redeem(address claimer, uint256 shares) external returns (uint256 withdrawnAssets, uint256 mintedShares);

    /**
     * @notice Instant withdraw collateral from the vault.
     * @param recipient Account that received the collateral.
     * @param amount Amount of the collateral withdrawn.
     * @return withdrawnAssets Amount of collateral withdrawn.
     * @return burnedShares Amount of active shares burned.
     */
    function instantWithdraw(address recipient, uint256 amount)
        external
        returns (uint256 withdrawnAssets, uint256 burnedShares);

    /**
     * @notice Claim collateral from the vault.
     * @param recipient Account that receives the collateral.
     * @param index Index to claim the collateral for.
     * @return amount Amount of the collateral claimed.
     */
    function claim(address recipient, uint256 index) external returns (uint256 amount);

    /**
     * @notice Claim collateral from the vault for multiple indexes.
     * @param recipient Account that receives the collateral.
     * @param indexes Indexes to claim the collateral for.
     * @return amount Amount of the collateral claimed.
     * @dev Deprecated. Use `multicall()` of `claim()` calls instead.
     */
    function claimBatch(address recipient, uint256[] calldata indexes) external returns (uint256 amount);

    /**
     * @notice Enable/disable deposit whitelist.
     * @param status If enabling deposit whitelist.
     * @dev Only a DEPOSIT_WHITELIST_SET_ROLE holder can call this function.
     */
    function setDepositWhitelist(bool status) external;

    /**
     * @notice Set a depositor whitelist status.
     * @param account Account for which the whitelist status is set.
     * @param status If whitelisting the account.
     * @dev Only a DEPOSITOR_WHITELIST_ROLE holder can call this function.
     */
    function setDepositorWhitelistStatus(address account, bool status) external;

    /**
     * @notice Enable/disable deposit limit.
     * @param status If enabling deposit limit.
     * @dev Only a IS_DEPOSIT_LIMIT_SET_ROLE holder can call this function.
     */
    function setIsDepositLimit(bool status) external;

    /**
     * @notice Set a deposit limit.
     * @param limit Deposit limit (maximum amount of the collateral that can be in the vault simultaneously).
     * @dev Only a DEPOSIT_LIMIT_SET_ROLE holder can call this function.
     */
    function setDepositLimit(uint256 limit) external;

    /**
     * @notice Set a plugin limit.
     * @param plugin Address of the plugin.
     * @param limit Limit of the plugin.
     * @dev Only a SET_PLUGIN_LIMIT_ROLE holder can call this function.
     */
    function setPluginLimit(address plugin, uint208 limit) external;

    /**
     * @notice Swap plugin order.
     * @param plugin1 Address of the first plugin.
     * @param plugin2 Address of the second plugin.
     * @dev Only a SWAP_PLUGINS_ROLE holder can call this function.
     */
    function swapPlugins(address plugin1, address plugin2) external;

    /**
     * @notice Allocate collateral to the plugin.
     * @param plugin Address of the plugin.
     * @param amount Amount of collateral to allocate.
     * @return allocated Amount of collateral allocated.
     * @dev Only an ALLOCATE_PLUGIN_ROLE holder can call this function.
     */
    function allocatePlugin(address plugin, uint256 amount) external returns (uint256 allocated);

    /**
     * @notice Deallocate collateral from the plugin.
     * @param plugin Address of the plugin.
     * @param amount Amount of collateral to deallocate.
     * @return deallocated Amount of collateral deallocated.
     * @dev Only a DEALLOCATE_PLUGIN_ROLE holder can call this function.
     */
    function deallocatePlugin(address plugin, uint256 amount) external returns (uint256 deallocated);

    /**
     * @notice Skim rewards from plugins into the vault.
     */
    function skimPlugins() external;

    /**
     * @notice Deallocate collateral from plugins when needed.
     */
    function deallocatePlugins() external;
}

// src/interfaces/slasher/IVetoSlasher.sol

uint64 constant VETO_SLASHER_TYPE = 1;

/**
 * @title IVetoSlasher
 * @notice Interface for the VetoSlasher contract.
 */
interface IVetoSlasher is IBaseSlasher {
    error AlreadySet();
    error InsufficientSlash();
    error InvalidCaptureTimestamp();
    error InvalidResolverSetEpochsDelay();
    error InvalidVetoDuration();
    error NoResolver();
    error NotNetwork();
    error NotResolver();
    error SlashPeriodEnded();
    error SlashRequestCompleted();
    error SlashRequestNotExist();
    error VetoPeriodEnded();
    error VetoPeriodNotEnded();

    /**
     * @notice Initial parameters needed for a slasher deployment.
     * @param baseParams Base parameters for slashers' deployment.
     * @param vetoDuration Duration of the veto period for a slash request.
     * @param resolverSetEpochsDelay Delay in epochs for a network to update a resolver.
     */
    struct InitParams {
        IBaseSlasher.BaseParams baseParams;
        uint48 vetoDuration;
        uint256 resolverSetEpochsDelay;
    }

    /**
     * @notice Structure for a slash request.
     * @param subnetwork Subnetwork that requested the slash.
     * @param operator Operator that could be slashed (if the request is not vetoed).
     * @param amount Maximum amount of the collateral to be slashed.
     * @param captureTimestamp Time point when the stake was captured.
     * @param vetoDeadline Deadline for the resolver to veto the slash (exclusively).
     * @param completed If the slash was vetoed/executed.
     */
    struct SlashRequest {
        bytes32 subnetwork;
        address operator;
        uint256 amount;
        uint48 captureTimestamp;
        uint48 vetoDeadline;
        bool completed;
    }

    /**
     * @notice Hints for a slash request.
     * @param slashableStakeHints Hints for the slashable stake checkpoints.
     */
    struct RequestSlashHints {
        bytes slashableStakeHints;
    }

    /**
     * @notice Hints for a slash execute.
     * @param captureResolverHint Hint for the resolver checkpoint at the capture time.
     * @param currentResolverHint Hint for the resolver checkpoint at the current time.
     * @param slashableStakeHints Hints for the slashable stake checkpoints.
     */
    struct ExecuteSlashHints {
        bytes captureResolverHint;
        bytes currentResolverHint;
        bytes slashableStakeHints;
    }

    /**
     * @notice Hints for a slash veto.
     * @param captureResolverHint Hint for the resolver checkpoint at the capture time.
     * @param currentResolverHint Hint for the resolver checkpoint at the current time.
     */
    struct VetoSlashHints {
        bytes captureResolverHint;
        bytes currentResolverHint;
    }

    /**
     * @notice Hints for a resolver set.
     * @param resolverHint Hint for the resolver checkpoint.
     */
    struct SetResolverHints {
        bytes resolverHint;
    }

    /**
     * @notice Extra data for the delegator.
     * @param slashableStake Amount of the slashable stake before the slash (cache).
     * @param stakeAt Amount of the stake at the capture time (cache).
     * @param slashIndex Index of the slash request.
     */
    struct DelegatorData {
        uint256 slashableStake;
        uint256 stakeAt;
        uint256 slashIndex;
    }

    /**
     * @notice Emitted when a slash request is created.
     * @param slashIndex Index of the slash request.
     * @param subnetwork Subnetwork that requested the slash.
     * @param operator Operator that could be slashed (if the request is not vetoed).
     * @param slashAmount Maximum amount of the collateral to be slashed.
     * @param captureTimestamp Time point when the stake was captured.
     * @param vetoDeadline Deadline for the resolver to veto the slash (exclusively).
     */
    event RequestSlash(
        uint256 indexed slashIndex,
        bytes32 indexed subnetwork,
        address indexed operator,
        uint256 slashAmount,
        uint48 captureTimestamp,
        uint48 vetoDeadline
    );

    /**
     * @notice Emitted when a slash request is executed.
     * @param slashIndex Index of the slash request.
     * @param slashedAmount Virtual amount of the collateral slashed.
     */
    event ExecuteSlash(uint256 indexed slashIndex, uint256 slashedAmount);

    /**
     * @notice Emitted when a slash request is vetoed.
     * @param slashIndex Index of the slash request.
     * @param resolver Address of the resolver that vetoed the slash.
     */
    event VetoSlash(uint256 indexed slashIndex, address indexed resolver);

    /**
     * @notice Emitted when a resolver is set.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param resolver Address of the resolver.
     */
    event SetResolver(bytes32 indexed subnetwork, address resolver);

    /**
     * @notice Get the network registry's address.
     * @return Address Of the network registry.
     */
    function NETWORK_REGISTRY() external view returns (address);

    /**
     * @notice Get a duration during which resolvers can veto slash requests.
     * @return Duration Of the veto period.
     */
    function vetoDuration() external view returns (uint48);

    /**
     * @notice Get a total number of slash requests.
     * @return Total Number of slash requests.
     */
    function slashRequestsLength() external view returns (uint256);

    /**
     * @notice Get a particular slash request.
     * @param slashIndex Index of the slash request.
     * @return subnetwork Subnetwork that requested the slash.
     * @return operator Operator that could be slashed (if the request is not vetoed).
     * @return amount Maximum amount of the collateral to be slashed.
     * @return captureTimestamp Time point when the stake was captured.
     * @return vetoDeadline Deadline for the resolver to veto the slash (exclusively).
     * @return completed If the slash was vetoed/executed.
     */
    function slashRequests(uint256 slashIndex)
        external
        view
        returns (
            bytes32 subnetwork,
            address operator,
            uint256 amount,
            uint48 captureTimestamp,
            uint48 vetoDeadline,
            bool completed
        );

    /**
     * @notice Get a delay for networks in epochs to update a resolver.
     * @return Updating Resolver delay in epochs.
     */
    function resolverSetEpochsDelay() external view returns (uint256);

    /**
     * @notice Get a resolver for a given subnetwork at a particular timestamp using a hint.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param timestamp Timestamp to get the resolver at.
     * @param hint Hint for the checkpoint index.
     * @return Address Of the resolver.
     */
    function resolverAt(bytes32 subnetwork, uint48 timestamp, bytes memory hint) external view returns (address);

    /**
     * @notice Get a resolver for a given subnetwork using a hint.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param hint Hint for the checkpoint index.
     * @return Address Of the resolver.
     */
    function resolver(bytes32 subnetwork, bytes memory hint) external view returns (address);

    /**
     * @notice Request a slash using a subnetwork for a particular operator by a given amount using hints.
     * @param subnetwork Full identifier of the subnetwork (address of the network concatenated with the uint96 identifier).
     * @param operator Address of the operator.
     * @param amount Maximum amount of the collateral to be slashed.
     * @param captureTimestamp Time point when the stake was captured.
     * @param hints Hints for checkpoints' indexes.
     * @return slashIndex Index of the slash request.
     * @dev Only a network middleware can call this function.
     */
    function requestSlash(
        bytes32 subnetwork,
        address operator,
        uint256 amount,
        uint48 captureTimestamp,
        bytes calldata hints
    ) external returns (uint256 slashIndex);

    /**
     * @notice Execute a slash with a given slash index using hints.
     * @param slashIndex Index of the slash request.
     * @param hints Hints for checkpoints' indexes.
     * @return slashedAmount Virtual amount of the collateral slashed.
     * @dev Only a network middleware can call this function.
     */
    function executeSlash(uint256 slashIndex, bytes calldata hints) external returns (uint256 slashedAmount);

    /**
     * @notice Veto a slash with a given slash index using hints.
     * @param slashIndex Index of the slash request.
     * @param hints Hints for checkpoints' indexes.
     * @dev Only a resolver can call this function.
     */
    function vetoSlash(uint256 slashIndex, bytes calldata hints) external;

    /**
     * @notice Set a resolver for a subnetwork using hints.
     * @param identifier Identifier of the subnetwork.
     * @param resolver Address of the resolver.
     * @param hints Hints for checkpoints' indexes.
     * @dev Only a network can call this function.
     */
    function setResolver(uint96 identifier, address resolver, bytes calldata hints) external;
}

// lib/openzeppelin-contracts/contracts/utils/math/Math.sol

// OpenZeppelin Contracts (last updated v5.3.0) (utils/math/Math.sol)

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    enum Rounding {
        Floor, // Toward negative infinity
        Ceil, // Toward positive infinity
        Trunc, // Toward zero
        Expand // Away from zero
    }

    /**
     * @dev Return the 512-bit addition of two uint256.
     *
     * The result is stored in two 256 variables such that sum = high * 2²⁵⁶ + low.
     */
    function add512(uint256 a, uint256 b) internal pure returns (uint256 high, uint256 low) {
        assembly ("memory-safe") {
            low := add(a, b)
            high := lt(low, a)
        }
    }

    /**
     * @dev Return the 512-bit multiplication of two uint256.
     *
     * The result is stored in two 256 variables such that product = high * 2²⁵⁶ + low.
     */
    function mul512(uint256 a, uint256 b) internal pure returns (uint256 high, uint256 low) {
        // 512-bit multiply [high low] = x * y. Compute the product mod 2²⁵⁶ and mod 2²⁵⁶ - 1, then use
        // the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
        // variables such that product = high * 2²⁵⁶ + low.
        assembly ("memory-safe") {
            let mm := mulmod(a, b, not(0))
            low := mul(a, b)
            high := sub(sub(mm, low), lt(mm, low))
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, with a success flag (no overflow).
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool success, uint256 result) {
        unchecked {
            uint256 c = a + b;
            success = c >= a;
            result = c * SafeCast.toUint(success);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with a success flag (no overflow).
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool success, uint256 result) {
        unchecked {
            uint256 c = a - b;
            success = c <= a;
            result = c * SafeCast.toUint(success);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with a success flag (no overflow).
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool success, uint256 result) {
        unchecked {
            uint256 c = a * b;
            assembly ("memory-safe") {
                // Only true when the multiplication doesn't overflow
                // (c / a == b) || (a == 0)
                success := or(eq(div(c, a), b), iszero(a))
            }
            // equivalent to: success ? c : 0
            result = c * SafeCast.toUint(success);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a success flag (no division by zero).
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool success, uint256 result) {
        unchecked {
            success = b > 0;
            assembly ("memory-safe") {
                // The `DIV` opcode returns zero when the denominator is 0.
                result := div(a, b)
            }
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a success flag (no division by zero).
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool success, uint256 result) {
        unchecked {
            success = b > 0;
            assembly ("memory-safe") {
                // The `MOD` opcode returns zero when the denominator is 0.
                result := mod(a, b)
            }
        }
    }

    /**
     * @dev Unsigned saturating addition, bounds to `2²⁵⁶ - 1` instead of overflowing.
     */
    function saturatingAdd(uint256 a, uint256 b) internal pure returns (uint256) {
        (bool success, uint256 result) = tryAdd(a, b);
        return ternary(success, result, type(uint256).max);
    }

    /**
     * @dev Unsigned saturating subtraction, bounds to zero instead of overflowing.
     */
    function saturatingSub(uint256 a, uint256 b) internal pure returns (uint256) {
        (, uint256 result) = trySub(a, b);
        return result;
    }

    /**
     * @dev Unsigned saturating multiplication, bounds to `2²⁵⁶ - 1` instead of overflowing.
     */
    function saturatingMul(uint256 a, uint256 b) internal pure returns (uint256) {
        (bool success, uint256 result) = tryMul(a, b);
        return ternary(success, result, type(uint256).max);
    }

    /**
     * @dev Branchless ternary evaluation for `a ? b : c`. Gas costs are constant.
     *
     * IMPORTANT: This function may reduce bytecode size and consume less gas when used standalone.
     * However, the compiler may optimize Solidity ternary operations (i.e. `a ? b : c`) to only compute
     * one branch when needed, making this function more expensive.
     */
    function ternary(bool condition, uint256 a, uint256 b) internal pure returns (uint256) {
        unchecked {
            // branchless ternary works because:
            // b ^ (a ^ b) == a
            // b ^ 0 == b
            return b ^ ((a ^ b) * SafeCast.toUint(condition));
        }
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return ternary(a > b, a, b);
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return ternary(a < b, a, b);
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds towards infinity instead
     * of rounding towards zero.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        if (b == 0) {
            // Guarantee the same behavior as in a regular Solidity division.
            Panic.panic(Panic.DIVISION_BY_ZERO);
        }

        // The following calculation ensures accurate ceiling division without overflow.
        // Since a is non-zero, (a - 1) / b will not overflow.
        // The largest possible result occurs when (a - 1) / b is type(uint256).max,
        // but the largest value we can obtain is type(uint256).max - 1, which happens
        // when a = type(uint256).max and b = 1.
        unchecked {
            return SafeCast.toUint(a > 0) * ((a - 1) / b + 1);
        }
    }

    /**
     * @dev Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or
     * denominator == 0.
     *
     * Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv) with further edits by
     * Uniswap Labs also under MIT license.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
        unchecked {
            (uint256 high, uint256 low) = mul512(x, y);

            // Handle non-overflow cases, 256 by 256 division.
            if (high == 0) {
                // Solidity will revert if denominator == 0, unlike the div opcode on its own.
                // The surrounding unchecked block does not change this fact.
                // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
                return low / denominator;
            }

            // Make sure the result is less than 2²⁵⁶. Also prevents denominator == 0.
            if (denominator <= high) {
                Panic.panic(ternary(denominator == 0, Panic.DIVISION_BY_ZERO, Panic.UNDER_OVERFLOW));
            }

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [high low].
            uint256 remainder;
            assembly ("memory-safe") {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                high := sub(high, gt(remainder, low))
                low := sub(low, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator.
            // Always >= 1. See https://cs.stackexchange.com/q/138556/92363.

            uint256 twos = denominator & (0 - denominator);
            assembly ("memory-safe") {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [high low] by twos.
                low := div(low, twos)

                // Flip twos such that it is 2²⁵⁶ / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from high into low.
            low |= high * twos;

            // Invert denominator mod 2²⁵⁶. Now that denominator is an odd number, it has an inverse modulo 2²⁵⁶ such
            // that denominator * inv ≡ 1 mod 2²⁵⁶. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv ≡ 1 mod 2⁴.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also
            // works in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2⁸
            inverse *= 2 - denominator * inverse; // inverse mod 2¹⁶
            inverse *= 2 - denominator * inverse; // inverse mod 2³²
            inverse *= 2 - denominator * inverse; // inverse mod 2⁶⁴
            inverse *= 2 - denominator * inverse; // inverse mod 2¹²⁸
            inverse *= 2 - denominator * inverse; // inverse mod 2²⁵⁶

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2²⁵⁶. Since the preconditions guarantee that the outcome is
            // less than 2²⁵⁶, this is the final result. We don't need to compute the high bits of the result and high
            // is no longer required.
            result = low * inverse;
            return result;
        }
    }

    /**
     * @dev Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
        return mulDiv(x, y, denominator) + SafeCast.toUint(unsignedRoundsUp(rounding) && mulmod(x, y, denominator) > 0);
    }

    /**
     * @dev Calculates floor(x * y >> n) with full precision. Throws if result overflows a uint256.
     */
    function mulShr(uint256 x, uint256 y, uint8 n) internal pure returns (uint256 result) {
        unchecked {
            (uint256 high, uint256 low) = mul512(x, y);
            if (high >= 1 << n) {
                Panic.panic(Panic.UNDER_OVERFLOW);
            }
            return (high << (256 - n)) | (low >> n);
        }
    }

    /**
     * @dev Calculates x * y >> n with full precision, following the selected rounding direction.
     */
    function mulShr(uint256 x, uint256 y, uint8 n, Rounding rounding) internal pure returns (uint256) {
        return mulShr(x, y, n) + SafeCast.toUint(unsignedRoundsUp(rounding) && mulmod(x, y, 1 << n) > 0);
    }

    /**
     * @dev Calculate the modular multiplicative inverse of a number in Z/nZ.
     *
     * If n is a prime, then Z/nZ is a field. In that case all elements are inversible, except 0.
     * If n is not a prime, then Z/nZ is not a field, and some elements might not be inversible.
     *
     * If the input value is not inversible, 0 is returned.
     *
     * NOTE: If you know for sure that n is (big) a prime, it may be cheaper to use Fermat's little theorem and get the
     * inverse using `Math.modExp(a, n - 2, n)`. See {invModPrime}.
     */
    function invMod(uint256 a, uint256 n) internal pure returns (uint256) {
        unchecked {
            if (n == 0) return 0;

            // The inverse modulo is calculated using the Extended Euclidean Algorithm (iterative version)
            // Used to compute integers x and y such that: ax + ny = gcd(a, n).
            // When the gcd is 1, then the inverse of a modulo n exists and it's x.
            // ax + ny = 1
            // ax = 1 + (-y)n
            // ax ≡ 1 (mod n) # x is the inverse of a modulo n

            // If the remainder is 0 the gcd is n right away.
            uint256 remainder = a % n;
            uint256 gcd = n;

            // Therefore the initial coefficients are:
            // ax + ny = gcd(a, n) = n
            // 0a + 1n = n
            int256 x = 0;
            int256 y = 1;

            while (remainder != 0) {
                uint256 quotient = gcd / remainder;

                (gcd, remainder) =
                (
                    // The old remainder is the next gcd to try.
                    remainder,
                    // Compute the next remainder.
                    // Can't overflow given that (a % gcd) * (gcd // (a % gcd)) <= gcd
                    // where gcd is at most n (capped to type(uint256).max)
                    gcd - remainder * quotient
                );

                (x, y) =
                (
                    // Increment the coefficient of a.
                    y,
                    // Decrement the coefficient of n.
                    // Can overflow, but the result is casted to uint256 so that the
                    // next value of y is "wrapped around" to a value between 0 and n - 1.
                    x - y * int256(quotient)
                );
            }

            if (gcd != 1) return 0; // No inverse exists.
            return ternary(x < 0, n - uint256(-x), uint256(x)); // Wrap the result if it's negative.
        }
    }

    /**
     * @dev Variant of {invMod}. More efficient, but only works if `p` is known to be a prime greater than `2`.
     *
     * From https://en.wikipedia.org/wiki/Fermat%27s_little_theorem[Fermat's little theorem], we know that if p is
     * prime, then `a**(p-1) ≡ 1 mod p`. As a consequence, we have `a * a**(p-2) ≡ 1 mod p`, which means that
     * `a**(p-2)` is the modular multiplicative inverse of a in Fp.
     *
     * NOTE: this function does NOT check that `p` is a prime greater than `2`.
     */
    function invModPrime(uint256 a, uint256 p) internal view returns (uint256) {
        unchecked {
            return Math.modExp(a, p - 2, p);
        }
    }

    /**
     * @dev Returns the modular exponentiation of the specified base, exponent and modulus (b ** e % m)
     *
     * Requirements:
     * - modulus can't be zero
     * - underlying staticcall to precompile must succeed
     *
     * IMPORTANT: The result is only valid if the underlying call succeeds. When using this function, make
     * sure the chain you're using it on supports the precompiled contract for modular exponentiation
     * at address 0x05 as specified in https://eips.ethereum.org/EIPS/eip-198[EIP-198]. Otherwise,
     * the underlying function will succeed given the lack of a revert, but the result may be incorrectly
     * interpreted as 0.
     */
    function modExp(uint256 b, uint256 e, uint256 m) internal view returns (uint256) {
        (bool success, uint256 result) = tryModExp(b, e, m);
        if (!success) {
            Panic.panic(Panic.DIVISION_BY_ZERO);
        }
        return result;
    }

    /**
     * @dev Returns the modular exponentiation of the specified base, exponent and modulus (b ** e % m).
     * It includes a success flag indicating if the operation succeeded. Operation will be marked as failed if trying
     * to operate modulo 0 or if the underlying precompile reverted.
     *
     * IMPORTANT: The result is only valid if the success flag is true. When using this function, make sure the chain
     * you're using it on supports the precompiled contract for modular exponentiation at address 0x05 as specified in
     * https://eips.ethereum.org/EIPS/eip-198[EIP-198]. Otherwise, the underlying function will succeed given the lack
     * of a revert, but the result may be incorrectly interpreted as 0.
     */
    function tryModExp(uint256 b, uint256 e, uint256 m) internal view returns (bool success, uint256 result) {
        if (m == 0) return (false, 0);
        assembly ("memory-safe") {
            let ptr := mload(0x40)
            // | Offset    | Content    | Content (Hex)                                                      |
            // |-----------|------------|--------------------------------------------------------------------|
            // | 0x00:0x1f | size of b  | 0x0000000000000000000000000000000000000000000000000000000000000020 |
            // | 0x20:0x3f | size of e  | 0x0000000000000000000000000000000000000000000000000000000000000020 |
            // | 0x40:0x5f | size of m  | 0x0000000000000000000000000000000000000000000000000000000000000020 |
            // | 0x60:0x7f | value of b | 0x<.............................................................b> |
            // | 0x80:0x9f | value of e | 0x<.............................................................e> |
            // | 0xa0:0xbf | value of m | 0x<.............................................................m> |
            mstore(ptr, 0x20)
            mstore(add(ptr, 0x20), 0x20)
            mstore(add(ptr, 0x40), 0x20)
            mstore(add(ptr, 0x60), b)
            mstore(add(ptr, 0x80), e)
            mstore(add(ptr, 0xa0), m)

            // Given the result < m, it's guaranteed to fit in 32 bytes,
            // so we can use the memory scratch space located at offset 0.
            success := staticcall(gas(), 0x05, ptr, 0xc0, 0x00, 0x20)
            result := mload(0x00)
        }
    }

    /**
     * @dev Variant of {modExp} that supports inputs of arbitrary length.
     */
    function modExp(bytes memory b, bytes memory e, bytes memory m) internal view returns (bytes memory) {
        (bool success, bytes memory result) = tryModExp(b, e, m);
        if (!success) {
            Panic.panic(Panic.DIVISION_BY_ZERO);
        }
        return result;
    }

    /**
     * @dev Variant of {tryModExp} that supports inputs of arbitrary length.
     */
    function tryModExp(bytes memory b, bytes memory e, bytes memory m)
        internal
        view
        returns (bool success, bytes memory result)
    {
        if (_zeroBytes(m)) return (false, new bytes(0));

        uint256 mLen = m.length;

        // Encode call args in result and move the free memory pointer
        result = abi.encodePacked(b.length, e.length, mLen, b, e, m);

        assembly ("memory-safe") {
            let dataPtr := add(result, 0x20)
            // Write result on top of args to avoid allocating extra memory.
            success := staticcall(gas(), 0x05, dataPtr, mload(result), dataPtr, mLen)
            // Overwrite the length.
            // result.length > returndatasize() is guaranteed because returndatasize() == m.length
            mstore(result, mLen)
            // Set the memory pointer after the returned data.
            mstore(0x40, add(dataPtr, mLen))
        }
    }

    /**
     * @dev Returns whether the provided byte array is zero.
     */
    function _zeroBytes(bytes memory byteArray) private pure returns (bool) {
        for (uint256 i = 0; i < byteArray.length; ++i) {
            if (byteArray[i] != 0) {
                return false;
            }
        }
        return true;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded
     * towards zero.
     *
     * This method is based on Newton's method for computing square roots; the algorithm is restricted to only
     * using integer operations.
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        unchecked {
            // Take care of easy edge cases when a == 0 or a == 1
            if (a <= 1) {
                return a;
            }

            // In this function, we use Newton's method to get a root of `f(x) := x² - a`. It involves building a
            // sequence x_n that converges toward sqrt(a). For each iteration x_n, we also define the error between
            // the current value as `ε_n = | x_n - sqrt(a) |`.
            //
            // For our first estimation, we consider `e` the smallest power of 2 which is bigger than the square root
            // of the target. (i.e. `2**(e-1) ≤ sqrt(a) < 2**e`). We know that `e ≤ 128` because `(2¹²⁸)² = 2²⁵⁶` is
            // bigger than any uint256.
            //
            // By noticing that
            // `2**(e-1) ≤ sqrt(a) < 2**e → (2**(e-1))² ≤ a < (2**e)² → 2**(2*e-2) ≤ a < 2**(2*e)`
            // we can deduce that `e - 1` is `log2(a) / 2`. We can thus compute `x_n = 2**(e-1)` using a method similar
            // to the msb function.
            uint256 aa = a;
            uint256 xn = 1;

            if (aa >= (1 << 128)) {
                aa >>= 128;
                xn <<= 64;
            }
            if (aa >= (1 << 64)) {
                aa >>= 64;
                xn <<= 32;
            }
            if (aa >= (1 << 32)) {
                aa >>= 32;
                xn <<= 16;
            }
            if (aa >= (1 << 16)) {
                aa >>= 16;
                xn <<= 8;
            }
            if (aa >= (1 << 8)) {
                aa >>= 8;
                xn <<= 4;
            }
            if (aa >= (1 << 4)) {
                aa >>= 4;
                xn <<= 2;
            }
            if (aa >= (1 << 2)) {
                xn <<= 1;
            }

            // We now have x_n such that `x_n = 2**(e-1) ≤ sqrt(a) < 2**e = 2 * x_n`. This implies ε_n ≤ 2**(e-1).
            //
            // We can refine our estimation by noticing that the middle of that interval minimizes the error.
            // If we move x_n to equal 2**(e-1) + 2**(e-2), then we reduce the error to ε_n ≤ 2**(e-2).
            // This is going to be our x_0 (and ε_0)
            xn = (3 * xn) >> 1; // ε_0 := | x_0 - sqrt(a) | ≤ 2**(e-2)

            // From here, Newton's method give us:
            // x_{n+1} = (x_n + a / x_n) / 2
            //
            // One should note that:
            // x_{n+1}² - a = ((x_n + a / x_n) / 2)² - a
            //              = ((x_n² + a) / (2 * x_n))² - a
            //              = (x_n⁴ + 2 * a * x_n² + a²) / (4 * x_n²) - a
            //              = (x_n⁴ + 2 * a * x_n² + a² - 4 * a * x_n²) / (4 * x_n²)
            //              = (x_n⁴ - 2 * a * x_n² + a²) / (4 * x_n²)
            //              = (x_n² - a)² / (2 * x_n)²
            //              = ((x_n² - a) / (2 * x_n))²
            //              ≥ 0
            // Which proves that for all n ≥ 1, sqrt(a) ≤ x_n
            //
            // This gives us the proof of quadratic convergence of the sequence:
            // ε_{n+1} = | x_{n+1} - sqrt(a) |
            //         = | (x_n + a / x_n) / 2 - sqrt(a) |
            //         = | (x_n² + a - 2*x_n*sqrt(a)) / (2 * x_n) |
            //         = | (x_n - sqrt(a))² / (2 * x_n) |
            //         = | ε_n² / (2 * x_n) |
            //         = ε_n² / | (2 * x_n) |
            //
            // For the first iteration, we have a special case where x_0 is known:
            // ε_1 = ε_0² / | (2 * x_0) |
            //     ≤ (2**(e-2))² / (2 * (2**(e-1) + 2**(e-2)))
            //     ≤ 2**(2*e-4) / (3 * 2**(e-1))
            //     ≤ 2**(e-3) / 3
            //     ≤ 2**(e-3-log2(3))
            //     ≤ 2**(e-4.5)
            //
            // For the following iterations, we use the fact that, 2**(e-1) ≤ sqrt(a) ≤ x_n:
            // ε_{n+1} = ε_n² / | (2 * x_n) |
            //         ≤ (2**(e-k))² / (2 * 2**(e-1))
            //         ≤ 2**(2*e-2*k) / 2**e
            //         ≤ 2**(e-2*k)
            xn = (xn + a / xn) >> 1; // ε_1 := | x_1 - sqrt(a) | ≤ 2**(e-4.5)  -- special case, see above
            xn = (xn + a / xn) >> 1; // ε_2 := | x_2 - sqrt(a) | ≤ 2**(e-9)    -- general case with k = 4.5
            xn = (xn + a / xn) >> 1; // ε_3 := | x_3 - sqrt(a) | ≤ 2**(e-18)   -- general case with k = 9
            xn = (xn + a / xn) >> 1; // ε_4 := | x_4 - sqrt(a) | ≤ 2**(e-36)   -- general case with k = 18
            xn = (xn + a / xn) >> 1; // ε_5 := | x_5 - sqrt(a) | ≤ 2**(e-72)   -- general case with k = 36
            xn = (xn + a / xn) >> 1; // ε_6 := | x_6 - sqrt(a) | ≤ 2**(e-144)  -- general case with k = 72

            // Because e ≤ 128 (as discussed during the first estimation phase), we know have reached a precision
            // ε_6 ≤ 2**(e-144) < 1. Given we're operating on integers, then we can ensure that xn is now either
            // sqrt(a) or sqrt(a) + 1.
            return xn - SafeCast.toUint(xn > a / xn);
        }
    }

    /**
     * @dev Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + SafeCast.toUint(unsignedRoundsUp(rounding) && result * result < a);
        }
    }

    /**
     * @dev Return the log in base 2 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     */
    function log2(uint256 x) internal pure returns (uint256 r) {
        // If value has upper 128 bits set, log2 result is at least 128
        r = SafeCast.toUint(x > 0xffffffffffffffffffffffffffffffff) << 7;
        // If upper 64 bits of 128-bit half set, add 64 to result
        r |= SafeCast.toUint((x >> r) > 0xffffffffffffffff) << 6;
        // If upper 32 bits of 64-bit half set, add 32 to result
        r |= SafeCast.toUint((x >> r) > 0xffffffff) << 5;
        // If upper 16 bits of 32-bit half set, add 16 to result
        r |= SafeCast.toUint((x >> r) > 0xffff) << 4;
        // If upper 8 bits of 16-bit half set, add 8 to result
        r |= SafeCast.toUint((x >> r) > 0xff) << 3;
        // If upper 4 bits of 8-bit half set, add 4 to result
        r |= SafeCast.toUint((x >> r) > 0xf) << 2;

        // Shifts value right by the current result and use it as an index into this lookup table:
        //
        // | x (4 bits) |  index  | table[index] = MSB position |
        // |------------|---------|-----------------------------|
        // |    0000    |    0    |        table[0] = 0         |
        // |    0001    |    1    |        table[1] = 0         |
        // |    0010    |    2    |        table[2] = 1         |
        // |    0011    |    3    |        table[3] = 1         |
        // |    0100    |    4    |        table[4] = 2         |
        // |    0101    |    5    |        table[5] = 2         |
        // |    0110    |    6    |        table[6] = 2         |
        // |    0111    |    7    |        table[7] = 2         |
        // |    1000    |    8    |        table[8] = 3         |
        // |    1001    |    9    |        table[9] = 3         |
        // |    1010    |   10    |        table[10] = 3        |
        // |    1011    |   11    |        table[11] = 3        |
        // |    1100    |   12    |        table[12] = 3        |
        // |    1101    |   13    |        table[13] = 3        |
        // |    1110    |   14    |        table[14] = 3        |
        // |    1111    |   15    |        table[15] = 3        |
        //
        // The lookup table is represented as a 32-byte value with the MSB positions for 0-15 in the last 16 bytes.
        assembly ("memory-safe") {
            r := or(r, byte(shr(r, x), 0x0000010102020202030303030303030300000000000000000000000000000000))
        }
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + SafeCast.toUint(unsignedRoundsUp(rounding) && 1 << result < value);
        }
    }

    /**
     * @dev Return the log in base 10 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10 ** 64) {
                value /= 10 ** 64;
                result += 64;
            }
            if (value >= 10 ** 32) {
                value /= 10 ** 32;
                result += 32;
            }
            if (value >= 10 ** 16) {
                value /= 10 ** 16;
                result += 16;
            }
            if (value >= 10 ** 8) {
                value /= 10 ** 8;
                result += 8;
            }
            if (value >= 10 ** 4) {
                value /= 10 ** 4;
                result += 4;
            }
            if (value >= 10 ** 2) {
                value /= 10 ** 2;
                result += 2;
            }
            if (value >= 10 ** 1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + SafeCast.toUint(unsignedRoundsUp(rounding) && 10 ** result < value);
        }
    }

    /**
     * @dev Return the log in base 256 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 x) internal pure returns (uint256 r) {
        // If value has upper 128 bits set, log2 result is at least 128
        r = SafeCast.toUint(x > 0xffffffffffffffffffffffffffffffff) << 7;
        // If upper 64 bits of 128-bit half set, add 64 to result
        r |= SafeCast.toUint((x >> r) > 0xffffffffffffffff) << 6;
        // If upper 32 bits of 64-bit half set, add 32 to result
        r |= SafeCast.toUint((x >> r) > 0xffffffff) << 5;
        // If upper 16 bits of 32-bit half set, add 16 to result
        r |= SafeCast.toUint((x >> r) > 0xffff) << 4;
        // Add 1 if upper 8 bits of 16-bit half set, and divide accumulated result by 8
        return (r >> 3) | SafeCast.toUint((x >> r) > 0xff);
    }

    /**
     * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + SafeCast.toUint(unsignedRoundsUp(rounding) && 1 << (result << 3) < value);
        }
    }

    /**
     * @dev Returns whether a provided rounding mode is considered rounding up for unsigned integers.
     */
    function unsignedRoundsUp(Rounding rounding) internal pure returns (bool) {
        return uint8(rounding) % 2 == 1;
    }
}

// lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
    /// @custom:storage-location erc7201:openzeppelin.storage.Ownable
    struct OwnableStorage {
        address _owner;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.Ownable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant OwnableStorageLocation =
        0x9016d09d72d40fdae2fd8ceac6b6234c7706214fd39c1cd1e609a0528c199300;

    function _getOwnableStorage() private pure returns (OwnableStorage storage $) {
        assembly {
            $.slot := OwnableStorageLocation
        }
    }

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    function __Ownable_init(address initialOwner) internal onlyInitializing {
        __Ownable_init_unchained(initialOwner);
    }

    function __Ownable_init_unchained(address initialOwner) internal onlyInitializing {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        OwnableStorage storage $ = _getOwnableStorage();
        return $._owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        OwnableStorage storage $ = _getOwnableStorage();
        address oldOwner = $._owner;
        $._owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol

// OpenZeppelin Contracts (last updated v5.4.0) (utils/structs/Checkpoints.sol)
// This file was procedurally generated from scripts/generate/templates/Checkpoints.js.

/**
 * @dev This library defines the `Trace*` struct, for checkpointing values as they change at different points in
 * time, and later looking up past values by block number. See {Votes} as an example.
 *
 * To create a history of checkpoints define a variable type `Checkpoints.Trace*` in your contract, and store a new
 * checkpoint for the current transaction block using the {push} function.
 */
library Checkpoints_0 {
    /**
     * @dev A value was attempted to be inserted on a past checkpoint.
     */
    error CheckpointUnorderedInsertion();

    struct Trace224 {
        Checkpoint224[] _checkpoints;
    }

    struct Checkpoint224 {
        uint32 _key;
        uint224 _value;
    }

    /**
     * @dev Pushes a (`key`, `value`) pair into a Trace224 so that it is stored as the checkpoint.
     *
     * Returns previous value and new value.
     *
     * IMPORTANT: Never accept `key` as a user input, since an arbitrary `type(uint32).max` key set will disable the
     * library.
     */
    function push(Trace224 storage self, uint32 key, uint224 value)
        internal
        returns (uint224 oldValue, uint224 newValue)
    {
        return _insert(self._checkpoints, key, value);
    }

    /**
     * @dev Returns the value in the first (oldest) checkpoint with key greater or equal than the search key, or zero if
     * there is none.
     */
    function lowerLookup(Trace224 storage self, uint32 key) internal view returns (uint224) {
        uint256 len = self._checkpoints.length;
        uint256 pos = _lowerBinaryLookup(self._checkpoints, key, 0, len);
        return pos == len ? 0 : _unsafeAccess(self._checkpoints, pos)._value;
    }

    /**
     * @dev Returns the value in the last (most recent) checkpoint with key lower or equal than the search key, or zero
     * if there is none.
     */
    function upperLookup(Trace224 storage self, uint32 key) internal view returns (uint224) {
        uint256 len = self._checkpoints.length;
        uint256 pos = _upperBinaryLookup(self._checkpoints, key, 0, len);
        return pos == 0 ? 0 : _unsafeAccess(self._checkpoints, pos - 1)._value;
    }

    /**
     * @dev Returns the value in the last (most recent) checkpoint with key lower or equal than the search key, or zero
     * if there is none.
     *
     * NOTE: This is a variant of {upperLookup} that is optimized to find "recent" checkpoint (checkpoints with high
     * keys).
     */
    function upperLookupRecent(Trace224 storage self, uint32 key) internal view returns (uint224) {
        uint256 len = self._checkpoints.length;

        uint256 low = 0;
        uint256 high = len;

        if (len > 5) {
            uint256 mid = len - Math.sqrt(len);
            if (key < _unsafeAccess(self._checkpoints, mid)._key) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }

        uint256 pos = _upperBinaryLookup(self._checkpoints, key, low, high);

        return pos == 0 ? 0 : _unsafeAccess(self._checkpoints, pos - 1)._value;
    }

    /**
     * @dev Returns the value in the most recent checkpoint, or zero if there are no checkpoints.
     */
    function latest(Trace224 storage self) internal view returns (uint224) {
        uint256 pos = self._checkpoints.length;
        return pos == 0 ? 0 : _unsafeAccess(self._checkpoints, pos - 1)._value;
    }

    /**
     * @dev Returns whether there is a checkpoint in the structure (i.e. it is not empty), and if so the key and value
     * in the most recent checkpoint.
     */
    function latestCheckpoint(Trace224 storage self) internal view returns (bool exists, uint32 _key, uint224 _value) {
        uint256 pos = self._checkpoints.length;
        if (pos == 0) {
            return (false, 0, 0);
        } else {
            Checkpoint224 storage ckpt = _unsafeAccess(self._checkpoints, pos - 1);
            return (true, ckpt._key, ckpt._value);
        }
    }

    /**
     * @dev Returns the number of checkpoints.
     */
    function length(Trace224 storage self) internal view returns (uint256) {
        return self._checkpoints.length;
    }

    /**
     * @dev Returns checkpoint at given position.
     */
    function at(Trace224 storage self, uint32 pos) internal view returns (Checkpoint224 memory) {
        return self._checkpoints[pos];
    }

    /**
     * @dev Pushes a (`key`, `value`) pair into an ordered list of checkpoints, either by inserting a new checkpoint,
     * or by updating the last one.
     */
    function _insert(Checkpoint224[] storage self, uint32 key, uint224 value)
        private
        returns (uint224 oldValue, uint224 newValue)
    {
        uint256 pos = self.length;

        if (pos > 0) {
            Checkpoint224 storage last = _unsafeAccess(self, pos - 1);
            uint32 lastKey = last._key;
            uint224 lastValue = last._value;

            // Checkpoint keys must be non-decreasing.
            if (lastKey > key) {
                revert CheckpointUnorderedInsertion();
            }

            // Update or push new checkpoint
            if (lastKey == key) {
                last._value = value;
            } else {
                self.push(Checkpoint224({_key: key, _value: value}));
            }
            return (lastValue, value);
        } else {
            self.push(Checkpoint224({_key: key, _value: value}));
            return (0, value);
        }
    }

    /**
     * @dev Return the index of the first (oldest) checkpoint with key strictly bigger than the search key, or `high`
     * if there is none. `low` and `high` define a section where to do the search, with inclusive `low` and exclusive
     * `high`.
     *
     * WARNING: `high` should not be greater than the array's length.
     */
    function _upperBinaryLookup(Checkpoint224[] storage self, uint32 key, uint256 low, uint256 high)
        private
        view
        returns (uint256)
    {
        while (low < high) {
            uint256 mid = Math.average(low, high);
            if (_unsafeAccess(self, mid)._key > key) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return high;
    }

    /**
     * @dev Return the index of the first (oldest) checkpoint with key greater or equal than the search key, or `high`
     * if there is none. `low` and `high` define a section where to do the search, with inclusive `low` and exclusive
     * `high`.
     *
     * WARNING: `high` should not be greater than the array's length.
     */
    function _lowerBinaryLookup(Checkpoint224[] storage self, uint32 key, uint256 low, uint256 high)
        private
        view
        returns (uint256)
    {
        while (low < high) {
            uint256 mid = Math.average(low, high);
            if (_unsafeAccess(self, mid)._key < key) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return high;
    }

    /**
     * @dev Access an element of the array without performing bounds check. The position is assumed to be within bounds.
     */
    function _unsafeAccess(Checkpoint224[] storage self, uint256 pos)
        private
        pure
        returns (Checkpoint224 storage result)
    {
        assembly {
            mstore(0, self.slot)
            result.slot := add(keccak256(0, 0x20), pos)
        }
    }

    struct Trace208 {
        Checkpoint208[] _checkpoints;
    }

    struct Checkpoint208 {
        uint48 _key;
        uint208 _value;
    }

    /**
     * @dev Pushes a (`key`, `value`) pair into a Trace208 so that it is stored as the checkpoint.
     *
     * Returns previous value and new value.
     *
     * IMPORTANT: Never accept `key` as a user input, since an arbitrary `type(uint48).max` key set will disable the
     * library.
     */
    function push(Trace208 storage self, uint48 key, uint208 value)
        internal
        returns (uint208 oldValue, uint208 newValue)
    {
        return _insert(self._checkpoints, key, value);
    }

    /**
     * @dev Returns the value in the first (oldest) checkpoint with key greater or equal than the search key, or zero if
     * there is none.
     */
    function lowerLookup(Trace208 storage self, uint48 key) internal view returns (uint208) {
        uint256 len = self._checkpoints.length;
        uint256 pos = _lowerBinaryLookup(self._checkpoints, key, 0, len);
        return pos == len ? 0 : _unsafeAccess(self._checkpoints, pos)._value;
    }

    /**
     * @dev Returns the value in the last (most recent) checkpoint with key lower or equal than the search key, or zero
     * if there is none.
     */
    function upperLookup(Trace208 storage self, uint48 key) internal view returns (uint208) {
        uint256 len = self._checkpoints.length;
        uint256 pos = _upperBinaryLookup(self._checkpoints, key, 0, len);
        return pos == 0 ? 0 : _unsafeAccess(self._checkpoints, pos - 1)._value;
    }

    /**
     * @dev Returns the value in the last (most recent) checkpoint with key lower or equal than the search key, or zero
     * if there is none.
     *
     * NOTE: This is a variant of {upperLookup} that is optimized to find "recent" checkpoint (checkpoints with high
     * keys).
     */
    function upperLookupRecent(Trace208 storage self, uint48 key) internal view returns (uint208) {
        uint256 len = self._checkpoints.length;

        uint256 low = 0;
        uint256 high = len;

        if (len > 5) {
            uint256 mid = len - Math.sqrt(len);
            if (key < _unsafeAccess(self._checkpoints, mid)._key) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }

        uint256 pos = _upperBinaryLookup(self._checkpoints, key, low, high);

        return pos == 0 ? 0 : _unsafeAccess(self._checkpoints, pos - 1)._value;
    }

    /**
     * @dev Returns the value in the most recent checkpoint, or zero if there are no checkpoints.
     */
    function latest(Trace208 storage self) internal view returns (uint208) {
        uint256 pos = self._checkpoints.length;
        return pos == 0 ? 0 : _unsafeAccess(self._checkpoints, pos - 1)._value;
    }

    /**
     * @dev Returns whether there is a checkpoint in the structure (i.e. it is not empty), and if so the key and value
     * in the most recent checkpoint.
     */
    function latestCheckpoint(Trace208 storage self) internal view returns (bool exists, uint48 _key, uint208 _value) {
        uint256 pos = self._checkpoints.length;
        if (pos == 0) {
            return (false, 0, 0);
        } else {
            Checkpoint208 storage ckpt = _unsafeAccess(self._checkpoints, pos - 1);
            return (true, ckpt._key, ckpt._value);
        }
    }

    /**
     * @dev Returns the number of checkpoints.
     */
    function length(Trace208 storage self) internal view returns (uint256) {
        return self._checkpoints.length;
    }

    /**
     * @dev Returns checkpoint at given position.
     */
    function at(Trace208 storage self, uint32 pos) internal view returns (Checkpoint208 memory) {
        return self._checkpoints[pos];
    }

    /**
     * @dev Pushes a (`key`, `value`) pair into an ordered list of checkpoints, either by inserting a new checkpoint,
     * or by updating the last one.
     */
    function _insert(Checkpoint208[] storage self, uint48 key, uint208 value)
        private
        returns (uint208 oldValue, uint208 newValue)
    {
        uint256 pos = self.length;

        if (pos > 0) {
            Checkpoint208 storage last = _unsafeAccess(self, pos - 1);
            uint48 lastKey = last._key;
            uint208 lastValue = last._value;

            // Checkpoint keys must be non-decreasing.
            if (lastKey > key) {
                revert CheckpointUnorderedInsertion();
            }

            // Update or push new checkpoint
            if (lastKey == key) {
                last._value = value;
            } else {
                self.push(Checkpoint208({_key: key, _value: value}));
            }
            return (lastValue, value);
        } else {
            self.push(Checkpoint208({_key: key, _value: value}));
            return (0, value);
        }
    }

    /**
     * @dev Return the index of the first (oldest) checkpoint with key strictly bigger than the search key, or `high`
     * if there is none. `low` and `high` define a section where to do the search, with inclusive `low` and exclusive
     * `high`.
     *
     * WARNING: `high` should not be greater than the array's length.
     */
    function _upperBinaryLookup(Checkpoint208[] storage self, uint48 key, uint256 low, uint256 high)
        private
        view
        returns (uint256)
    {
        while (low < high) {
            uint256 mid = Math.average(low, high);
            if (_unsafeAccess(self, mid)._key > key) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return high;
    }

    /**
     * @dev Return the index of the first (oldest) checkpoint with key greater or equal than the search key, or `high`
     * if there is none. `low` and `high` define a section where to do the search, with inclusive `low` and exclusive
     * `high`.
     *
     * WARNING: `high` should not be greater than the array's length.
     */
    function _lowerBinaryLookup(Checkpoint208[] storage self, uint48 key, uint256 low, uint256 high)
        private
        view
        returns (uint256)
    {
        while (low < high) {
            uint256 mid = Math.average(low, high);
            if (_unsafeAccess(self, mid)._key < key) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return high;
    }

    /**
     * @dev Access an element of the array without performing bounds check. The position is assumed to be within bounds.
     */
    function _unsafeAccess(Checkpoint208[] storage self, uint256 pos)
        private
        pure
        returns (Checkpoint208 storage result)
    {
        assembly {
            mstore(0, self.slot)
            result.slot := add(keccak256(0, 0x20), pos)
        }
    }

    struct Trace160 {
        Checkpoint160[] _checkpoints;
    }

    struct Checkpoint160 {
        uint96 _key;
        uint160 _value;
    }

    /**
     * @dev Pushes a (`key`, `value`) pair into a Trace160 so that it is stored as the checkpoint.
     *
     * Returns previous value and new value.
     *
     * IMPORTANT: Never accept `key` as a user input, since an arbitrary `type(uint96).max` key set will disable the
     * library.
     */
    function push(Trace160 storage self, uint96 key, uint160 value)
        internal
        returns (uint160 oldValue, uint160 newValue)
    {
        return _insert(self._checkpoints, key, value);
    }

    /**
     * @dev Returns the value in the first (oldest) checkpoint with key greater or equal than the search key, or zero if
     * there is none.
     */
    function lowerLookup(Trace160 storage self, uint96 key) internal view returns (uint160) {
        uint256 len = self._checkpoints.length;
        uint256 pos = _lowerBinaryLookup(self._checkpoints, key, 0, len);
        return pos == len ? 0 : _unsafeAccess(self._checkpoints, pos)._value;
    }

    /**
     * @dev Returns the value in the last (most recent) checkpoint with key lower or equal than the search key, or zero
     * if there is none.
     */
    function upperLookup(Trace160 storage self, uint96 key) internal view returns (uint160) {
        uint256 len = self._checkpoints.length;
        uint256 pos = _upperBinaryLookup(self._checkpoints, key, 0, len);
        return pos == 0 ? 0 : _unsafeAccess(self._checkpoints, pos - 1)._value;
    }

    /**
     * @dev Returns the value in the last (most recent) checkpoint with key lower or equal than the search key, or zero
     * if there is none.
     *
     * NOTE: This is a variant of {upperLookup} that is optimized to find "recent" checkpoint (checkpoints with high
     * keys).
     */
    function upperLookupRecent(Trace160 storage self, uint96 key) internal view returns (uint160) {
        uint256 len = self._checkpoints.length;

        uint256 low = 0;
        uint256 high = len;

        if (len > 5) {
            uint256 mid = len - Math.sqrt(len);
            if (key < _unsafeAccess(self._checkpoints, mid)._key) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }

        uint256 pos = _upperBinaryLookup(self._checkpoints, key, low, high);

        return pos == 0 ? 0 : _unsafeAccess(self._checkpoints, pos - 1)._value;
    }

    /**
     * @dev Returns the value in the most recent checkpoint, or zero if there are no checkpoints.
     */
    function latest(Trace160 storage self) internal view returns (uint160) {
        uint256 pos = self._checkpoints.length;
        return pos == 0 ? 0 : _unsafeAccess(self._checkpoints, pos - 1)._value;
    }

    /**
     * @dev Returns whether there is a checkpoint in the structure (i.e. it is not empty), and if so the key and value
     * in the most recent checkpoint.
     */
    function latestCheckpoint(Trace160 storage self) internal view returns (bool exists, uint96 _key, uint160 _value) {
        uint256 pos = self._checkpoints.length;
        if (pos == 0) {
            return (false, 0, 0);
        } else {
            Checkpoint160 storage ckpt = _unsafeAccess(self._checkpoints, pos - 1);
            return (true, ckpt._key, ckpt._value);
        }
    }

    /**
     * @dev Returns the number of checkpoints.
     */
    function length(Trace160 storage self) internal view returns (uint256) {
        return self._checkpoints.length;
    }

    /**
     * @dev Returns checkpoint at given position.
     */
    function at(Trace160 storage self, uint32 pos) internal view returns (Checkpoint160 memory) {
        return self._checkpoints[pos];
    }

    /**
     * @dev Pushes a (`key`, `value`) pair into an ordered list of checkpoints, either by inserting a new checkpoint,
     * or by updating the last one.
     */
    function _insert(Checkpoint160[] storage self, uint96 key, uint160 value)
        private
        returns (uint160 oldValue, uint160 newValue)
    {
        uint256 pos = self.length;

        if (pos > 0) {
            Checkpoint160 storage last = _unsafeAccess(self, pos - 1);
            uint96 lastKey = last._key;
            uint160 lastValue = last._value;

            // Checkpoint keys must be non-decreasing.
            if (lastKey > key) {
                revert CheckpointUnorderedInsertion();
            }

            // Update or push new checkpoint
            if (lastKey == key) {
                last._value = value;
            } else {
                self.push(Checkpoint160({_key: key, _value: value}));
            }
            return (lastValue, value);
        } else {
            self.push(Checkpoint160({_key: key, _value: value}));
            return (0, value);
        }
    }

    /**
     * @dev Return the index of the first (oldest) checkpoint with key strictly bigger than the search key, or `high`
     * if there is none. `low` and `high` define a section where to do the search, with inclusive `low` and exclusive
     * `high`.
     *
     * WARNING: `high` should not be greater than the array's length.
     */
    function _upperBinaryLookup(Checkpoint160[] storage self, uint96 key, uint256 low, uint256 high)
        private
        view
        returns (uint256)
    {
        while (low < high) {
            uint256 mid = Math.average(low, high);
            if (_unsafeAccess(self, mid)._key > key) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return high;
    }

    /**
     * @dev Return the index of the first (oldest) checkpoint with key greater or equal than the search key, or `high`
     * if there is none. `low` and `high` define a section where to do the search, with inclusive `low` and exclusive
     * `high`.
     *
     * WARNING: `high` should not be greater than the array's length.
     */
    function _lowerBinaryLookup(Checkpoint160[] storage self, uint96 key, uint256 low, uint256 high)
        private
        view
        returns (uint256)
    {
        while (low < high) {
            uint256 mid = Math.average(low, high);
            if (_unsafeAccess(self, mid)._key < key) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return high;
    }

    /**
     * @dev Access an element of the array without performing bounds check. The position is assumed to be within bounds.
     */
    function _unsafeAccess(Checkpoint160[] storage self, uint256 pos)
        private
        pure
        returns (Checkpoint160 storage result)
    {
        assembly {
            mstore(0, self.slot)
            result.slot := add(keccak256(0, 0x20), pos)
        }
    }
}

// src/contracts/libraries/ERC4626Math.sol

/**
 * @title ERC4626Math
 * @notice Library implementing an ERC4626 share-and-asset conversion helper set.
 */
library ERC4626Math {
    using Math for uint256;

    function previewDeposit(uint256 assets, uint256 totalShares, uint256 totalAssets) internal pure returns (uint256) {
        return convertToShares(assets, totalShares, totalAssets, Math.Rounding.Floor);
    }

    function previewMint(uint256 shares, uint256 totalAssets, uint256 totalShares) internal pure returns (uint256) {
        return convertToAssets(shares, totalAssets, totalShares, Math.Rounding.Ceil);
    }

    function previewWithdraw(uint256 assets, uint256 totalShares, uint256 totalAssets) internal pure returns (uint256) {
        return convertToShares(assets, totalShares, totalAssets, Math.Rounding.Ceil);
    }

    function previewRedeem(uint256 shares, uint256 totalAssets, uint256 totalShares) internal pure returns (uint256) {
        return convertToAssets(shares, totalAssets, totalShares, Math.Rounding.Floor);
    }

    /**
     * @dev Internal conversion function (from assets to shares) with support for rounding direction.
     */
    function convertToShares(uint256 assets, uint256 totalShares, uint256 totalAssets, Math.Rounding rounding)
        internal
        pure
        returns (uint256)
    {
        return assets.mulDiv(totalShares + 10 ** _decimalsOffset(), totalAssets + 1, rounding);
    }

    /**
     * @dev Internal conversion function (from shares to assets) with support for rounding direction.
     */
    function convertToAssets(uint256 shares, uint256 totalAssets, uint256 totalShares, Math.Rounding rounding)
        internal
        pure
        returns (uint256)
    {
        return shares.mulDiv(totalAssets + 1, totalShares + 10 ** _decimalsOffset(), rounding);
    }

    function _decimalsOffset() private pure returns (uint8) {
        return 0;
    }
}

// src/contracts/libraries/Checkpoints.sol

/**
 * @title Checkpoints
 * @notice Library implementing a timestamped checkpoint lookup and mutation primitive set.
 */
library Checkpoints_1 {
    using Checkpoints_0 for Checkpoints_0.Trace208;

    error SystemCheckpoint();

    struct Trace208 {
        Checkpoints_0.Trace208 _trace;
    }

    struct Checkpoint208 {
        uint48 _key;
        uint208 _value;
    }

    struct Trace256 {
        Checkpoints_0.Trace208 _trace;
        uint256[] _values;
    }

    struct Checkpoint256 {
        uint48 _key;
        uint256 _value;
    }

    /**
     * @dev Pushes a (`key`, `value`) pair into a Trace208 so that it is stored as the checkpoint.
     *
     * Returns previous value and new value.
     */
    function push(Trace208 storage self, uint48 key, uint208 value) internal returns (uint208, uint208) {
        return self._trace.push(key, value);
    }

    /**
     * @dev Returns the value in the last (most recent) checkpoint with a key lower or equal than the search key, or zero
     * if there is none.
     */
    function upperLookupRecent(Trace208 storage self, uint48 key) internal view returns (uint208) {
        return self._trace.upperLookupRecent(key);
    }

    /**
     * @dev Returns the value in the last (most recent) checkpoint with a key lower or equal than the search key, or zero
     * if there is none.
     *
     * NOTE: This is a variant of {upperLookupRecent} that can be optimized by getting the hint
     * (index of the checkpoint with a key lower or equal than the search key).
     */
    function upperLookupRecent(Trace208 storage self, uint48 key, bytes memory hint_) internal view returns (uint208) {
        if (hint_.length == 0) {
            return upperLookupRecent(self, key);
        }

        uint32 hint = abi.decode(hint_, (uint32));
        Checkpoint208 memory checkpoint = at(self, hint);
        if (checkpoint._key == key) {
            return checkpoint._value;
        }

        if (checkpoint._key < key && (hint == length(self) - 1 || at(self, hint + 1)._key > key)) {
            return checkpoint._value;
        }

        return upperLookupRecent(self, key);
    }

    /**
     * @dev Returns whether there is a checkpoint with a key lower or equal than the search key in the structure (i.e. it is not empty),
     * and if so the key and value in the checkpoint, and its position in the trace.
     */
    function upperLookupRecentCheckpoint(Trace208 storage self, uint48 key)
        internal
        view
        returns (bool, uint48, uint208, uint32)
    {
        uint256 len = self._trace._checkpoints.length;

        uint256 low = 0;
        uint256 high = len;

        if (len > 5) {
            uint256 mid = len - Math.sqrt(len);
            if (key < _unsafeAccess(self._trace._checkpoints, mid)._key) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }

        uint256 pos = _upperBinaryLookup(self._trace._checkpoints, key, low, high);

        if (pos == 0) {
            return (false, 0, 0, 0);
        }

        Checkpoints_0.Checkpoint208 memory checkpoint = _unsafeAccess(self._trace._checkpoints, pos - 1);
        return (true, checkpoint._key, checkpoint._value, uint32(pos - 1));
    }

    /**
     * @dev Returns whether there is a checkpoint with a key lower or equal than the search key in the structure (i.e. it is not empty),
     * and if so the key and value in the checkpoint, and its position in the trace.
     *
     * NOTE: This is a variant of {upperLookupRecentCheckpoint} that can be optimized by getting the hint
     * (index of the checkpoint with a key lower or equal than the search key).
     */
    function upperLookupRecentCheckpoint(Trace208 storage self, uint48 key, bytes memory hint_)
        internal
        view
        returns (bool, uint48, uint208, uint32)
    {
        if (hint_.length == 0) {
            return upperLookupRecentCheckpoint(self, key);
        }

        uint32 hint = abi.decode(hint_, (uint32));
        Checkpoint208 memory checkpoint = at(self, hint);
        if (checkpoint._key == key) {
            return (true, checkpoint._key, checkpoint._value, hint);
        }

        if (checkpoint._key < key && (hint == length(self) - 1 || at(self, hint + 1)._key > key)) {
            return (true, checkpoint._key, checkpoint._value, hint);
        }

        return upperLookupRecentCheckpoint(self, key);
    }

    /**
     * @dev Returns the value in the most recent checkpoint, or zero if there are no checkpoints.
     */
    function latest(Trace208 storage self) internal view returns (uint208) {
        return self._trace.latest();
    }

    /**
     * @dev Returns whether there is a checkpoint in the structure (i.e. it is not empty), and if so the key and value
     * in the most recent checkpoint.
     */
    function latestCheckpoint(Trace208 storage self) internal view returns (bool, uint48, uint208) {
        return self._trace.latestCheckpoint();
    }

    /**
     * @dev Returns a total number of checkpoints.
     */
    function length(Trace208 storage self) internal view returns (uint256) {
        return self._trace.length();
    }

    /**
     * @dev Returns checkpoint at a given position.
     */
    function at(Trace208 storage self, uint32 pos) internal view returns (Checkpoint208 memory) {
        Checkpoints_0.Checkpoint208 memory checkpoint = self._trace.at(pos);
        return Checkpoint208({_key: checkpoint._key, _value: checkpoint._value});
    }

    /**
     * @dev Pops the last (most recent) checkpoint.
     */
    function pop(Trace208 storage self) internal returns (uint208 value) {
        value = self._trace.latest();
        self._trace._checkpoints.pop();
    }

    /**
     * @dev Pushes a (`key`, `value`) pair into a Trace256 so that it is stored as the checkpoint.
     *
     * Returns previous value and new value.
     */
    function push(Trace256 storage self, uint48 key, uint256 value) internal returns (uint256, uint256) {
        if (self._values.length == 0) {
            self._values.push(0);
        }

        (bool exists, uint48 lastKey,) = self._trace.latestCheckpoint();

        uint256 len = self._values.length;
        uint256 lastValue = latest(self);
        if (exists && key == lastKey) {
            self._values[len - 1] = value;
        } else {
            self._trace.push(key, uint208(len));
            self._values.push(value);
        }

        return (lastValue, value);
    }

    /**
     * @dev Returns the value in the last (most recent) checkpoint with a key lower or equal than the search key, or zero
     * if there is none.
     */
    function upperLookupRecent(Trace256 storage self, uint48 key) internal view returns (uint256) {
        uint208 idx = self._trace.upperLookupRecent(key);
        return idx > 0 ? self._values[idx] : 0;
    }

    /**
     * @dev Returns the value in the last (most recent) checkpoint with a key lower or equal than the search key, or zero
     * if there is none.
     *
     * NOTE: This is a variant of {upperLookupRecent} that can be optimized by getting the hint
     * (index of the checkpoint with a key lower or equal than the search key).
     */
    function upperLookupRecent(Trace256 storage self, uint48 key, bytes memory hint_) internal view returns (uint256) {
        if (hint_.length == 0) {
            return upperLookupRecent(self, key);
        }

        uint32 hint = abi.decode(hint_, (uint32));
        Checkpoint256 memory checkpoint = at(self, hint);
        if (checkpoint._key == key) {
            return checkpoint._value;
        }

        if (checkpoint._key < key && (hint == length(self) - 1 || at(self, hint + 1)._key > key)) {
            return checkpoint._value;
        }

        return upperLookupRecent(self, key);
    }

    /**
     * @dev Returns whether there is a checkpoint with a key lower or equal than the search key in the structure (i.e. it is not empty),
     * and if so the key and value in the checkpoint, and its position in the trace.
     */
    function upperLookupRecentCheckpoint(Trace256 storage self, uint48 key)
        internal
        view
        returns (bool, uint48, uint256, uint32)
    {
        uint256 len = self._trace._checkpoints.length;

        uint256 low = 0;
        uint256 high = len;

        if (len > 5) {
            uint256 mid = len - Math.sqrt(len);
            if (key < _unsafeAccess(self._trace._checkpoints, mid)._key) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }

        uint256 pos = _upperBinaryLookup(self._trace._checkpoints, key, low, high);

        if (pos == 0) {
            return (false, 0, 0, 0);
        }

        Checkpoints_0.Checkpoint208 memory checkpoint = _unsafeAccess(self._trace._checkpoints, pos - 1);
        return (true, checkpoint._key, self._values[checkpoint._value], uint32(pos - 1));
    }

    /**
     * @dev Returns whether there is a checkpoint with a key lower or equal than the search key in the structure (i.e. it is not empty),
     * and if so the key and value in the checkpoint, and its position in the trace.
     *
     * NOTE: This is a variant of {upperLookupRecentCheckpoint} that can be optimized by getting the hint
     * (index of the checkpoint with a key lower or equal than the search key).
     */
    function upperLookupRecentCheckpoint(Trace256 storage self, uint48 key, bytes memory hint_)
        internal
        view
        returns (bool, uint48, uint256, uint32)
    {
        if (hint_.length == 0) {
            return upperLookupRecentCheckpoint(self, key);
        }

        uint32 hint = abi.decode(hint_, (uint32));
        Checkpoint256 memory checkpoint = at(self, hint);
        if (checkpoint._key == key) {
            return (true, checkpoint._key, checkpoint._value, hint);
        }

        if (checkpoint._key < key && (hint == length(self) - 1 || at(self, hint + 1)._key > key)) {
            return (true, checkpoint._key, checkpoint._value, hint);
        }

        return upperLookupRecentCheckpoint(self, key);
    }

    /**
     * @dev Returns the value in the most recent checkpoint, or zero if there are no checkpoints.
     */
    function latest(Trace256 storage self) internal view returns (uint256) {
        uint208 idx = self._trace.latest();
        return idx > 0 ? self._values[idx] : 0;
    }

    /**
     * @dev Returns whether there is a checkpoint in the structure (i.e. it is not empty), and if so the key and value
     * in the most recent checkpoint.
     */
    function latestCheckpoint(Trace256 storage self) internal view returns (bool exists, uint48 _key, uint256 _value) {
        uint256 idx;
        (exists, _key, idx) = self._trace.latestCheckpoint();
        _value = exists ? self._values[idx] : 0;
    }

    /**
     * @dev Returns a total number of checkpoints.
     */
    function length(Trace256 storage self) internal view returns (uint256) {
        return self._trace.length();
    }

    /**
     * @dev Returns checkpoint at a given position.
     */
    function at(Trace256 storage self, uint32 pos) internal view returns (Checkpoint256 memory) {
        Checkpoints_0.Checkpoint208 memory checkpoint = self._trace.at(pos);
        return Checkpoint256({_key: checkpoint._key, _value: self._values[checkpoint._value]});
    }

    /**
     * @dev Pops the last (most recent) checkpoint.
     */
    function pop(Trace256 storage self) internal returns (uint256 value) {
        uint208 idx = self._trace.latest();
        if (idx == 0) {
            revert SystemCheckpoint();
        }
        value = self._values[idx];
        self._trace._checkpoints.pop();
        self._values.pop();
    }

    /**
     * @dev Return the index of the last (most recent) checkpoint with a key lower or equal than the search key, or `high`
     * if there is none. `low` and `high` define a section where to do the search, with inclusive `low` and exclusive.
     * `high`.
     *
     * WARNING: `high` should not be greater than the array's length.
     */
    function _upperBinaryLookup(Checkpoints_0.Checkpoint208[] storage self, uint48 key, uint256 low, uint256 high)
        private
        view
        returns (uint256)
    {
        while (low < high) {
            uint256 mid = Math.average(low, high);
            if (_unsafeAccess(self, mid)._key > key) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return high;
    }

    /**
     * @dev Access an element of the array without performing a bounds check. The position is assumed to be within bounds.
     */
    function _unsafeAccess(Checkpoints_0.Checkpoint208[] storage self, uint256 pos)
        private
        pure
        returns (Checkpoints_0.Checkpoint208 storage result)
    {
        assembly {
            mstore(0, self.slot)
            result.slot := add(keccak256(0, 0x20), pos)
        }
    }
}

// src/contracts/libraries/CheckpointsV2.sol

/**
 * @title Checkpoints
 * @notice Library implementing a timestamped checkpoint lookup and mutation primitive set.
 */
library Checkpoints_2 {
    using Checkpoints_0 for Checkpoints_0.Trace208;

    error SystemCheckpoint();

    struct Trace208 {
        Checkpoints_0.Trace208 _trace;
    }

    struct Checkpoint208 {
        uint48 _key;
        uint208 _value;
    }

    struct Trace256 {
        Checkpoints_0.Trace208 _trace;
        mapping(uint208 pointer => uint256 value) _values;
    }

    struct Trace512 {
        Checkpoints_0.Trace208 _trace;
        mapping(uint208 pointer => uint256[2] value) _values;
    }

    struct Checkpoint256 {
        uint48 _key;
        uint256 _value;
    }

    struct Checkpoint512 {
        uint48 _key;
        uint256[2] _value;
    }

    /**
     * @dev Pushes a (`key`, `value`) pair into a Trace208 so that it is stored as the checkpoint.
     *
     * Returns previous value and new value.
     */
    function push(Trace208 storage self, uint48 key, uint208 value) internal returns (uint208, uint208) {
        return self._trace.push(key, value);
    }

    /**
     * @dev Returns the value in the last (most recent) checkpoint with a key lower or equal than the search key, or zero
     * if there is none.
     */
    function upperLookupRecent(Trace208 storage self, uint48 key) internal view returns (uint208) {
        return self._trace.upperLookupRecent(key);
    }

    /**
     * @dev Returns the value in the last (most recent) checkpoint with a key lower or equal than the search key, or zero
     * if there is none.
     *
     * NOTE: This is a variant of {upperLookupRecent} that can be optimized by getting the hint
     * (index of the checkpoint with a key lower or equal than the search key).
     */
    function upperLookupRecent(Trace208 storage self, uint48 key, bytes memory hint_) internal view returns (uint208) {
        if (hint_.length == 0) {
            return upperLookupRecent(self, key);
        }

        uint32 hint = abi.decode(hint_, (uint32));
        Checkpoint208 memory checkpoint = at(self, hint);
        if (checkpoint._key == key) {
            return checkpoint._value;
        }

        if (checkpoint._key < key && (hint == length(self) - 1 || at(self, hint + 1)._key > key)) {
            return checkpoint._value;
        }

        return upperLookupRecent(self, key);
    }

    /**
     * @dev Returns whether there is a checkpoint with a key lower or equal than the search key in the structure (i.e. it is not empty),
     * and if so the key and value in the checkpoint, and its position in the trace.
     */
    function upperLookupRecentCheckpoint(Trace208 storage self, uint48 key)
        internal
        view
        returns (bool, uint48, uint208, uint32)
    {
        uint256 len = self._trace._checkpoints.length;

        uint256 low = 0;
        uint256 high = len;

        if (len > 5) {
            uint256 mid = len - Math.sqrt(len);
            if (key < _unsafeAccess(self._trace._checkpoints, mid)._key) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }

        uint256 pos = _upperBinaryLookup(self._trace._checkpoints, key, low, high);

        if (pos == 0) {
            return (false, 0, 0, 0);
        }

        unchecked {
            Checkpoints_0.Checkpoint208 memory checkpoint = _unsafeAccess(self._trace._checkpoints, pos - 1);
            return (true, checkpoint._key, checkpoint._value, uint32(pos - 1));
        }
    }

    /**
     * @dev Returns whether there is a checkpoint with a key lower or equal than the search key in the structure (i.e. it is not empty),
     * and if so the key and value in the checkpoint, and its position in the trace.
     *
     * NOTE: This is a variant of {upperLookupRecentCheckpoint} that can be optimized by getting the hint
     * (index of the checkpoint with a key lower or equal than the search key).
     */
    function upperLookupRecentCheckpoint(Trace208 storage self, uint48 key, bytes memory hint_)
        internal
        view
        returns (bool, uint48, uint208, uint32)
    {
        if (hint_.length == 0) {
            return upperLookupRecentCheckpoint(self, key);
        }

        uint32 hint = abi.decode(hint_, (uint32));
        Checkpoint208 memory checkpoint = at(self, hint);
        if (checkpoint._key == key) {
            return (true, checkpoint._key, checkpoint._value, hint);
        }

        if (checkpoint._key < key && (hint == length(self) - 1 || at(self, hint + 1)._key > key)) {
            return (true, checkpoint._key, checkpoint._value, hint);
        }

        return upperLookupRecentCheckpoint(self, key);
    }

    /**
     * @dev Returns the value in the most recent checkpoint, or zero if there are no checkpoints.
     */
    function latest(Trace208 storage self) internal view returns (uint208) {
        return self._trace.latest();
    }

    /**
     * @dev Returns whether there is a checkpoint in the structure (i.e. it is not empty), and if so the key and value
     * in the most recent checkpoint.
     */
    function latestCheckpoint(Trace208 storage self) internal view returns (bool, uint48, uint208) {
        return self._trace.latestCheckpoint();
    }

    /**
     * @dev Returns a total number of checkpoints.
     */
    function length(Trace208 storage self) internal view returns (uint256) {
        return self._trace.length();
    }

    /**
     * @dev Returns checkpoint at a given position.
     */
    function at(Trace208 storage self, uint32 pos) internal view returns (Checkpoint208 memory) {
        Checkpoints_0.Checkpoint208 memory checkpoint = self._trace.at(pos);
        return Checkpoint208({_key: checkpoint._key, _value: checkpoint._value});
    }

    /**
     * @dev Pops the last (most recent) checkpoint.
     */
    function pop(Trace208 storage self) internal returns (uint208 value) {
        value = self._trace.latest();
        self._trace._checkpoints.pop();
    }

    /**
     * @dev Pushes a (`key`, `value`) pair into a Trace256 so that it is stored as the checkpoint.
     *
     * Returns previous value and new value.
     */
    function push(Trace256 storage self, uint48 key, uint256 value) internal returns (uint256, uint256) {
        (bool exists, uint48 lastKey, uint208 lastPointer) = self._trace.latestCheckpoint();

        uint256 lastValue = latest(self);
        if (exists && key == lastKey) {
            self._values[lastPointer] = value;
        } else {
            uint208 newPointer = lastPointer + 1;
            self._trace.push(key, newPointer);
            self._values[newPointer] = value;
        }

        return (lastValue, value);
    }

    /**
     * @dev Returns the value in the last (most recent) checkpoint with a key lower or equal than the search key, or zero
     * if there is none.
     */
    function upperLookupRecent(Trace256 storage self, uint48 key) internal view returns (uint256) {
        uint208 idx = self._trace.upperLookupRecent(key);
        return idx > 0 ? self._values[idx] : 0;
    }

    /**
     * @dev Returns the value in the last (most recent) checkpoint with a key lower or equal than the search key, or zero
     * if there is none.
     *
     * NOTE: This is a variant of {upperLookupRecent} that can be optimized by getting the hint
     * (index of the checkpoint with a key lower or equal than the search key).
     */
    function upperLookupRecent(Trace256 storage self, uint48 key, bytes memory hint_) internal view returns (uint256) {
        if (hint_.length == 0) {
            return upperLookupRecent(self, key);
        }

        uint32 hint = abi.decode(hint_, (uint32));
        Checkpoint256 memory checkpoint = at(self, hint);
        if (checkpoint._key == key) {
            return checkpoint._value;
        }

        if (checkpoint._key < key && (hint == length(self) - 1 || at(self, hint + 1)._key > key)) {
            return checkpoint._value;
        }

        return upperLookupRecent(self, key);
    }

    /**
     * @dev Returns whether there is a checkpoint with a key lower or equal than the search key in the structure (i.e. it is not empty),
     * and if so the key and value in the checkpoint, and its position in the trace.
     */
    function upperLookupRecentCheckpoint(Trace256 storage self, uint48 key)
        internal
        view
        returns (bool, uint48, uint256, uint32)
    {
        uint256 len = self._trace._checkpoints.length;

        uint256 low = 0;
        uint256 high = len;

        if (len > 5) {
            uint256 mid = len - Math.sqrt(len);
            if (key < _unsafeAccess(self._trace._checkpoints, mid)._key) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }

        uint256 pos = _upperBinaryLookup(self._trace._checkpoints, key, low, high);

        if (pos == 0) {
            return (false, 0, 0, 0);
        }

        unchecked {
            Checkpoints_0.Checkpoint208 memory checkpoint = _unsafeAccess(self._trace._checkpoints, pos - 1);
            return (true, checkpoint._key, self._values[checkpoint._value], uint32(pos - 1));
        }
    }

    /**
     * @dev Returns whether there is a checkpoint with a key lower or equal than the search key in the structure (i.e. it is not empty),
     * and if so the key and value in the checkpoint, and its position in the trace.
     *
     * NOTE: This is a variant of {upperLookupRecentCheckpoint} that can be optimized by getting the hint
     * (index of the checkpoint with a key lower or equal than the search key).
     */
    function upperLookupRecentCheckpoint(Trace256 storage self, uint48 key, bytes memory hint_)
        internal
        view
        returns (bool, uint48, uint256, uint32)
    {
        if (hint_.length == 0) {
            return upperLookupRecentCheckpoint(self, key);
        }

        uint32 hint = abi.decode(hint_, (uint32));
        Checkpoint256 memory checkpoint = at(self, hint);
        if (checkpoint._key == key) {
            return (true, checkpoint._key, checkpoint._value, hint);
        }

        if (checkpoint._key < key && (hint == length(self) - 1 || at(self, hint + 1)._key > key)) {
            return (true, checkpoint._key, checkpoint._value, hint);
        }

        return upperLookupRecentCheckpoint(self, key);
    }

    /**
     * @dev Returns the value in the most recent checkpoint, or zero if there are no checkpoints.
     */
    function latest(Trace256 storage self) internal view returns (uint256) {
        uint208 idx = self._trace.latest();
        return idx > 0 ? self._values[idx] : 0;
    }

    /**
     * @dev Returns whether there is a checkpoint in the structure (i.e. it is not empty), and if so the key and value
     * in the most recent checkpoint.
     */
    function latestCheckpoint(Trace256 storage self) internal view returns (bool exists, uint48 _key, uint256 _value) {
        uint208 idx;
        (exists, _key, idx) = self._trace.latestCheckpoint();
        _value = exists ? self._values[idx] : 0;
    }

    /**
     * @dev Returns a total number of checkpoints.
     */
    function length(Trace256 storage self) internal view returns (uint256) {
        return self._trace.length();
    }

    /**
     * @dev Returns checkpoint at a given position.
     */
    function at(Trace256 storage self, uint32 pos) internal view returns (Checkpoint256 memory) {
        Checkpoints_0.Checkpoint208 memory checkpoint = self._trace.at(pos);
        return Checkpoint256({_key: checkpoint._key, _value: self._values[checkpoint._value]});
    }

    /**
     * @dev Pops the last (most recent) checkpoint.
     */
    function pop(Trace256 storage self) internal returns (uint256 value) {
        uint208 idx = self._trace.latest();
        if (idx == 0) {
            revert SystemCheckpoint();
        }
        value = self._values[idx];
        self._trace._checkpoints.pop();
        delete self._values[idx];
    }

    /**
     * @dev Pushes a (`key`, `value`) pair into a Trace256 so that it is stored as the checkpoint.
     *
     * Returns previous value and new value.
     */
    function push(Trace512 storage self, uint48 key, uint256[2] memory value)
        internal
        returns (uint256[2] memory, uint256[2] memory)
    {
        (bool exists, uint48 lastKey, uint208 lastPointer) = self._trace.latestCheckpoint();

        uint256[2] memory lastValue = latest(self);
        if (exists && key == lastKey) {
            self._values[lastPointer] = value;
        } else {
            uint208 newPointer = lastPointer + 1;
            self._trace.push(key, newPointer);
            self._values[newPointer] = value;
        }

        return (lastValue, value);
    }

    /**
     * @dev Returns the value in the last (most recent) checkpoint with a key lower or equal than the search key, or zero
     * if there is none.
     */
    function upperLookupRecent(Trace512 storage self, uint48 key) internal view returns (uint256[2] memory) {
        uint208 idx = self._trace.upperLookupRecent(key);
        return idx > 0 ? self._values[idx] : [uint256(0), 0];
    }

    /**
     * @dev Returns the value in the last (most recent) checkpoint with a key lower or equal than the search key, or zero
     * if there is none.
     *
     * NOTE: This is a variant of {upperLookupRecent} that can be optimized by getting the hint
     * (index of the checkpoint with a key lower or equal than the search key).
     */
    function upperLookupRecent(Trace512 storage self, uint48 key, bytes memory hint_)
        internal
        view
        returns (uint256[2] memory)
    {
        if (hint_.length == 0) {
            return upperLookupRecent(self, key);
        }

        uint32 hint = abi.decode(hint_, (uint32));
        Checkpoint512 memory checkpoint = at(self, hint);
        if (checkpoint._key == key) {
            return checkpoint._value;
        }

        if (checkpoint._key < key && (hint == length(self) - 1 || at(self, hint + 1)._key > key)) {
            return checkpoint._value;
        }

        return upperLookupRecent(self, key);
    }

    /**
     * @dev Returns whether there is a checkpoint with a key lower or equal than the search key in the structure (i.e. it is not empty),
     * and if so the key and value in the checkpoint, and its position in the trace.
     */
    function upperLookupRecentCheckpoint(Trace512 storage self, uint48 key)
        internal
        view
        returns (bool, uint48, uint256[2] memory, uint32)
    {
        uint256 len = self._trace._checkpoints.length;

        uint256 low = 0;
        uint256 high = len;

        if (len > 5) {
            uint256 mid = len - Math.sqrt(len);
            if (key < _unsafeAccess(self._trace._checkpoints, mid)._key) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }

        uint256 pos = _upperBinaryLookup(self._trace._checkpoints, key, low, high);

        if (pos == 0) {
            return (false, 0, [uint256(0), 0], 0);
        }

        unchecked {
            Checkpoints_0.Checkpoint208 memory checkpoint = _unsafeAccess(self._trace._checkpoints, pos - 1);
            return (true, checkpoint._key, self._values[checkpoint._value], uint32(pos - 1));
        }
    }

    /**
     * @dev Returns whether there is a checkpoint with a key lower or equal than the search key in the structure (i.e. it is not empty),
     * and if so the key and value in the checkpoint, and its position in the trace.
     *
     * NOTE: This is a variant of {upperLookupRecentCheckpoint} that can be optimized by getting the hint
     * (index of the checkpoint with a key lower or equal than the search key).
     */
    function upperLookupRecentCheckpoint(Trace512 storage self, uint48 key, bytes memory hint_)
        internal
        view
        returns (bool, uint48, uint256[2] memory, uint32)
    {
        if (hint_.length == 0) {
            return upperLookupRecentCheckpoint(self, key);
        }

        uint32 hint = abi.decode(hint_, (uint32));
        Checkpoint512 memory checkpoint = at(self, hint);
        if (checkpoint._key == key) {
            return (true, checkpoint._key, checkpoint._value, hint);
        }

        if (checkpoint._key < key && (hint == length(self) - 1 || at(self, hint + 1)._key > key)) {
            return (true, checkpoint._key, checkpoint._value, hint);
        }

        return upperLookupRecentCheckpoint(self, key);
    }

    /**
     * @dev Returns the value in the most recent checkpoint, or zero if there are no checkpoints.
     */
    function latest(Trace512 storage self) internal view returns (uint256[2] memory) {
        uint208 idx = self._trace.latest();
        return idx > 0 ? self._values[idx] : [uint256(0), 0];
    }

    /**
     * @dev Returns whether there is a checkpoint in the structure (i.e. it is not empty), and if so the key and value
     * in the most recent checkpoint.
     */
    function latestCheckpoint(Trace512 storage self)
        internal
        view
        returns (bool exists, uint48 _key, uint256[2] memory _value)
    {
        uint208 idx;
        (exists, _key, idx) = self._trace.latestCheckpoint();
        _value = exists ? self._values[idx] : [uint256(0), 0];
    }

    /**
     * @dev Returns a total number of checkpoints.
     */
    function length(Trace512 storage self) internal view returns (uint256) {
        return self._trace.length();
    }

    /**
     * @dev Returns checkpoint at a given position.
     */
    function at(Trace512 storage self, uint32 pos) internal view returns (Checkpoint512 memory) {
        Checkpoints_0.Checkpoint208 memory checkpoint = self._trace.at(pos);
        return Checkpoint512({_key: checkpoint._key, _value: self._values[checkpoint._value]});
    }

    /**
     * @dev Pops the last (most recent) checkpoint.
     */
    function pop(Trace512 storage self) internal returns (uint256[2] memory value) {
        uint208 idx = self._trace.latest();
        if (idx == 0) {
            revert SystemCheckpoint();
        }
        value = self._values[idx];
        self._trace._checkpoints.pop();
        delete self._values[idx];
    }

    /**
     * @dev Return the index of the last (most recent) checkpoint with a key lower or equal than the search key, or `high`
     * if there is none. `low` and `high` define a section where to do the search, with inclusive `low` and exclusive.
     * `high`.
     *
     * WARNING: `high` should not be greater than the array's length.
     */
    function _upperBinaryLookup(Checkpoints_0.Checkpoint208[] storage self, uint48 key, uint256 low, uint256 high)
        private
        view
        returns (uint256)
    {
        while (low < high) {
            uint256 mid = Math.average(low, high);
            if (_unsafeAccess(self, mid)._key > key) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return high;
    }

    /**
     * @dev Access an element of the array without performing a bounds check. The position is assumed to be within bounds.
     */
    function _unsafeAccess(Checkpoints_0.Checkpoint208[] storage self, uint256 pos)
        private
        pure
        returns (Checkpoints_0.Checkpoint208 storage result)
    {
        assembly {
            mstore(0, self.slot)
            result.slot := add(keccak256(0, 0x20), pos)
        }
    }
}

// lib/openzeppelin-contracts-upgradeable/contracts/access/AccessControlUpgradeable.sol

// OpenZeppelin Contracts (last updated v5.4.0) (access/AccessControl.sol)

/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms. This is a lightweight version that doesn't allow enumerating role
 * members except through off-chain means by accessing the contract event logs. Some
 * applications may benefit from on-chain enumerability, for those cases see
 * {AccessControlEnumerable}.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```solidity
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```solidity
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
 * to enforce additional security measures for this role.
 */
abstract contract AccessControlUpgradeable is Initializable, ContextUpgradeable, IAccessControl, ERC165Upgradeable {
    struct RoleData {
        mapping(address account => bool) hasRole;
        bytes32 adminRole;
    }

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /// @custom:storage-location erc7201:openzeppelin.storage.AccessControl
    struct AccessControlStorage {
        mapping(bytes32 role => RoleData) _roles;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.AccessControl")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant AccessControlStorageLocation =
        0x02dd7bc7dec4dceedda775e58dd541e08a116c6c53815c0bd028192f7b626800;

    function _getAccessControlStorage() private pure returns (AccessControlStorage storage $) {
        assembly {
            $.slot := AccessControlStorageLocation
        }
    }

    /**
     * @dev Modifier that checks that an account has a specific role. Reverts
     * with an {AccessControlUnauthorizedAccount} error including the required role.
     */
    modifier onlyRole(bytes32 role) {
        _checkRole(role);
        _;
    }

    function __AccessControl_init() internal onlyInitializing {}

    function __AccessControl_init_unchained() internal onlyInitializing {}

    /// @inheritdoc IERC165
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view virtual returns (bool) {
        AccessControlStorage storage $ = _getAccessControlStorage();
        return $._roles[role].hasRole[account];
    }

    /**
     * @dev Reverts with an {AccessControlUnauthorizedAccount} error if `_msgSender()`
     * is missing `role`. Overriding this function changes the behavior of the {onlyRole} modifier.
     */
    function _checkRole(bytes32 role) internal view virtual {
        _checkRole(role, _msgSender());
    }

    /**
     * @dev Reverts with an {AccessControlUnauthorizedAccount} error if `account`
     * is missing `role`.
     */
    function _checkRole(bytes32 role, address account) internal view virtual {
        if (!hasRole(role, account)) {
            revert AccessControlUnauthorizedAccount(account, role);
        }
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view virtual returns (bytes32) {
        AccessControlStorage storage $ = _getAccessControlStorage();
        return $._roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     *
     * May emit a {RoleGranted} event.
     */
    function grantRole(bytes32 role, address account) public virtual onlyRole(getRoleAdmin(role)) {
        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     *
     * May emit a {RoleRevoked} event.
     */
    function revokeRole(bytes32 role, address account) public virtual onlyRole(getRoleAdmin(role)) {
        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been revoked `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `callerConfirmation`.
     *
     * May emit a {RoleRevoked} event.
     */
    function renounceRole(bytes32 role, address callerConfirmation) public virtual {
        if (callerConfirmation != _msgSender()) {
            revert AccessControlBadConfirmation();
        }

        _revokeRole(role, callerConfirmation);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        AccessControlStorage storage $ = _getAccessControlStorage();
        bytes32 previousAdminRole = getRoleAdmin(role);
        $._roles[role].adminRole = adminRole;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }

    /**
     * @dev Attempts to grant `role` to `account` and returns a boolean indicating if `role` was granted.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleGranted} event.
     */
    function _grantRole(bytes32 role, address account) internal virtual returns (bool) {
        AccessControlStorage storage $ = _getAccessControlStorage();
        if (!hasRole(role, account)) {
            $._roles[role].hasRole[account] = true;
            emit RoleGranted(role, account, _msgSender());
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Attempts to revoke `role` from `account` and returns a boolean indicating if `role` was revoked.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleRevoked} event.
     */
    function _revokeRole(bytes32 role, address account) internal virtual returns (bool) {
        AccessControlStorage storage $ = _getAccessControlStorage();
        if (hasRole(role, account)) {
            $._roles[role].hasRole[account] = false;
            emit RoleRevoked(role, account, _msgSender());
            return true;
        } else {
            return false;
        }
    }
}

// lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol

// OpenZeppelin Contracts (last updated v5.4.0) (token/ERC20/ERC20.sol)

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * The default value of {decimals} is 18. To change this, you should override
 * this function so it returns a different value.
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC-20
 * applications.
 */
abstract contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20, IERC20Metadata, IERC20Errors {
    /// @custom:storage-location erc7201:openzeppelin.storage.ERC20
    struct ERC20Storage {
        mapping(address account => uint256) _balances;

        mapping(address account => mapping(address spender => uint256)) _allowances;

        uint256 _totalSupply;

        string _name;
        string _symbol;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.ERC20")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant ERC20StorageLocation = 0x52c63247e1f47db19d5ce0460030c497f067ca4cebf71ba98eeadabe20bace00;

    function _getERC20Storage() private pure returns (ERC20Storage storage $) {
        assembly {
            $.slot := ERC20StorageLocation
        }
    }

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * Both values are immutable: they can only be set once during construction.
     */
    function __ERC20_init(string memory name_, string memory symbol_) internal onlyInitializing {
        __ERC20_init_unchained(name_, symbol_);
    }

    function __ERC20_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
        ERC20Storage storage $ = _getERC20Storage();
        $._name = name_;
        $._symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        ERC20Storage storage $ = _getERC20Storage();
        return $._name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        ERC20Storage storage $ = _getERC20Storage();
        return $._symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the default value returned by this function, unless
     * it's overridden.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    /// @inheritdoc IERC20
    function totalSupply() public view virtual returns (uint256) {
        ERC20Storage storage $ = _getERC20Storage();
        return $._totalSupply;
    }

    /// @inheritdoc IERC20
    function balanceOf(address account) public view virtual returns (uint256) {
        ERC20Storage storage $ = _getERC20Storage();
        return $._balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `value`.
     */
    function transfer(address to, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

    /// @inheritdoc IERC20
    function allowance(address owner, address spender) public view virtual returns (uint256) {
        ERC20Storage storage $ = _getERC20Storage();
        return $._allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `value` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, value);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Skips emitting an {Approval} event indicating an allowance update. This is not
     * required by the ERC. See {xref-ERC20-_approve-address-address-uint256-bool-}[_approve].
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `value`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `value`.
     */
    function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead.
     */
    function _transfer(address from, address to, uint256 value) internal {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, value);
    }

    /**
     * @dev Transfers a `value` amount of tokens from `from` to `to`, or alternatively mints (or burns) if `from`
     * (or `to`) is the zero address. All customizations to transfers, mints, and burns should be done by overriding
     * this function.
     *
     * Emits a {Transfer} event.
     */
    function _update(address from, address to, uint256 value) internal virtual {
        ERC20Storage storage $ = _getERC20Storage();
        if (from == address(0)) {
            // Overflow check required: The rest of the code assumes that totalSupply never overflows
            $._totalSupply += value;
        } else {
            uint256 fromBalance = $._balances[from];
            if (fromBalance < value) {
                revert ERC20InsufficientBalance(from, fromBalance, value);
            }
            unchecked {
                // Overflow not possible: value <= fromBalance <= totalSupply.
                $._balances[from] = fromBalance - value;
            }
        }

        if (to == address(0)) {
            unchecked {
                // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
                $._totalSupply -= value;
            }
        } else {
            unchecked {
                // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
                $._balances[to] += value;
            }
        }

        emit Transfer(from, to, value);
    }

    /**
     * @dev Creates a `value` amount of tokens and assigns them to `account`, by transferring it from address(0).
     * Relies on the `_update` mechanism
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead.
     */
    function _mint(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(address(0), account, value);
    }

    /**
     * @dev Destroys a `value` amount of tokens from `account`, lowering the total supply.
     * Relies on the `_update` mechanism.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead
     */
    function _burn(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        _update(account, address(0), value);
    }

    /**
     * @dev Sets `value` as the allowance of `spender` over the `owner`'s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     *
     * Overrides to this logic should be done to the variant with an additional `bool emitEvent` argument.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        _approve(owner, spender, value, true);
    }

    /**
     * @dev Variant of {_approve} with an optional flag to enable or disable the {Approval} event.
     *
     * By default (when calling {_approve}) the flag is set to true. On the other hand, approval changes made by
     * `_spendAllowance` during the `transferFrom` operation set the flag to false. This saves gas by not emitting any
     * `Approval` event during `transferFrom` operations.
     *
     * Anyone who wishes to continue emitting `Approval` events on the`transferFrom` operation can force the flag to
     * true using the following override:
     *
     * ```solidity
     * function _approve(address owner, address spender, uint256 value, bool) internal virtual override {
     *     super._approve(owner, spender, value, true);
     * }
     * ```
     *
     * Requirements are the same as {_approve}.
     */
    function _approve(address owner, address spender, uint256 value, bool emitEvent) internal virtual {
        ERC20Storage storage $ = _getERC20Storage();
        if (owner == address(0)) {
            revert ERC20InvalidApprover(address(0));
        }
        if (spender == address(0)) {
            revert ERC20InvalidSpender(address(0));
        }
        $._allowances[owner][spender] = value;
        if (emitEvent) {
            emit Approval(owner, spender, value);
        }
    }

    /**
     * @dev Updates `owner`'s allowance for `spender` based on spent `value`.
     *
     * Does not update the allowance value in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Does not emit an {Approval} event.
     */
    function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance < type(uint256).max) {
            if (currentAllowance < value) {
                revert ERC20InsufficientAllowance(spender, currentAllowance, value);
            }
            unchecked {
                _approve(owner, spender, currentAllowance - value, false);
            }
        }
    }
}

// src/contracts/common/MigratableEntity.sol

// Copyright (c) 2025 Symbiotic

/// @title MigratableEntity
/// @notice Base contract for controlled upgradeable entity migration lifecycle.
abstract contract MigratableEntity is Initializable, OwnableUpgradeable, ReentrancyGuardUpgradeable, IMigratableEntity {
    /// @inheritdoc IMigratableEntity
    address public immutable FACTORY;

    modifier notInitialized() {
        if (_getInitializedVersion() != 0) {
            revert AlreadyInitialized();
        }

        _;
    }

    constructor(address factory) {
        _disableInitializers();

        FACTORY = factory;
    }

    /// @inheritdoc IMigratableEntity
    function version() external view returns (uint64) {
        return _getInitializedVersion();
    }

    /// @inheritdoc IMigratableEntity
    function initialize(uint64 initialVersion, address owner_, bytes calldata data)
        external
        notInitialized
        reinitializer(initialVersion)
    {
        __ReentrancyGuard_init();

        if (owner_ != address(0)) {
            __Ownable_init(owner_);
        }

        _initialize(initialVersion, owner_, data);
    }

    /// @inheritdoc IMigratableEntity
    function migrate(uint64 newVersion, bytes calldata data) external nonReentrant {
        if (msg.sender != FACTORY) {
            revert NotFactory();
        }

        _migrateInternal(_getInitializedVersion(), newVersion, data);
    }

    function _migrateInternal(uint64 oldVersion, uint64 newVersion, bytes calldata data)
        private
        reinitializer(newVersion)
    {
        _migrate(oldVersion, newVersion, data);
    }

    function _initialize(
        uint64,
        /* initialVersion */
        address,
        /* owner */
        bytes memory /* data */
    )
        internal
        virtual {}

    function _migrate(
        uint64,
        /* oldVersion */
        uint64,
        /* newVersion */
        bytes calldata /* data */
    )
        internal
        virtual {}

    uint256[10] private __gap;
}

// lib/openzeppelin-contracts/contracts/utils/Arrays.sol

// OpenZeppelin Contracts (last updated v5.4.0) (utils/Arrays.sol)
// This file was procedurally generated from scripts/generate/templates/Arrays.js.

/**
 * @dev Collection of functions related to array types.
 */
library Arrays {
    using SlotDerivation for bytes32;
    using StorageSlot for bytes32;

    /**
     * @dev Sort an array of uint256 (in memory) following the provided comparator function.
     *
     * This function does the sorting "in place", meaning that it overrides the input. The object is returned for
     * convenience, but that returned value can be discarded safely if the caller has a memory pointer to the array.
     *
     * NOTE: this function's cost is `O(n · log(n))` in average and `O(n²)` in the worst case, with n the length of the
     * array. Using it in view functions that are executed through `eth_call` is safe, but one should be very careful
     * when executing this as part of a transaction. If the array being sorted is too large, the sort operation may
     * consume more gas than is available in a block, leading to potential DoS.
     *
     * IMPORTANT: Consider memory side-effects when using custom comparator functions that access memory in an unsafe way.
     */
    function sort(uint256[] memory array, function(uint256, uint256) pure returns (bool) comp)
        internal
        pure
        returns (uint256[] memory)
    {
        _quickSort(_begin(array), _end(array), comp);
        return array;
    }

    /**
     * @dev Variant of {sort} that sorts an array of uint256 in increasing order.
     */
    function sort(uint256[] memory array) internal pure returns (uint256[] memory) {
        sort(array, Comparators.lt);
        return array;
    }

    /**
     * @dev Sort an array of address (in memory) following the provided comparator function.
     *
     * This function does the sorting "in place", meaning that it overrides the input. The object is returned for
     * convenience, but that returned value can be discarded safely if the caller has a memory pointer to the array.
     *
     * NOTE: this function's cost is `O(n · log(n))` in average and `O(n²)` in the worst case, with n the length of the
     * array. Using it in view functions that are executed through `eth_call` is safe, but one should be very careful
     * when executing this as part of a transaction. If the array being sorted is too large, the sort operation may
     * consume more gas than is available in a block, leading to potential DoS.
     *
     * IMPORTANT: Consider memory side-effects when using custom comparator functions that access memory in an unsafe way.
     */
    function sort(address[] memory array, function(address, address) pure returns (bool) comp)
        internal
        pure
        returns (address[] memory)
    {
        sort(_castToUint256Array(array), _castToUint256Comp(comp));
        return array;
    }

    /**
     * @dev Variant of {sort} that sorts an array of address in increasing order.
     */
    function sort(address[] memory array) internal pure returns (address[] memory) {
        sort(_castToUint256Array(array), Comparators.lt);
        return array;
    }

    /**
     * @dev Sort an array of bytes32 (in memory) following the provided comparator function.
     *
     * This function does the sorting "in place", meaning that it overrides the input. The object is returned for
     * convenience, but that returned value can be discarded safely if the caller has a memory pointer to the array.
     *
     * NOTE: this function's cost is `O(n · log(n))` in average and `O(n²)` in the worst case, with n the length of the
     * array. Using it in view functions that are executed through `eth_call` is safe, but one should be very careful
     * when executing this as part of a transaction. If the array being sorted is too large, the sort operation may
     * consume more gas than is available in a block, leading to potential DoS.
     *
     * IMPORTANT: Consider memory side-effects when using custom comparator functions that access memory in an unsafe way.
     */
    function sort(bytes32[] memory array, function(bytes32, bytes32) pure returns (bool) comp)
        internal
        pure
        returns (bytes32[] memory)
    {
        sort(_castToUint256Array(array), _castToUint256Comp(comp));
        return array;
    }

    /**
     * @dev Variant of {sort} that sorts an array of bytes32 in increasing order.
     */
    function sort(bytes32[] memory array) internal pure returns (bytes32[] memory) {
        sort(_castToUint256Array(array), Comparators.lt);
        return array;
    }

    /**
     * @dev Performs a quick sort of a segment of memory. The segment sorted starts at `begin` (inclusive), and stops
     * at end (exclusive). Sorting follows the `comp` comparator.
     *
     * Invariant: `begin <= end`. This is the case when initially called by {sort} and is preserved in subcalls.
     *
     * IMPORTANT: Memory locations between `begin` and `end` are not validated/zeroed. This function should
     * be used only if the limits are within a memory array.
     */
    function _quickSort(uint256 begin, uint256 end, function(uint256, uint256) pure returns (bool) comp) private pure {
        unchecked {
            if (end - begin < 0x40) return;

            // Use first element as pivot
            uint256 pivot = _mload(begin);
            // Position where the pivot should be at the end of the loop
            uint256 pos = begin;

            for (uint256 it = begin + 0x20; it < end; it += 0x20) {
                if (comp(_mload(it), pivot)) {
                    // If the value stored at the iterator's position comes before the pivot, we increment the
                    // position of the pivot and move the value there.
                    pos += 0x20;
                    _swap(pos, it);
                }
            }

            _swap(begin, pos); // Swap pivot into place
            _quickSort(begin, pos, comp); // Sort the left side of the pivot
            _quickSort(pos + 0x20, end, comp); // Sort the right side of the pivot
        }
    }

    /**
     * @dev Pointer to the memory location of the first element of `array`.
     */
    function _begin(uint256[] memory array) private pure returns (uint256 ptr) {
        assembly ("memory-safe") {
            ptr := add(array, 0x20)
        }
    }

    /**
     * @dev Pointer to the memory location of the first memory word (32bytes) after `array`. This is the memory word
     * that comes just after the last element of the array.
     */
    function _end(uint256[] memory array) private pure returns (uint256 ptr) {
        unchecked {
            return _begin(array) + array.length * 0x20;
        }
    }

    /**
     * @dev Load memory word (as a uint256) at location `ptr`.
     */
    function _mload(uint256 ptr) private pure returns (uint256 value) {
        assembly {
            value := mload(ptr)
        }
    }

    /**
     * @dev Swaps the elements memory location `ptr1` and `ptr2`.
     */
    function _swap(uint256 ptr1, uint256 ptr2) private pure {
        assembly {
            let value1 := mload(ptr1)
            let value2 := mload(ptr2)
            mstore(ptr1, value2)
            mstore(ptr2, value1)
        }
    }

    /// @dev Helper: low level cast address memory array to uint256 memory array
    function _castToUint256Array(address[] memory input) private pure returns (uint256[] memory output) {
        assembly {
            output := input
        }
    }

    /// @dev Helper: low level cast bytes32 memory array to uint256 memory array
    function _castToUint256Array(bytes32[] memory input) private pure returns (uint256[] memory output) {
        assembly {
            output := input
        }
    }

    /// @dev Helper: low level cast address comp function to uint256 comp function
    function _castToUint256Comp(function(address, address) pure returns (bool) input)
        private
        pure
        returns (function(uint256, uint256) pure returns (bool) output)
    {
        assembly {
            output := input
        }
    }

    /// @dev Helper: low level cast bytes32 comp function to uint256 comp function
    function _castToUint256Comp(function(bytes32, bytes32) pure returns (bool) input)
        private
        pure
        returns (function(uint256, uint256) pure returns (bool) output)
    {
        assembly {
            output := input
        }
    }

    /**
     * @dev Searches a sorted `array` and returns the first index that contains
     * a value greater or equal to `element`. If no such index exists (i.e. all
     * values in the array are strictly less than `element`), the array length is
     * returned. Time complexity O(log n).
     *
     * NOTE: The `array` is expected to be sorted in ascending order, and to
     * contain no repeated elements.
     *
     * IMPORTANT: Deprecated. This implementation behaves as {lowerBound} but lacks
     * support for repeated elements in the array. The {lowerBound} function should
     * be used instead.
     */
    function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
        uint256 low = 0;
        uint256 high = array.length;

        if (high == 0) {
            return 0;
        }

        while (low < high) {
            uint256 mid = Math.average(low, high);

            // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
            // because Math.average rounds towards zero (it does integer division with truncation).
            if (unsafeAccess(array, mid).value > element) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }

        // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
        if (low > 0 && unsafeAccess(array, low - 1).value == element) {
            return low - 1;
        } else {
            return low;
        }
    }

    /**
     * @dev Searches an `array` sorted in ascending order and returns the first
     * index that contains a value greater or equal than `element`. If no such index
     * exists (i.e. all values in the array are strictly less than `element`), the array
     * length is returned. Time complexity O(log n).
     *
     * See C++'s https://en.cppreference.com/w/cpp/algorithm/lower_bound[lower_bound].
     */
    function lowerBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
        uint256 low = 0;
        uint256 high = array.length;

        if (high == 0) {
            return 0;
        }

        while (low < high) {
            uint256 mid = Math.average(low, high);

            // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
            // because Math.average rounds towards zero (it does integer division with truncation).
            if (unsafeAccess(array, mid).value < element) {
                // this cannot overflow because mid < high
                unchecked {
                    low = mid + 1;
                }
            } else {
                high = mid;
            }
        }

        return low;
    }

    /**
     * @dev Searches an `array` sorted in ascending order and returns the first
     * index that contains a value strictly greater than `element`. If no such index
     * exists (i.e. all values in the array are strictly less than `element`), the array
     * length is returned. Time complexity O(log n).
     *
     * See C++'s https://en.cppreference.com/w/cpp/algorithm/upper_bound[upper_bound].
     */
    function upperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
        uint256 low = 0;
        uint256 high = array.length;

        if (high == 0) {
            return 0;
        }

        while (low < high) {
            uint256 mid = Math.average(low, high);

            // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
            // because Math.average rounds towards zero (it does integer division with truncation).
            if (unsafeAccess(array, mid).value > element) {
                high = mid;
            } else {
                // this cannot overflow because mid < high
                unchecked {
                    low = mid + 1;
                }
            }
        }

        return low;
    }

    /**
     * @dev Same as {lowerBound}, but with an array in memory.
     */
    function lowerBoundMemory(uint256[] memory array, uint256 element) internal pure returns (uint256) {
        uint256 low = 0;
        uint256 high = array.length;

        if (high == 0) {
            return 0;
        }

        while (low < high) {
            uint256 mid = Math.average(low, high);

            // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
            // because Math.average rounds towards zero (it does integer division with truncation).
            if (unsafeMemoryAccess(array, mid) < element) {
                // this cannot overflow because mid < high
                unchecked {
                    low = mid + 1;
                }
            } else {
                high = mid;
            }
        }

        return low;
    }

    /**
     * @dev Same as {upperBound}, but with an array in memory.
     */
    function upperBoundMemory(uint256[] memory array, uint256 element) internal pure returns (uint256) {
        uint256 low = 0;
        uint256 high = array.length;

        if (high == 0) {
            return 0;
        }

        while (low < high) {
            uint256 mid = Math.average(low, high);

            // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
            // because Math.average rounds towards zero (it does integer division with truncation).
            if (unsafeMemoryAccess(array, mid) > element) {
                high = mid;
            } else {
                // this cannot overflow because mid < high
                unchecked {
                    low = mid + 1;
                }
            }
        }

        return low;
    }

    /**
     * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
     *
     * WARNING: Only use if you are certain `pos` is lower than the array length.
     */
    function unsafeAccess(address[] storage arr, uint256 pos) internal pure returns (StorageSlot.AddressSlot storage) {
        bytes32 slot;
        assembly ("memory-safe") {
            slot := arr.slot
        }
        return slot.deriveArray().offset(pos).getAddressSlot();
    }

    /**
     * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
     *
     * WARNING: Only use if you are certain `pos` is lower than the array length.
     */
    function unsafeAccess(bytes32[] storage arr, uint256 pos) internal pure returns (StorageSlot.Bytes32Slot storage) {
        bytes32 slot;
        assembly ("memory-safe") {
            slot := arr.slot
        }
        return slot.deriveArray().offset(pos).getBytes32Slot();
    }

    /**
     * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
     *
     * WARNING: Only use if you are certain `pos` is lower than the array length.
     */
    function unsafeAccess(uint256[] storage arr, uint256 pos) internal pure returns (StorageSlot.Uint256Slot storage) {
        bytes32 slot;
        assembly ("memory-safe") {
            slot := arr.slot
        }
        return slot.deriveArray().offset(pos).getUint256Slot();
    }

    /**
     * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
     *
     * WARNING: Only use if you are certain `pos` is lower than the array length.
     */
    function unsafeAccess(bytes[] storage arr, uint256 pos) internal pure returns (StorageSlot.BytesSlot storage) {
        bytes32 slot;
        assembly ("memory-safe") {
            slot := arr.slot
        }
        return slot.deriveArray().offset(pos).getBytesSlot();
    }

    /**
     * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
     *
     * WARNING: Only use if you are certain `pos` is lower than the array length.
     */
    function unsafeAccess(string[] storage arr, uint256 pos) internal pure returns (StorageSlot.StringSlot storage) {
        bytes32 slot;
        assembly ("memory-safe") {
            slot := arr.slot
        }
        return slot.deriveArray().offset(pos).getStringSlot();
    }

    /**
     * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
     *
     * WARNING: Only use if you are certain `pos` is lower than the array length.
     */
    function unsafeMemoryAccess(address[] memory arr, uint256 pos) internal pure returns (address res) {
        assembly {
            res := mload(add(add(arr, 0x20), mul(pos, 0x20)))
        }
    }

    /**
     * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
     *
     * WARNING: Only use if you are certain `pos` is lower than the array length.
     */
    function unsafeMemoryAccess(bytes32[] memory arr, uint256 pos) internal pure returns (bytes32 res) {
        assembly {
            res := mload(add(add(arr, 0x20), mul(pos, 0x20)))
        }
    }

    /**
     * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
     *
     * WARNING: Only use if you are certain `pos` is lower than the array length.
     */
    function unsafeMemoryAccess(uint256[] memory arr, uint256 pos) internal pure returns (uint256 res) {
        assembly {
            res := mload(add(add(arr, 0x20), mul(pos, 0x20)))
        }
    }

    /**
     * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
     *
     * WARNING: Only use if you are certain `pos` is lower than the array length.
     */
    function unsafeMemoryAccess(bytes[] memory arr, uint256 pos) internal pure returns (bytes memory res) {
        assembly {
            res := mload(add(add(arr, 0x20), mul(pos, 0x20)))
        }
    }

    /**
     * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
     *
     * WARNING: Only use if you are certain `pos` is lower than the array length.
     */
    function unsafeMemoryAccess(string[] memory arr, uint256 pos) internal pure returns (string memory res) {
        assembly {
            res := mload(add(add(arr, 0x20), mul(pos, 0x20)))
        }
    }

    /**
     * @dev Helper to set the length of a dynamic array. Directly writing to `.length` is forbidden.
     *
     * WARNING: this does not clear elements if length is reduced, of initialize elements if length is increased.
     */
    function unsafeSetLength(address[] storage array, uint256 len) internal {
        assembly ("memory-safe") {
            sstore(array.slot, len)
        }
    }

    /**
     * @dev Helper to set the length of a dynamic array. Directly writing to `.length` is forbidden.
     *
     * WARNING: this does not clear elements if length is reduced, of initialize elements if length is increased.
     */
    function unsafeSetLength(bytes32[] storage array, uint256 len) internal {
        assembly ("memory-safe") {
            sstore(array.slot, len)
        }
    }

    /**
     * @dev Helper to set the length of a dynamic array. Directly writing to `.length` is forbidden.
     *
     * WARNING: this does not clear elements if length is reduced, of initialize elements if length is increased.
     */
    function unsafeSetLength(uint256[] storage array, uint256 len) internal {
        assembly ("memory-safe") {
            sstore(array.slot, len)
        }
    }

    /**
     * @dev Helper to set the length of a dynamic array. Directly writing to `.length` is forbidden.
     *
     * WARNING: this does not clear elements if length is reduced, of initialize elements if length is increased.
     */
    function unsafeSetLength(bytes[] storage array, uint256 len) internal {
        assembly ("memory-safe") {
            sstore(array.slot, len)
        }
    }

    /**
     * @dev Helper to set the length of a dynamic array. Directly writing to `.length` is forbidden.
     *
     * WARNING: this does not clear elements if length is reduced, of initialize elements if length is increased.
     */
    function unsafeSetLength(string[] storage array, uint256 len) internal {
        assembly ("memory-safe") {
            sstore(array.slot, len)
        }
    }
}

// lib/openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol

// OpenZeppelin Contracts (last updated v5.4.0) (utils/structs/EnumerableSet.sol)
// This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 * - Set can be cleared (all elements removed) in O(n).
 *
 * ```solidity
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * The following types are supported:
 *
 * - `bytes32` (`Bytes32Set`) since v3.3.0
 * - `address` (`AddressSet`) since v3.3.0
 * - `uint256` (`UintSet`) since v3.3.0
 * - `string` (`StringSet`) since v5.4.0
 * - `bytes` (`BytesSet`) since v5.4.0
 *
 * [WARNING]
 * ====
 * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
 * unusable.
 * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
 *
 * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
 * array of EnumerableSet.
 * ====
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;
        // Position is the index of the value in the `values` array plus 1.
        // Position 0 is used to mean a value is not in the set.
        mapping(bytes32 value => uint256) _positions;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._positions[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We cache the value's position to prevent multiple reads from the same storage slot
        uint256 position = set._positions[value];

        if (position != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 valueIndex = position - 1;
            uint256 lastIndex = set._values.length - 1;

            if (valueIndex != lastIndex) {
                bytes32 lastValue = set._values[lastIndex];

                // Move the lastValue to the index where the value to delete is
                set._values[valueIndex] = lastValue;
                // Update the tracked position of the lastValue (that was just moved)
                set._positions[lastValue] = position;
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the tracked position for the deleted slot
            delete set._positions[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes all the values from a set. O(n).
     *
     * WARNING: This function has an unbounded cost that scales with set size. Developers should keep in mind that
     * using it may render the function uncallable if the set grows to the point where clearing it consumes too much
     * gas to fit in a block.
     */
    function _clear(Set storage set) private {
        uint256 len = _length(set);
        for (uint256 i = 0; i < len; ++i) {
            delete set._positions[set._values[i]];
        }
        Arrays.unsafeSetLength(set._values, 0);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._positions[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    /**
     * @dev Return a slice of the set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function _values(Set storage set, uint256 start, uint256 end) private view returns (bytes32[] memory) {
        unchecked {
            end = Math.min(end, _length(set));
            start = Math.min(start, end);

            uint256 len = end - start;
            bytes32[] memory result = new bytes32[](len);
            for (uint256 i = 0; i < len; ++i) {
                result[i] = Arrays.unsafeAccess(set._values, start + i).value;
            }
            return result;
        }
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Removes all the values from a set. O(n).
     *
     * WARNING: Developers should keep in mind that this function has an unbounded cost and using it may render the
     * function uncallable if the set grows to the point where clearing it consumes too much gas to fit in a block.
     */
    function clear(Bytes32Set storage set) internal {
        _clear(set._inner);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
        bytes32[] memory store = _values(set._inner);
        bytes32[] memory result;

        assembly ("memory-safe") {
            result := store
        }

        return result;
    }

    /**
     * @dev Return a slice of the set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(Bytes32Set storage set, uint256 start, uint256 end) internal view returns (bytes32[] memory) {
        bytes32[] memory store = _values(set._inner, start, end);
        bytes32[] memory result;

        assembly ("memory-safe") {
            result := store
        }

        return result;
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes all the values from a set. O(n).
     *
     * WARNING: Developers should keep in mind that this function has an unbounded cost and using it may render the
     * function uncallable if the set grows to the point where clearing it consumes too much gas to fit in a block.
     */
    function clear(AddressSet storage set) internal {
        _clear(set._inner);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(AddressSet storage set) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        assembly ("memory-safe") {
            result := store
        }

        return result;
    }

    /**
     * @dev Return a slice of the set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(AddressSet storage set, uint256 start, uint256 end) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner, start, end);
        address[] memory result;

        assembly ("memory-safe") {
            result := store
        }

        return result;
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Removes all the values from a set. O(n).
     *
     * WARNING: Developers should keep in mind that this function has an unbounded cost and using it may render the
     * function uncallable if the set grows to the point where clearing it consumes too much gas to fit in a block.
     */
    function clear(UintSet storage set) internal {
        _clear(set._inner);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(UintSet storage set) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        assembly ("memory-safe") {
            result := store
        }

        return result;
    }

    /**
     * @dev Return a slice of the set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(UintSet storage set, uint256 start, uint256 end) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner, start, end);
        uint256[] memory result;

        assembly ("memory-safe") {
            result := store
        }

        return result;
    }

    struct StringSet {
        // Storage of set values
        string[] _values;
        // Position is the index of the value in the `values` array plus 1.
        // Position 0 is used to mean a value is not in the set.
        mapping(string value => uint256) _positions;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(StringSet storage set, string memory value) internal returns (bool) {
        if (!contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._positions[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(StringSet storage set, string memory value) internal returns (bool) {
        // We cache the value's position to prevent multiple reads from the same storage slot
        uint256 position = set._positions[value];

        if (position != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 valueIndex = position - 1;
            uint256 lastIndex = set._values.length - 1;

            if (valueIndex != lastIndex) {
                string memory lastValue = set._values[lastIndex];

                // Move the lastValue to the index where the value to delete is
                set._values[valueIndex] = lastValue;
                // Update the tracked position of the lastValue (that was just moved)
                set._positions[lastValue] = position;
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the tracked position for the deleted slot
            delete set._positions[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes all the values from a set. O(n).
     *
     * WARNING: Developers should keep in mind that this function has an unbounded cost and using it may render the
     * function uncallable if the set grows to the point where clearing it consumes too much gas to fit in a block.
     */
    function clear(StringSet storage set) internal {
        uint256 len = length(set);
        for (uint256 i = 0; i < len; ++i) {
            delete set._positions[set._values[i]];
        }
        Arrays.unsafeSetLength(set._values, 0);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(StringSet storage set, string memory value) internal view returns (bool) {
        return set._positions[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(StringSet storage set) internal view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(StringSet storage set, uint256 index) internal view returns (string memory) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(StringSet storage set) internal view returns (string[] memory) {
        return set._values;
    }

    /**
     * @dev Return a slice of the set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(StringSet storage set, uint256 start, uint256 end) internal view returns (string[] memory) {
        unchecked {
            end = Math.min(end, length(set));
            start = Math.min(start, end);

            uint256 len = end - start;
            string[] memory result = new string[](len);
            for (uint256 i = 0; i < len; ++i) {
                result[i] = Arrays.unsafeAccess(set._values, start + i).value;
            }
            return result;
        }
    }

    struct BytesSet {
        // Storage of set values
        bytes[] _values;
        // Position is the index of the value in the `values` array plus 1.
        // Position 0 is used to mean a value is not in the set.
        mapping(bytes value => uint256) _positions;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(BytesSet storage set, bytes memory value) internal returns (bool) {
        if (!contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._positions[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(BytesSet storage set, bytes memory value) internal returns (bool) {
        // We cache the value's position to prevent multiple reads from the same storage slot
        uint256 position = set._positions[value];

        if (position != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 valueIndex = position - 1;
            uint256 lastIndex = set._values.length - 1;

            if (valueIndex != lastIndex) {
                bytes memory lastValue = set._values[lastIndex];

                // Move the lastValue to the index where the value to delete is
                set._values[valueIndex] = lastValue;
                // Update the tracked position of the lastValue (that was just moved)
                set._positions[lastValue] = position;
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the tracked position for the deleted slot
            delete set._positions[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes all the values from a set. O(n).
     *
     * WARNING: Developers should keep in mind that this function has an unbounded cost and using it may render the
     * function uncallable if the set grows to the point where clearing it consumes too much gas to fit in a block.
     */
    function clear(BytesSet storage set) internal {
        uint256 len = length(set);
        for (uint256 i = 0; i < len; ++i) {
            delete set._positions[set._values[i]];
        }
        Arrays.unsafeSetLength(set._values, 0);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(BytesSet storage set, bytes memory value) internal view returns (bool) {
        return set._positions[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(BytesSet storage set) internal view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(BytesSet storage set, uint256 index) internal view returns (bytes memory) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(BytesSet storage set) internal view returns (bytes[] memory) {
        return set._values;
    }

    /**
     * @dev Return a slice of the set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(BytesSet storage set, uint256 start, uint256 end) internal view returns (bytes[] memory) {
        unchecked {
            end = Math.min(end, length(set));
            start = Math.min(start, end);

            uint256 len = end - start;
            bytes[] memory result = new bytes[](len);
            for (uint256 i = 0; i < len; ++i) {
                result[i] = Arrays.unsafeAccess(set._values, start + i).value;
            }
            return result;
        }
    }
}

// src/contracts/common/Registry.sol

// Copyright (c) 2025 Symbiotic

/// @title Registry
/// @notice Base contract for generic entity set management.
abstract contract Registry is IRegistry {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private _entities;

    modifier checkEntity(address account) {
        _checkEntity(account);
        _;
    }

    /// @inheritdoc IRegistry
    function isEntity(address entity_) public view returns (bool) {
        return _entities.contains(entity_);
    }

    /// @inheritdoc IRegistry
    function totalEntities() public view returns (uint256) {
        return _entities.length();
    }

    /// @inheritdoc IRegistry
    function entity(uint256 index) public view returns (address) {
        return _entities.at(index);
    }

    function _addEntity(address entity_) internal {
        _entities.add(entity_);

        emit AddEntity(entity_);
    }

    function _checkEntity(address account) internal view {
        if (!isEntity(account)) {
            revert EntityNotExist();
        }
    }
}

// src/contracts/vault/VaultV2Storage.sol

// Copyright (c) 2026 Symbiotic

/// @title VaultV2Storage
/// @notice Base contract for VaultV2 storage layout and checkpoint getters.
abstract contract VaultV2Storage is StaticDelegateCallable, IVaultV2Storage {
    using Checkpoints_1 for Checkpoints_1.Trace256;
    using Checkpoints_1 for Checkpoints_1.Trace208;
    using Checkpoints_2 for Checkpoints_2.Trace256;
    using Checkpoints_2 for Checkpoints_2.Trace208;

    /* IMMUTABLES */

    /// @dev Address of the delegator factory.
    address internal immutable DELEGATOR_FACTORY;
    /// @dev Address of the slasher factory.
    address internal immutable SLASHER_FACTORY;
    /// @dev Address of the fee registry.
    address internal immutable FEE_REGISTRY;
    /// @dev Address of the rewards contract.
    address internal immutable REWARDS;
    /// @dev Address of the plugin registry.
    address internal immutable PLUGIN_REGISTRY;

    /* STATE VARIABLES */

    /// @inheritdoc IVaultV2Storage
    bool public depositWhitelist;
    /// @inheritdoc IVaultV2Storage
    bool public isDepositLimit;
    /// @inheritdoc IVaultV2Storage
    address public collateral;
    /// @inheritdoc IVaultV2Storage
    address public burner;
    /// @dev DEPRECATED: This variable is kept for storage layout compatibility with previous versions.
    uint48 internal __epochDurationInit;
    /// @inheritdoc IVaultV2Storage
    uint48 public epochDuration;
    /// @inheritdoc IVaultV2Storage
    address public delegator;
    /// @dev Flag indicating whether the delegator is initialized.
    bool internal _isDelegatorInitialized;
    /// @inheritdoc IVaultV2Storage
    address public slasher;
    /// @dev Flag indicating whether the slasher is initialized.
    bool internal _isSlasherInitialized;
    /// @inheritdoc IVaultV2Storage
    uint256 public depositLimit;
    /// @inheritdoc IVaultV2Storage
    mapping(address account => bool value) public isDepositorWhitelisted;

    /// @dev DEPRECATED: This variable is kept for storage layout compatibility with previous versions.
    mapping(uint256 epoch => uint256 amount) internal __withdrawals;
    /// @dev DEPRECATED: This variable is kept for storage layout compatibility with previous versions.
    mapping(uint256 epoch => uint256 amount) internal __withdrawalShares;
    /// @dev Withdrawal shares per withdrawal index and account.
    mapping(uint256 index => mapping(address account => uint256 amount)) internal _withdrawalSharesOf;
    /// @inheritdoc IVaultV2Storage
    mapping(uint256 index => mapping(address account => bool value)) public isWithdrawalsClaimed;

    /// @dev Checkpointed total active shares.
    Checkpoints_1.Trace256 internal _activeShares;
    /// @dev Checkpointed total active stake.
    Checkpoints_1.Trace256 internal _activeStake;
    /// @dev Checkpointed active shares per account.
    mapping(address account => Checkpoints_1.Trace256 shares) internal _activeSharesOf;

    /// @dev Timestamp when migration to the current storage model occurred.
    uint48 public migrateTimestamp;
    /// @dev Epoch index at migration.
    uint48 internal __migrateEpoch;
    /// @dev Timestamp of the next epoch boundary at migration.
    uint48 internal __migrateNextEpochTimestamp;

    /// @dev Number of withdrawal requests per account.
    mapping(address account => uint256 value) internal _withdrawalsOfLength;
    /// @dev Withdrawal unlock timestamp per withdrawal index and account.
    mapping(uint256 index => mapping(address account => uint48 timestamp)) internal _withdrawalUnlockAt;
    /// @dev Checkpointed withdrawal shares per bucket.
    mapping(uint256 bucketIndex => Checkpoints_2.Trace256 shares) internal _withdrawalShares;
    /// @dev Checkpointed withdrawal amounts per bucket.
    mapping(uint256 bucketIndex => Checkpoints_2.Trace256 withdrawals) internal _withdrawals;
    /// @dev Checkpointed mapping from unlock time to withdrawal bucket index.
    Checkpoints_2.Trace208 internal _unlockToBucket;
    /// @dev Cumulative withdrawal share checkpoints.
    Checkpoints_2.Trace256 internal _withdrawalSharesCumulative;
    /// @dev Signed accumulator for claimable-vs-unclaimable withdrawal accounting.
    int256 internal _unclaimedRaw;

    /// @inheritdoc IVaultV2Storage
    address[] public plugins;
    /// @inheritdoc IVaultV2Storage
    mapping(address plugin => uint208 amount) public pluginLimit;
    /// @inheritdoc IVaultV2Storage
    uint256 public pluginsAllocated;
    /// @inheritdoc IVaultV2Storage
    mapping(address plugin => uint256 amount) public pluginAllocated;

    /* CONSTRUCTOR */

    constructor(
        address delegatorFactory,
        address slasherFactory,
        address feeRegistry,
        address rewards,
        address pluginRegistry
    ) {
        DELEGATOR_FACTORY = delegatorFactory;
        SLASHER_FACTORY = slasherFactory;
        FEE_REGISTRY = feeRegistry;
        REWARDS = rewards;
        PLUGIN_REGISTRY = pluginRegistry;
    }

    /* VIEW FUNCTIONS */

    /// @inheritdoc IVaultV2Storage
    function activeSharesAt(uint48 timestamp, bytes calldata hint) public view returns (uint256) {
        return _activeShares.upperLookupRecent(timestamp, hint);
    }

    /// @inheritdoc IVaultV2Storage
    function activeShares() public view returns (uint256) {
        return _activeShares.latest();
    }

    /// @inheritdoc IVaultV2Storage
    function activeStakeAt(uint48 timestamp, bytes calldata hint) public view returns (uint256) {
        return _activeStake.upperLookupRecent(timestamp, hint);
    }

    /// @inheritdoc IVaultV2Storage
    function activeStake() public view returns (uint256) {
        return _activeStake.latest();
    }

    /// @inheritdoc IVaultV2Storage
    function activeSharesOfAt(address account, uint48 timestamp, bytes calldata hint) public view returns (uint256) {
        return _activeSharesOf[account].upperLookupRecent(timestamp, hint);
    }

    /// @inheritdoc IVaultV2Storage
    function activeSharesOf(address account) public view returns (uint256) {
        return _activeSharesOf[account].latest();
    }

    /// @inheritdoc IVaultV2Storage
    function withdrawalBucket() public view returns (uint208) {
        return _unlockToBucket.latest();
    }

    /// @inheritdoc IVaultV2Storage
    function withdrawalShares(uint256 index) public view returns (uint256) {
        return _withdrawalShares[index].latest();
    }

    /// @inheritdoc IVaultV2Storage
    function withdrawals(uint256 index) public view returns (uint256) {
        return _withdrawals[index].latest();
    }

    /// @inheritdoc IVaultV2Storage
    function pluginsLength() public view returns (uint256) {
        return plugins.length;
    }

    /* STORAGE GAP */

    /// @dev Reserved storage gap for future upgrades.
    uint256[37] internal __gap;
}

// src/contracts/common/Factory.sol

// Copyright (c) 2025 Symbiotic

/// @title Factory
/// @notice Factory contract for generic implementation whitelisting and deployment.
contract Factory is Registry, Ownable, IFactory {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Clones for address;

    /// @inheritdoc IFactory
    mapping(uint64 type_ => bool value) public blacklisted;

    EnumerableSet.AddressSet private _whitelistedImplementations;

    modifier checkType(uint64 type_) {
        if (type_ >= totalTypes()) {
            revert InvalidType();
        }
        _;
    }

    constructor(address owner_) Ownable(owner_) {}

    /// @inheritdoc IFactory
    function totalTypes() public view returns (uint64) {
        return uint64(_whitelistedImplementations.length());
    }

    /// @inheritdoc IFactory
    function implementation(uint64 type_) public view returns (address) {
        return _whitelistedImplementations.at(type_);
    }

    /// @inheritdoc IFactory
    function whitelist(address implementation_) external onlyOwner {
        if (IEntity(implementation_).FACTORY() != address(this) || IEntity(implementation_).TYPE() != totalTypes()) {
            revert InvalidImplementation();
        }
        if (!_whitelistedImplementations.add(implementation_)) {
            revert AlreadyWhitelisted();
        }

        emit Whitelist(implementation_);
    }

    /// @inheritdoc IFactory
    function blacklist(uint64 type_) external onlyOwner checkType(type_) {
        if (blacklisted[type_]) {
            revert AlreadyBlacklisted();
        }

        blacklisted[type_] = true;

        emit Blacklist(type_);
    }

    /// @inheritdoc IFactory
    function create(uint64 type_, bytes calldata data) external returns (address entity_) {
        entity_ = implementation(type_).cloneDeterministic(keccak256(abi.encode(totalEntities(), type_, data)));

        _addEntity(entity_);

        IEntity(entity_).initialize(data);
    }
}

// src/contracts/DelegatorFactory.sol

// Copyright (c) 2025 Symbiotic

/// @title DelegatorFactory
/// @notice Factory contract for delegator implementation deployments.
contract DelegatorFactory is Factory, IDelegatorFactory {
    constructor(address owner_) Factory(owner_) {}
}

// src/contracts/SlasherFactory.sol

// Copyright (c) 2025 Symbiotic

/// @title SlasherFactory
/// @notice Factory contract for slasher implementation deployments.
contract SlasherFactory is Factory, ISlasherFactory {
    constructor(address owner_) Factory(owner_) {}
}

// src/contracts/slasher/UniversalSlasher.sol

// Copyright (c) 2026 Symbiotic

/// @title UniversalSlasher
/// @notice Contract for slash request lifecycle, resolver updates, and owed slash synchronization.
contract UniversalSlasher is Entity, StaticDelegateCallable, ReentrancyGuardUpgradeable, IUniversalSlasher {
    using FixedPointMathLib for uint256;
    using Subnetwork for bytes32;
    using Subnetwork for address;
    using Checkpoints_2 for Checkpoints_2.Trace208;
    using Checkpoints_2 for Checkpoints_2.Trace256;

    /* IMMUTABLES */

    /// @dev Address of the vault factory.
    address internal immutable VAULT_FACTORY;
    /// @dev Address of the network middleware service.
    address internal immutable NETWORK_MIDDLEWARE_SERVICE;
    /// @dev Address of the network registry.
    address internal immutable NETWORK_REGISTRY;

    /* STATE VARIABLES */

    /// @inheritdoc IUniversalSlasher
    address public vault;
    /// @inheritdoc IUniversalSlasher
    bool public isBurnerHook;
    /// @inheritdoc IUniversalSlasher
    uint48 public vetoDuration;
    /// @inheritdoc IUniversalSlasher
    uint48 public resolverSetDelay;
    /// @inheritdoc IUniversalSlasher
    mapping(bytes32 subnetwork => bytes32 value) public pendingResolverData;

    /// @inheritdoc IUniversalSlasher
    uint256 public totalOwed;
    /// @inheritdoc IUniversalSlasher
    mapping(bytes32 subnetwork => mapping(address operator => uint256 amount)) public owed;

    /// @dev Slash request storage.
    SlashRequest[] internal _slashRequests;
    /// @dev Resolver mapping before pending resolver activation.
    mapping(bytes32 subnetwork => address value) internal _resolver;
    /// @dev Legacy latest slashed capture timestamps.
    mapping(bytes32 subnetwork => mapping(address operator => uint48 value)) internal __latestSlashedCaptureTimestamp;
    /// @dev Legacy cumulative slash checkpoints.
    mapping(bytes32 subnetwork => mapping(address operator => Checkpoints_2.Trace256 amount)) internal
        __cumulativeSlash;

    /// @dev Timestamp when migration from the previous slasher occurred.
    uint48 public migrateTimestamp;
    /// @dev Address of the previous slasher during migration.
    address public oldSlasher;

    /* CONSTRUCTOR */

    constructor(
        address vaultFactory,
        address networkMiddlewareService,
        address networkRegistry,
        address slasherFactory,
        uint64 entityType
    ) Entity(slasherFactory, entityType) {
        VAULT_FACTORY = vaultFactory;
        NETWORK_MIDDLEWARE_SERVICE = networkMiddlewareService;
        NETWORK_REGISTRY = networkRegistry;
    }

    /* VIEW FUNCTIONS */

    /// @inheritdoc IUniversalSlasher
    function slashRequestsLength() public view returns (uint256) {
        return _slashRequests.length;
    }

    /// @inheritdoc IUniversalSlasher
    function slashRequests(uint256 slashIndex) public view returns (SlashRequest memory request) {
        unchecked {
            request = _slashRequests[slashIndex];

            // Legacy support.
            if (request.amount == 0) {
                bool oldCompleted;
                (
                    request.subnetwork,
                    request.operator,
                    request.amount,
                    request.createdAt,
                    request.vetoDeadline,
                    oldCompleted
                ) = IVetoSlasher(oldSlasher).slashRequests(slashIndex);
                if (oldCompleted) {
                    request.completed = true;
                }
                request.resolver = IVetoSlasher(oldSlasher).resolverAt(request.subnetwork, request.createdAt, "");
                if (
                    request.resolver != address(0)
                        && IVetoSlasher(oldSlasher).resolverAt(request.subnetwork, uint48(block.timestamp) - 1, "")
                            == address(0)
                ) {
                    request.resolver = address(0);
                }
            }
        }
    }

    /// @inheritdoc IUniversalSlasher
    function resolver(bytes32 subnetwork) public view returns (address) {
        return uint48(uint256(pendingResolverData[subnetwork])) == 0
            || block.timestamp < uint48(uint256(pendingResolverData[subnetwork]))
            ? _resolver[subnetwork]
            : address(uint160(uint256(pendingResolverData[subnetwork]) >> 48));
    }

    /// @inheritdoc IUniversalSlasher
    function slashableStake(bytes32 subnetwork, address operator, uint48 captureTimestamp, bytes calldata)
        public
        view
        returns (uint256)
    {
        unchecked {
            if (captureTimestamp == 0 || captureTimestamp >= migrateTimestamp) {
                if (
                    captureTimestamp > 0
                        && (captureTimestamp <= block.timestamp.saturatingSub(VaultV2(vault).epochDuration())
                            || captureTimestamp > block.timestamp)
                ) {
                    return 0;
                }
                return UniversalDelegator(VaultV2(vault).delegator()).stakeFor(subnetwork, operator, 0);
            }

            // Legacy support.
            if (
                captureTimestamp <= block.timestamp.saturatingSub(VaultV2(vault).epochDuration())
                    || captureTimestamp >= block.timestamp
                    || captureTimestamp < _latestSlashedCaptureTimestamp(subnetwork, operator)
            ) {
                return 0;
            }
            return UniversalDelegator(VaultV2(vault).delegator()).stakeAt(subnetwork, operator, captureTimestamp, "")
                .saturatingSub(
                    _cumulativeSlash(subnetwork, operator) - _cumulativeSlashAt(subnetwork, operator, captureTimestamp)
                );
        }
    }

    /* PUBLIC FUNCTIONS */

    /// @inheritdoc IUniversalSlasher
    function slash(bytes32 subnetwork, address operator, uint256 amount) external returns (uint256) {
        return executeSlash(requestSlash(subnetwork, operator, amount, 0, Calldata.emptyBytes()), Calldata.emptyBytes());
    }

    /// @inheritdoc IUniversalSlasher
    function requestSlash(bytes32 subnetwork, address operator, uint256 amount, uint48, bytes calldata)
        public
        nonReentrant
        returns (uint256 slashIndex)
    {
        unchecked {
            _checkNetworkMiddleware(subnetwork);

            amount = FixedPointMathLib.min(amount, slashableStake(subnetwork, operator, 0, Calldata.emptyBytes()));
            if (amount == 0) {
                revert InsufficientSlash();
            }

            address curResolver = resolver(subnetwork);
            uint48 vetoDeadline = uint48(block.timestamp) + (curResolver != address(0) ? vetoDuration : 0);

            slashIndex = _slashRequests.length;
            _slashRequests.push(
                SlashRequest({
                    subnetwork: subnetwork,
                    operator: operator,
                    amount: amount,
                    createdAt: uint48(block.timestamp),
                    resolver: curResolver,
                    vetoDeadline: vetoDeadline,
                    completed: false
                })
            );

            emit RequestSlash(slashIndex, subnetwork, operator, amount, vetoDeadline);
        }
    }

    /// @inheritdoc IUniversalSlasher
    function executeSlash(uint256 slashIndex, bytes calldata) public nonReentrant returns (uint256 slashedAmount) {
        unchecked {
            SlashRequest memory request = slashRequests(slashIndex);

            _checkNetworkMiddleware(request.subnetwork);

            if (request.completed) {
                revert SlashRequestCompleted();
            }

            if (request.vetoDeadline > block.timestamp) {
                revert VetoPeriodNotEnded();
            }

            slashedAmount = FixedPointMathLib.min(
                request.amount,
                slashableStake(request.subnetwork, request.operator, request.createdAt, Calldata.emptyBytes())
            );
            if (slashedAmount == 0) {
                revert InsufficientSlash();
            }

            _slashRequests[slashIndex].completed = true;

            if (request.createdAt >= migrateTimestamp) {
                slashedAmount = UniversalDelegator(VaultV2(vault).delegator())
                    .onSlash(request.subnetwork, request.operator, slashedAmount, abi.encode(slashIndex));
            } else {
                // Legacy support.
                __latestSlashedCaptureTimestamp[request.subnetwork][request.operator] = request.createdAt;
                uint256 newCumulativeSlash = _cumulativeSlash(request.subnetwork, request.operator) + slashedAmount;
                require(newCumulativeSlash >= slashedAmount);
                __cumulativeSlash[request.subnetwork][request.operator].push(
                    uint48(block.timestamp), newCumulativeSlash
                );
            }

            uint256 owedAmount;
            (slashedAmount, owedAmount) = VaultV2(vault)
                .onSlash(
                    slashedAmount,
                    request.createdAt >= migrateTimestamp
                        ? !UniversalDelegator(VaultV2(vault).delegator()).getIsNoPlugins(request.subnetwork)
                        : false
                );
            if (owedAmount > 0) {
                totalOwed += owedAmount;
                owed[request.subnetwork][request.operator] += owedAmount;
            }

            _burnerOnSlash(request.subnetwork, request.operator, slashedAmount - owedAmount);

            emit ExecuteSlash(slashIndex, slashedAmount);
        }
    }

    /// @inheritdoc IUniversalSlasher
    function vetoSlash(uint256 slashIndex) public nonReentrant {
        SlashRequest memory request = slashRequests(slashIndex);

        if (request.completed) {
            revert SlashRequestCompleted();
        }

        if (request.resolver != msg.sender) {
            revert NotResolver();
        }

        if (request.vetoDeadline <= block.timestamp) {
            revert VetoPeriodEnded();
        }

        _slashRequests[slashIndex].completed = true;

        emit VetoSlash(slashIndex, msg.sender);
    }

    /// @inheritdoc IUniversalSlasher
    function setResolver(uint96 identifier, address newResolver) public nonReentrant {
        unchecked {
            if (!IRegistry(NETWORK_REGISTRY).isEntity(msg.sender)) {
                revert NotNetwork();
            }

            bytes32 subnetwork = (msg.sender).subnetwork(identifier);
            address curResolver = resolver(subnetwork);
            if (curResolver == address(0)) {
                _resolver[subnetwork] = newResolver;
                pendingResolverData[subnetwork] = 0;
            } else {
                _resolver[subnetwork] = curResolver;
                pendingResolverData[subnetwork] =
                    bytes32(uint256(uint160(newResolver)) << 48 | (block.timestamp + resolverSetDelay));
            }

            emit SetResolver(subnetwork, newResolver);
        }
    }

    /* PUBLIC FUNCTIONS (PERMISSIONLESS) */

    /// @inheritdoc IUniversalSlasher
    function syncOwedSlash(bytes32 subnetwork, address operator) public returns (uint256 slashedAmount) {
        unchecked {
            uint256 curOwed = owed[subnetwork][operator];
            slashedAmount = VaultV2(vault).syncOwedSlash(curOwed);
            owed[subnetwork][operator] = curOwed - slashedAmount;
            totalOwed -= slashedAmount;
            _burnerOnSlash(subnetwork, operator, slashedAmount);

            emit SyncOwedSlash(subnetwork, operator, slashedAmount);
        }
    }

    /* INTERNAL FUNCTIONS */

    /// @dev Revert unless caller is the middleware configured for the request subnetwork.
    function _checkNetworkMiddleware(bytes32 subnetwork) internal view {
        if (INetworkMiddlewareService(NETWORK_MIDDLEWARE_SERVICE).middleware(subnetwork.network()) != msg.sender) {
            revert NotNetworkMiddleware();
        }
    }

    /// @dev Call the burner hook after a slash when burner hook mode is enabled.
    function _burnerOnSlash(bytes32 subnetwork, address operator, uint256 amount) internal {
        unchecked {
            if (isBurnerHook) {
                address burner = VaultV2(vault).burner();
                bytes memory burnerCalldata = abi.encodeCall(IBurner.onSlash, (subnetwork, operator, amount, 0));

                if (gasleft() < BURNER_RESERVE + BURNER_GAS_LIMIT * 64 / 63) {
                    revert InsufficientBurnerGas();
                }

                assembly ("memory-safe") {
                    pop(call(BURNER_GAS_LIMIT, burner, 0, add(burnerCalldata, 0x20), mload(burnerCalldata), 0, 0))
                }
            }
        }
    }

    /* INITIALIZATION */

    /// @dev Initialize slasher state from encoded initialization parameters.
    function _initialize(bytes calldata data) internal override {
        (address initVault, bytes memory initData) = abi.decode(data, (address, bytes));

        if (!IRegistry(VAULT_FACTORY).isEntity(initVault)) {
            revert NotVault();
        }

        if (IMigratableEntity(initVault).version() < VAULT_V2_VERSION) {
            revert OldVault();
        }

        InitParams memory params = abi.decode(initData, (InitParams));

        if (params.vetoDuration >= VaultV2(initVault).epochDuration()) {
            revert InvalidVetoDuration();
        }

        if (params.resolverSetDelay <= VaultV2(initVault).epochDuration() || params.resolverSetDelay > MAX_DURATION) {
            revert InvalidResolverSetEpochsDelay();
        }

        if (VaultV2(initVault).burner() == address(0) && params.isBurnerHook) {
            revert NoBurner();
        }

        __ReentrancyGuard_init();

        vault = initVault;

        isBurnerHook = params.isBurnerHook;
        vetoDuration = params.vetoDuration;
        resolverSetDelay = params.resolverSetDelay;

        emit Initialize(params);
    }

    /* MIGRATION */

    /// @dev Migrate slasher state from the previously configured slasher.
    function migrate(address oldSlasher_) public {
        if (vault != msg.sender) {
            revert NotVault();
        }
        uint64 oldSlasherType = IEntity(oldSlasher_).TYPE();
        if (oldSlasherType == TYPE) {
            revert NotMigrating();
        }
        migrateTimestamp = uint48(block.timestamp);
        oldSlasher = oldSlasher_;

        isBurnerHook = IVetoSlasher(oldSlasher_).isBurnerHook();
        if (oldSlasherType == VETO_SLASHER_TYPE) {
            uint256 oldSlashRequestsLength = IVetoSlasher(oldSlasher_).slashRequestsLength();
            assembly ("memory-safe") {
                sstore(_slashRequests.slot, oldSlashRequestsLength)
            }
            vetoDuration = IVetoSlasher(oldSlasher_).vetoDuration();
            resolverSetDelay = uint48(
                FixedPointMathLib.min(
                    IVetoSlasher(oldSlasher_).resolverSetEpochsDelay() * VaultV2(vault).epochDuration(), MAX_DURATION
                )
            );
        }
    }

    /* INTERNAL FUNCTIONS (LEGACY) */

    /// @dev Legacy support.
    function _latestSlashedCaptureTimestamp(bytes32 subnetwork, address operator) internal view returns (uint48) {
        if (oldSlasher == address(0) || __latestSlashedCaptureTimestamp[subnetwork][operator] > 0) {
            return __latestSlashedCaptureTimestamp[subnetwork][operator];
        }
        return IBaseSlasher(oldSlasher).latestSlashedCaptureTimestamp(subnetwork, operator);
    }

    /// @dev Legacy support.
    function _cumulativeSlashAt(bytes32 subnetwork, address operator, uint48 timestamp)
        internal
        view
        returns (uint256)
    {
        if (timestamp < migrateTimestamp) {
            return IBaseSlasher(oldSlasher).cumulativeSlashAt(subnetwork, operator, timestamp, "");
        }
        return __cumulativeSlash[subnetwork][operator].upperLookupRecent(timestamp);
    }

    /// @dev Legacy support.
    function _cumulativeSlash(bytes32 subnetwork, address operator) internal view returns (uint256) {
        if (oldSlasher == address(0) || __cumulativeSlash[subnetwork][operator].length() > 0) {
            return __cumulativeSlash[subnetwork][operator].latest();
        }
        return IBaseSlasher(oldSlasher).cumulativeSlash(subnetwork, operator);
    }
}

// src/contracts/vault/VaultV2.sol

// Copyright (c) 2026 Symbiotic

/// @title VaultV2
/// @notice Contract for upgradeable vault collateral, withdrawals, plugins, and migrations.
/// @dev Priority over funds utilization:
///      1. No-plugins subvaults can always slash full amount.
///      2. Firstly, incoming funds are used for claimable withdrawals.
///      3. Secondly, incoming funds are used to sync owed slashes.
///      4. Remaining funds are used for instant withdrawals and plugins allocation simultaneously.
contract VaultV2 is VaultV2Storage, MigratableEntity, AccessControlUpgradeable, ERC20Upgradeable, IVaultV2 {
    using FixedPointMathLib for uint256;
    using SafeTransferLib for address;
    using Checkpoints_1 for Checkpoints_1.Trace208;
    using Checkpoints_1 for Checkpoints_1.Trace256;
    using Checkpoints_2 for Checkpoints_2.Trace208;
    using Checkpoints_2 for Checkpoints_2.Trace256;

    /* MULTICALL */

    /// @inheritdoc IVaultV2
    function multicall(bytes[] calldata data) public {
        for (uint256 i; i < data.length; ++i) {
            (bool success, bytes memory returnData) = address(this).delegatecall(data[i]);
            if (!success) {
                assembly ("memory-safe") {
                    revert(add(32, returnData), mload(returnData))
                }
            }
        }
    }

    /* CONSTRUCTOR */

    constructor(
        address delegatorFactory,
        address slasherFactory,
        address vaultFactory,
        address feeRegistry,
        address rewards,
        address pluginRegistry
    )
        VaultV2Storage(delegatorFactory, slasherFactory, feeRegistry, rewards, pluginRegistry)
        MigratableEntity(vaultFactory)
    {}

    /* VIEW FUNCTIONS */

    /// @inheritdoc IVaultV2
    function isInitialized() public view returns (bool) {
        return _isDelegatorInitialized && _isSlasherInitialized;
    }

    /// @inheritdoc IVaultV2
    function totalStake() public view returns (uint256) {
        unchecked {
            return activeStake() + activeWithdrawals();
        }
    }

    /// @inheritdoc IVaultV2
    function activeWithdrawalsForAt(uint48 duration, uint48 timestamp) public view returns (uint256) {
        unchecked {
            if (duration > epochDuration) {
                return 0;
            }
            uint208 curWithdrawalBucket = _unlockToBucket.upperLookupRecent(timestamp);
            uint256 curWithdrawalShares = _withdrawalShares[curWithdrawalBucket].upperLookupRecent(timestamp);
            return curWithdrawalShares > 0
                ? _activeWithdrawalSharesForAt(duration, timestamp)
                    .fullMulDiv(_withdrawals[curWithdrawalBucket].upperLookupRecent(timestamp), curWithdrawalShares)
                : 0;
        }
    }

    /// @inheritdoc IVaultV2
    function activeWithdrawalsFor(uint48 duration) public view returns (uint256 amount) {
        unchecked {
            if (duration > epochDuration) {
                return 0;
            }
            uint208 curWithdrawalBucket = withdrawalBucket();
            uint256 curWithdrawalShares = withdrawalShares(curWithdrawalBucket);
            return curWithdrawalShares > 0
                ? _activeWithdrawalSharesFor(duration).fullMulDiv(withdrawals(curWithdrawalBucket), curWithdrawalShares)
                : 0;
        }
    }

    /// @inheritdoc IVaultV2
    function activeWithdrawalsAt(uint48 timestamp) public view returns (uint256) {
        return activeWithdrawalsForAt(0, timestamp);
    }

    /// @inheritdoc IVaultV2
    function activeWithdrawals() public view returns (uint256) {
        return activeWithdrawalsFor(0);
    }

    /// @inheritdoc IVaultV2
    function activeBalanceOfAt(address account, uint48 timestamp, bytes calldata) public view returns (uint256) {
        return ERC4626Math.previewRedeem(
            activeSharesOfAt(account, timestamp, Calldata.emptyBytes()),
            activeStakeAt(timestamp, Calldata.emptyBytes()),
            activeSharesAt(timestamp, Calldata.emptyBytes())
        );
    }

    /// @inheritdoc IVaultV2
    function activeBalanceOf(address account) public view returns (uint256) {
        return ERC4626Math.previewRedeem(activeSharesOf(account), activeStake(), activeShares());
    }

    /// @inheritdoc IVaultV2
    function withdrawalsOfLength(address account) public view returns (uint256) {
        unchecked {
            if (migrateTimestamp == 0 || _withdrawalsOfLength[account] > 0) {
                return _withdrawalsOfLength[account];
            }

            // Legacy support.
            return __migrateEpoch + 2;
        }
    }

    /// @inheritdoc IVaultV2
    function withdrawalSharesOf(uint256 index, address account) public view returns (uint256 shares) {
        unchecked {
            shares = _withdrawalSharesOf[index][account];

            // Legacy support.
            if (migrateTimestamp > 0) {
                uint48 migrateEpoch = __migrateEpoch;
                if (index == migrateEpoch || index == migrateEpoch + 1) {
                    shares = ERC4626Math.previewRedeem(shares, __withdrawals[index], __withdrawalShares[index]);
                }
            }
        }
    }

    /// @inheritdoc IVaultV2
    function withdrawalUnlockAt(uint256 index, address account) public view returns (uint48 timestamp) {
        unchecked {
            if (migrateTimestamp > 0) {
                // Legacy support.
                uint48 migrateEpoch = __migrateEpoch;
                if (index == migrateEpoch) {
                    return __migrateNextEpochTimestamp;
                }
                if (index == migrateEpoch + 1) {
                    return migrateTimestamp + epochDuration;
                }
            }

            return _withdrawalUnlockAt[index][account];
        }
    }

    /// @inheritdoc IVaultV2
    function withdrawalsOf(uint256 index, address account) public view returns (uint256 amount) {
        unchecked {
            uint48 migrateEpoch = __migrateEpoch;
            if (index >= migrateEpoch) {
                uint48 unlockAt = withdrawalUnlockAt(index, account);
                uint256 bucketIndex = _unlockToBucket.upperLookupRecent(unlockAt > 0 ? unlockAt - 1 : 0);
                uint256 withdrawalShares_ = withdrawalShares(bucketIndex);
                return withdrawalShares_ > 0
                    ? ERC4626Math.previewRedeem(
                        withdrawalSharesOf(index, account), withdrawals(bucketIndex), withdrawalShares_
                    )
                    : 0;
            }

            // Legacy support.
            return ERC4626Math.previewRedeem(
                _withdrawalSharesOf[index][account], __withdrawals[index], __withdrawalShares[index]
            );
        }
    }

    /// @inheritdoc ERC20Upgradeable
    function decimals() public view override returns (uint8) {
        return IERC20Metadata(collateral).decimals();
    }

    /// @inheritdoc ERC20Upgradeable
    function totalSupply() public view override returns (uint256) {
        return activeShares();
    }

    /// @inheritdoc ERC20Upgradeable
    function balanceOf(address account) public view override returns (uint256) {
        return activeSharesOf(account);
    }

    /// @inheritdoc IVaultV2
    function allocatable() public view returns (uint256) {
        return _maxAllocatable().saturatingSub(pluginsAllocated);
    }

    /* PUBLIC FUNCTIONS (ACCOUNTING) */

    /// @inheritdoc IVaultV2
    function deposit(address onBehalfOf, uint256 amount)
        public
        nonReentrant
        returns (uint256 depositedAmount, uint256 mintedShares)
    {
        unchecked {
            skimPlugins();

            _revertIfZero(onBehalfOf);
            if (depositWhitelist && !isDepositorWhitelisted[msg.sender]) {
                revert NotWhitelistedDepositor();
            }

            depositedAmount = _safeTransferIn(msg.sender, amount);

            if (isDepositLimit && activeStake() + depositedAmount > depositLimit) {
                revert DepositLimitReached();
            }

            uint256 curActiveStake = activeStake();
            uint256 curActiveShares = activeShares();

            mintedShares = ERC4626Math.previewDeposit(depositedAmount, curActiveShares, curActiveStake);
            _revertIfZero(mintedShares);

            uint256 newActiveShares = curActiveShares + mintedShares;
            require(newActiveShares >= curActiveShares);
            _activeShares.push(uint48(block.timestamp), newActiveShares);
            _activeStake.push(uint48(block.timestamp), curActiveStake + depositedAmount);
            _activeSharesOf[onBehalfOf].push(uint48(block.timestamp), activeSharesOf(onBehalfOf) + mintedShares);

            emit Deposit(msg.sender, onBehalfOf, depositedAmount, mintedShares);
            emit Transfer(address(0), onBehalfOf, mintedShares);

            // Allocate only non-fee-on-transfer tokens.
            if (depositedAmount == amount && plugins.length > 0) {
                _allocatePlugin(plugins[0], depositedAmount);
            }
        }
    }

    /// @inheritdoc IVaultV2
    function withdraw(address claimer, uint256 amount)
        public
        nonReentrant
        returns (uint256 burnedShares, uint256 mintedShares)
    {
        unchecked {
            skimPlugins();

            _revertIfZero(claimer);
            _revertIfZero(amount);

            burnedShares = ERC4626Math.previewWithdraw(amount, activeShares(), activeStake());
            _revertIfZero(burnedShares);
            if (burnedShares > activeSharesOf(msg.sender)) {
                revert TooMuchWithdraw();
            }
            mintedShares = _withdraw(claimer, amount, burnedShares);
        }
    }

    /// @inheritdoc IVaultV2
    function redeem(address claimer, uint256 shares)
        public
        nonReentrant
        returns (uint256 withdrawnAssets, uint256 mintedShares)
    {
        unchecked {
            skimPlugins();

            _revertIfZero(claimer);
            _revertIfZero(shares);
            if (shares > activeSharesOf(msg.sender)) {
                revert TooMuchRedeem();
            }

            withdrawnAssets = ERC4626Math.previewRedeem(shares, activeStake(), activeShares());
            _revertIfZero(withdrawnAssets);
            mintedShares = _withdraw(claimer, withdrawnAssets, shares);
        }
    }

    /// @inheritdoc IVaultV2
    function instantWithdraw(address recipient, uint256 amount)
        public
        nonReentrant
        returns (uint256 withdrawnAssets, uint256 burnedShares)
    {
        unchecked {
            _revertIfZero(recipient);

            uint256 curActiveStake = activeStake();
            uint256 curActiveShares = activeShares();
            uint256 curActiveSharesOf = activeSharesOf(msg.sender);

            withdrawnAssets = FixedPointMathLib.min(amount, UniversalDelegator(delegator).getWithdrawalBuffer());

            burnedShares = ERC4626Math.previewWithdraw(withdrawnAssets, curActiveShares, curActiveStake);
            if (burnedShares > curActiveSharesOf) {
                revert TooMuchWithdraw();
            }

            _activeSharesOf[msg.sender].push(uint48(block.timestamp), curActiveSharesOf - burnedShares);
            _activeStake.push(uint48(block.timestamp), curActiveStake - withdrawnAssets);
            _activeShares.push(uint48(block.timestamp), curActiveShares - burnedShares);

            deallocatePlugins();

            if (_maxAllocatable() < pluginsAllocated) {
                revert InsufficientAmount();
            }

            uint256 fees =
                withdrawnAssets.fullMulDivUp(IFeeRegistry(FEE_REGISTRY).getInstantWithdrawFee(address(this)), MAX_FEE);
            if (fees > 0) {
                collateral.safeApprove(REWARDS, fees);
                IRewards(REWARDS).distributeDonationRewards(address(this), fees);
            }

            _safeTransferOut(recipient, withdrawnAssets - fees);

            emit InstantWithdraw(msg.sender, withdrawnAssets, burnedShares);
            emit Transfer(msg.sender, address(0), burnedShares);
        }
    }

    /// @inheritdoc IVaultV2
    function claim(address recipient, uint256 index) public nonReentrant returns (uint256 amount) {
        unchecked {
            deallocatePlugins();

            _revertIfZero(recipient);

            if (isWithdrawalsClaimed[index][msg.sender]) {
                revert AlreadyClaimed();
            }
            if (block.timestamp < withdrawalUnlockAt(index, msg.sender)) {
                revert WithdrawalNotMatured();
            }

            amount = withdrawalsOf(index, msg.sender);

            isWithdrawalsClaimed[index][msg.sender] = true;
            _unclaimedRaw -= int256(amount);

            _safeTransferOut(recipient, amount);

            emit Claim(msg.sender, recipient, index, amount);
        }
    }

    /// @inheritdoc IVaultV2
    function claimBatch(address recipient, uint256[] calldata indexes) public returns (uint256 amount) {
        unchecked {
            for (uint256 i; i < indexes.length; ++i) {
                amount += claim(recipient, indexes[i]);
            }
        }
    }

    /// @dev Credit rewards donation into active stake after pulling collateral from the rewards address.
    function donate(uint256 amount) public {
        unchecked {
            if (REWARDS != msg.sender) {
                revert NotRewards();
            }

            amount = _safeTransferIn(msg.sender, amount);

            uint256 curActiveStake = activeStake();
            uint256 curActiveWithdrawals = activeWithdrawals();
            uint256 withdrawalsDonated = amount.fullMulDiv(curActiveWithdrawals, curActiveStake + curActiveWithdrawals);

            if (withdrawalsDonated > 0) {
                _updateWithdrawalsSharePrice(curActiveWithdrawals + withdrawalsDonated);
            }
            _activeStake.push(uint48(block.timestamp), amount - withdrawalsDonated + curActiveStake);

            emit Donate(amount);
        }
    }

    // @dev Internal dev function to handle slashing.
    function onSlash(uint256 amount, bool withPlugins)
        public
        nonReentrant
        returns (uint256 slashedAmount, uint256 owedAmount)
    {
        unchecked {
            if (slasher != msg.sender) {
                revert NotSlasher();
            }

            uint256 curActiveStake = activeStake();
            uint256 curActiveWithdrawals = activeWithdrawals();
            uint256 slashableStake = curActiveStake + curActiveWithdrawals;

            slashedAmount = FixedPointMathLib.min(amount, slashableStake);
            if (slashedAmount > 0) {
                uint256 activeSlashed = slashedAmount.fullMulDiv(curActiveStake, slashableStake);
                _activeStake.push(uint48(block.timestamp), curActiveStake - activeSlashed);
                if (curActiveWithdrawals > 0) {
                    _updateWithdrawalsSharePrice(curActiveWithdrawals - (slashedAmount - activeSlashed));
                }

                if (withPlugins) {
                    deallocatePlugins();
                    owedAmount = FixedPointMathLib.min(slashedAmount, _pluginsOwe());
                }

                _safeTransferOut(burner, slashedAmount - owedAmount);
            }
        }

        emit OnSlash(amount, slashedAmount);
    }

    /* INTERNAL FUNCTIONS (ACCOUNTING) */

    /// @dev Return active withdrawal shares for a duration at a timestamp.
    function _activeWithdrawalSharesForAt(uint48 duration, uint48 timestamp) internal view returns (uint256) {
        unchecked {
            return _withdrawalSharesCumulative.upperLookupRecent(timestamp + epochDuration)
                - _withdrawalSharesCumulative.upperLookupRecent(timestamp + duration);
        }
    }

    /// @dev Return active withdrawal shares for a duration at the current timestamp.
    function _activeWithdrawalSharesFor(uint48 duration) internal view returns (uint256) {
        unchecked {
            return _withdrawalSharesCumulative.latest()
                - _withdrawalSharesCumulative.upperLookupRecent(uint48(block.timestamp) + duration);
        }
    }

    /// @dev Convert active shares into a withdrawal request.
    function _withdraw(address claimer, uint256 withdrawnAssets, uint256 burnedShares)
        internal
        virtual
        returns (uint256 mintedShares)
    {
        unchecked {
            _activeSharesOf[msg.sender].push(uint48(block.timestamp), activeSharesOf(msg.sender) - burnedShares);
            _activeShares.push(uint48(block.timestamp), activeShares() - burnedShares);
            _activeStake.push(uint48(block.timestamp), activeStake() - withdrawnAssets);

            uint208 curWithdrawalBucket = withdrawalBucket();
            uint256 curWithdrawals = withdrawals(curWithdrawalBucket);
            uint256 curWithdrawalShares = withdrawalShares(curWithdrawalBucket);

            mintedShares = ERC4626Math.previewDeposit(withdrawnAssets, curWithdrawalShares, curWithdrawals);
            _revertIfZero(mintedShares);

            uint256 newWithdrawalShares = curWithdrawalShares + mintedShares;
            require(newWithdrawalShares >= curWithdrawalShares);
            _withdrawalShares[curWithdrawalBucket].push(uint48(block.timestamp), newWithdrawalShares);
            _withdrawals[curWithdrawalBucket].push(uint48(block.timestamp), curWithdrawals + withdrawnAssets);

            uint48 unlockAt = uint48(block.timestamp) + epochDuration;
            uint256 curWithdrawalsOfLength = withdrawalsOfLength(claimer);

            _withdrawalsOfLength[claimer] = curWithdrawalsOfLength + 1;
            _withdrawalSharesOf[curWithdrawalsOfLength][claimer] = mintedShares;
            _withdrawalUnlockAt[curWithdrawalsOfLength][claimer] = unlockAt;
            _withdrawalSharesCumulative.push(unlockAt, _withdrawalSharesCumulative.latest() + mintedShares);

            emit Withdraw(msg.sender, claimer, withdrawnAssets, burnedShares, mintedShares, curWithdrawalsOfLength);
            emit Transfer(msg.sender, address(0), burnedShares);
        }
    }

    /// @dev Reprice active withdrawals and roll claimable shares into a new bucket when a boundary is crossed.
    function _updateWithdrawalsSharePrice(uint256 newActiveWithdrawals) internal {
        unchecked {
            uint208 curWithdrawalBucket = withdrawalBucket();
            uint256 curActiveWithdrawalShares = _activeWithdrawalSharesFor(0);
            uint256 curClaimableWithdrawals = withdrawals(curWithdrawalBucket) - activeWithdrawals();
            uint256 curClaimableWithdrawalShares = withdrawalShares(curWithdrawalBucket) - curActiveWithdrawalShares;

            if (curClaimableWithdrawalShares > 0) {
                _withdrawalShares[curWithdrawalBucket].push(uint48(block.timestamp), curClaimableWithdrawalShares);
                _withdrawals[curWithdrawalBucket].push(uint48(block.timestamp), curClaimableWithdrawals);
                _unclaimedRaw += int256(curClaimableWithdrawals);

                ++curWithdrawalBucket;
                _withdrawalShares[curWithdrawalBucket].push(uint48(block.timestamp), curActiveWithdrawalShares);
                _unlockToBucket.push(uint48(block.timestamp), curWithdrawalBucket);
            }
            _withdrawals[curWithdrawalBucket].push(uint48(block.timestamp), newActiveWithdrawals);
        }
    }

    /* PUBLIC FUNCTIONS (CURATOR) */

    /// @inheritdoc IVaultV2
    function setDepositWhitelist(bool newStatus) public nonReentrant onlyRole(DEPOSIT_WHITELIST_SET_ROLE) {
        depositWhitelist = newStatus;
        emit SetDepositWhitelist(newStatus);
    }

    /// @inheritdoc IVaultV2
    function setDepositorWhitelistStatus(address account, bool newStatus)
        public
        nonReentrant
        onlyRole(DEPOSITOR_WHITELIST_ROLE)
    {
        _revertIfZero(account);
        isDepositorWhitelisted[account] = newStatus;
        emit SetDepositorWhitelistStatus(account, newStatus);
    }

    /// @inheritdoc IVaultV2
    function setIsDepositLimit(bool newStatus) public nonReentrant onlyRole(IS_DEPOSIT_LIMIT_SET_ROLE) {
        isDepositLimit = newStatus;
        emit SetIsDepositLimit(newStatus);
    }

    /// @inheritdoc IVaultV2
    function setDepositLimit(uint256 newLimit) public nonReentrant onlyRole(DEPOSIT_LIMIT_SET_ROLE) {
        depositLimit = newLimit;
        emit SetDepositLimit(newLimit);
    }

    /// @inheritdoc IVaultV2
    function setPluginLimit(address plugin, uint208 newLimit) public nonReentrant onlyRole(SET_PLUGIN_LIMIT_ROLE) {
        unchecked {
            _revertIfZero(plugin);

            if (pluginAllocated[plugin] > newLimit) {
                revert PluginAllocated();
            }

            uint256 numPlugins = plugins.length;
            if (newLimit > 0) {
                if (pluginLimit[plugin] == 0) {
                    if (numPlugins + 1 > MAX_PLUGINS) {
                        revert TooManyPlugins();
                    }
                    if (!IRegistry(PLUGIN_REGISTRY).isEntity(plugin)) {
                        revert NotPlugin();
                    }
                    plugins.push(plugin);
                    _grantRoleIfNotZero(ALLOCATE_PLUGIN_ROLE, plugin);
                    _grantRoleIfNotZero(DEALLOCATE_PLUGIN_ROLE, plugin);
                }
            } else {
                for (uint256 i; i < numPlugins; ++i) {
                    if (plugin == plugins[i]) {
                        plugins[i] = plugins[numPlugins - 1];
                        plugins.pop();
                        super._revokeRole(ALLOCATE_PLUGIN_ROLE, plugin);
                        super._revokeRole(DEALLOCATE_PLUGIN_ROLE, plugin);
                        break;
                    }
                }
            }
            pluginLimit[plugin] = newLimit;

            emit SetPluginLimit(plugin, newLimit);
        }
    }

    /// @inheritdoc IVaultV2
    function swapPlugins(address plugin1, address plugin2) public nonReentrant onlyRole(SWAP_PLUGINS_ROLE) {
        unchecked {
            uint256 index1 = type(uint256).max;
            uint256 index2 = type(uint256).max;
            uint256 numPlugins = plugins.length;
            for (uint256 i; i < numPlugins; ++i) {
                if (plugin1 == plugins[i]) {
                    index1 = i;
                } else if (plugin2 == plugins[i]) {
                    index2 = i;
                }
            }
            (plugins[index1], plugins[index2]) = (plugins[index2], plugins[index1]);

            emit SwapPlugins(plugin1, plugin2);
        }
    }

    /// @inheritdoc IVaultV2
    function allocatePlugin(address plugin, uint256 amount)
        public
        onlyRole(ALLOCATE_PLUGIN_ROLE)
        returns (uint256 allocated)
    {
        return _allocatePlugin(plugin, amount);
    }

    /// @dev Allocate collateral to a plugin within configured limits.
    function _allocatePlugin(address plugin, uint256 amount) internal returns (uint256 allocated) {
        unchecked {
            allocated = FixedPointMathLib.min(
                FixedPointMathLib.min(
                    FixedPointMathLib.min(amount, pluginLimit[plugin] - pluginAllocated[plugin]), allocatable()
                ),
                IPluginBase(plugin).allocatable(address(this))
            );

            if (allocated > 0) {
                pluginsAllocated += allocated;
                pluginAllocated[plugin] += allocated;

                uint256 balanceBefore = collateral.balanceOf(plugin);
                _safeTransferOut(plugin, allocated);
                if (collateral.balanceOf(plugin) - balanceBefore < allocated) {
                    revert FeeOnTransferNotSupported();
                }
                IPluginBase(plugin).allocate(allocated);
            }

            emit Allocate(plugin, allocated);
        }
    }

    /// @inheritdoc IVaultV2
    function deallocatePlugin(address plugin, uint256 amount)
        public
        onlyRole(DEALLOCATE_PLUGIN_ROLE)
        returns (uint256)
    {
        return _deallocatePlugin(plugin, amount);
    }

    /// @dev Deallocate collateral from a plugin and update accounting.
    function _deallocatePlugin(address plugin, uint256 amount) internal returns (uint256 deallocated) {
        deallocated = IPluginBase(plugin).deallocate(amount);
        if (deallocated > 0) {
            _safeTransferIn(plugin, deallocated);

            pluginAllocated[plugin] -= deallocated;
            unchecked {
                pluginsAllocated -= deallocated;
            }
        }

        emit Deallocate(plugin, deallocated);
    }

    /* PUBLIC FUNCTIONS (PERMISSIONLESS) */

    /// @inheritdoc IVaultV2
    function skimPlugins() public {
        for (uint256 i; i < plugins.length; ++i) {
            IPluginBase(plugins[i]).skim(address(this));
        }
    }

    /// @inheritdoc IVaultV2
    function deallocatePlugins() public {
        for (uint256 i; i < plugins.length; ++i) {
            uint256 toDeallocate = _pluginsOwe();
            if (toDeallocate == uint256(0)) {
                break;
            }
            address plugin = plugins[i];
            uint256 curPluginAllocated = pluginAllocated[plugin];
            if (curPluginAllocated > 0) {
                _deallocatePlugin(plugin, FixedPointMathLib.min(curPluginAllocated, toDeallocate));
            }
        }
    }

    /* INTERNAL FUNCTIONS (PLUGINS) */

    /// @dev Return the vault stake that may still be allocated after reserving no-plugins capacity.
    function _maxAllocatable() internal view returns (uint256) {
        return totalStake().saturatingSub(UniversalDelegator(delegator).getNoPluginsSize());
    }

    /// @dev Return how much plugin allocation currently exceeds the vault allocatable amount.
    function _pluginsOwe() internal view returns (uint256) {
        return pluginsAllocated.saturatingSub(_maxAllocatable());
    }

    /// @inheritdoc AccessControlUpgradeable
    function _revokeRole(bytes32 role, address account) internal override returns (bool) {
        if (pluginLimit[account] > 0 && (role == ALLOCATE_PLUGIN_ROLE || role == DEALLOCATE_PLUGIN_ROLE)) {
            return false;
        }
        return super._revokeRole(role, account);
    }

    /* PUBLIC FUNCTIONS (INTERNAL LOGIC) */

    // @dev Internal dev function to handle owed slashing.
    function syncOwedSlash(uint256 amount) public nonReentrant returns (uint256 slashedAmount) {
        if (slasher != msg.sender) {
            revert NotSlasher();
        }

        slashedAmount =
            FixedPointMathLib.min(amount, UniversalSlasher(slasher).totalOwed().saturatingSub(_pluginsOwe()));
        _safeTransferOut(burner, slashedAmount);

        emit SyncOwedSlash(slashedAmount);
    }

    /// @dev Set the vault delegator once after validating registry membership and vault linkage.
    function setDelegator(address newDelegator) public nonReentrant {
        if (_isDelegatorInitialized) {
            revert DelegatorAlreadyInitialized();
        }

        _validateEntity(newDelegator, DELEGATOR_FACTORY, UNIVERSAL_DELEGATOR_TYPE, InvalidDelegator.selector);

        delegator = newDelegator;

        _isDelegatorInitialized = true;

        emit SetDelegator(newDelegator);
    }

    /// @dev Set the vault slasher once after validating registry membership and vault linkage.
    function setSlasher(address newSlasher) public nonReentrant {
        if (_isSlasherInitialized) {
            revert SlasherAlreadyInitialized();
        }

        if (newSlasher != address(0)) {
            _validateEntity(newSlasher, SLASHER_FACTORY, UNIVERSAL_SLASHER_TYPE, InvalidSlasher.selector);

            slasher = newSlasher;
        }

        _isSlasherInitialized = true;

        emit SetSlasher(newSlasher);
    }

    /* INTERNAL FUNCTIONS (ERC20) */

    /// @inheritdoc ERC20Upgradeable
    /// @dev Mirror ERC20 transfers into active share checkpoints.
    function _update(address from, address to, uint256 value) internal override {
        // _Update() is called only on transfers, so from == address(0) or to == address(0) is not possible.
        _activeSharesOf[from].push(uint48(block.timestamp), balanceOf(from) - value);
        unchecked {
            _activeSharesOf[to].push(uint48(block.timestamp), balanceOf(to) + value);
        }

        emit Transfer(from, to, value);
    }

    /* INITIALIZATION */

    /// @dev Initialize vault state from encoded initialization parameters.
    function _initialize(uint64, address, bytes memory data) internal virtual override {
        unchecked {
            InitParams memory params = abi.decode(data, (InitParams));

            if (params.collateral == address(0)) {
                revert InvalidCollateral();
            }

            if (params.epochDuration == uint48(0) || params.epochDuration > MAX_DURATION) {
                revert TooLongDuration();
            }

            if (params.depositorToWhitelist == address(0)) {
                revert InvalidDepositorToWhitelist();
            }

            __ERC20_init(params.name, params.symbol);

            collateral = params.collateral;

            burner = params.burner;

            epochDuration = params.epochDuration;

            depositWhitelist = params.depositWhitelist;
            isDepositorWhitelisted[params.depositorToWhitelist] = true;

            isDepositLimit = params.isDepositLimit;
            depositLimit = params.depositLimit;

            _grantRoleIfNotZero(DEFAULT_ADMIN_ROLE, params.defaultAdminRoleHolder);
            _grantRoleIfNotZero(DEPOSIT_WHITELIST_SET_ROLE, params.depositWhitelistSetRoleHolder);
            _grantRoleIfNotZero(DEPOSITOR_WHITELIST_ROLE, params.depositorWhitelistRoleHolder);
            _grantRoleIfNotZero(IS_DEPOSIT_LIMIT_SET_ROLE, params.isDepositLimitSetRoleHolder);
            _grantRoleIfNotZero(DEPOSIT_LIMIT_SET_ROLE, params.depositLimitSetRoleHolder);
            _grantRoleIfNotZero(SET_PLUGIN_LIMIT_ROLE, params.setPluginLimitRoleHolder);
            _grantRoleIfNotZero(ALLOCATE_PLUGIN_ROLE, params.allocatePluginRoleHolder);

            emit Initialize(params);
        }
    }

    /* MIGRATION */

    /// @dev Migrate vault state and deploy V2 delegator and slasher contracts.
    function _migrate(uint64 oldVersion, uint64, bytes calldata data) internal override {
        unchecked {
            if (epochDuration > MAX_DURATION) {
                revert TooLongDuration();
            }

            migrateTimestamp = uint48(block.timestamp);
            uint48 migrateEpoch = uint48((block.timestamp - __epochDurationInit) / epochDuration);
            __migrateEpoch = migrateEpoch;
            uint48 migrateNextEpochTimestamp = __epochDurationInit + (migrateEpoch + 1) * epochDuration;
            __migrateNextEpochTimestamp = migrateNextEpochTimestamp;

            MigrateParams memory params = abi.decode(data, (MigrateParams));
            if (oldVersion == VAULT_VERSION) {
                __ERC20_init(params.name, params.symbol);
            }

            uint256 curActiveWithdrawals;
            if (migrateEpoch > 0) {
                curActiveWithdrawals = __withdrawals[migrateEpoch];
                if (curActiveWithdrawals > 0) {
                    _withdrawalSharesCumulative.push(migrateNextEpochTimestamp, curActiveWithdrawals);
                }
            }
            curActiveWithdrawals += __withdrawals[migrateEpoch + 1];
            if (curActiveWithdrawals > 0) {
                _withdrawalSharesCumulative.push(uint48(block.timestamp) + epochDuration, curActiveWithdrawals);
                _withdrawals[0].push(uint48(block.timestamp), curActiveWithdrawals);
                _withdrawalShares[0].push(uint48(block.timestamp), curActiveWithdrawals);
            }

            _unclaimedRaw = int256(collateral.balanceOf(address(this)) - activeStake() - curActiveWithdrawals);

            address oldDelegator = delegator;
            delegator = DelegatorFactory(DELEGATOR_FACTORY)
                .create(UNIVERSAL_DELEGATOR_TYPE, abi.encode(address(this), params.delegatorParams));
            UniversalDelegator(delegator).migrate(oldDelegator);

            if (slasher != address(0)) {
                address oldSlasher = slasher;
                slasher = SlasherFactory(SLASHER_FACTORY)
                    .create(UNIVERSAL_SLASHER_TYPE, abi.encode(address(this), params.slasherParams));
                UniversalSlasher(slasher).migrate(oldSlasher);
            }

            emit Migrate(params, delegator, slasher);
        }
    }

    /* UTILITY FUNCTIONS */

    /// @dev Revert when an address argument is zero.
    function _revertIfZero(address value) internal pure {
        if (value == address(0)) {
            revert InvalidAddress();
        }
    }

    /// @dev Revert when an amount argument is zero.
    function _revertIfZero(uint256 amount) internal pure {
        if (amount == uint256(0)) {
            revert InsufficientAmount();
        }
    }

    /// @dev Revert when an entity is invalid.
    function _validateEntity(address entity, address factory, uint64 minType, bytes4 errorSelector) internal view {
        if (
            !IRegistry(factory).isEntity(entity) || UniversalDelegator(entity).vault() != address(this)
                || IEntity(entity).TYPE() < minType
        ) {
            assembly ("memory-safe") {
                mstore(0x00, errorSelector)
                revert(0x00, 0x04)
            }
        }
    }

    /// @dev Grant a role when the holder address is not zero.
    function _grantRoleIfNotZero(bytes32 role, address holder) internal {
        if (holder != address(0)) {
            _grantRole(role, holder);
        }
    }

    /// @dev Transfer collateral from a source address to the vault.
    function _safeTransferIn(address from, uint256 amount) internal returns (uint256 amountIn) {
        uint256 balanceBefore = collateral.balanceOf(address(this));
        collateral.safeTransferFrom(from, address(this), amount);
        amountIn = collateral.balanceOf(address(this)) - balanceBefore;
        _revertIfZero(amountIn);
    }

    /// @dev Transfer collateral from the vault to a recipient address.
    function _safeTransferOut(address to, uint256 amount) internal {
        _revertIfZero(amount);
        collateral.safeTransfer(to, amount);
    }
}

// src/contracts/delegator/UniversalDelegator.sol

// Copyright (c) 2026 Symbiotic

/// @title UniversalDelegator
/// @notice Contract for hierarchical stake allocation across subvaults, networks, and operators.
contract UniversalDelegator is
    Entity,
    StaticDelegateCallable,
    AccessControlUpgradeable,
    ReentrancyGuardUpgradeable,
    IUniversalDelegator
{
    using FixedPointMathLib for uint256;
    using Subnetwork for bytes32;
    using Subnetwork for address;
    using UniversalDelegatorIndex for uint96;
    using Checkpoints_2 for Checkpoints_2.Trace208;

    /* IMMUTABLES */

    /// @dev Address of the network registry.
    address internal immutable NETWORK_REGISTRY;
    /// @dev Address of the vault factory.
    address internal immutable VAULT_FACTORY;
    /// @dev Address of the network middleware service.
    address internal immutable NETWORK_MIDDLEWARE_SERVICE;

    /* STATE VARIABLES */

    struct SlotStorage {
        bool exists;
        bool isShared;
        bool noPlugins;
        uint32 prevSlot;
        uint32 totalChildren;
        uint32 existChildren;
        uint48 _childrenPendingAt;
        Checkpoints_2.Trace208 size;
        Checkpoints_2.Trace208 nextSlot;
        Checkpoints_2.Trace208 lastChild;
        Checkpoints_2.Trace208 firstChild;
        Checkpoints_2.Trace208 prevSizeSum;
        Checkpoints_2.Trace208 syncPrevSizeSums;
        Checkpoints_2.Trace208 pendingCumulative;
        Checkpoints_2.Trace208 clearedPendingCursor;
        Checkpoints_2.Trace208 sharedPendingConsumedCursor;
        Checkpoints_2.Trace208 sharedSizeConsumedCumulative;
    }

    /// @inheritdoc IUniversalDelegator
    address public vault;
    /// @inheritdoc IUniversalDelegator
    address public hook;

    /// @dev Total slot size marked as no-plugins across root subvaults.
    uint256 internal _noPluginsSize;
    /// @dev Slot storage keyed by encoded slot index.
    mapping(uint96 index => SlotStorage slot) internal slots;
    /// @dev Mapping from subnetwork id to slot index checkpoints.
    mapping(bytes32 subnetwork => Checkpoints_2.Trace208) internal _networkToSlot;
    /// @dev Mapping from slot index to subnetwork id.
    mapping(uint96 index => bytes32 subnetwork) internal _slotToNetwork;
    /// @dev Mapping from parent slot and operator to slot index checkpoints.
    mapping(uint96 parentIndex => mapping(address operator => Checkpoints_2.Trace208)) internal _operatorToSlot;
    /// @dev Mapping from slot index to operator address.
    mapping(uint96 index => address operator) internal _slotToOperator;
    /// @dev Cumulative pending no-plugins amounts.
    Checkpoints_2.Trace208 internal _noPluginsPendingCumulative;
    /// @dev Cumulative cleared pending no-plugins amounts.
    Checkpoints_2.Trace208 internal _clearedNoPluginsPendingCursor;
    /// @dev Maximum network limit per subnetwork.
    mapping(bytes32 subnetwork => Checkpoints_2.Trace208) internal _maxNetworkLimit;

    /// @inheritdoc IUniversalDelegator
    uint48 public migrateTimestamp;
    /// @inheritdoc IUniversalDelegator
    address public oldDelegator;

    /* MODIFIERS */

    modifier syncPrevSizeSums(uint96 parentIndex) {
        if (slots[parentIndex].syncPrevSizeSums.latest() > 0) {
            _syncPrevSizeSums(parentIndex);
            slots[parentIndex].syncPrevSizeSums.push(uint48(block.timestamp), 0);
        }
        _;
        _syncPrevSizeSums(parentIndex);
    }

    /// @dev Synchronize cumulative child size prefix sums for a parent slot.
    function _syncPrevSizeSums(uint96 parentIndex) internal {
        unchecked {
            if (parentIndex.getDepth() == 1 && slots[parentIndex].isShared) {
                return;
            }
            uint32 childIndex = uint32(slots[parentIndex].firstChild.latest());
            if (childIndex == 0) {
                if (parentIndex == 0 && _withdrawalBufferSlot().prevSizeSum.latest() != 0) {
                    _withdrawalBufferSlot().prevSizeSum.push(uint48(block.timestamp), 0);
                }
                return;
            }
            uint208 prevSum;
            for (; childIndex > 0;) {
                SlotStorage storage child = slots[parentIndex.createIndex(childIndex)];
                if (child.prevSizeSum.latest() != prevSum) {
                    child.prevSizeSum.push(uint48(block.timestamp), prevSum);
                }
                prevSum += child.size.latest();
                childIndex = uint32(child.nextSlot.latest());
            }
        }
    }

    /* MULTICALL */

    /// @inheritdoc IUniversalDelegator
    function multicall(bytes[] calldata data) public {
        for (uint256 i; i < data.length; ++i) {
            (bool success, bytes memory returnData) = address(this).delegatecall(data[i]);
            if (!success) {
                assembly ("memory-safe") {
                    revert(add(32, returnData), mload(returnData))
                }
            }
        }
    }

    /* CONSTRUCTOR */

    constructor(
        address networkRegistry,
        address vaultFactory,
        address delegatorFactory,
        uint64 entityType,
        address networkMiddlewareService
    ) Entity(delegatorFactory, entityType) {
        NETWORK_REGISTRY = networkRegistry;
        VAULT_FACTORY = vaultFactory;
        NETWORK_MIDDLEWARE_SERVICE = networkMiddlewareService;
    }

    /// @inheritdoc IUniversalDelegator
    function VERSION() public pure returns (uint64) {
        return 2;
    }

    /* VIEW FUNCTIONS */

    /// @inheritdoc IUniversalDelegator
    function stakeForAt(bytes32 subnetwork, address operator, uint48 duration, uint48 timestamp)
        public
        view
        returns (uint256)
    {
        return _maxNetworkLimit[subnetwork].upperLookupRecent(timestamp) > 0
            ? getAllocatedAt(subnetwork, operator, duration, timestamp)
            : 0;
    }

    /// @inheritdoc IUniversalDelegator
    function stakeFor(bytes32 subnetwork, address operator, uint48 duration) public view returns (uint256) {
        return _maxNetworkLimit[subnetwork].latest() > 0 ? getAllocated(subnetwork, operator, duration) : 0;
    }

    /// @inheritdoc IUniversalDelegator
    function stakeAt(bytes32 subnetwork, address operator, uint48 timestamp, bytes calldata)
        public
        view
        returns (uint256)
    {
        if (timestamp < migrateTimestamp) {
            // Legacy support.
            return IBaseDelegator(oldDelegator).stakeAt(subnetwork, operator, timestamp, "");
        }
        return getAllocatedAt(subnetwork, operator, _getEpochDuration() - 1, timestamp);
    }

    /// @inheritdoc IUniversalDelegator
    function stake(bytes32 subnetwork, address operator) public view returns (uint256) {
        return getAllocated(subnetwork, operator, _getEpochDuration() - 1);
    }

    /// @inheritdoc IUniversalDelegator
    function getSlot(uint96 index) public view returns (Slot memory) {
        return Slot({
            exists: slots[index].exists,
            nextSlot: uint32(slots[index].nextSlot.latest()),
            prevSlot: slots[index].prevSlot,
            totalChildren: slots[index].totalChildren,
            existChildren: slots[index].existChildren,
            firstChild: uint32(slots[index].firstChild.latest()),
            lastChild: uint32(slots[index].lastChild.latest()),
            isShared: slots[index].isShared,
            noPlugins: slots[index].noPlugins,
            size: uint128(slots[index].size.latest()),
            prevSizeSum: _getPrevSizeSum(index),
            subnetworkOrOperator: index.getDepth() == 3
                ? bytes20(_slotToOperator[index])
                : index.getDepth() == 2 ? _slotToNetwork[index] : bytes32(0)
        });
    }

    /// @inheritdoc IUniversalDelegator
    function getPendingAt(uint96 index, uint48 duration, uint48 timestamp) public view returns (uint208) {
        return _getPendingAt(slots[index].pendingCumulative, slots[index].clearedPendingCursor, duration, timestamp);
    }

    /// @inheritdoc IUniversalDelegator
    function getPending(uint96 index, uint48 duration) public view returns (uint208) {
        return _getPending(slots[index].pendingCumulative, slots[index].clearedPendingCursor, duration);
    }

    /// @inheritdoc IUniversalDelegator
    function getBalanceAt(uint96 index, uint48 duration, uint48 timestamp) public view returns (uint256) {
        unchecked {
            return index > 0
                ? getAllocatedAt(index, duration, timestamp)
                : VaultV2(vault).activeStakeAt(timestamp, "")
                    + VaultV2(vault).activeWithdrawalsForAt(duration, timestamp);
        }
    }

    /// @inheritdoc IUniversalDelegator
    function getBalance(uint96 index, uint48 duration) public view returns (uint256) {
        unchecked {
            return index > 0
                ? getAllocated(index, duration)
                : VaultV2(vault).activeStake() + VaultV2(vault).activeWithdrawalsFor(duration);
        }
    }

    /// @inheritdoc IUniversalDelegator
    function getAllocatedAt(uint96 index, uint48 duration, uint48 timestamp) public view returns (uint256) {
        unchecked {
            if (duration >= _getEpochDuration()) {
                return 0;
            }
            uint96 parentIndex = index.getParentIndex();
            uint256 slotBalance = getBalanceAt(parentIndex, duration, timestamp);
            if (parentIndex.getDepth() != 1 || !slots[parentIndex].isShared) {
                slotBalance = slotBalance.saturatingSub(_getPrevSumAt(index, 0, timestamp));
            }
            return FixedPointMathLib.min(slotBalance, _getPendingSizeAt(index, duration, timestamp));
        }
    }

    /// @inheritdoc IUniversalDelegator
    function getAllocated(uint96 index, uint48 duration) public view returns (uint256) {
        unchecked {
            if (duration >= _getEpochDuration()) {
                return 0;
            }
            uint96 parentIndex = index.getParentIndex();
            uint256 slotBalance = getBalance(parentIndex, duration);
            if (parentIndex.getDepth() == 1 && slots[parentIndex].isShared) {
                if (VaultV2(vault).slasher() == msg.sender) {
                    // Support slashing without captureTimestamp for shared subvaults.
                    slotBalance += _getSharedPendingGuarantee(index, duration) + _getSharedSizeGuarantee(index);
                }
            } else {
                slotBalance = slotBalance.saturatingSub(_getPrevSum(index, 0));
            }
            return FixedPointMathLib.min(slotBalance, _getPendingSize(index, duration));
        }
    }

    /// @inheritdoc IUniversalDelegator
    function getSlotOfNetworkAt(bytes32 subnetwork, uint48 timestamp) public view returns (uint96) {
        return uint96(_networkToSlot[subnetwork].upperLookupRecent(timestamp));
    }

    /// @inheritdoc IUniversalDelegator
    function getSlotOfNetwork(bytes32 subnetwork) public view returns (uint96) {
        return uint96(_networkToSlot[subnetwork].latest());
    }

    /// @inheritdoc IUniversalDelegator
    function getSlotOfOperatorAt(uint96 parentIndex, address operator, uint48 timestamp) public view returns (uint96) {
        return uint96(_operatorToSlot[parentIndex][operator].upperLookupRecent(timestamp));
    }

    /// @inheritdoc IUniversalDelegator
    function getSlotOfOperator(uint96 parentIndex, address operator) public view returns (uint96) {
        return uint96(_operatorToSlot[parentIndex][operator].latest());
    }

    /// @inheritdoc IUniversalDelegator
    function getSlotOfAt(bytes32 subnetwork, address operator, uint48 timestamp) public view returns (uint96) {
        return getSlotOfOperatorAt(getSlotOfNetworkAt(subnetwork, timestamp), operator, timestamp);
    }

    /// @inheritdoc IUniversalDelegator
    function getSlotOf(bytes32 subnetwork, address operator) public view returns (uint96) {
        return getSlotOfOperator(getSlotOfNetwork(subnetwork), operator);
    }

    /// @inheritdoc IUniversalDelegator
    function getAllocatedAt(bytes32 subnetwork, address operator, uint48 duration, uint48 timestamp)
        public
        view
        returns (uint256)
    {
        uint96 index = getSlotOfAt(subnetwork, operator, timestamp);
        return index > 0 ? getAllocatedAt(index, duration, timestamp) : 0;
    }

    /// @inheritdoc IUniversalDelegator
    function getAllocated(bytes32 subnetwork, address operator, uint48 duration) public view returns (uint256) {
        uint96 index = getSlotOf(subnetwork, operator);
        return index > 0 ? getAllocated(index, duration) : 0;
    }

    /// @inheritdoc IUniversalDelegator
    function getFilledAt(uint96 index, uint48 duration, uint48 timestamp) public view returns (uint256 filled) {
        unchecked {
            for (
                uint32 childIndex = uint32(slots[index].firstChild.upperLookupRecent(timestamp));
                childIndex > 0 && childIndex < WITHDRAWAL_BUFFER_CHILD_INDEX;

            ) {
                uint96 childSlotIndex = index.createIndex(childIndex);
                filled += getAllocatedAt(childSlotIndex, duration, timestamp);
                childIndex = uint32(slots[childSlotIndex].nextSlot.upperLookupRecent(timestamp));
            }
        }
    }

    /// @inheritdoc IUniversalDelegator
    function getFilled(uint96 index, uint48 duration) public view returns (uint256 filled) {
        unchecked {
            for (
                uint32 childIndex = uint32(slots[index].firstChild.latest());
                childIndex > 0 && childIndex < WITHDRAWAL_BUFFER_CHILD_INDEX;

            ) {
                uint96 childSlotIndex = index.createIndex(childIndex);
                filled += getAllocated(childSlotIndex, duration);
                childIndex = uint32(slots[childSlotIndex].nextSlot.latest());
            }
        }
    }

    /// @inheritdoc IUniversalDelegator
    function maxNetworkLimit(bytes32 subnetwork) public view returns (uint256) {
        if (_maxNetworkLimit[subnetwork].length() == 0 && migrateTimestamp > 0) {
            // Legacy support.
            return IBaseDelegator(oldDelegator).maxNetworkLimit(subnetwork) > 0 ? type(uint208).max : 0;
        }
        return _maxNetworkLimit[subnetwork].latest();
    }

    /// @inheritdoc IUniversalDelegator
    function getIsShared(bytes32 subnetwork) public view returns (bool) {
        uint96 index = getSlotOfNetwork(subnetwork);
        if (index == 0) {
            revert NotAssigned();
        }
        return slots[index.getParentIndex()].isShared;
    }

    /// @inheritdoc IUniversalDelegator
    function getIsNoPlugins(bytes32 subnetwork) public view returns (bool) {
        uint96 index = getSlotOfNetwork(subnetwork);
        if (index == 0) {
            revert NotAssigned();
        }
        return slots[index.getParentIndex()].noPlugins;
    }

    /// @inheritdoc IUniversalDelegator
    function getNoPluginsSize() public view returns (uint256) {
        return _noPluginsSize + _getPending(_noPluginsPendingCumulative, _clearedNoPluginsPendingCursor, 0);
    }

    /// @inheritdoc IUniversalDelegator
    function getWithdrawalBuffer() public view returns (uint256) {
        return getAllocated(WITHDRAWAL_BUFFER_INDEX, 0);
    }

    /* PUBLIC FUNCTIONS (CURATOR) */

    /// @inheritdoc IUniversalDelegator
    function createSlot(bytes32 subnetworkOrOperator, uint96 parentIndex, bool isShared, bool noPlugins, uint128 size)
        public
        onlyRole(CREATE_SLOT_ROLE)
        returns (uint96 index)
    {
        return _createSlot(subnetworkOrOperator, parentIndex, isShared, noPlugins, size);
    }

    /// @dev Create a new slot.
    function _createSlot(bytes32 subnetworkOrOperator, uint96 parentIndex, bool isShared, bool noPlugins, uint128 size)
        internal
        syncPrevSizeSums(parentIndex)
        returns (uint96 index)
    {
        _revertIfNotExists(parentIndex);
        unchecked {
            if (parentIndex.getDepth() > 0 && (isShared || noPlugins)) {
                revert WrongDepth();
            }

            SlotStorage storage parent = slots[parentIndex];
            if (
                ++parent.existChildren
                    > (parentIndex.getDepth() == 0
                            ? MAX_SUBVAULTS
                            : parentIndex.getDepth() == 1 ? MAX_NETWORKS : MAX_OPERATORS)
            ) {
                revert TooManyChildren();
            }
            ++parent.totalChildren;

            index = parentIndex.createIndex(parent.totalChildren);

            if (parentIndex.getDepth() == 1) {
                if (_networkToSlot[subnetworkOrOperator].latest() > 0) {
                    revert AlreadyAssigned();
                }
                _networkToSlot[subnetworkOrOperator].push(uint48(block.timestamp), index);
                _slotToNetwork[index] = subnetworkOrOperator;

                // Legacy support.
                if (_maxNetworkLimit[subnetworkOrOperator].length() == 0 && migrateTimestamp > 0) {
                    _maxNetworkLimit[subnetworkOrOperator].push(
                        uint48(block.timestamp),
                        maxNetworkLimit(subnetworkOrOperator) > 0 && parentIndex.getChildIndex() == 1
                            ? type(uint208).max
                            : 0
                    );
                }
            } else if (parentIndex.getDepth() == 2) {
                if (_operatorToSlot[parentIndex][address(bytes20(subnetworkOrOperator))].latest() > 0) {
                    revert AlreadyAssigned();
                }
                _operatorToSlot[parentIndex][address(
                        bytes20(subnetworkOrOperator)
                    )].push(uint48(block.timestamp), index);
                _slotToOperator[index] = address(bytes20(subnetworkOrOperator));
            }

            SlotStorage storage slot = slots[index];

            slot.exists = true;
            if (parent.firstChild.latest() == 0) {
                parent.firstChild.push(uint48(block.timestamp), index.getChildIndex());
            } else {
                uint96 lastIndex = parentIndex.createIndex(uint32(parent.lastChild.latest()));
                slots[lastIndex].nextSlot.push(uint48(block.timestamp), index.getChildIndex());
                slot.prevSlot = uint32(parent.lastChild.latest());
            }
            parent.lastChild.push(uint48(block.timestamp), index.getChildIndex());
            if (size > 0) {
                slot.size.push(uint48(block.timestamp), size);
            }

            if (parentIndex.getDepth() == 0) {
                slots[index].nextSlot.push(uint48(block.timestamp), WITHDRAWAL_BUFFER_CHILD_INDEX);
                slot.isShared = isShared;
                if (noPlugins) {
                    if (size > VaultV2(vault).allocatable()) {
                        revert NotEnoughNoPlugins();
                    }
                    slot.noPlugins = true;
                    _noPluginsSize += size;
                }
            } else if (parentIndex.getDepth() == 1 && parent.isShared) {
                slot.sharedPendingConsumedCursor.push(uint48(block.timestamp), parent.clearedPendingCursor.latest());
                slot.sharedSizeConsumedCumulative
                    .push(uint48(block.timestamp), parent.sharedSizeConsumedCumulative.latest());
            }

            emit CreateSlot(index, isShared, noPlugins, size);
        }
    }

    /// @inheritdoc IUniversalDelegator
    function setSize(uint96 index, uint128 newSize)
        public
        onlyRole(SET_SIZE_ROLE)
        syncPrevSizeSums(index.getParentIndex())
    {
        _revertIfNotExists(index);
        unchecked {
            SlotStorage storage slot = slots[index];
            uint128 curSize = uint128(slot.size.latest());
            if (curSize == newSize) {
                return;
            }
            uint96 parentIndex = index.getParentIndex();
            SlotStorage storage parent = slots[parentIndex];

            if (newSize > curSize) {
                uint48 maxDuration = _getEpochDuration() - 1;
                uint256 curBalance = getBalance(parentIndex, 0);
                uint256 minBalance = getBalance(parentIndex, maxDuration);
                if (
                    !parent.isShared && _getPrevSum(index, maxDuration) + curSize < curBalance
                        && slot.nextSlot.latest() > 0 && slot.nextSlot.latest() < WITHDRAWAL_BUFFER_CHILD_INDEX
                ) {
                    uint96 lastIndex = parentIndex.createIndex(uint32(parent.lastChild.latest()));
                    if (
                        newSize - curSize
                            > minBalance.saturatingSub(
                                _getPrevSum(lastIndex, 0) + slots[lastIndex].size.latest() + getPending(lastIndex, 0)
                            )
                    ) {
                        revert NotEnoughBalance();
                    }
                }
                if (slot.noPlugins && newSize - curSize > VaultV2(vault).allocatable()) {
                    revert NotEnoughNoPlugins();
                }
            } else {
                uint208 addPending = uint208(getAllocated(index, 0).saturatingSub(getPending(index, 0) + newSize));
                if (addPending > 0) {
                    parent._childrenPendingAt = uint48(block.timestamp);
                    slot.pendingCumulative.push(uint48(block.timestamp), slot.pendingCumulative.latest() + addPending);
                    if (slot.noPlugins) {
                        _noPluginsPendingCumulative.push(
                            uint48(block.timestamp), _noPluginsPendingCumulative.latest() + addPending
                        );
                    }
                }
            }
            slot.size.push(uint48(block.timestamp), newSize);
            if (slot.noPlugins) {
                _noPluginsSize = _noPluginsSize - curSize + newSize;
            }

            emit SetSize(index, newSize);
        }
    }

    /// @inheritdoc IUniversalDelegator
    function swapSlots(uint96 index1, uint96 index2)
        public
        onlyRole(SWAP_SLOTS_ROLE)
        syncPrevSizeSums(index1.getParentIndex())
    {
        _revertIfNotExists(index1);
        _revertIfNotExists(index2);
        unchecked {
            uint96 parentIndex = index1.getParentIndex();
            SlotStorage storage parent = slots[parentIndex];

            if (parentIndex != index2.getParentIndex()) {
                revert NotSameParent();
            }
            if (parent.isShared) {
                revert IsShared();
            }
            for (
                uint32 childIndex = index2.getChildIndex();
                childIndex > 0;
                childIndex = uint32(slots[parentIndex.createIndex(childIndex)].nextSlot.latest())
            ) {
                if (childIndex == index1.getChildIndex()) {
                    revert WrongOrder();
                }
            }
            {
                uint48 maxDuration = _getEpochDuration() - 1;
                uint256 minBalance = getBalance(parentIndex, maxDuration);
                uint256 curPrevSum = _getPrevSum(index2, 0);

                // - slot2 fully allocated at maxDuration (epochDuration - 1) => slot1 is fully allocated too,
                // - slot1 unallocated at duration=0 => slot2 is unallocated too,
                // - otherwise, revert.
                if (curPrevSum < minBalance) {
                    if (curPrevSum + slots[index2].size.latest() + getPending(index2, 0) > minBalance) {
                        revert PartiallyAllocated();
                    }
                } else if (_getPrevSum(index1, maxDuration) < getBalance(parentIndex, 0)) {
                    revert NotSameAllocated();
                }
            }

            if (index1.getChildIndex() == parent.firstChild.latest()) {
                parent.firstChild.push(uint48(block.timestamp), index2.getChildIndex());
            }
            if (index2.getChildIndex() == parent.lastChild.latest()) {
                parent.lastChild.push(uint48(block.timestamp), index1.getChildIndex());
            }

            SlotStorage storage slot1 = slots[index1];
            SlotStorage storage slot2 = slots[index2];

            uint32 nextSlot1 = uint32(slot1.nextSlot.latest());
            slot1.nextSlot.push(uint48(block.timestamp), uint32(slot2.nextSlot.latest()));
            slot2.nextSlot.push(uint48(block.timestamp), nextSlot1);

            if (slot1.nextSlot.latest() > 0) {
                slots[parentIndex.createIndex(uint32(slot1.nextSlot.latest()))].prevSlot = index1.getChildIndex();
            }
            slots[parentIndex.createIndex(uint32(slot2.nextSlot.latest()))].prevSlot = index2.getChildIndex();

            (slot1.prevSlot, slot2.prevSlot) = (slot2.prevSlot, slot1.prevSlot);

            slots[parentIndex.createIndex(slot1.prevSlot)].nextSlot
                .push(uint48(block.timestamp), index1.getChildIndex());
            if (slot2.prevSlot > 0) {
                slots[parentIndex.createIndex(uint32(slot2.prevSlot))].nextSlot
                    .push(uint48(block.timestamp), index2.getChildIndex());
            }

            emit SwapSlots(index1, index2);
        }
    }

    /// @inheritdoc IUniversalDelegator
    function removeSlot(uint96 index) public onlyRole(REMOVE_SLOT_ROLE) syncPrevSizeSums(index.getParentIndex()) {
        _revertIfNotExists(index);
        if (getAllocated(index, 0) > 0) {
            revert SlotAllocated();
        }

        _removeSlot(index);
        emit RemoveSlot(index);
    }

    /// @dev Remove a slot from the linked-list structure and mark it as non-existent.
    function _removeSlot(uint96 index) internal {
        unchecked {
            SlotStorage storage slot = slots[index];
            uint96 parentIndex = index.getParentIndex();
            SlotStorage storage parent = slots[parentIndex];

            if (index.getDepth() == 1) {
                for (
                    uint32 childIndex = uint32(slot.firstChild.latest());
                    childIndex > 0 && childIndex < WITHDRAWAL_BUFFER_CHILD_INDEX;

                ) {
                    uint96 curIndex = index.createIndex(childIndex);
                    bytes32 subnetwork = _slotToNetwork[curIndex];
                    _networkToSlot[subnetwork].push(uint48(block.timestamp), 0);
                    _slotToNetwork[curIndex] = bytes32(0);
                    if (_maxNetworkLimit[subnetwork].latest() > 0) {
                        _maxNetworkLimit[subnetwork].push(uint48(block.timestamp), 0);
                    }
                    childIndex = uint32(slots[curIndex].nextSlot.latest());
                }
            } else if (index.getDepth() == 2) {
                bytes32 subnetwork = _slotToNetwork[index];
                _networkToSlot[subnetwork].push(uint48(block.timestamp), 0);
                _slotToNetwork[index] = bytes32(0);
                if (_maxNetworkLimit[subnetwork].latest() > 0) {
                    _maxNetworkLimit[subnetwork].push(uint48(block.timestamp), 0);
                }
            } else if (index.getDepth() == 3) {
                _operatorToSlot[parentIndex][_slotToOperator[index]].push(uint48(block.timestamp), 0);
                _slotToOperator[index] = address(0);
            }

            if (index.getChildIndex() == parent.firstChild.latest()) {
                uint32 nextChildIndex = uint32(slot.nextSlot.latest());
                parent.firstChild
                    .push(
                        uint48(block.timestamp),
                        index.getDepth() > 1 || nextChildIndex < WITHDRAWAL_BUFFER_CHILD_INDEX ? nextChildIndex : 0
                    );
            } else {
                slots[parentIndex.createIndex(slot.prevSlot)].nextSlot
                    .push(uint48(block.timestamp), uint32(slot.nextSlot.latest()));
            }
            if (index.getChildIndex() == parent.lastChild.latest()) {
                parent.lastChild.push(uint48(block.timestamp), slot.prevSlot);
            } else {
                slots[parentIndex.createIndex(uint32(slot.nextSlot.latest()))].prevSlot = slot.prevSlot;
            }

            if (index.getDepth() == 1 && slot.noPlugins) {
                uint208 pending = getPending(index, 0);
                if (pending > 0) {
                    _clearedNoPluginsPendingCursor.push(uint48(block.timestamp), _getNoPluginsPendingCursor() + pending);
                }

                _noPluginsSize -= slot.size.latest();
            }

            --parent.existChildren;
            slot.exists = false;
        }
    }

    /// @inheritdoc IUniversalDelegator
    function setWithdrawalBufferSize(uint128 newWithdrawalBufferSize) public onlyRole(SET_WITHDRAWAL_BUFFER_SIZE_ROLE) {
        _withdrawalBufferSlot().size.push(uint48(block.timestamp), newWithdrawalBufferSize);

        emit SetWithdrawalBufferSize(newWithdrawalBufferSize);
    }

    /// @inheritdoc IUniversalDelegator
    function setHook(address newHook) public nonReentrant onlyRole(HOOK_SET_ROLE) {
        hook = newHook;

        emit SetHook(newHook);
    }

    /* PUBLIC FUNCTIONS (NETWORK) */

    /// @inheritdoc IUniversalDelegator
    function setMaxNetworkLimit(uint96 identifier, uint256 amount) public {
        if (!IRegistry(NETWORK_REGISTRY).isEntity(msg.sender)) {
            revert NotNetwork();
        }
        bytes32 subnetwork = (msg.sender).subnetwork(identifier);
        if (maxNetworkLimit(subnetwork) > 0) {
            revert AlreadySet();
        }
        if (amount < type(uint256).max) {
            revert LimitNotUint256Max();
        }
        _maxNetworkLimit[subnetwork].push(uint48(block.timestamp), type(uint208).max);

        emit SetMaxNetworkLimit(subnetwork, amount);
    }

    /// @inheritdoc IUniversalDelegator
    function resetAllocation(bytes32 subnetwork) public {
        unchecked {
            if (
                !IRegistry(NETWORK_REGISTRY).isEntity(subnetwork.network())
                    || (subnetwork.network() != msg.sender
                        && INetworkMiddlewareService(NETWORK_MIDDLEWARE_SERVICE).middleware(subnetwork.network())
                            != msg.sender)
            ) {
                revert NotNetworkOrMiddleware();
            }

            uint96 index = getSlotOfNetwork(subnetwork);
            if (index == 0) {
                revert NotAssigned();
            }
            if (slots[index.getParentIndex()].existChildren == 1) {
                index = index.getParentIndex();
            }
            SlotStorage storage slot = slots[index];
            SlotStorage storage parent = slots[index.getParentIndex()];

            if (
                slot.size.latest() > 0 && parent.syncPrevSizeSums.latest() == 0
                    && (index.getDepth() == 1 || (!parent.isShared && slot.nextSlot.latest() > 0))
            ) {
                parent.syncPrevSizeSums.push(uint48(block.timestamp), 1);
            }

            // Remove slot to restrict from slashing.
            _removeSlot(index);

            emit ResetAllocation(index, subnetwork);
        }
    }

    /* PUBLIC FUNCTIONS (INTERNAL LOGIC) */

    /// @dev Apply slash accounting updates across the affected slot chain and invoke the optional hook.
    function onSlash(bytes32 subnetwork, address operator, uint256 amount, bytes calldata data)
        public
        nonReentrant
        returns (uint256 actualAmount)
    {
        unchecked {
            if (VaultV2(vault).slasher() != msg.sender) {
                revert NotSlasher();
            }

            actualAmount = amount;
            uint96 index = getSlotOf(subnetwork, operator);
            uint96 networkIndex = index.getParentIndex();

            // Adjust slot's and its parents' allocations.
            for (uint96 curIndex = index; curIndex > 0;) {
                SlotStorage storage slot = slots[curIndex];
                SlotStorage storage parent = slots[curIndex.getParentIndex()];
                uint208 pendingSlashed = uint208(FixedPointMathLib.min(getPending(curIndex, 0), amount));
                uint128 sizeSlashed = uint128(FixedPointMathLib.min(slot.size.latest(), amount - pendingSlashed));
                actualAmount = FixedPointMathLib.min(actualAmount, pendingSlashed + sizeSlashed);
                if (curIndex.getDepth() == 1 && slot.isShared) {
                    // Actual slashed amount can be lower than requested due to slashing by multiple shared networks.
                    actualAmount = FixedPointMathLib.min(actualAmount, getAllocated(curIndex, 0));
                }
                if (pendingSlashed > 0) {
                    // Clear slot's pending.
                    slot.clearedPendingCursor
                        .push(uint48(block.timestamp), _getPendingCursor(curIndex) + pendingSlashed);

                    // Clear no-plugins pending.
                    if (curIndex.getDepth() == 1 && slot.noPlugins) {
                        _clearedNoPluginsPendingCursor.push(
                            uint48(block.timestamp), _getNoPluginsPendingCursor() + pendingSlashed
                        );
                    }
                }
                if (sizeSlashed > 0) {
                    // Clear slot's size.
                    slot.size.push(uint48(block.timestamp), slot.size.latest() - sizeSlashed);
                    if (
                        parent.syncPrevSizeSums.latest() == 0
                            && (curIndex.getDepth() == 1
                                || ((curIndex.getDepth() == 3 || !parent.isShared) && slot.nextSlot.latest() > 0))
                    ) {
                        parent.syncPrevSizeSums.push(uint48(block.timestamp), 1);
                    }
                    if (curIndex.getDepth() == 1 && slot.noPlugins) {
                        // Clear no-plugins size.
                        _noPluginsSize -= sizeSlashed;
                    }
                }
                if (curIndex.getDepth() == 1 && slot.isShared) {
                    // Consume guarantees for shared subvault.
                    if (sizeSlashed > 0) {
                        slot.sharedSizeConsumedCumulative
                            .push(uint48(block.timestamp), slot.sharedSizeConsumedCumulative.latest() + sizeSlashed);
                    }
                    uint208 pendingConsumed =
                        uint208(FixedPointMathLib.min(_getSharedPendingGuarantee(networkIndex, 0), amount));
                    if (pendingConsumed > 0) {
                        slots[networkIndex].sharedPendingConsumedCursor
                            .push(uint48(block.timestamp), _getSharedPendingCursor(networkIndex) + pendingConsumed);
                    }
                    uint208 sizeConsumed =
                        uint208(FixedPointMathLib.min(_getSharedSizeGuarantee(networkIndex), amount - pendingConsumed));
                    if (sizeConsumed > 0) {
                        slots[networkIndex].sharedSizeConsumedCumulative
                            .push(uint48(block.timestamp), _getSharedSizeCursor(networkIndex) + sizeConsumed);
                    }
                }
                curIndex = curIndex.getParentIndex();
            }

            // Make a call to the custom hook.
            address hook_ = hook;
            if (hook_ != address(0)) {
                bytes memory hookCalldata = abi.encodeCall(IDelegatorHook.onSlash, (subnetwork, operator, amount, data));

                if (gasleft() < HOOK_RESERVE + HOOK_GAS_LIMIT * 64 / 63) {
                    revert InsufficientHookGas();
                }

                assembly ("memory-safe") {
                    pop(call(HOOK_GAS_LIMIT, hook_, 0, add(hookCalldata, 0x20), mload(hookCalldata), 0, 0))
                }
            }

            emit OnSlash(subnetwork, operator, amount);
        }
    }

    /* INITIALIZATION */

    /// @dev Initialize delegator state from encoded initialization parameters.
    function _initialize(bytes calldata data) internal override {
        (address initVault, bytes memory initData) = abi.decode(data, (address, bytes));

        if (!IRegistry(VAULT_FACTORY).isEntity(initVault)) {
            revert NotVault();
        }
        if (IMigratableEntity(initVault).version() < VAULT_V2_VERSION) {
            revert OldVault();
        }

        InitParams memory params = abi.decode(initData, (InitParams));

        __ReentrancyGuard_init();

        vault = initVault;

        hook = params.hook;

        _withdrawalBufferSlot().size.push(uint48(block.timestamp), params.withdrawalBufferSize);

        _grantRoleIfNotZero(DEFAULT_ADMIN_ROLE, params.defaultAdminRoleHolder);
        _grantRoleIfNotZero(HOOK_SET_ROLE, params.hookSetRoleHolder);
        _grantRoleIfNotZero(CREATE_SLOT_ROLE, params.createSlotRoleHolder);
        _grantRoleIfNotZero(SET_SIZE_ROLE, params.setSizeRoleHolder);
        _grantRoleIfNotZero(SWAP_SLOTS_ROLE, params.swapSlotsRoleHolder);

        emit Initialize(params);
    }

    /* MIGRATION */

    /// @dev Migrate delegator state from the previously configured delegator.
    function migrate(address oldDelegator_) public {
        if (vault != msg.sender) {
            revert NotVault();
        }
        migrateTimestamp = uint48(block.timestamp);
        oldDelegator = oldDelegator_;

        _createSlot(
            bytes32(0),
            0,
            IEntity(oldDelegator_).TYPE() < OPERATOR_NETWORK_SPECIFIC_DELEGATOR_TYPE,
            true,
            uint128(FixedPointMathLib.min(VaultV2(vault).allocatable(), type(uint128).max))
        );
    }

    /* UTILITY FUNCTIONS */

    /// @dev Get the pending size at a specific timestamp.
    function _getPendingSizeAt(uint96 index, uint48 duration, uint48 timestamp) internal view returns (uint208) {
        unchecked {
            return slots[index].size.upperLookupRecent(timestamp) + getPendingAt(index, duration, timestamp);
        }
    }

    /// @dev Return current slot size plus pending stake within the requested duration window.
    function _getPendingSize(uint96 index, uint48 duration) internal view returns (uint208) {
        unchecked {
            return slots[index].size.latest() + getPending(index, duration);
        }
    }

    /// @dev Return the prefix sum of previous sibling sizes at a timestamp.
    function _getPrevSizeSumAt(uint96 index, uint48 timestamp) internal view returns (uint208 prevSizeSum) {
        unchecked {
            if (index == 0) {
                return 0;
            }
            uint96 parentIndex = index.getParentIndex();
            SlotStorage storage parent = slots[parentIndex];
            if (parentIndex.getDepth() == 1 && parent.isShared) {
                return 0;
            }
            if (parent.syncPrevSizeSums.upperLookupRecent(timestamp) == 0) {
                return slots[index].prevSizeSum.upperLookupRecent(timestamp);
            }
            for (uint32 childIndex = uint32(parent.firstChild.upperLookupRecent(timestamp)); childIndex > 0;) {
                uint96 curIndex = parentIndex.createIndex(childIndex);
                if (index == curIndex) {
                    break;
                }
                prevSizeSum += slots[curIndex].size.upperLookupRecent(timestamp);
                childIndex = uint32(slots[curIndex].nextSlot.upperLookupRecent(timestamp));
            }
        }
    }

    /// @dev Return the current prefix sum of previous sibling sizes.
    function _getPrevSizeSum(uint96 index) internal view returns (uint208 prevSizeSum) {
        unchecked {
            if (index == 0) {
                return 0;
            }
            uint96 parentIndex = index.getParentIndex();
            SlotStorage storage parent = slots[parentIndex];
            if (parentIndex.getDepth() == 1 && parent.isShared) {
                return 0;
            }
            if (parent.syncPrevSizeSums.latest() == 0) {
                return slots[index].prevSizeSum.latest();
            }
            for (uint32 childIndex = uint32(parent.firstChild.latest()); childIndex > 0;) {
                uint96 curIndex = parentIndex.createIndex(childIndex);
                if (index == curIndex) {
                    break;
                }
                prevSizeSum += slots[curIndex].size.latest();
                childIndex = uint32(slots[curIndex].nextSlot.latest());
            }
        }
    }

    /// @dev Return the prefix sum of previous sibling pending amounts within the duration window at a timestamp.
    function _getPrevPendingSumAt(uint96 index, uint48 duration, uint48 timestamp)
        internal
        view
        returns (uint208 prevPendingSum)
    {
        unchecked {
            if (index == 0) {
                return 0;
            }
            uint96 parentIndex = index.getParentIndex();
            SlotStorage storage parent = slots[parentIndex];
            if (parentIndex.getDepth() == 1 && parent.isShared) {
                return 0;
            }
            for (uint32 childIndex = uint32(parent.firstChild.upperLookupRecent(timestamp)); childIndex > 0;) {
                uint96 curIndex = parentIndex.createIndex(childIndex);
                if (index == curIndex) {
                    break;
                }
                prevPendingSum += getPendingAt(curIndex, duration, timestamp);
                childIndex = uint32(slots[curIndex].nextSlot.upperLookupRecent(timestamp));
            }
        }
    }

    /// @dev Return the current prefix sum of previous sibling pending amounts within the duration window.
    function _getPrevPendingSum(uint96 index, uint48 duration) internal view returns (uint208 prevPendingSum) {
        unchecked {
            if (index == 0) {
                return 0;
            }
            uint96 parentIndex = index.getParentIndex();
            SlotStorage storage parent = slots[parentIndex];
            if (parentIndex.getDepth() == 1 && parent.isShared) {
                return 0;
            }
            if (
                parent._childrenPendingAt
                    <= block.timestamp.saturatingSub(uint256(_getEpochDuration()).saturatingSub(duration))
            ) {
                return 0;
            }
            for (uint32 childIndex = uint32(parent.firstChild.latest()); childIndex > 0;) {
                uint96 curIndex = parentIndex.createIndex(childIndex);
                if (index == curIndex) {
                    break;
                }
                prevPendingSum += getPending(curIndex, duration);
                childIndex = uint32(slots[curIndex].nextSlot.latest());
            }
        }
    }

    /// @dev Return the total size-plus-pending prefix sum of previous siblings at a timestamp.
    function _getPrevSumAt(uint96 index, uint48 duration, uint48 timestamp) internal view returns (uint208) {
        unchecked {
            return _getPrevSizeSumAt(index, timestamp) + _getPrevPendingSumAt(index, duration, timestamp);
        }
    }

    /// @dev Return the current total size-plus-pending prefix sum of previous siblings.
    function _getPrevSum(uint96 index, uint48 duration) internal view returns (uint208) {
        unchecked {
            return _getPrevSizeSum(index) + _getPrevPendingSum(index, duration);
        }
    }

    /// @dev Return the effective cleared-pending cursor for a slot in the current window.
    function _getPendingCursor(uint96 index) internal view returns (uint208) {
        return _getCursor(slots[index].pendingCumulative, slots[index].clearedPendingCursor);
    }

    /// @dev Return the effective cleared-pending cursor for the global no-plugins lane.
    function _getNoPluginsPendingCursor() internal view returns (uint208) {
        return _getCursor(_noPluginsPendingCumulative, _clearedNoPluginsPendingCursor);
    }

    /// @dev Return the effective shared-size consumption cursor for a network under a shared subvault.
    function _getSharedSizeCursor(uint96 networkIndex) internal view returns (uint208) {
        return _getCursor(
            slots[networkIndex.getParentIndex()].sharedSizeConsumedCumulative,
            slots[networkIndex].sharedSizeConsumedCumulative
        );
    }

    /// @dev Return the remaining shared size guarantee available to a network.
    function _getSharedSizeGuarantee(uint96 networkIndex) internal view returns (uint208) {
        return uint208(
            uint256(slots[networkIndex.getParentIndex()].sharedSizeConsumedCumulative.latest())
                .saturatingSub(_getSharedSizeCursor(networkIndex))
        );
    }

    /// @dev Return the effective shared pending cursor for a network under a shared subvault.
    function _getSharedPendingCursor(uint96 networkIndex) internal view returns (uint208) {
        return _getCursor(
            slots[networkIndex.getParentIndex()].clearedPendingCursor, slots[networkIndex].sharedPendingConsumedCursor
        );
    }

    /// @dev Return the remaining shared pending guarantee available to a network for the duration window.
    function _getSharedPendingGuarantee(uint96 networkIndex, uint48 duration) internal view returns (uint208) {
        return _getPending(
            slots[networkIndex.getParentIndex()].clearedPendingCursor,
            slots[networkIndex].sharedPendingConsumedCursor,
            duration
        );
    }

    /// @dev Return the effective cursor after applying the rolling epoch floor to a cumulative series.
    function _getCursor(Checkpoints_2.Trace208 storage base, Checkpoints_2.Trace208 storage cursor)
        internal
        view
        returns (uint208)
    {
        return uint208(
            FixedPointMathLib.max(
                base.upperLookupRecent(uint48(block.timestamp.saturatingSub(_getEpochDuration()))), cursor.latest()
            )
        );
    }

    /// @dev Return pending amount in a duration window at a specific timestamp.
    function _getPendingAt(
        Checkpoints_2.Trace208 storage base,
        Checkpoints_2.Trace208 storage cursor,
        uint48 duration,
        uint48 timestamp
    ) internal view returns (uint208) {
        unchecked {
            if (base.length() == 0) {
                return 0;
            }
            uint48 fromTimestamp =
                uint48(uint256(timestamp).saturatingSub(uint256(_getEpochDuration()).saturatingSub(duration)));
            (, uint48 lastPendingKey, uint208 pendingCumulativeLatest,) = base.upperLookupRecentCheckpoint(timestamp);
            if (lastPendingKey <= fromTimestamp) {
                return 0;
            }
            return pendingCumulativeLatest
                - uint208(
                FixedPointMathLib.max(base.upperLookupRecent(fromTimestamp), cursor.upperLookupRecent(timestamp))
            );
        }
    }

    /// @dev Return current pending amount in a duration window.
    function _getPending(Checkpoints_2.Trace208 storage base, Checkpoints_2.Trace208 storage cursor, uint48 duration)
        internal
        view
        returns (uint208)
    {
        unchecked {
            if (base.length() == 0) {
                return 0;
            }
            uint48 fromTimestamp =
                uint48(block.timestamp.saturatingSub(uint256(_getEpochDuration()).saturatingSub(duration)));
            (, uint48 lastPendingKey, uint208 pendingCumulativeLatest) = base.latestCheckpoint();
            if (lastPendingKey <= fromTimestamp) {
                return 0;
            }
            return pendingCumulativeLatest
                - uint208(FixedPointMathLib.max(base.upperLookupRecent(fromTimestamp), cursor.latest()));
        }
    }

    /// @dev Read the connected vault epoch duration.
    function _getEpochDuration() internal view returns (uint48) {
        return VaultV2(vault).epochDuration();
    }

    /// @dev Return storage pointer to the withdrawal buffer slot.
    function _withdrawalBufferSlot() internal view returns (SlotStorage storage) {
        return slots[WITHDRAWAL_BUFFER_INDEX];
    }

    /// @dev Revert when a non-zero slot index does not exist.
    function _revertIfNotExists(uint96 index) internal view {
        if (index > 0 && !slots[index].exists) {
            revert SlotNotExists();
        }
    }

    /// @dev Grant a role when the holder address is not zero.
    function _grantRoleIfNotZero(bytes32 role, address holder) internal {
        if (holder != address(0)) {
            _grantRole(role, holder);
        }
    }
}
