// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {ERC20} from "solady/src/tokens/ERC20.sol";
import {LibString} from "solady/src/utils/LibString.sol";
import {SafeTransferLib} from "solady/src/utils/SafeTransferLib.sol";
import {OwnableRoles} from "solady/src/auth/OwnableRoles.sol";

import {ReentrancyGuard} from "./utils/ReentrancyGuard.sol";
import {ICheezburgerFactory} from "./interfaces/ICheezburgerFactory.sol";
import {CheezburgerRegistry} from "./CheezburgerRegistry.sol";

abstract contract CheezburgerDeployerKit is
    ERC20,
    CheezburgerRegistry,
    ReentrancyGuard,
    OwnableRoles
{
    using LibString for uint256;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    error EmptyNumericUserId();
    error SocialNotOpened();
    error UserIdNotFound();
    error UserIdAlreadyExist(uint256 userId);
    error IncorrectPoolOpeningFee(uint256 value, uint256 expected);
    error SupplyOverflow();
    error CannotUseCHZBNamespace();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STRUCT                            */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    struct GlobalSettings {
        ICheezburgerFactory factory;
        address router;
    }

    struct SocialSettings {
        uint256 pairingAmount;
        uint256 leftSideSupply;
        uint256 openFeeWei;
        uint8 poolCreatorFeePercentage;
        DynamicSettings walletSettings;
        DynamicSettings feeSettings;
    }

    struct TokenSettings {
        uint256 pairingAmount;
        uint256 openFeeWei;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    event SocialTokenDeployed(
        uint256 indexed userId,
        address indexed token,
        uint256 indexed creationAmount,
        uint256 currentOutOfCirculationSupply
    );

    event SocialTokenFeeWithdrawal(
        address indexed pair,
        address indexed to,
        uint256 indexed amount
    );

    event LiquidityLessTokenDeployed(
        address indexed token,
        uint256 indexed creationAmount,
        uint256 currentOutOfCirculationSupply
    );

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STORAGE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    string internal _website;
    string internal _social;
    uint256 public outOfCirculationTokens;

    uint256 internal constant NAMESPACE_ROLE = _ROLE_5;

    GlobalSettings public globalSettings;
    SocialSettings public socialSettings;
    TokenSettings public tokenSettings;

    mapping(uint256 => Token) public socialTokens;
    mapping(address => uint256) public socialIds;

    /// @dev Deploy a new social token using bootstrapped CHZB liquidity
    /// @param userId User ID for the social token
    /// @dev Can be deployed from another contract but for gas reasons we'll let it here
    function deploySocialTokenWithCHZB(
        uint256 userId
    ) external payable nonReentrant returns (address) {
        // Ensure userId is valid
        if (userId == 0) {
            revert EmptyNumericUserId();
        }

        // Ensure userId doesn't already exist
        if (socialTokens[userId].leftSide != address(0)) {
            revert UserIdAlreadyExist(userId);
        }

        // Half liquidity is burned
        // Half is kept in the contract as a custodial
        address[] memory feeAddresses = new address[](2);
        feeAddresses[0] = address(0);
        feeAddresses[1] = address(this);

        // 50/50 fees split
        uint8[] memory feePercentages = new uint8[](1);
        feePercentages[0] = 50;

        // Transform the user ID to string for name and symbol
        string memory userIdString = userId.toString();

        Token memory token = _deployWithCHZB(
            TokenCustomization({
                name: LibString.concat(userIdString, " (Social)"),
                symbol: LibString.concat("CHZB-X-", userIdString),
                website: _website,
                social: _social,
                supply: socialSettings.leftSideSupply
            }),
            LiquiditySettings({
                feeThresholdPercent: 2,
                feeAddresses: feeAddresses,
                feePercentages: feePercentages
            }),
            socialSettings.feeSettings,
            socialSettings.walletSettings,
            socialSettings.poolCreatorFeePercentage > 0
                ? ReferralSettings({
                    feeReceiver: msg.sender,
                    feePercentage: socialSettings.poolCreatorFeePercentage
                })
                : ReferralSettings({feeReceiver: address(0), feePercentage: 0}),
            socialSettings.pairingAmount,
            socialSettings.openFeeWei
        );

        // Register ID
        socialTokens[userId] = token;
        socialIds[token.leftSide] = userId;

        emit SocialTokenDeployed(
            userId,
            token.leftSide,
            socialSettings.pairingAmount,
            outOfCirculationTokens
        );

        return address(token.leftSide);
    }

    /// @dev Deploy a new customized token with bootstrapped CHZB liquidity
    function deployTokenWithCHZB(
        TokenCustomization memory _customization,
        LiquiditySettings memory _liquidity,
        DynamicSettings memory _fee,
        DynamicSettings memory _wallet,
        ReferralSettings memory _referral
    ) external payable nonReentrant returns (address) {
        if (
            LibString.startsWith(_customization.symbol, "CHZB-") &&
            !hasAnyRole(msg.sender, NAMESPACE_ROLE)
        ) {
            revert CannotUseCHZBNamespace();
        }

        Token memory token = _deployWithCHZB(
            _customization,
            _liquidity,
            _fee,
            _wallet,
            _referral,
            tokenSettings.pairingAmount,
            tokenSettings.openFeeWei
        );

        emit LiquidityLessTokenDeployed(
            token.leftSide,
            tokenSettings.pairingAmount,
            outOfCirculationTokens
        );

        return address(token.leftSide);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                     INTERNAL FUNCTIONS                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function _deployWithCHZB(
        TokenCustomization memory _customization,
        LiquiditySettings memory _liquidity,
        DynamicSettings memory _fee,
        DynamicSettings memory _wallet,
        ReferralSettings memory _referral,
        uint256 _pairingAmount,
        uint256 _openingFee
    ) private returns (Token memory) {
        // Collect fee if any
        if (msg.value != _openingFee) {
            revert IncorrectPoolOpeningFee(msg.value, _openingFee);
        }

        // The tokens are used to pool with the token to give initial liquidity
        // This have no impact on price and they cannot be withdrawn as they are burned
        _mint(address(this), _pairingAmount);

        // Approve the Factory to use the created CHZB
        SafeTransferLib.safeApprove(
            address(this),
            address(globalSettings.factory),
            _pairingAmount
        );

        // Create the token
        address tokenAddress = globalSettings.factory.deployWithToken(
            _customization,
            globalSettings.router,
            address(this),
            _pairingAmount,
            _liquidity,
            _fee,
            _wallet,
            _referral
        );

        // Get token info
        Token memory token = getToken(globalSettings.factory, tokenAddress);

        // Burn liquidity
        SafeTransferLib.safeTransferAll(address(token.pair), address(0));

        // Update out of circulating supply data
        unchecked {
            if (totalSupply() > totalSupply() + _pairingAmount) {
                revert SupplyOverflow();
            }
            outOfCirculationTokens = outOfCirculationTokens + _pairingAmount;
        }

        return token;
    }

    /// @dev Allows to withdraw creation liquidity fees to a customized contract
    function _withdrawFeesOf(
        uint256 _userId,
        address _to
    ) internal returns (uint256) {
        address pair = address(socialTokens[_userId].pair);
        if (pair == address(0)) {
            revert UserIdNotFound();
        }
        uint256 amount = SafeTransferLib.safeTransferAll(pair, _to);
        emit SocialTokenFeeWithdrawal(pair, _to, amount);
        return amount;
    }
}
