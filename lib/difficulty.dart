enum Difficulty
{
  easy,
  medium,
  hard
}

double aiSpeedMultiplier(Difficulty difficulty)
{
  if (difficulty == Difficulty.easy)
  {
    return 0.35;
  }
  else if (difficulty == Difficulty.medium)
  {
    return 0.5;
  }
  else
  {
    return 0.7;
  }
}
