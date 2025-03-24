#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    # insert winning team into teams table
    INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    #if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
    #then
    #  echo Inserted winner into teams: $WINNER
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #fi
    # insert opponent (losing) team into teams table
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    #if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
    #then
    #  echo Inserted opponent into teams: $OPPONENT
     OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #fi
    # insert game data into games table
    INSERT_GAMEDATA_RESULT=$($PSQL "INSERT INTO games(round,year,winner_goals,opponent_goals,winner_id,opponent_id) VALUES('$ROUND',$YEAR,$WINNER_GOALS,$OPPONENT_GOALS,$WINNER_ID,$OPPONENT_ID)") 
  fi
done
