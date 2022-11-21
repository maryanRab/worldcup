#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

INSERT_TEAM () {
  # get team_id
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$1'")
    # if not found
    if [[ -z $TEAM_ID ]]
    then
      # insert team
      $PSQL "INSERT INTO teams(name) VALUES('$1')"
    fi
}

#echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # team insertion
    INSERT_TEAM "$WINNER"
    INSERT_TEAM "$OPPONENT"

    # game insertion
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    $PSQL "INSERT INTO games(round, year, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$ROUND',$YEAR,$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)"
  fi
done
