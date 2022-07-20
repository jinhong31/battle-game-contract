contract BattleField {
  struct Character {
    uint8 state;
    uint8 element;
    uint256 power;
  }
  uint256 public POWER_BONUS = 10;
  uint256 public WIN_BONUS = 5;
  uint256 public ENTER_PRICE = 3 * 10 ** 18;
  mapping(uint256 => Character) characters;
  uint32 public total_characters = 100;

  enum public STATES = { NOTENTER, ENTERED, PICKED, FIGHT, LOST, WINNED};
  enum public ELEMENT_TYPES = { WATER, EARTH, ICE, AIR, FIRE, WATER }
  constructor() {
  }

  function enterGame(uint256 tokenID) external {
    _bToken.transferFrom(msg.sender, address(this), ENTER_PRICE);
    require(characters[tokenID] == 0, 'Already entered');
    characters[tokenID].state = STATES.ENTERED;
  }
  function _random() internal view returns (uint16) { // this will be replaced with Chainlink random oracle.
    uint16 randomNumber = uint16(uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp)))) % 100;
    return randomNumber;
  }
  function chooseEnemy(uint256 tokenID) external returns (uint256) {
    uint256 enemyID = _random(tokenID);
    return enemyID;
  }

  function fight(uint256 enemyID) external {
    uint32 winPercent = _calcWinPercent();
    uint16 randomN = _random();
    if(randomN >= winPercent)
      return 1;
    return 0;
  }

  function _calcWinPercent() internal {
    power_fighter = _getBattlePower();
    power_enemy = enemy.power;
    uint32 winPercent = 50 + (power_fighter - power_enemy) / 50;
    winPercent = winPercent < 0 ? 0 : winPercent;
    return winPercent;
  }

  function reward() internal {
    uint16 rewardPercent = _random();
    rewardPercent += 50;
    _bToken.transferFrom(address(this), msg.sender, ENTER_PRICE * (100 + rewardPercent) / 100);
  }

  function _getInitialPower(uint256 tokenID) public returns(uint256){
    return characters[tokenID].power;
  }

  function _getBattlePower(uint256 tokenID, uint256 enemyID) public returns(uint256) {
    if (characters[tokenID] - 1 == characters[enemyID])
      return characters[tokenID].power * (100 + POWER_BONUS) / 100;
    return characters[tokenID].power;
  }
}